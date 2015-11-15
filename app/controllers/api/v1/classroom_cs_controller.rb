class Api::V1::ClassroomCsController < ApplicationController
  respond_to :json, :xml

  def index
    respond_with ClassroomC.first
  end
end
