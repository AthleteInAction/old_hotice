class ZendeskFieldsController < ApplicationController
  
  before_filter :authorize
  
  # GET /zendesk_fields
  # GET /zendesk_fields.json
  def index
    @zendesk_fields = ZendeskField.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @zendesk_fields }
    end
  end

  # GET /zendesk_fields/1
  # GET /zendesk_fields/1.json
  def show
    @zendesk_field = ZendeskField.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @zendesk_field }
    end
  end

  # GET /zendesk_fields/new
  # GET /zendesk_fields/new.json
  def new
    @zendesk_field = ZendeskField.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @zendesk_field }
    end
  end

  # GET /zendesk_fields/1/edit
  def edit
    @zendesk_field = ZendeskField.find(params[:id])
  end

  # POST /zendesk_fields
  # POST /zendesk_fields.json
  def create
    @zendesk_field = ZendeskField.new(params[:zendesk_field])

    respond_to do |format|
      if @zendesk_field.save
        format.html { redirect_to @zendesk_field, notice: 'Zendesk field was successfully created.' }
        format.json { render json: @zendesk_field, status: :created, location: @zendesk_field }
      else
        format.html { render action: "new" }
        format.json { render json: @zendesk_field.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /zendesk_fields/1
  # PUT /zendesk_fields/1.json
  def update
    @zendesk_field = ZendeskField.find(params[:id])

    respond_to do |format|
      if @zendesk_field.update_attributes(params[:zendesk_field])
        format.html { redirect_to @zendesk_field, notice: 'Zendesk field was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @zendesk_field.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /zendesk_fields/1
  # DELETE /zendesk_fields/1.json
  def destroy
    @zendesk_field = ZendeskField.find(params[:id])
    @zendesk_field.destroy

    respond_to do |format|
      format.html { redirect_to zendesk_fields_url }
      format.json { head :no_content }
    end
  end
end
