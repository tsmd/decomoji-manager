class Decomoji < ApplicationRecord
  has_many :aliases, dependent: :destroy

  validates :name, presence: true, length: { minimum: 1 }
  validates :yomi, presence: true, length: { minimum: 1 }
  belongs_to :version
end
