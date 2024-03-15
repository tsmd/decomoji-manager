class Decomoji < ApplicationRecord
  validates :name, presence: true, length: { minimum: 1 }
  validates :yomi, presence: true, length: { minimum: 1 }
  belongs_to :version
end
