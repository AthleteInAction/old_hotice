class ApplicationController < ActionController::Base

  #add_breadcrumb 'Home','/'
  
  protect_from_forgery
  
  def GetHeaders file
    
    header = []
    CSV.foreach(file,:encoding => 'windows-1251:utf-8',:headers => true) do |row|
      
      header = row.headers
      break
      
    end
    
    header
    
  end
  
  def GetCSV file
    
    CSV.read(file,"r:ISO-8859-15:UTF-8",:headers => true)
    
  end
  
  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user
  
  def get_cfs
    FieldsWorker.perform_async params
  end

  def authorize
    redirect_to login_url, alert: "Not authorized" if current_user.nil?
  end
  
  def adminize
    redirect_to login_url, alert: "Not authorized" if current_user['role'].to_s != 'admin'
  end
  
  def restrictor params,profile
    
    if params[:type].to_s.downcase != profile.state.to_s.downcase
      redirect_to '/profiles/'+profile.id.to_s+'/csv/'+profile.state.to_s,notice: 'Not allowed to move on yet!' if profile.source.downcase == 'csv'
    end
    
  end
  
  
  def GetModel type
    
    ntype = type.capitalize
    
    if type.to_s.downcase == 'users'
      ntype = 'ZdUsers'
    end
    if type.to_s.downcase == 'ticket_comments'
      ntype = 'TicketComments'
    end
    
    ntype.constantize
    
  end
  helper_method :GetModel
  
end
