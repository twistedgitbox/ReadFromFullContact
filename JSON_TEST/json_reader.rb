#! /usr/bin/env ruby
require 'json'
require 'csv'

class ContactINFO

  def init_lize(filename)
    if File.exist?("./#{filename}2.csv") then
      File.truncate("./#{filename}2.csv", 0)
    end
    if File.exist?("./#{filename}.csv") then
      File.truncate("./#{filename}.csv", 0)
    end
    self.check_for_API_key
    puts "YOUR KEY IS #{@api_key}"
    label = "COMPANY"
    @org_info = {}
    @all_orgs = []
    @listings = []
    return label
  end

  def check_for_API_key
    api_key_path = "../.api_key_test"
    f = File.open(api_key_path, 'r')
    if !f.nil? && File.exist?(f)
      f.close unless f.closed?
      lines = IO.readlines(api_key_path)
      puts lines.length
      testme = lines[1]
    elsif
      puts "NO API KEY FILE"
      testme = "NoKey"
    end

    puts "TEST KEY #{testme}"
    @api_key = testme
    puts "#{@api_key}"
  end

  def reset_variables(filename)
    @infohash = ""
    @datafile = filename
    @org_info = {}
  end

  def convert_DATA_to_CSV(info_hash)
    datafile = "#{@datafile}.csv"
    CSV.open(datafile, "a") {|csv| info_hash.to_a.each {|elem| csv << elem} }


#      info_hash.each do |hash|
#        csv << hash.values
#      end
#   end
  end

  def write_csv(info_hash)
    datafile = "#{@datafile}2.csv"
    CSV.open(datafile, "a", headers: info_hash.keys) do |csv|
      #csv << ['URL', 'COMPANY', 'DESC', 'KEYWDS', 'PHONE']
      puts info_hash.keys
      csv << info_hash.values
    end
  end

  def read_JSON(filename)
    file = File.read "./#{filename}.json"
    data = JSON.parse(file)
    #puts data
    #puts data.class
    data.each do |key, val|
    #  puts "{#{key} => #{val}"
    puts
    end
    @all_orgs << data
    puts @all_orgs
    puts @all_orgs.count
    return data
  end

  def get_webInfo(data)
    webInfo = data.fetch("website")
    puts "URL: #{webInfo}"
    puts webInfo.class
    @org_info['url'] = webInfo
    return webInfo
  end

  def get_nameInfo(data)
    nameInfo = data.fetch("name")
    puts "NAME: #{nameInfo}"
    @org_info['company'] = nameInfo
    return nameInfo
  end

  def get_descInfo(data)
    descInfo = data.fetch("overview")
    puts "DESC: #{descInfo}"
    @org_info['desc'] = descInfo
  end

  def get_phoneInfo(data)
    phoneInfo = data.fetch("phoneNumbers")
    if phoneInfo.is_a?(Hash)
      puts "HASH"
      phone1 = phoneInfo
    elsif phoneInfo.is_a?(Array)
      puts "ARRAY"
      phone1 = phoneInfo[0]
    end
    puts phone1
    phone = phone1.fetch("number")
    puts phone
    @org_info['hq_phone'] = phone
  end

  def get_addressInfo(data)
    addressInfo = data.fetch("addresses")
    if addressInfo.is_a?(Hash)
      puts "HASH"
      address1 = addressInfo
    elsif addressInfo.is_a?(Array)
      puts "ARRAY"
      address1 = addressInfo[0]

    end
    puts address1
    line1 = address1.fetch("addressLine1")
    city = address1.fetch("locality")
    zip = address1.fetch("postalCode")
    stateInfo = address1.fetch("region")
    puts line1
    puts city
    puts zip
    state = stateInfo.fetch("name")
    puts state
    @org_info['address1'] = line1
    @org_info['city'] = city
    @org_info['state'] = state
    @org_info['zipcode'] = zip
  end

  def get_keywords(data)
    keyInfo = data.fetch("keywords")
    puts "KEYWORDS: #{keyInfo}"
    @org_info['keywds'] = keyInfo
  end

  def get_orgInfo(data)
    puts data.keys
    puts data.keys[7]
    fullorgInfo = data.fetch("organization")
    puts fullorgInfo.keys
    fullorgInfo.each do |key, val|
      puts "#{key} = #{val}"
      puts
    end

    nameInfo = self.get_nameInfo(fullorgInfo)
    descInfo = self.get_descInfo(fullorgInfo)
    keyInfo = self.get_keywords(fullorgInfo)
    puts "NAME: #{nameInfo}"
    orgInfo = fullorgInfo.fetch("contactInfo")
    puts orgInfo.class
    puts
    puts orgInfo.keys
    orgInfo.each do |key, val|
      puts "#{key} => #{val}"
      puts
      puts
    end
    phoneInfo = self.get_phoneInfo(orgInfo)
    addressInfo = self.get_addressInfo(orgInfo)

    return orgInfo
  end

  def run(filename, data)
    #label = self.init_lize(filename)
    #data = self.read_JSON(filename)
    self.reset_variables(filename)
    puts "FILE: #{filename}"
    webInfo = self.get_webInfo(data)
    puts
    puts
    orgInfo = self.get_orgInfo(data)
    puts @org_info
    self.convert_DATA_to_CSV(@org_info)
    self.write_csv(@org_info)
    my_hash = @org_info.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
    puts my_hash
    my_hash = @org_info

  end

  def cycle_through
    filename = "test"
    self.init_lize(filename)
    @listings << "test1"
    @listings << "test2"
    @listings << "test3"
    puts @listings
    listings = @listings
    listings.each_with_index do |company, index|
      puts "#{index} : #{company}"
      data = self.read_JSON(company)
      self.run(filename, data)
    end

  end

  def instance_test
    testarr= ["phone", "desc", "address"]
    category_arr = []
    testarr.each_with_index do |category, index|
      stage = "#{testarr[index]}Info"
      category_arr << stage
      #self.instance_variable_set(:@category, )
    end
    puts category_arr
    return category_arr
  end

end

x = ContactINFO.new

x.cycle_through
x.instance_test
