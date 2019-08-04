# == Schema Information
#
# Table name: roles
#
#  id             :integer          not null, primary key
#  character_name :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  actor_id       :integer
#  movie_id       :integer
#

class Role < ApplicationRecord
end
