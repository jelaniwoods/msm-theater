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
end
