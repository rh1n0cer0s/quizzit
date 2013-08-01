class Question < ActiveRecord::Base
  attr_accessible :title, :quiz_id, :answers_attributes

  validates :title, :presence => true

  belongs_to :quiz
  has_many :answers

  accepts_nested_attributes_for :answers, :allow_destroy => true

  def correct? user_answers
    user_answers.reject! { |c| c.empty? }
    self.answers.collect do |answer|
      answer.correct? ? user_answers.include?(answer.id.to_s) : !user_answers.include?(answer.id.to_s)
    end.select{|r| r == false}.empty?
  end
end
