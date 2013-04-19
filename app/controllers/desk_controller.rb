class DeskController < ApplicationController
  
  def index
    
    DeskWorker.perform_async params
    
    render json: params
    
  end
  
end