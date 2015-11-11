class Api::V1::ClassroomAsController < ApplicationController
  respond_to :json, :xml

  def index
    respond_with ClassroomA.first
  end
end
