class Tag < ApplicationRecord
  has_many :decomoji_tags, dependent: :destroy
  has_many :decomojis, through: :decomoji_tags

  validates :name, presence: true, length: { minimum: 1 }, uniqueness: true
end
