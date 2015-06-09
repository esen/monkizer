require 'fileutils'

class RunTests
  include Sidekiq::Worker

  def perform(project_id, test_build = false)
    project = Project.find project_id
    build = project.builds.in_queue.last
    last_processed_build = project.last_processed_build

    # Skip tasks and run only last queued task
    since_time = last_processed_build.nil? ? Time.new("2000") : last_processed_build.created_at
    return if build.nil? || since_time > build.created_at
    project.builds.in_queue.where("created_at > ?", since_time).where.not(id: build.id).each do |sb|
      sb.update_attribute :status, "Skipped"
    end

    build.update_attribute :status, "In Progress"

    rvm_vars = "GEM_HOME=$HOME/.rvm/gems/ruby-#{project.ruby_version}@#{project.ruby_gemset}" +
               " GEM_PATH=$HOME/.rvm/gems/ruby-#{project.ruby_version}@#{project.ruby_gemset}" + 
               ":$HOME/.rvm/gems/ruby-#{project.ruby_version}@global"
    apk_file = "app/build/outputs/apk/app-#{project.build_variant}.apk"
    calabash = "bundle exec calabash-android"



    logger.info "Starting build of project #{project.name}"

    Bundler.with_clean_env do
      Dir.chdir project.location do

        logger.info "checkout #{project.git_branch}"
        system "git checkout #{project.git_branch}"
        unless $?.success?
          build.set_error "Could not checkout to #{project.git_branch}"
          return
        end

        logger.info "clean git directory"
        system "git reset --hard"
        unless $?.success?
          build.set_error "Could not clean git directory"
          return
        end


        logger.info "pull from #{project.git_repo}"
        system "git pull origin #{project.git_branch}"
        unless $?.success?
          build.set_error "Could not updated from #{project.git_repo}"
          return
        end


        logger.info "set IP in project to #{project.vagrant_ip}"
        begin
          contents = File.read(project.location + "/app/build.gradle")
          File.open(project.location + "/app/build.gradle", "w") do |file| 
            file.puts contents.gsub(/192.168.33.10/, project.vagrant_ip.strip)
          end
        rescue Exception => e
          build.set_error e.message
          return
        end


        logger.info "gradle assemble#{project.build_variant.capitalize}"
        system "gradle assemble#{project.build_variant.capitalize}"
        unless $?.success?
          build.set_error "Could not build the project using given build variant"
          return
        end

        logger.info "Resign apk"
        system "#{rvm_vars} #{calabash} resign #{apk_file}"
        unless $?.success?
          build.set_error "Could not resign the app"
          return
        end

        project.devices.each do |device|
          puts device.inspect
          build_result = build.build_results.create device: device, passed: false
          build_result.log_file = Rails.root.to_s + "/log/build_logs/#{build_result.id}_device_#{device.id}_build_#{build.id}.log"
          build_result.save

          FileUtils.touch(build_result.log_file)
          config_path = Rails.root.to_s + "/config/device_configs/device_#{device.id}.json"

          logger.info "Running tests. BuildResult id: #{build_result.id}"
          only_test_feature = test_build ? " features/groups_create.feature" : ""
          cmd = "#{rvm_vars} STEPS=#{config_path} ADB_DEVICE_ARG=\"#{device.adb_device_id}\" #{calabash} run #{apk_file}#{only_test_feature} > #{build_result.log_file}"

          pid = fork { exec(cmd) }
          build_result.pid = pid
          build_result.save
          _, status = Process.waitpid2(pid)
          build_result.pid = nil
          build_result.save

          build_result.passed! if status.success? 
        end

        build.finish!
      end
    end
  end
end