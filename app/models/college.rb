class College < ActiveRecord::Base
  attr_accessible :cName, :state, :enrollment
  has_many :applies,inverse_of: :college
end
