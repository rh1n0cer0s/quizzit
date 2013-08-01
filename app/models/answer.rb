class Answer < ActiveRecord::Base
  attr_accessible :title, :correct

  belongs_to :question

  validates :title, :presence => true
end
