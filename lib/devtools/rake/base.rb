module Devtools
  module Rake
    class Base
      include Procto.call(:run),
              Adamantium

      def task_name
        self.class.name[/(\w+)$/].downcase
      end

      def notify_enqueuement(message = 'waiting')
        puts "#{task_name}:notify_enqueuement #{message}"
        puts '--------------------------------------------------------------------------------'
        Github.update_status(task_name, :pending, message)
      end

      def notify_start(message = 'running')
        puts '--------------------------------------------------------------------------------'
        puts "#{task_name}:notify_start #{message}"
        Github.update_status(task_name, :pending, message)
      end

      def notify_success(message = 'success')
        puts "#{task_name}:notify_success #{message}"
        puts '--------------------------------------------------------------------------------'
        Github.update_status(task_name, :success, message)
      end

      def notify_failure(message = 'failure')
        puts "#{task_name}:notify_failure #{message}"
        puts '--------------------------------------------------------------------------------'
        # abort(message)
        Github.update_status(task_name, :failure, message)
        false
      end

      def notify_error(message = 'error')
        puts "#{task_name}:notify_error #{message}"
        puts '--------------------------------------------------------------------------------'
        Github.update_status(task_name, :error, message)
      end

      def auto_notify
        notify_start

        return false unless yield.nil?

        notify_success
      rescue StandardError => error
        notify_error(error.message)
      end
    end
  end
end
