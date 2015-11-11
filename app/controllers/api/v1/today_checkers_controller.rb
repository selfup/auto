class Api::V1::TodayCheckersController < ApplicationController
  respond_to :json, :xml

  def index
    TodayChecker.check
    respond_with "Check"
  end
end
