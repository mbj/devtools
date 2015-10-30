module Devtools
  module Rake
    class Github
      include Adamantium

      def self.update_status(context, status, message)
        return unless Devtools.ci?
        return if ENV['GITHUB_ACCESS_TOKEN'].nil? || ENV['GITHUB_ACCESS_TOKEN'].empty?

        unless github_status_is_good?
          puts 'Github is experiencing outages. Request may fail.'
        end

        unless scopes_include_repo_statuses?
          puts "Access token lacks the required privileges of 'repo:status'"
          return
        end

        unless can_write_to_repo?
          puts "Access token has insufficient privileges for #{repo_slug}"
          return
        end

        create_status(context, status, message)
      rescue Octokit::TooManyRequests
        puts "Being requested limited by Github, resets at #{client.ratelimit.resets_at}"
      end

      def self.client
        @client ||= Octokit::Client.new(access_token: ENV['GITHUB_ACCESS_TOKEN'])
      end

      def self.github_status_is_good?
        client.github_status[:status] == 'good'
      end

      def self.scopes_include_repo_statuses?
        @scopes_include_repo_statuses ||= client.scopes.include? 'repo:status'
      end

      def self.can_write_to_repo?
        @can_write_to_repo ||= client.repositories.any? { |repo| repo[:full_name] == repo_slug }
      end

      def self.create_status(context, status, message)
        client.create_status(
          repo_slug,
          commit_sha,
          status.to_s,
          context: "dt/#{context}",
          description: message,
          target_url: target_url
        )
      end

      def self.repo_slug
        case
        when Devtools.circle_ci?
          ENV['CIRCLE_PROJECT_USERNAME'] + '/' + ENV['CIRCLE_PROJECT_REPONAME']
        when Devtools.travis?
          ENV['TRAVIS_REPO_SLUG']
        end
      end

      def self.commit_sha
        case
        when Devtools.circle_ci?
          ENV['CIRCLE_SHA1']
        when Devtools.travis?
          ENV['TRAVIS_COMMIT']
        end
      end

      def self.target_url
        case
        when Devtools.circle_ci?
          "https://circleci.com/gh/#{repo_slug}/#{ENV['CIRCLE_BUILD_NUM']}"
        when Devtools.travis?
          nil
        end
      end
    end
  end
end
