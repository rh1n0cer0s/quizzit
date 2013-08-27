class Team < ActiveRecord::Base
  has_many :users

  validates :name, :presence => true

  accepts_nested_attributes_for :users
end
