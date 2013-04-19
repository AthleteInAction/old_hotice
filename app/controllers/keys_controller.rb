class KeysController < ApplicationController
  
  before_filter :authorize
  
  # GET /keys
  # GET /keys.json
  def index
    @keys = Keys.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @keys }
    end
  end

  # GET /keys/1
  # GET /keys/1.json
  def show
    @key = Keys.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @key }
    end
  end

  # GET /keys/new
  # GET /keys/new.json
  def new
    @key = Keys.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @key }
    end
  end

  # GET /keys/1/edit
  def edit
    @key = Keys.find(params[:id])
  end

  # POST /keys
  # POST /keys.json
  def create
    @key = Keys.new(params[:keys])

    respond_to do |format|
      if @key.save
        format.html { redirect_to @key }
        format.json { render json: @key, status: :created }
      else
        format.html { render action: "new" }
        format.json { render json: @key.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /keys/1
  # PUT /keys/1.json
  def update
    @key = Keys.find(params[:id])
    @cf = CustomFields.exists?(params[:keys][:field_id])
    if @cf
      puts 'Custom field found!'
      params[:keys][:custom_field] = 1
    else
      puts 'Custom field not found!'
      params[:keys][:custom_field] = 0
    end
    
    params[:keys].delete(:profile_id)

    respond_to do |format|
      if @key.update_attributes(params[:keys])
        format.html { head :no_content }
        format.json { head :no_content }
      else
        format.html { head :no_content }
        format.json { head :no_content }
      end
    end
  end

  # DELETE /keys/1
  # DELETE /keys/1.json
  def destroy
    @key = Keys.find(params[:id])
    @key.destroy

    respond_to do |format|
      format.html { redirect_to keys_url }
      format.json { head :no_content }
    end
  end
end
