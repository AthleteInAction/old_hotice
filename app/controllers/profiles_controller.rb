class ProfilesController < ApplicationController
  
  before_filter :authorize
  
  add_breadcrumb 'Profiles','profiles_path'
  
  # GET /profiles
  # GET /profiles.json
  def index
    @profiles = Profile.where(user_id: current_user.id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: {test: @test} }
    end
  end

  # GET /profiles/1
  # GET /profiles/1.json
  def show
    @profile = Profile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @profile }
    end
  end

  # GET /profiles/new
  # GET /profiles/new.json
  def new
    @profile = Profile.new
    @client = Client.new

    respond_to do |format|
      format.html # new.html.erb
    end
  end

  # GET /profiles/1/edit
  def edit
    @profile = Profile.find(params[:id])
  end

  # POST /profiles
  # POST /profiles.json
  def create
    
    client = true
    profile = false
    
    params[:profile][:user_id] = current_user.id
    
    1.times do
      
      if params[:profile][:destination] == 'create'
        @client = Client.new(params[:client])
        if @client.valid?
          @client.save
          params[:profile][:destination] = @client.id
        else
          client = false
          break
        end
      end
      
      @profile = Profile.new(params[:profile])
      if @profile.valid?
        profile = true
        @profile.save
      else
        break
      end
      
    end    
      

    respond_to do |format|
      if profile && client
        format.html { redirect_to "/imports/#{@profile.id}/sync", notice: 'Profile was successfully created.' }
        format.json { render json: @profile, status: :created, location: @profile }
      else
        format.html { render action: "new" }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end

  end

  # PUT /profiles/1
  # PUT /profiles/1.json
  def update
    
    @profile = Profile.find(params[:id])

    respond_to do |format|
      if @profile.update_attributes(params[:profile])
        format.html { redirect_to "/imports/#{@profile.id}/edit", notice: 'Profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @profile.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /profiles/1
  # DELETE /profiles/1.json
  def destroy
    
    @profile = Profile.find(params[:id])
    Organizations.where(profile_id: params[:id]).destroy_all
    ZdUsers.where(profile_id: params[:id]).destroy_all
    Groups.where(profile_id: params[:id]).destroy_all
    Tickets.where(profile_id: params[:id]).destroy_all
    CustomRoles.where(profile_id: params[:id]).destroy_all
    CustomFields.where(profile_id: params[:id]).destroy_all
    Attachment.where(profile_id: params[:id]).destroy_all
    CsvAttempt.where(profile_id: params[:id]).destroy_all
    ImportAttempts.where(profile_id: params[:id]).destroy_all
    CsvErrors.where(profile_id: params[:id]).destroy_all
    Keys.where(profile_id: params[:id]).destroy_all
    @profile.destroy

    respond_to do |format|
      format.html { redirect_to '/imports' }
      format.json { head :no_content }
    end
    
  end
  
  def skip
    
    @profile = Profile.find(params[:profile_id])
    @profile.update_attributes(synced: 1,status: 'opened')
    redirect_to request.path.gsub('/skip','/select')
    
  end
  
  def select
    
    @profile = Profile.find(params[:profile_id])
    
    if @profile.synced
      path = "/imports/#{@profile.id}/csv/#{@profile.state}"
    else
      path = "/imports/#{@profile.id}/sync"
    end
    
    redirect_to path
    
  end
  
  def rollback
    
    RollbackWorker.perform_async params
    
    render json: {rollback: true}
    
  end
  
end