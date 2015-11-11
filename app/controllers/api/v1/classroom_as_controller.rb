class Api::V1::ClassroomAsController < ApplicationController
  respond_to :json, :xml

  def index
    ClassroomA.update_info
    respond_with ClassroomA.all
  end
end
