require 'test_helper'

class Api::V1::TodayCheckersControllerTest < ActionController::TestCase
  test "#index" do
    get :index, format: :json

    assert_response :success
  end

  test '#index returns the right number of InvoiceItems' do
    number_of_invoiceitems = TodayChecker.count

    get :index, format: :json

    json_response = JSON.parse(response.body)

    assert_equal 2, json_response.count
  end
end
