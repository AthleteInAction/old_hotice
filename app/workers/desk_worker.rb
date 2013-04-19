class DeskWorker
  
  include Sidekiq::Worker
  require 'gentools'
  require 'zendeskAPI'
  require 'deskAPI'
  require 'rinoThread'
  require 'csv'
  require 'mysql2'
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
  
  
  # Perform
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def perform params
    
    desk = DeskAPI.new(
      url: 'https://shopify.desk.com',
      key: 'ZCIF5koEMgl03j8qR7Rz',
      secret: 'B11szsyi3PzXG9nXamPBihyrRmqfE0IAHd023f5L',
      token: '5AUBQwpalS0ifzspMRHM',
      token_secret: 'bN9H8wsyQnK2Zr28yyELTfTroaY2W0k894o71QbZ'
    )
    
    pages = desk.cases(status: 'new,open,pending,resolved')[:pages]
    JP %{Total pages: #{pages}\n}
    list = RinoThread.new(2)
    pages.times do |page|
      page += 1
      #break if page >= 5
      list.queue do

        a = Time.now.to_f

        sql = Mysql2::Client.new(
          :host => 'localhost',
          :username => 'root',
          :database => 'desk'
        )
        inserts = []
        cases = desk.cases(page: page,status: 'new,open,pending,resolved')[:body]
        cases.each_with_index do |c,i|
          
          c = c['case']
          final = {
            desk_id: c['id'],
            priority: c['priority'],
            subject: c['subject'],
            description: c['description'],
            customer_id: c['customer_id'],
            case_status_type: c['case_status_type'],
            labels: c['labels'],
            created_at: c['created_at']
          }
          if c['group']
            final = final.merge(group_id: c['group']['id'],group_name: c['group']['name'])
          end
          if c['user']
            final = final.merge(user_id: c['user']['id'],user_name: c['user']['name'])
          end
          inserts << final
          
          r = (page.to_f*100).to_f+(i+1)
          STDOUT.write %{Page: #{page} || Record: #{r}        \r}
          
        end
        
        DeskCases.create(inserts)
        
        b = Time.now.to_f
        sql.close
        c = b.to_f-a.to_f
        if c < 2

          delay = 2.to_f - c.to_f
          sleep delay

        end
        d = Time.now.to_f
        e = d.to_f-a.to_f

      end
    end
    list.execute
    JP %{\n}
    
  end
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # -:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
end