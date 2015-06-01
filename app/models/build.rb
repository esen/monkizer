class Build < ActiveRecord::Base
  belongs_to :project
  has_many :build_results
end
