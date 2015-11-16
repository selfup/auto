class TodayChecker < ActiveRecord::Base

  def self.initialize_vars
    @user = "turingschool"
    @repo = "today"
    # @user = "selfup"
    # @repo = "rails-engine"
    @connection = Hurley::Client.new("https://api.github.com")
    @connection.query[:access_token] = ENV["TOKEN"]
    @connection.header[:accept] = "application/vnd.github+json"
    @notifier = Slack::Notifier.new ENV["WEB_HOOK_URL"]
  end

  def self.repo_call
    JSON.parse(@connection.get("repos/#{@user}/#{@repo}/commits").body)[0]["commit"]["committer"]["date"]
  end

  def self.check
    initialize_vars
    repo_call
    if TodayChecker.first.repo_day != repo_call
      @notifier.ping "I am a robot. How can you see me :P - This is a Development ENV test :)"
      sleep(90)
      TodayChecker.first.update(repo_day: repo_call)
      ClassroomA.update_info
      ClassroomB.update_info
      ClassroomC.update_info
      BigWorkspace.update_info
    end
  end

end
