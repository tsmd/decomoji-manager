class Decomoji < ApplicationRecord
  belongs_to :version
  validates :name, presence: true, length: { minimum: 1 }
  validates :yomi, presence: true, length: { minimum: 1 }
end
