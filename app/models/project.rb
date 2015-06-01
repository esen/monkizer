class Project < ActiveRecord::Base
  has_many :devices
  has_many :builds
end
