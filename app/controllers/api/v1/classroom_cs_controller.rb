class Api::V1::ClassroomCsController < ApplicationController
  respond_to :json, :xml

  def index
    # ClassroomC.update_info
    respond_with ClassroomC.all
  end
end
