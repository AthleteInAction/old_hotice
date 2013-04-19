class ClientsController < ApplicationController
  
  before_filter :authorize
  
  require 'zendeskAPI'
  
  # GET /clients
  # GET /clients.json
  def index
    @clients = Client.where(user_id: current_user.id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @clients }
    end
  end

  # GET /clients/1
  # GET /clients/1.json
  def show
    @client = Client.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @client }
    end
  end

  # GET /clients/new
  # GET /clients/new.json
  def new
    @client = Client.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @client }
    end
  end

  # GET /clients/1/edit
  def edit
    @client = Client.find(params[:id])
  end

  # POST /clients
  # POST /clients.json
  def create
    
    params[:client][:code] = params[:client][:name].gsub(' ','').gsub('(','').gsub(')','').downcase
    
    @client = Client.new(params[:client])

    respond_to do |format|
      if @client.save
        format.html { redirect_to @client, notice: 'Client was successfully created.' }
        format.json { render json: @client, status: :created, location: @client }
      else
        format.html { render action: "new" }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /clients/1
  # PUT /clients/1.json
  def update
    @client = Client.find(params[:id])

    respond_to do |format|
      if @client.update_attributes(params[:client])
        format.html { redirect_to "/clients/#{params[:id]}/edit", notice: 'Client was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client = Client.find(params[:id])
    @client.destroy

    respond_to do |format|
      format.html { redirect_to clients_url }
      format.json { head :no_content }
    end
  end
  
  
  def zendesk
    
    code = 1
    
    if params[:client][:subdomain] && params[:client][:username] && params[:client][:password] && !params[:client][:subdomain].blank? && !params[:client][:username].blank? && !params[:client][:password].blank?
      
      zendesk = ZendeskAPI.new(
        domain: params[:client][:subdomain],
        username: params[:client][:username],
        password: params[:client][:password]
      )
      call = zendesk.getCall('/api/v2/users.json')
      code = call[:code]
      
    end
    
    message = 'Could not connect to Zendesk!'
    clean = false
    if code.to_f == 200
      message = 'Connection is good!'
      clean = true
    end
    
    final = {
      code: code,
      message: message,
      clean: clean
    }
    
    render json: final
    
  end
  
  
end