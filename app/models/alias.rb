class Alias < ApplicationRecord
  validates :name, presence: true, length: { minimum: 1 }, uniqueness: true
  validate :unique_name_across_models
  belongs_to :decomoji

  private

  def unique_name_across_models
    if Decomoji.find_by(name: name)
      errors.add(:name, 'is already taken')
    end
  end
end
