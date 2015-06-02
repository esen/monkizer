require 'fileutils'

class BuildResult < ActiveRecord::Base
  belongs_to :build
  belongs_to :device

  before_destroy :remove_log_file

  def passed!
    self.passed = true
    self.save
  end

  private

  def remove_log_file
    FileUtils.rm self.log_file
  end
end
