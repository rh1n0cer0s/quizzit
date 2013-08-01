class Quiz < ActiveRecord::Base
  attr_accessible :name

  validates :name, :presence => true

  has_many :questions, :dependent => :destroy
  has_many :results, :dependent => :destroy

  def result_for user
    self.results.where(:user_id => user).first
  end

  def to_s
    self.name
  end
end
