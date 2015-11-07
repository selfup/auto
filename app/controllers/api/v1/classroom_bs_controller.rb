class Api::V1::ClassroomBsController < ApplicationController
  respond_to :json, :xml

  def index
    respond_with ClassroomB.all
  end
end
