class Version < ApplicationRecord
  validates :name, presence: true, length: { minimum: 1 }, uniqueness: true
  
  def self.ordered_by_gem_version
    all.sort_by(&:to_gem_version).reverse
  end

  def to_gem_version
    Gem::Version.new(name)
  end
end
