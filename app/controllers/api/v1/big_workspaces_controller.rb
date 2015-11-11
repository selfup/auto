class Api::V1::BigWorkspacesController < ApplicationController
  respond_to :json, :xml

  def index
    # BigWorkspace.update_info
    respond_with BigWorkspace.all
  end
end
