# == Schema Information
#
# Table name: levels
#
#  id         :integer          not null, primary key
#  directions :text
#  number     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Level < ApplicationRecord
  has_many :answers

  def valid_answer?(query)
    answers.pluck(:content).include?(query)
  end

  def is_solved_by?(query)
    rand_answer = answers.pluck(:content).shuffle.first
    correct_result = eval(rand_answer)
    begin
      user_result = eval(query)
    rescue Exception
      user_result = "Nope"
    end
    correct_result == user_result
  end
end
