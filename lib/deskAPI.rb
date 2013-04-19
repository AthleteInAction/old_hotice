class DeskAPI
  
  # Includes
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  require 'json'
  require 'net/http'
  require 'net/https'
  require 'uri'
  require 'oauth'
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  
  # Initialize
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def initialize params = {}
    
    @url = params[:url]
    @path = "#{@url}/api/v1"
    
    consumer = OAuth::Consumer.new(
      params[:key],
      params[:secret],
      :site => params[:url],
      :scheme => :header
    )
    @desk = OAuth::AccessToken.from_hash(
      consumer,
      :oauth_token => params[:token],
      :oauth_token_secret => params[:token_secret]
    )
    
  end
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  
  # Up
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def Up params = {}

    query = ''

    i = 0
    params.each do |key,val|

      query += '?' if i == 0
      query += '&' if i > 0
      query += key.to_s+'='+val.to_s
      i += 1

    end

    query

  end
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  
  # Methods
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def users params = {}
    params = params.merge(data: :users)
    get params
  end
  def user id
    params = {}
    params = params.merge(data: "users/#{id}")
    single_get params
  end
  def cases params = {}
    params = params.merge(data: :cases)
    get params
  end
  def case id
    params = {}
    params = params.merge(data: "cases/#{id}")
    single_get params
  end
  def customers params = {}
    params = params.merge(data: :customers)
    get params
  end
  def customer id
    params = {}
    params = params.merge(data: "customers/#{id}")
    single_get params
  end
  def groups params = {}
    params = params.merge(data: :groups)
    get params
  end
  def group id
    params = {}
    params = params.merge(data: "groups/#{id}")
    single_get params
  end
  def interactions params = {}
    params = params.merge(data: :interactions)
    get params
  end
  def interaction id
    params = {}
    params = params.merge(data: "interactions/#{id}")
    single_get params
  end
  def article id
    params = {}
    params = params.merge(data: "articles/#{id}")
    single_get params
  end
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
  
  
  # GET
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def get params = {}
    
    params[:count] = 100 if !params[:count]
    count = params[:count]
    
    data = params[:data]
    params.delete(:data)
    
    params = Up params
    path = "#{@path}/#{data}.json#{params}"
    call = @desk.get(path)
    body = JSON.parse(call.body)
    final = {
      code: call.code.to_f.round,
      body: body['results'],
      total: body['total'],
      count: body['count'],
      page: body['page'],
      pages: (body['total'].to_f/count.to_f).ceil
    }
    
  end
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # SINGLE GET
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def single_get params = {}
    
    data = params[:data]
    params.delete(:data)
    params = Up params
    path = "#{@path}/#{data}.json#{params}"
    call = @desk.get(path)
    body = JSON.parse(call.body)
    {code: call.code.to_f.round,body: body}
    
  end
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  # Download File
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  def GetFile path
    
    uri = URI(path)
    json = Net::HTTP.get(uri)
    
  end
  #-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
  
end