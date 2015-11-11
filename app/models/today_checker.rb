class TodayChecker < ActiveRecord::Base

  def self.initialize_vars
    @user = "selfup"
    @repo = "rails-engine"
    @connection = Hurley::Client.new("https://api.github.com")
    @connection.query[:access_token] = ENV["TOKEN"]
    @connection.header[:accept] = "application/vnd.github+json"
    @notifier = Slack::Notifier.new "WEBHOOK_URL", channel: '#default',
                                                   username: 'notifier'
  end

  def self.repo_call
    JSON.parse(@connection.get("repos/#{@user}/#{@repo}/commits").body)[0]["commit"]["committer"]["date"]
  end

  def self.check
    initialize_vars
    repo_call
    if TodayChecker.first.repo_day != repo_call
      TodayChecker.first.update(repo_day: repo_call)
      ClassroomA.update_info; sleep(0.5)
      ClassroomB.update_info; sleep(0.5)
      ClassroomC.update_info; sleep(0.5)
      BigWorkspace.update_info; sleep(0.5)
      @notifier.ping
      repo_call
    end
  end

end
