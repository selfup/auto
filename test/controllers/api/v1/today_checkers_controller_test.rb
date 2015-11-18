require 'test_helper'

class Api::V1::TodayCheckersControllerTest < ActionController::TestCase
  # include Capybara::DSL

  test "#index" do
    get :index, format: :json

    assert_response :success
  end

  test '#index returns the right number of json objects' do
    number_of_invoiceitems = TodayChecker.count

    get :index, format: :json

    json_response = JSON.parse(response.body)

    assert_equal 2, json_response.count
  end

  test "#index scrapes TODAY at 5am" do
    new_time = Time.local(2015, 11, 9, 05, 0, 0)
    Timecop.freeze(new_time)

    get :index, format: :json

    json_response = JSON.parse(response.body)

    assert_equal 2, json_response.count

    new_time == Time.now
    Timecop.return
  end
end
