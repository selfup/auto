class TodayChecker < ActiveRecord::Base

  def self.initialize_vars
    @user = "turingschool"
    @repo = "today"
    @connection = Hurley::Client.new("https://api.github.com")
    @connection.query[:access_token] = ENV["TOKEN"]
    @connection.header[:accept] = "application/vnd.github+json"
    @notifier = Slack::Notifier.new ENV["WEB_HOOK_URL"]
  end

  def self.repo_call
    JSON.parse(@connection.get("repos/#{@user}/#{@repo}/commits").
    body)[0]["commit"]["committer"]["date"]
  end

  def self.update_all_tables
    TodayChecker.first.update(repo_day: repo_call)
    ClassroomA.update_info
    ClassroomB.update_info
    ClassroomC.update_info
    BigWorkspace.update_info
  end

  def self.check
    initialize_vars
    repo_call
    if Time.now.to_s.split(" ")[1].include?("05:00")
      update_all_tables
      @notifier.ping "Hey! I just updated the LCD screens because it is a new day :)"
    elsif TodayChecker.first.repo_day != repo_call
      @notifier.ping "Hey! today.turing.io just got updated! LCD screens will update in 2 minutes :)"
      # sleep(120)
      update_all_tables
    end
  end

end
