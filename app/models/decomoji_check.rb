class DecomojiCheck < ApplicationRecord
  belongs_to :decomoji
  belongs_to :check

  validates :status, presence: true, inclusion: { in: ['unchecked', 'problem', 'ok'] }
end
