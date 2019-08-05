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
end
