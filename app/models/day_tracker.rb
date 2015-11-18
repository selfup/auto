class DayTracker
  attr_reader :weekend_execute

  def initialize(weekend_execute = "")
    @weekend_execute = weekend_execute
  end

  def day_time
    Time.now.asctime.split.first
  end

  def date
    if day_time == "Sat"
      Time.at(Time.now.to_i - 172800).to_s.split.first
    elsif day_time == "Sun"
      Time.at(Time.now.to_i - 259200).to_s.split.first
    else
      Time.now.to_s.split(" ").first
    end
  end

  def weekend
    if day_time == "Fri" || day_time == "Sat" || day_time == "Sun"
      weekend_execute
    end
  end
end
