class PullController < ApplicationController
  
  before_filter :authorize
  before_filter :get_cfs, only: [:index]
  
  require 'zendeskAPI'
  
  def index
    
    valids = ['organizations','users','groups']
    
    if !valids.include? params['type']
      redirect_to "/profiles/#{params[:profile_id]}/pull/organizations",notice: "Invalid type: \"#{params[:type]}\""
    end
    
    @profile = Profile.find(params[:profile_id])
    @client = Client.find(@profile.destination)
    @zendesk = ZendeskAPI.new(
      domain: @client.subdomain,
      username: @client.username,
      password: @client.password
    )
    
  end
  
  
  def start
    
    valids = ['organizations','users','groups']
    
    if !valids.include? params['type']
      redirect_to request.path.gsub('/start',''),notice: "Invalid type: \"#{params[:type]}\""
    end
    
    profile = Profile.find(params['profile_id'])
    
    profile.update_attributes(locked: 1,action: "pulling_#{params['type']}")
    
    PullWorker.perform_async params
    
    redirect_to "/profiles/#{params[:profile_id]}/pull/#{params[:type]}",notice: "Pulling #{params[:type]}..."
    
  end
  
  
  def status
    
    profile = Profile.find(params[:profile_id])
    client = Client.find(profile.destination)
    zendesk = ZendeskAPI.new(
      domain: client.subdomain,
      username: client.username,
      password: client.password
    )
    
    total = zendesk.getCall("/api/v2/#{params[:type]}.json")[:body]['count']
    pulled = GetModel(params[:type]).where("pulled = 1 AND profile_id = #{profile.id}")
    pct = 0
    pct = ((pulled.count.to_f/total.to_f)*100).floor if total > 0
    
    final = {
      total: total,
      pulled: pulled.count,
      pct: pct,
      locked: profile.locked
    }
    
    render json: final
    
  end
  
  
end