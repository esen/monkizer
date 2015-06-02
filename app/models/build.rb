class Build < ActiveRecord::Base
  belongs_to :project
  has_many :build_results, :dependent => :destroy

  def set_error(error)
    self.error = error
    self.status = "Failed"
    self.save
  end
end
