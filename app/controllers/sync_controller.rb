class SyncController < ApplicationController
  
  # Infrastructure
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  require 'zendeskAPI'
  require 'rinoThread'
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  
  # Sync Records from Zendesk Instance
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # /import/:profile_id/sync
  def index
    
    @profile = Profile.find(params[:profile_id])
    @client = Client.find(@profile.destination)
    @zendesk = ZendeskAPI.new(
      domain: @client.subdomain,
      username: @client.username,
      password: @client.password
    )
    
  end
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  
  # Start Sync
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def start
    
    @profile = Profile.find(params[:profile_id])
    @profile.update_attributes(synced: 1,status: 'opened')
    @client = Client.find(@profile.destination)
    @zendesk = ZendeskAPI.new(
      domain: @client.subdomain,
      username: @client.username,
      password: @client.password
    )
    
    final = {
      sync: {
      
      }
    }
    
    @profile.update_attributes(locked: 1,action: 'syncing')
    PullWorker.perform_async params
    
    redirect_to request.path.to_s.gsub('/start.json',''),notice: "Syncing with Zendesk!"
    
  end
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  
  # Status
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def status
    
    profile = Profile.find(params[:profile_id])
    client = Client.find(profile.destination)
    zendesk = ZendeskAPI.new(
      domain: client.subdomain,
      username: client.username,
      password: client.password
    )
    
    threads = RinoThread.new(10)
    threads.queue do
      @orgs = zendesk.getCall("/api/v2/organizations.json")[:body]['count']    
      @orgs_pulled = Organizations.where("pulled = 1 AND profile_id = #{profile.id}")
      @orgs_pct = 0
      @orgs_pct = ((@orgs_pulled.count.to_f/@orgs.to_f)*100).floor if @orgs > 0
    end
    threads.queue do
      @users = zendesk.getCall("/api/v2/users.json")[:body]['count']    
      @users_pulled = ZdUsers.where("pulled = 1 AND profile_id = #{profile.id}")
      @users_pct = 0
      @users_pct = ((@users_pulled.count.to_f/@users.to_f)*100).floor if @users > 0
    end
    threads.queue do
      @groups = zendesk.getCall("/api/v2/groups.json")[:body]['count']    
      @groups_pulled = Groups.where("pulled = 1 AND profile_id = #{profile.id}")
      @groups_pct = 0
      @groups_pct = ((@groups_pulled.count.to_f/@groups.to_f)*100).floor if @groups > 0
    end
    threads.execute
    
    final = {
      organizations: {
        total: @orgs,
        pulled: @orgs_pulled.count,
        pct: @orgs_pct
      },
      users: {
        total: @users,
        pulled: @users_pulled.count,
        pct: @users_pct
      },
      groups: {
        total: @groups,
        pulled: @groups_pulled.count,
        pct: @groups_pct
      },
      locked: profile.locked,
      action: profile.action
    }
    
    render json: final
    
  end
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
end