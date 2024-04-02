class Check < ApplicationRecord
  has_many :decomoji_checks
  has_many :decomojis, through: :decomoji_checks

  validates :name, presence: true
  validates :status, presence: true, inclusion: { in: ['in_progress', 'completed'] }
end
