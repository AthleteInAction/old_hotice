class ConditionsController < ApplicationController
  
  # List
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def index
    
    @map = Maps.find(params[:map_id])
    @condtions = Conditions.where(profile_id: params[:profile_id],map_id: params[:map_id])
    
  end
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  
  # Create
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def create
    
    @map = Maps.find(params[:map_id])
    @condition = Conditions.new
    
    final = []
    params[:condition].each do |c|
      
      c = c.merge(profile_id: params[:profile_id],map_id: @map.id)
      final << c
      
    end
    
    Conditions.create(final)
    
    render json: final
    
  end
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
end