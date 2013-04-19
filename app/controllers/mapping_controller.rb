class MappingController < ApplicationController
  
  
  # List Maps
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def index
    
    @profile = Profile.find(params[:profile_id])
    
  end
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  
  # New Map
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def new
    
    @profile = Profile.find(params[:profile_id])
    @map = Maps.new
    
  end
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  
  # Edit
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def edit
    
    @profile = Profile.find(params[:profile_id])
    @map = Maps.find(params[:id])
    
  end
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  
  # Create Map
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def create
    
    params[:map][:profile_id] = params[:profile_id]
    final = params
    @map = Maps.new(params[:map])
    if @map.save
      
      @condition = Conditions.new

      final = []
      evtime = false
      params[:condition].each do |c|
        
        if c[:field_id] == 'everytime'
          c[:condition] = 'everytime'
          evtime = true
          c[:field_id] = nil
        end

        c = c.merge(profile_id: params[:profile_id],map_id: @map.id)
        final << c

      end
      
      Conditions.create(final) if final.count > 0
      
      @action = MActions.new

      final = []
      params[:actions].each do |a|
        
        a = a.merge(atype: 'map') if evtime

        a = a.merge(profile_id: params[:profile_id],map_id: @map.id)
        final << a

      end
      
      MActions.create(final) if final.count > 0
      
      redirect_to request.path,notice: 'Mapping was created!'
      
    else
      
      puts %{::: ---- #{@map.errors}}
      render 'new'
      
    end
    
  end
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  
  # Deactivate
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def deactivate
    
    @map = Maps.find(params[:map_id])
    @map.update_attributes(active: 0)
    
    path = request.path.split('/')
    path.pop
    path.pop
    
    redirect_to path.join('/')
    
  end
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  
  # Activate
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def activate
    
    @map = Maps.find(params[:map_id])
    @map.update_attributes(active: 1)
    
    path = request.path.split('/')
    path.pop
    path.pop
    
    redirect_to path.join('/')
    
  end
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  
  # Destroy
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def destroy
    
    @map = Maps.find(params[:id])
    Conditions.where(id: @map.id).destroy_all
    MActions.where(id: @map.id).destroy_all
    @map.destroy
    
    path = request.path.split('/')
    path.pop
    
    redirect_to path.join('/')
    
  end
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
end