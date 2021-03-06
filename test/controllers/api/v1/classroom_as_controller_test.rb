require 'test_helper'

class Api::V1::ClassroomAsControllerTest < ActionController::TestCase
  test "#index" do
    get :index, format: :json

    assert_response :success
  end

  test '#index returns the right number of ClassroomA JSON objects' do
    number_of_invoiceitems = ClassroomA.first

    get :index, format: :json

    json_response = JSON.parse(response.body)

    assert_equal 2, json_response.count
  end
end
