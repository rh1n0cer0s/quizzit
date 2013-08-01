class Result < ActiveRecord::Base
  belongs_to :user
  belongs_to :quiz

  serialize :details

  def answered_questions
    if self.details[:answered_questions]
      self.quiz.questions.where("id in (?)", self.details[:answered_questions].keys)
    else
      Question.where(:id => nil)
    end
  end

  def unanswered_questions
    if self.details[:answered_questions]
      self.quiz.questions.where("id not in (?)", self.details[:answered_questions].keys)
    else
      self.quiz.questions
    end
  end

  def done?
    answered_questions.length == self.quiz.questions.length
  end

  def answer_question! question, result
    self.details[:answered_questions] ||= {}
    self.details[:answered_questions][question.id] = result

    correct_answers = self.details[:answered_questions].select {|id, result| result == true}.keys
    self.percent = (correct_answers.length.to_f / self.quiz.questions.length.to_f * 100.00).to_i

    save
  end

  def answer_for question
    self.details[:answered_questions][question.id]
  end

  def to_s
    "#{self.percent}%"
  end
end
