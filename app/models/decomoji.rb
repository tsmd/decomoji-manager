class Decomoji < ApplicationRecord
  include RomajiKanaConverter

  validates :name, presence: true, length: { minimum: 1 }, uniqueness: true

  validates :yomi, presence: true, length: { minimum: 1 }

  belongs_to :color, optional: true
  before_create :assign_default_color, if: -> { color_id.blank? }

  belongs_to :version, optional: true

  has_many :aliases, dependent: :destroy
  after_create :add_romaji_aliases

  has_many :decomoji_tags, dependent: :destroy
  has_many :tags, through: :decomoji_tags

  has_one_attached :image
  #validates :image, presence: true
  validate :validate_image_format

  before_save :replace_image, if: -> { image.attached? && image.changed? }

  has_many :decomoji_checks, dependent: :destroy
  has_many :checks, through: :decomoji_checks

  def yomi_kunrei
    yomi.present? ? to_kunrei_romaji(yomi) : ''
  end

  def yomi_hepburn
    yomi.present? ? to_hepburn_romaji(yomi) : ''
  end

  def self.default_font(name)
    return 'latin' unless self.has_non_ascii_string?(name)
    return 'serif' if name.size <= 2
    'sans-serif'
  end

  # デフォルトの色を設定

  def assign_default_color
    last_color_id = Decomoji.last&.color_id
    self.color_id = last_color_id ? Decomoji.next_color_id(last_color_id) : Color.first.id
  end

  def self.next_color_id(current_color_id)
    colors = Color.order(:id).to_a
    current_index = colors.index { |color| color.id == current_color_id }

    if current_index.nil?
      return colors[0].id
    end

    next_index = (current_index + 1) % colors.size
    colors[next_index].id
  end

  # SVGレンダリング関連

  VIEWBOX_SIZE = 64

  def raw_text
    typesetting || name
  end

  def split_text
    return @split_text if defined? @split_text
    split = []
    raw_text.gsub(/\s*/, '').chars.each do |fragment|
      if split.empty?
        split.push(fragment)
        next
      end
      last_char = split.last[-1]
      if Decomoji.has_non_ascii_string?(last_char) || Decomoji.has_non_ascii_string?(fragment)
        split.push(fragment)
      else
        split[-1] += fragment
      end
    end
    @split_text = split
  end

  def lines
    return @lines if defined? @lines
    lines = [raw_text]
    # 半角スペースが含まれていれば強制的に改行
    if raw_text.include?(' ')
      lines = raw_text.split(/ +/)
    else
      if split_text.length > 2
        slice_pos = (split_text.length / 2.0).ceil
        lines = [split_text.take(slice_pos).join(''), split_text.drop(slice_pos).join('')]
      end
    end
    @lines = lines
    lines
  end

  def orientation
    orientation = :horizontal
    unless raw_text.include?(' ')
      if split_text.length == 2 && !split_text.any? { |s| Decomoji.has_ascii_string?(s) }
        orientation = :vertical
      end
    end
    orientation
  end

  def font_size
    return @font_size if defined? @font_size
    if orientation == :horizontal
      if lines.size == 1 && !Decomoji.has_non_ascii_string?(lines[0])
        font_size = VIEWBOX_SIZE / 2
      else
        font_size = VIEWBOX_SIZE / lines.size
      end
    else
      font_size = VIEWBOX_SIZE / lines[0].size
    end
    @font_size = font_size
  end

  def scale_x
    max_size = lines.map { |line| get_text_size line }.max
    max_size > lines.size ? lines.size / max_size : 1
  end

  # フォーマット関連

  def as_json
    super({
      only: [:name, :yomi, :font, :typesetting],
      include: {
        color: { only: [:name, :hex] },
        version: { only: :name },
        tags: { only: :name },
        aliases: { only: :name }
      }
    })
  end

  def self.row_header
    %w(name yomi typesetting alias1 alias2 alias3 tag1 tag2 tag3 color font version)
  end

  def as_row
    row = [name, yomi, typesetting]
    row += aliases.limit(3).pluck(:name).tap { |a| a.fill('', a.size..2) }
    row += tags.limit(3).pluck(:name).tap { |t| t.fill('', t.size..2) }
    row += [color&.name, font, version&.name]
    row
  end

  # ASCII 文字を含むかどうか判定
  def self.has_ascii_string?(string)
    !!string.match(/[!-~]/)
  end

  # 非ASCII文字を含むかどうか判定
  def self.has_non_ascii_string?(string)
    !!string.match(/[^!-~]/)
  end

  private

  def validate_image_format
    return unless image.attached?

    unless image.content_type == 'image/png'
      image.purge
      errors.add(:image, 'needs to be a PNG file')
    end
  end

  def replace_image
    image.attachment.purge if image.attachment.present? && image.attachment.persisted?
  end

  def get_text_size(text)
    length = 0.0
    text.each_char do |char|
      if char.ascii_only? || char.match?(/[\u0080-\u00FF]/)
        # ASCII文字やアクセント記号付きの欧文文字
        length += 2.0 / 3
      else
        # それ以外の文字
        length += 1
      end
    end
    length
  end

  def add_romaji_aliases
    kunrei = yomi_kunrei
    hepburn = yomi_hepburn

    if hepburn != kunrei && !aliases.exists?(name: kunrei)
      aliases.create(name: kunrei)
    end

    if !aliases.exists?(name: hepburn)
      aliases.create(name: hepburn)
    end
  end
end
