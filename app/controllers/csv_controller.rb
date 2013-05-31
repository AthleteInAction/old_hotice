class CsvController < ApplicationController
  
  before_filter :authorize
  before_filter :get_cfs, only: [:files]
  
  def sender
    
    @profile = Profile.find(params[:profile_id])
    redirect_to '/profiles/'+params[:profile_id].to_s+'/csv/'+@profile.state.to_s
    
  end
  
  
  def files
    
    require 'zendeskAPI'
    
    @profile = Profile.find(params[:profile_id])
    @profile.update_attributes(state: params[:type])
    
    if params[:type] == 'users'
      
      client = Client.find(@profile.destination)
      zd = ZendeskAPI.new(domain: client.subdomain,username: client.username,password: client.password)
      roles = zd.getCall('/api/v2/custom_roles.json')
      
      if roles[:code].to_f.round == 200
        
        CustomRoles.where("client_id = #{client.id}").destroy_all

        roles[:body]['custom_roles'].each do |r|

          final = {
            id: r['id'],
            profile_id: @profile.id,
            client_id: client.id,
            name: r['name'].downcase
          }

          CustomRoles.create(final)

        end
        
      end
      
    end
    
  end
  
  
  def upload
    
    csv = GetCSV params[:attachment][:file].path
    @attachment = Attachment.new(file: params[:attachment][:file],profile_id: params[:profile_id],state: params[:type],total: csv.count)
    if @attachment.save
      
      csv.headers.each do |h|
        
        final = {
          attachment_id: @attachment.id,
          header: h,
          profile_id: params[:profile_id]
        }
        
        @field = ZendeskField.where("state = '#{params[:type]}' AND (db_name = '#{h}' OR display_name = '#{h}') AND active = 1 AND map = 1").limit(1)
        tmp = {active: 0}
        if @field.count == 0
          if params[:type] == 'tickets'
            
            cf = CustomFields.where(profile_id: params[:profile_id],display_name: h).limit(1)
            if cf.count == 1
              tmp = {field_id: cf.first.id,custom_field: 1}
            end
            
          end
        else
          tmp = {field_id: @field.to_a[0].id}
        end
        final = final.merge(tmp)
        
        Keys.new(final).save
        
      end
      
      ImportAttempts.new(profile_id: params[:profile_id],state: params[:type],active: 0).save
      
      redirect_to '/imports/'+params[:profile_id].to_s+'/csv/'+params[:type].to_s,notice: 'Upload successful!'
      
    else
      
      redirect_to '/imports/'+params[:profile_id].to_s+'/csv/'+params[:type].to_s,notice: 'Upload failed!'
      
    end
    
  end
  
  
  def extract
  
  attachment = Attachment.find(params[:attachment_id])
  attempt = CsvAttempt.create(profile_id: params['profile_id'],file_id: attachment['id'])
  puts %{+++\n}*10
  test = {profile_id: params['profile_id'],file_id: attachment['id']}
  puts attempt['id']
  puts %{+++\n}*10
  attachment.update_attributes(locked: 1,status: 'extracting')
  
  CsvWorker.perform_async params,attempt['id']
  
  respond_to do |format|
    format.html { redirect_to '/imports/'+params[:profile_id].to_s+'/csv/'+params[:type].to_s }
  end
    
  end
  
  
  def reset
    
    GetModel(params[:type]).where("file_id = #{params[:attachment_id]}").destroy_all
    CsvErrors.where("file_id = #{params[:attachment_id]}").destroy_all
    ImportAttempts.create(profile_id: params[:profile_id],state: params[:type],active: 0)
    @attachment = Attachment.find(params[:attachment_id])
    @attachment.update_attributes(locked: 0,complete: 0,status: 'ready')
    
    respond_to do |format|      
      format.html { redirect_to '/imports/'+params[:profile_id].to_s+'/csv/'+params[:type].to_s,notice: 'File has been reset!' }
    end
    
  end
  
  
  def log
    
    respond_to do |format|
      
      format.csv do
        attachment = Attachment.find(params[:attachment_id])
        errors = CsvErrors.where("file_id = #{params[:attachment_id]}").order("id ASC").except(:id,:created_at,:updated_at)
        send_data errors.to_csv,filename: "log_#{Time.now.utc.iso8601}_#{attachment.file.url.split('/').last}"
      end
      
    end
    
  end
  def raw
    
    respond_to do |format|
      
      format.csv do
        attachment = Attachment.find(params[:attachment_id])
        errors = CsvErrors.where("file_id = #{params[:attachment_id]}").order("id ASC").except(:id,:created_at,:updated_at)
        send_data errors.to_raw,filename: "new_#{Time.now.utc.iso8601}_#{attachment.file.url.split('/').last}"
      end
      
    end
    
  end
  
  
  def delete
    
    @attachment = Attachment.find(params[:attachment_id])
    @attachment.destroy
    CsvAttempt.where("file_id = #{params[:attachment_id]}").destroy_all
    CsvErrors.where("file_id = #{params[:attachment_id]}").destroy_all
    Keys.where(attachment_id: @attachment.id).destroy_all
    GetModel(params[:type]).where(file_id: @attachment.id).destroy_all
    
    respond_to do |format|      
      format.html { redirect_to '/profiles/'+params[:profile_id].to_s+'/csv/'+params[:type].to_s,notice: 'File has been deleted!' }
    end
    
  end
  
  def next
    
    states = ['organizations','users','groups','group_memberships','ticketcomments','tickets']
    profile = Profile.find(params[:profile_id])
    states.each_with_index do |s,i|
      
      if profile.state.to_s.downcase == s.to_s.downcase
        if (i+1)!=states.count
          profile.update_attributes(state: states[i+1])
        end
        break
      end
      
    end
    
    redirect_to '/profiles/'+profile.id.to_s+'/csv'
    
  end
  
  def back
    
    states = ['organizations','users','groups','group_memberships','ticketcomments','tickets']
    profile = Profile.find(params[:profile_id])
    states.each_with_index do |s,i|
      
      if profile.state.to_s.downcase == s.to_s.downcase
        if i != 0
          profile.update_attributes(state: states[i-1])
        end
        break
      end
      
    end
    
    redirect_to '/profiles/'+profile.id.to_s+'/csv'
    
  end
  
end