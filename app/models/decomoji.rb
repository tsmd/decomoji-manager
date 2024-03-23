class Decomoji < ApplicationRecord
  include RomajiKanaConverter

  validates :name, presence: true, length: { minimum: 1 }, uniqueness: true
  validate :unique_name_across_models

  #validates :yomi, presence: true, length: { minimum: 1 }

  belongs_to :version

  has_many :aliases, dependent: :destroy

  has_many :decomoji_tags
  has_many :tags, through: :decomoji_tags

  has_one_attached :image
  #validates :image, presence: true
  validate :validate_image_format

  before_save :replace_image, if: -> { image.attached? && image.changed? }

  belongs_to :color

  def yomi_kunrei
    yomi.present? ? to_kunrei_romaji(yomi) : ''
  end

  def yomi_hepburn
    yomi.present? ? to_hepburn_romaji(yomi) : ''
  end

  private

  def unique_name_across_models
    if Alias.find_by(name: name)
      errors.add(:name, 'is already taken')
    end
  end

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
end
