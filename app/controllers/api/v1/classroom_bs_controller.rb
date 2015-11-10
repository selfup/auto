class Api::V1::ClassroomBsController < ApplicationController
  respond_to :json, :xml

  def index
    ClassroomB.update_info
    respond_with ClassroomB.all
  end
end
