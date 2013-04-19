require 'zendeskAPI'
require 'gentools'
require 'rinoThread'


Live = ZendeskAPI.new(
  domain: 'prophix',
  username: 'robert.sipko@customware.net',
  password: 'Embra5!'
)
Sand = ZendeskAPI.new(
  domain: 'prophix1361983205',
  username: 'robert.sipko@customware.net',
  password: 'Embra5!'
)


fields = Live.getCall('/api/v2/ticket_fields.json')[:body]
standard = ['subject','description','status','tickettype','priority','group','assignee']
custom_fields = []
fields['ticket_fields'].each do |f|
  
  f.delete('id')
  f.delete('url')
  f.delete('created_at')
  f.delete('updated_at')
  
  custom_fields << f if !standard.include?(f['type'].to_s.downcase)
  
end

rino = RinoThread.new(5)

custom_fields.each do |f|
  rino.queue do
    
    f = {ticket_field: f}
    call = Sand.postCall('/api/v2/ticket_fields.json',f.to_json)
    JP call[:body]
    
  end
end

rino.execute