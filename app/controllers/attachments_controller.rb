class AttachmentsController < ApplicationController
  
  before_filter :authorize
  
  # GET /attachments
  # GET /attachments.json
  def index
    @attachments = Attachment.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @attachments }
    end
  end

  # GET /attachments/1
  # GET /attachments/1.json
  def show
    @attachment = Attachment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @attachment }
    end
  end

  # GET /attachments/new
  # GET /attachments/new.json
  def new
    @attachment = Attachment.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @attachment }
    end
  end

  # GET /attachments/1/edit
  def edit
    @attachment = Attachment.find(params[:id])
  end

  # POST /attachments
  # POST /attachments.json
  def create
    @attachment = Attachment.new(params[:attachment])

    respond_to do |format|
      if @attachment.save
        format.html { redirect_to @attachment, notice: 'Attachment was successfully created.' }
        format.json { render json: @attachment, status: :created, location: @attachment }
      else
        format.html { render action: "new" }
        format.json { render json: @attachment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /attachments/1
  # PUT /attachments/1.json
  def update
    @attachment = Attachment.find(params[:id])

    respond_to do |format|
      if @attachment.update_attributes(params[:attachment])
        format.html { head :no_content }
        format.json { head :no_content }
      else
        format.html { head :no_content }
        format.json { head :no_content }
      end
    end
  end

  # DELETE /attachments/1
  # DELETE /attachments/1.json
  def destroy
    
    @attachment = Attachment.find(params[:attachment_id])
    @attachment.destroy
    Keys.where(attachment_id: @attachment.id).destroy_all
    GetModel(params[:type]).where(file_id: @attachment.id).destroy_all
    
    respond_to do |format|      
      format.html { redirect_to '/imports/'+params[:profile_id].to_s+'/csv/'+params[:type].to_s,notice: 'File has been deleted!' }
    end
    
  end
  
  
  def status
    
    @attachment = Attachment.find(params[:id])
    
    final = {
      clean: true,
      status: @attachment.status,
      success: GetModel(params[:type]).where("file_id = #{params[:id]}").count,
      errors: CsvErrors.where("file_id = #{params[:id]}").count,
      complete: @attachment.complete,
      total: @attachment.total,
      pct: ((@attachment.complete.to_f/@attachment.total.to_f)*100.to_f).round
    }
    
    respond_to do |format|      
      format.json { render json: final }    
    end
    
  end
  
end
