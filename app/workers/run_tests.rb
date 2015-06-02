require 'fileutils'

class RunTests
  include Sidekiq::Worker

  def perform(build_id, test_build = false)
    build = Build.find build_id
    project = build.project
    rvm_vars = "GEM_HOME=$HOME/.rvm/gems/ruby-#{project.ruby_version}@#{project.ruby_gemset}" +
               " GEM_PATH=$HOME/.rvm/gems/ruby-#{project.ruby_version}@#{project.ruby_gemset}" + 
               ":$HOME/.rvm/gems/ruby-#{project.ruby_version}@global"
    apk_file = "app/build/outputs/apk/app-#{project.build_variant}.apk"
    calabash = "bundle exec calabash-android"



    logger.info "Starting build of project #{project.name}"

    logger.info "go to the project's directory"
    Bundler.with_clean_env do
      Dir.chdir project.location do

        logger.info "gradle assemble#{project.build_variant.capitalize}"
        system "gradle assemble#{project.build_variant.capitalize}"
        unless $?.success?
          build.set_error "Could not build the project using given build variant"
          return
        end

        logger.info "Resign apk"
        `#{rvm_vars} #{calabash} resign #{apk_file}`
        unless $?.success?
          build.set_error "Could not resign the app"
          return
        end

        project.devices.each do |device|
          build_result = build.build_results.create device: device, passed: false, 
            log_file: Rails.root.to_s + "/log/build_logs/device_#{device.id}_build_#{build.id}_br_#{}.log"

          FileUtils.touch(build_result.log_file)

          logger.info "Running tests. BuildResult id: #{build_result.id}"
          only_test_feature = test_build ? " features/groups_create.feature --tags @doing" : ""
          `#{rvm_vars} ADB_DEVICE_ARG="#{device.adb_device_id}" #{calabash} run #{apk_file}#{only_test_feature} > #{build_result.log_file}`
          
          build_result.passed! if $?.success? 
        end

        build.passed! if build.all_passed?
      end
    end
  end
end