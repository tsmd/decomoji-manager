class Decomoji < ApplicationRecord
  has_one_attached :image
  has_many :aliases, dependent: :destroy
  has_many :decomoji_tags
  has_many :tags, through: :decomoji_tags

  validates :name, presence: true, length: { minimum: 1 }, uniqueness: true
  validate :unique_name_across_models
  validates :yomi, presence: true, length: { minimum: 1 }
  validates :image, presence: true
  validate :validate_image_format
  belongs_to :version

  before_save :replace_image, if: -> { image.attached? && image.changed? }

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
