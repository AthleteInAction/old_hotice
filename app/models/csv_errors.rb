class CsvErrors < ActiveRecord::Base
  attr_accessible :data, :file_id, :row, :attempt_id, :alerts, :profile_id
  
  def self.to_csv
    
    show = ['row','match','alerts','data']
    
    CSV.generate do |csv|
      csv << show
      all.each_with_index do |file,i|
        file.attributes['row'] = (i+1)
        tmp = {
          'row' => file.attributes['row'],
          'new_i' => (i+1),
          'alerts' => file.attributes['alerts'],
          'data' => file.attributes['data'],
        }
        puts tmp.values
        csv << tmp.values
      end
    end
    
  end
  
  def self.to_raw
    
    headers = ['match']
    all.each do |file|
      Keys.where("attachment_id = #{file.file_id}").each do |k|
        
        headers << k['header']
        
      end
      break
    end
    
    csv = %{#{headers.join(',')}\n}
    all.each_with_index do |file,i|
      csv << %{#{(i+1)},#{file.data}}
    end
    
    csv
    
  end
    
end
