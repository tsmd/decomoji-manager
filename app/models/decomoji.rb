class Decomoji < ApplicationRecord
  has_many :aliases, dependent: :destroy
  has_many :decomoji_tags
  has_many :tags, through: :decomoji_tags

  validates :name, presence: true, length: { minimum: 1 }, uniqueness: true
  validate :unique_name_across_models
  validates :yomi, presence: true, length: { minimum: 1 }
  belongs_to :version

  private

  def unique_name_across_models
    if Alias.find_by(name: name)
      errors.add(:name, 'is already taken')
    end
  end
end
