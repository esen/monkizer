class Build < ActiveRecord::Base
  belongs_to :project
  has_many :build_results, :dependent => :destroy

  scope :of_project, ->(project) { where(project: project) }
  scope :in_queue, -> { where(status: "In Queue") }

  def set_error(error)
    self.error = error
    self.status = "Failed"
    self.save
  end

  def all_passed?
    self.build_results.not_passed.count == 0
  end

  def finish!
    self.status = self.all_passed? ? "Success" : "Tests Failed"
    self.save
  end
end
