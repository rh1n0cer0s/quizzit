class Team < ActiveRecord::Base
  attr_accessible :name, :members_attributes

  has_many :members, :class_name => "User"
  has_one :leader, :class_name => "User"

  validates :name, :presence => true

  accepts_nested_attributes_for :members
end
