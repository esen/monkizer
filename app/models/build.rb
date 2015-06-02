class Build < ActiveRecord::Base
  belongs_to :project
  has_many :build_results, :dependent => :destroy

  def set_error(error)
    self.error = error
    self.status = "Failed"
    self.save
  end

  def all_passed?
    self.build_results.not_passed.count == 0
  end

  def passed!
    self.status = "Finished"
    self.save
  end
end
