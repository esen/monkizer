class Project < ActiveRecord::Base
  has_many :devices
  has_many :builds

  def last_ci_build
    builds.where("ci_build_number IS NOT NULL").last
  end

  def last_processed_build
    builds.where.not(status: "In Queue").last
  end
end
