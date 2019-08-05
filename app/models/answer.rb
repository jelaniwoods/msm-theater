# == Schema Information
#
# Table name: answers
#
#  id         :integer          not null, primary key
#  content    :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  level_id   :integer
#

class Answer < ApplicationRecord
end
