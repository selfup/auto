require 'test_helper'

class Api::V1::ClassroomCsControllerTest < ActionController::TestCase
  test "#index" do
    get :index, format: :json

    assert_response :success
  end

  test '#index returns the right number of ClassroomC JSON objects' do
    number_of_invoiceitems = ClassroomC.first

    get :index, format: :json

    json_response = JSON.parse(response.body)

    assert_equal 2, json_response.count
  end
end
