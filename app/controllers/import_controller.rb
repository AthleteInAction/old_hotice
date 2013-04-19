class ImportController < ApplicationController
  
  before_filter :authorize
  before_filter :get_cfs, only: [:import]
  
  def index
    
    respond_to do |format|
      
      format.html do
        
        @profile = Profile.find(params[:profile_id])
        @profile.update_attributes(state: params[:type])
        
      end
      
    end
    
  end
  
  
  def start
    
    ImportWorker.perform_async params
    
    sleep 1
    
    redirect_to '/imports/'+params[:profile_id].to_s+'/import/'+params[:type].to_s,notice: 'Import has started!'
    
  end
  
  def stop
    
    ImportAttempts.where("profile_id = #{params[:profile_id]} AND state = '#{params[:type]}'").order("id DESC").limit(1).each do |ia|
      
      ImportAttempts.find(ia.id).update_attributes(active: 0)
      
    end
    
    sleep 1
    
    redirect_to '/imports/'+params[:profile_id].to_s+'/import/'+params[:type].to_s,notice: 'Import has been stopped!'
    
  end
  
  def status
    
    completed = GetModel(params[:type]).where("profile_id = #{params[:profile_id]} AND state = 'imported'").count
    total = GetModel(params[:type]).where("profile_id = #{params[:profile_id]}").count
    
    final = {
      pending: GetModel(params[:type]).where("profile_id = #{params[:profile_id]} AND error = 0 AND state = 'pending'").count,
      errors: GetModel(params[:type]).where("profile_id = #{params[:profile_id]} AND error = 1 AND state = 'imported'").count,
      success: GetModel(params[:type]).where("profile_id = #{params[:profile_id]} AND error = 0 AND state = 'imported'").count,
      completed: completed,
      total: total,
      pct: ((completed.to_f/total.to_f)*100.to_f).round
    }
    
    render json: final
    
  end
  
  def reset
    
    GetModel(params[:type]).update_all({zendesk_id: nil,state: 'pending',code: nil,report: '',error: 0},{profile_id: params[:profile_id],pulled: 0})
    redirect_to '/imports/'+params[:profile_id].to_s+'/import/'+params[:type].to_s,notice: params[:type].to_s+' has been reset!'
    
  end
  
  
  def log
    
    respond_to do |format|
      
      format.csv do
        items = GetModel(params[:type]).where(state: 'imported',profile_id: params[:profile_id],error: 1)
        send_data items.to_csv(params),filename: "import_#{params[:type]}_#{Time.now.utc.iso8601}.csv"
      end
      
    end
    
  end
  
end