require 'fileutils'

class BuildResult < ActiveRecord::Base
  belongs_to :build
  belongs_to :device

  before_destroy :remove_log_file

  scope :passed, -> { where(passed: true) }
  scope :not_passed, -> { where(passed: false) }

  def passed!
    self.passed = true
    self.save
  end

  private

  def remove_log_file
    FileUtils.rm self.log_file rescue nil
  end
end
