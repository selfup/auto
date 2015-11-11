class Api::V1::BigWorkspacesController < ApplicationController
  respond_to :json, :xml

  def index
    respond_with BigWorkspace.first
  end
end
