set :output, nil
set :output, {:error => nil, :standard => nil}


every 1.minutes do
  runner "TodayChecker.check"
end
