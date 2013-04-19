require 'rubygems'
require 'json'



def valid_json? json_  
  begin  
    JSON.parse(json_)  
    return true  
  rescue Exception => e  
    return false  
  end  
end
def JP val
  
  if val.instance_of?(Array) || val.instance_of?(Hash) || valid_json?(val)
    
    puts JSON.pretty_generate val
    
  else
    
    puts val
    
  end
  
end
class String
  def is_number?
    true if Float(self) rescue false
  end
end


# End Time
#-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
def ET time

  diff = ((Time.now.to_f-time)*1000).round.to_f/1000

end
#-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:


# Get File Contents
#-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
def GetFile path

  if File.exists? path

    file = File.open(path)
    contents = file.read
    file.close

  else

    contents = false

  end

  contents

end
#-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:


# Make Directory
#-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
def MakeDir path,output = true
  
  if !File.exists?(path)
    
    if Dir::mkdir(path,0777)

      puts %{#{File.expand_path(path)} was created!} if output

    end
    
  end

end
#-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:



# Write File
#-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:
def Write path,data

  File.open(path,'w') do |f|

    f.puts data

  end
  
  true

end
#-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:-:



# Up
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