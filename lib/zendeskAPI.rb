class ZendeskAPI
  
  # Includes
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  require 'json'
  require 'net/http'
  require 'net/https'
  require 'uri'
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  
  # Set Infrastructure
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def initialize params = {}
    
    @subdomain           = params[:domain]
    @username            = params[:username]
    @password            = params[:password]
    @roles = {
      'end-user' => '0', 0 => '0',
      'admin'    => '2', 2 => '2',
      'agent'    => '4', 4 => '4'
    }
    
  end
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  
  # Test Connection
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def testConn
    
    test = getCall('/api/v2/users.json')
    
    if test[:code].to_f.round == 200
      
      result = {
        :connection => test[:code].to_f.round,
        :status => 'Success!'
      }
      
    else
      
      result = {
        :connection => test[:code].to_f.round,
        :status => 'Failed!',
        :body => test[:body]
      }
      
    end
    
  end
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  
  # GET Call
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def getCall path
    
    a = Time.now.to_f
    http = Net::HTTP.new(@subdomain+'.zendesk.com',443)
    req = Net::HTTP::Get.new(path)
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = true
    req.content_type = 'application/json'
    req.basic_auth @username,@password
    response = http.request(req)
    code = response.code
    body = response.body
    b = Time.now.to_f
    c = ((b-a)*100).round.to_f/100
    
    final = {:code => code.to_f.round,:body => JSON.parse(body),time: c}
    
  end
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # POST Call
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def postCall path,payload
    
    a = Time.now.to_f
    http = Net::HTTP.new(@subdomain+'.zendesk.com',443)
    req = Net::HTTP::Post.new(path)
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = true
    req.content_type = 'application/json'
    req.basic_auth @username,@password
    req.body = payload
    response = http.request(req)
    code = response.code.to_f.round
    body = response.body
    b = Time.now.to_f
    c = ((b-a)*100).round.to_f/100
    
    final = {:code => code,time: c}
    if code == 500
      final = final.merge(:body => body)
    else
      final = final.merge(:body => JSON.parse(body))
    end
    
    final
    
  end
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # PUT Call
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def putCall path,payload
    
    a = Time.now.to_f
    http = Net::HTTP.new(@subdomain+'.zendesk.com',443)
    req = Net::HTTP::Put.new(path)
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = true
    req.content_type = 'application/json'
    req.basic_auth @username,@password
    req.body = payload
    response = http.request(req)
    code = response.code
    body = response.body
    b = Time.now.to_f
    c = ((b-a)*100).round.to_f/100
    #body = JSON.parse(body) if code.to_f.round = 200
    
    final = {:code => code.to_f.round,:body => JSON.parse(body),time: c}
    
  end
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # DELETE Call
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def deleteCall path
    
    a = Time.now.to_f
    http = Net::HTTP.new(@subdomain+'.zendesk.com',443)
    req = Net::HTTP::Delete.new(path)
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = true
    req.content_type = 'application/json'
    req.basic_auth @username,@password
    response = http.request(req)
    code = response.code
    b = Time.now.to_f
    c = ((b-a)*100).round.to_f/100
    
    final = {:code => code.to_f.round,time: c}
    
  end
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # UPLOAD Call
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def uploadCall path,payload
    
    a = Time.now.to_f
    http = Net::HTTP.new(@subdomain+'.zendesk.com',443)
    req = Net::HTTP::Post.new(path)
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = true
    req.content_type = 'application/binary'
    req.basic_auth @username,@password
    req.body = payload
    response = http.request(req)
    code = response.code
    body = response.body
    b = Time.now.to_f
    c = ((b-a)*100).round.to_f/100
    
    final = {:code => code.to_f.round,:body => JSON.parse(body),time: c}
    
  end
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
end