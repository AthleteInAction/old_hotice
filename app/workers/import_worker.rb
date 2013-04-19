class ImportWorker
  
  include Sidekiq::Worker
  require 'gentools'
  require 'zendeskAPI'
  require 'rinoThread'
  sidekiq_options retry: false
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
  
  
  
  # Main Import
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def perform params
    
    profile = Profile.find(params['profile_id'])
    client = Client.find(profile['destination'])
    
    @zendesk = ZendeskAPI.new(
      domain: client['subdomain'],
      username: client['username'],
      password: client['password']
    )
    
    if params['type'] == 'organizations'
      profile.update_attributes(status: 'running',locked: 1)
      ImportOrganizations @zendesk,params,client,profile
      profile.update_attributes(status: 'opened',locked: 0)
    end
    ImportUsers @zendesk,params,client,profile if params['type'] == 'users'
    ImportGroups @zendesk,params,client,profile if params['type'] == 'groups'
    ImportTickets @zendesk,params,client,profile if params['type'] == 'tickets'
    
  end
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  
  # Import Organizations
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def ImportOrganizations zd,params,client,profile
    
    attempt = ImportAttempts.create(profile_id: profile['id'],state: params['type'])
    orgs = Organizations.where("state = 'pending' AND error = 0 AND profile_id = #{profile['id']}")
    fields = ZendeskField.where("zendesk = 1 AND state = '#{params['type']}'")
    fnames = {}
    fields.each do |f|
      
      fnames = fnames.merge(f.id.to_s => f.db_name)
      
    end
    amaps = []
    mappings = Maps.where(profile_id: params['profile_id'],active: 1,data_type: params['type']).order('id ASC').each do |m|
      
      con = []
      act = []
      
      Conditions.where(map_id: m[:id]).each do |c|
        
        con << {field_id: c.field_id,condition: c.condition,field_value: c.field_value}
        
      end
      MActions.where(map_id: m[:id]).each do |a|
        
        act << {field_id: a.field_id,field_val: a.field_val,atype: a.atype,field_2_id: a.field_2_id}
        
      end
      
      tmp = {
        con: con,
        act: act
      }
      amaps << tmp
      
    end
    
    JP amaps
    
    olist = []
    orgs.each_with_index do |o,i|
      
      tmp = {}
      
      fields.each do |f|
        
        key = f['db_name'].to_s
        val = o[f['db_name']]
        
        
        tmp = tmp.merge(key => val) if val
        #JP tmp if val
        
      end
      
      amaps.each do |m|
        
        cmet = 0
        
        m[:con].each do |c|
          
          # IS
          # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
          if c[:condition] == 'is'
            
            if o[fnames[c[:field_id].to_s]].to_s.downcase == c[:field_value].to_s.downcase
              cmet += 1
            end
            
          end
          # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
          
          # IS NOT
          # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
          if c[:condition] == 'is_not'
            
            if o[fnames[c[:field_id].to_s]].to_s.downcase != c[:field_value].to_s.downcase
              cmet += 1
            end
            
          end
          # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
          
          # CONTAINS
          # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
          if c[:condition] == 'contains'
            
            if o[fnames[c[:field_id].to_s]].to_s.downcase.include?(c[:field_value].to_s.downcase)
              cmet += 1
            end
            
          end
          # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
          
          # DOES NOT CONTAIN
          # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
          if c[:condition] == 'no_contain'
            
            if !o[fnames[c[:field_id].to_s]].to_s.downcase.include?(c[:field_value].to_s.downcase)
              cmet += 1
            end
            
          end
          # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
          
          # EVERYTIME
          # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
          if c[:condition] == 'everytime'
            
            JP %{everytime}
            cmet += 1
            
          end
          # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
          
        end
        
        
        if cmet == m[:con].count
          JP m[:act]
          m[:act].each do |a|
            
            if a[:atype] == 'map'
              
              JP %{MAP}
              tmp[fnames[a[:field_2_id].to_s]] = tmp[fnames[a[:field_id].to_s]]
              JP %{Mapped #{fnames[a[:field_id].to_s]} to #{fnames[a[:field_2_id].to_s]}}
              
            end
            
            if a[:atype] == 'change'
              
              tmp[fnames[a[:field_id].to_s]] = a[:field_val]
              JP %{Changed #{fnames[a[:field_id].to_s]} to #{tmp[fnames[a[:field_id].to_s]]}}
              
            end
            
          end
          
        end
        
        
        
      end
      
      olist << [o['id'],tmp]
      JP tmp
      #break if i >= 20
      
    end
    
    tasks = RinoThread.new(9)
    olist.each_with_index do |item,i|
      tasks.queue do
        1.times do
          
          a_t = Time.now

          sql = Mysql2::Client.new(:host => 'localhost',:username => 'root',:database => 'migrationrocket_v2')

          q = "SELECT * FROM import_attempts WHERE profile_id = #{profile['id']} AND state = '#{params['type']}' ORDER BY id DESC LIMIT 1"
          breakit = false
          sql.query(q).each do |ia|
            JP %{|||----- #{ia['active']}}
            if ia['active'] == 0
              @on = false
              breakit = true
            end
          end
          
          if breakit
            sql.close
            break            
          end

          tmp = {organization: item[1]}.to_json
          call = zd.postCall('/api/v2/organizations.json',tmp)

          q = "UPDATE organizations SET code = #{call[:code].to_f.round}"

          update = {code: call[:code]}
          if call[:code].to_f.round == 201

            update = update.merge(status: 'imported')
            q << ",state = 'imported'"
            q << ",zendesk_id = #{call[:body]['organization']['id']}"

          else

            update = update.merge(status: 'imported',error: 1,report: call[:body].to_json)
            q << ",state = 'imported'"
            q << ",error = 1"
            q << ",report = '#{sql.escape(call[:body].to_json)}'"

          end

          q << " WHERE id = #{item[0]}"

          sql.query(q)
          sql.close

          b_t = Time.now

          JP %{#{(i+1)} ::: #{b_t.to_f-a_t.to_f}\n}
          
        end
      end
    end
    
    tasks.execute
    
    
    attempt.update_attributes(active: 0)
    
  end
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  # Import Users
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def ImportUsers zd,params,client,profile
    
    limit = 1000000000
    limit = params['limit'] if params['limit']
    
    attempt = ImportAttempts.create(profile_id: profile['id'],state: params['type'])
    orgs = ZdUsers.where(state: 'pending',error: 0,profile_id: profile['id']).limit(limit)
    fields = ZendeskField.where(zendesk: 1,state: 'users')
    olist = []
    orgs.each do |o|
      
      tmp = {}
      
      fields.each do |f|
        
        key = f['db_name'].to_s
        val = o[f['db_name']]
        if val
          val.strip! if key.include? 'email'
          #val << '.fake.zd' if key == 'email'
          tmp = tmp.merge(key => val)
        end
        
      end
      
      olist << [o['id'],tmp]
      
    end
    
    tasks = RinoThread.new(7)
    olist.each_with_index do |item,i|
      tasks.queue do
        1.times do
          
          a_t = Time.now

          sql = Mysql2::Client.new(:host => 'localhost',:username => 'root',:database => 'migrationrocket_v2')

          q = "SELECT * FROM import_attempts WHERE profile_id = #{profile['id']} AND state = '#{params['type']}' ORDER BY id DESC LIMIT 1"
          breakit = false
          sql.query(q).each do |ia|
            #JP %{|||----- #{ia['active']}}
            if ia['active'] == 0
              @on = false
              breakit = true
            end
          end
          
          if breakit
            sql.close
            break            
          end

          tmp = {user: item[1]}
          pres = {i => tmp}
          #JP pres
          #sql.close
          #break
          call = zd.postCall('/api/v2/users.json',tmp.to_json)
          pres = {time: call[:time],i => tmp}
          JP pres

          q = "UPDATE zd_users SET code = #{call[:code].to_f.round}"

          update = {code: call[:code]}
          if call[:code].to_f.round == 201

            update = update.merge(status: 'imported')
            q << ",state = 'imported'"
            q << ",zendesk_id = #{call[:body]['user']['id']}"

          else

            update = update.merge(status: 'imported',error: 1,report: call[:body].to_json)
            q << ",state = 'imported'"
            q << ",error = 1"
            q << ",report = '#{sql.escape(call[:body].to_json)}'"

          end

          q << " WHERE id = #{item[0]}"

          sql.query(q)
          sql.close

          b_t = Time.now

          #JP %{#{(i+1)} ::: #{b_t.to_f-a_t.to_f}\n}
          
        end
      end
    end
    
    tasks.execute
    
    
    attempt.update_attributes(active: 0)
    
  end
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  # Import Groups
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def ImportGroups zd,params,client,profile
    
    attempt = ImportAttempts.create(profile_id: profile['id'],state: params['type'])
    orgs = Groups.where("state = 'pending' AND error = 0 AND profile_id = #{profile['id']}")
    fields = ZendeskField.where("zendesk = 1 AND state = 'groups'")
    olist = []
    orgs.each do |o|
      
      tmp = {}
      
      fields.each do |f|
        
        key = f['db_name'].to_s
        val = o[f['db_name']]
        val << '.zd' if key == 'email'
        tmp = tmp.merge(key => val) if o[f['db_name']]
        
      end
      
      olist << [o['id'],tmp]
      
    end
    
    tasks = RinoThread.new(9)
    olist.each_with_index do |item,i|
      tasks.queue do
        1.times do
          
          a_t = Time.now

          sql = Mysql2::Client.new(:host => 'localhost',:username => 'root',:database => 'migrationrocket_v2')

          q = "SELECT * FROM import_attempts WHERE profile_id = #{profile['id']} AND state = '#{params['type']}' ORDER BY id DESC LIMIT 1"
          breakit = false
          sql.query(q).each do |ia|
            if ia['active'] == 0
              @on = false
              breakit = true
            end
          end
          
          if breakit
            sql.close
            break            
          end

          tmp = {group: item[1]}
          pres = {type: params['type'],i => tmp}
          JP pres
          #sql.close
          #break
          call = zd.postCall('/api/v2/groups.json',tmp.to_json)

          q = "UPDATE groups SET code = #{call[:code].to_f.round}"

          update = {code: call[:code]}
          if call[:code].to_f.round == 201

            update = update.merge(status: 'imported')
            q << ",state = 'imported'"
            q << ",zendesk_id = #{call[:body]['group']['id']}"

          else

            update = update.merge(status: 'imported',error: 1,report: call[:body].to_json)
            q << ",state = 'imported'"
            q << ",error = 1"
            q << ",report = '#{sql.escape(call[:body].to_json)}'"

          end

          q << " WHERE id = #{item[0]}"

          sql.query(q)
          sql.close

          b_t = Time.now
          
        end
      end
    end
    
    tasks.execute
    
    
    attempt.update_attributes(active: 0)
    
  end
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  
  # Import Tickets
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def ImportTickets zd,params,client,profile
    
    limit = 1000000000
    limit = params['limit'] if params['limit']
    
    attempt = ImportAttempts.create(profile_id: profile['id'],state: params['type'])
    items = GetModel(params['type']).where("state = 'pending' AND error = 0 AND profile_id = #{profile['id']}").limit(limit)
    fields = ZendeskField.where("zendesk = 1 AND state = '#{params['type']}'")
    c_fields = CustomFields.where("profile_id = #{profile['id']}")
    list = []
    items.each do |item|
      
      tmp = {custom_fields: []}
      
      fields.each do |f|
        
        key = f['db_name'].to_s
        key = 'type' if key == 't_type'
        val = item[f['db_name']]
        if val
          #val << '.fake.zd' if key == 'email'
          key = 'created_at' if key == 'cdate'
          tmp = tmp.merge(key => val)
        end
        
      end
      
      c_fields.each do |f|
        
        if f.id != 21723132
          
          cfs = {
            id: f.id,
            value: item["cf_#{f.rel}"]
          }
          tmp[:custom_fields] << cfs
          
        end
        
      end
      
      isql = Mysql2::Client.new(:host => 'localhost',:username => 'root',:database => 'migrationrocket_v2')
      q = "SELECT * FROM ticket_comments WHERE profile_id = #{params['profile_id']} AND ticket_id = '#{item['old_id']}'"
      comments = []
      pub = [false,true]
      isql.query(q).each do |c|
        comments << {
          author_id: c['author_id'],
          public: pub[c['public'].to_f.round],
          body: c['value'],
          created_at: c['cdate']
        }
      end
      isql.close
      
      tmp = tmp.merge(comments: comments)
      
      list << [item['id'],tmp]
      
    end
    
    tasks = RinoThread.new(15)
    inc = 0
    JP %{Total: #{items.count}\n}
    list.each_with_index do |item,i|
      tasks.queue do
        1.times do
          
          a_t = Time.now

          sql = Mysql2::Client.new(:host => 'localhost',:username => 'root',:database => 'migrationrocket_v2')

          q = "SELECT * FROM import_attempts WHERE profile_id = #{profile['id']} AND state = '#{params['type']}' ORDER BY id DESC LIMIT 1"
          breakit = false
          sql.query(q).each do |ia|
            if ia['active'] == 0
              @on = false
              breakit = true
            end
          end
          
          if breakit
            sql.close
            break            
          end

          tmp = {ticket: item[1]}
          item[1]['tags'] = item[1]['tags'].split(',')
          #item[1]['tags'] << 'import_v5'
          pres = {type: params['type'],i => tmp}
          
          call = zd.postCall("/api/v2/imports/tickets.json",tmp.to_json)

          q = "UPDATE #{params['type']} SET code = #{call[:code].to_f.round}"

          update = {code: call[:code]}
          if call[:code].to_f.round == 201

            update = update.merge(status: 'imported')
            q << ",state = 'imported'"
            q << ",zendesk_id = #{call[:body]['ticket']['id']}"

          elsif call[:code].to_f.round == 500
            
            JP %{>>> 500 Error! <<<\n}
            
          else
            
            #JP tmp
            update = update.merge(status: 'imported',error: 1,report: call[:body].to_json)
            q << ",state = 'imported'"
            q << ",error = 1"
            q << ",report = '#{sql.escape(call[:body].to_json)}'"

          end

          q << " WHERE id = #{item[0]}"

          sql.query(q)
          sql.close

          b_t = Time.now
          
          inc += 1
          print "\rImport ##{inc} || #{call[:code]}       "
          
        end
      end
    end
    
    tasks.execute
    
    
    attempt.update_attributes(active: 0)
    
    JP %{\n}
    
  end
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  
  
end