#! /usr/bin/env ruby
require 'json'
require 'csv'

class CB_ContactINFO

  def initialize
    puts "INIT JSON CHECK"

    ## TRACK METHODS ##
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS

    #self.check_for_API_key
    #puts "YOUR KEY IS #{@api_key}"
    @org_info = {}
    @all_orgs = []
    @listings = []
  end

  def init_lize(filename)
    puts "START JSON CHECK"

    ## TRACK METHODS ##
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS
    puts; puts; puts
    filename.sub!(/^.\/read\//,'')
    filename = "./export/CSV/#{filename}"
    puts "#### TRUNCATE FILES #{filename}"
    if File.exist?("./#{filename}_.csv") then
      File.truncate("./#{filename}_.csv", 0)
    end
    if File.exist?("./#{filename}.csv") then
      File.truncate("./#{filename}.csv", 0)
    end

    #self.check_for_API_key
    #puts "YOUR KEY IS #{@api_key}"
    label = "COMPANY"
    puts "init #{label}"
    return label
  end

  def check_for_API_key

    ## TRACK METHODS ##
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS

    api_key_path = "./.api_key_test"
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

    ## TRACK METHODS ##
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS

    @infohash = {}
    @datafile = filename
    @org_info = {}
  end

  def convert_DATA_to_CSV(info_hash)

    ## TRACK METHODS ##
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS

    datafile = @datafile
    datafile.sub!(/^.\/read\//,'')
    datafile = "./export/CSV/#{@datafile}.csv"

    puts "FILE LOCATION: #{datafile}"
    CSV.open(datafile, "a") {|csv| info_hash.to_a.each {|elem| csv << elem} }


#      info_hash.each do |hash|
#        csv << hash.values
#      end
#   end
  end

  def write_csv(info_hash)

    ## TRACK METHODS ##
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS

    datafile = @datafile
    puts "##########"
    puts "INFO #{info_hash}"
    puts "##########"
    datafile.sub!(/^.\/read\//,'')
    datafile = "./export/CSV/#{@datafile}_.csv"

    puts
    puts
    puts
    puts "FILELOCATION: #{datafile}"
    CSV.open(datafile, "a", headers: info_hash.keys) do |csv|
      #csv << ['URL', 'COMPANY', 'DESC', 'KEYWDS', 'PHONE']
      puts info_hash.keys
      csv << info_hash.values
    end
  end

  def read_JSON_file(filename, filepath)

    ## TRACK METHODS ##
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS

    puts "READING JSON FILE #{filename} at #{filepath}"
    #file = File.read "./export/FC/#{filename}.json"
    file = File.read "#{filepath}"
    data = JSON.parse(file)
    newdata = self.get_all_orgdata(data)
    data = newdata
    puts data
    return data
  end

  def get_all_orgdata(data)

    ## TRACK METHODS ##
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS

    #data = JSON.parse(data)
    puts
    puts "CLASS: #{data.class}"
    puts "TYPE: "
    puts ":: #{data}"
    puts
    #puts data.class
    data.each do |key, val|
    #  puts "{#{key} => #{val}"
    puts
    end
    @all_orgs << data
    puts @all_orgs
    puts @all_orgs.count
    puts data
    return data
  end

  def read_JSON_info(data)

    ## TRACK METHODS ##
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS

    json_data = JSON.parse(data)
    #newdata = self.get_all_orgdata(data)
    #data = newdata
    #puts data
    #return data

    newdata = self.get_all_orgdata(json_data)
    data = newdata
    puts data
    puts data.class
    data.each do |key, val|
      puts "{#{key} => #{val}"
    end
    @all_orgs << data
    puts @all_orgs
    puts @all_orgs.count
    puts data
    return data
  end


  def get_webInfo(data)

    ## TRACK METHODS ##
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS

    if data.has_key? "website" then
      webInfo = data.fetch("website")
    else
      webInfo == "NONE"
    end

    puts "URL: #{webInfo}"
    puts webInfo.class
    @org_info['url'] = webInfo
    return webInfo
  end

  def get_nameInfo(data)

    ## TRACK METHODS ##
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS

    if data.has_key? "name" then
      nameInfo = data.fetch("name")
    else
      nameInfo = "NONE"
    end

    puts "NAME: #{nameInfo}"
    @org_info['company'] = nameInfo
    return nameInfo
  end

  def get_descInfo(data)

    ## TRACK METHODS ##
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS

    if data.has_key? "overview" then
      descInfo = data.fetch("overview")
    else
      descInfo = "NONE"
    end

    descInfo = data.fetch("overview")
    puts "DESC: #{descInfo}"
    @org_info['desc'] = descInfo
    return descInfo
  end

  def get_phoneInfo(data)

    ## TRACK METHODS ##
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS

    if data.has_key? "phoneNumbers" then
      phoneInfo = data.fetch("phoneNumbers")
    else
      phoneInfo = "NONE"
    end

    if phoneInfo.is_a?(Hash)
      puts "HASH"
      phone1 = phoneInfo
    elsif phoneInfo.is_a?(Array)
      puts "ARRAY"
      phone1 = phoneInfo[0]
    else
      phone = "NONE"
    end
    puts "PHONESET: #{phone1}"


    if phone1.is_a?(Hash) then
      phone = phone1.fetch("number") if  phone1.has_key? "number"
      phone = phone1.fetch("Number") if phone1.has_key? "Number"
    end

    puts "PHONE #{phone}"
    @org_info['hq_phone'] = phone
    return phone
  end

  def get_addressInfo(data)

    ## TRACK METHODS ##
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS
    if data.has_key? "addresses" then
      addressInfo = data.fetch("addresses")
    else
      addressInfo == "NONE"
    end

    puts "addressInfo : #{addressInfo}"
    if addressInfo.is_a?(Hash)
      puts "HASH"
      address1 = addressInfo
    elsif addressInfo.is_a?(Array)
      puts "ARRAY"
      address1 = addressInfo[0]
    else
      address1 = "NONE"
    end

    puts "ADDRESS SET: #{address1}"
    if address1.is_a?(Hash) then
      line1 = address1.fetch("addressLine1") if address1.has_key? "addressLine1"
      city = address1.fetch("locality") if address1.has_key? "locality"
      zip = address1.fetch("postalCode") if address1.has_key? "postalCode"
      stateInfo = address1.fetch("region") if address1.has_key? "region"
      countryInfo = address1.fetch("country") if address1.has_key? "country"
      stateInfo = address1.fetch("state") if address1.key?("state")
      if stateInfo.kind_of?(Hash) then
        state = stateInfo.fetch("code") if stateInfo.has_key? "code"
        puts "StateInfo #{stateInfo}"
      else
        state = stateInfo
      end

      if countryInfo.kind_of?(Hash) then
        country = countryInfo.fetch("name") if countryInfo.has_key? "name"
      else
        country = countryInfo
      end
    else
      line1 = "NONE LISTED"
      city = "NONE LISTED"
      zip = "NONE"
      state = "NONE"
      country = "NONE"
    end

    puts "Line1: #{line1}"
    puts "City: #{city}"
    puts "Zip: #{zip}"
    puts "State: #{state}"
    puts "Country: #{country}"
    @org_info['address1'] = line1
    @org_info['city'] = city
    @org_info['state'] = state
    @org_info['zipcode'] = zip
    @org_info['country'] = country
  end

  def get_keywords(data)

    ## TRACK METHODS ##
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS
    if data.has_key? "keywords" then
      keyInfo = data.fetch("keywords")
    elsif
      keyInfo == "NONE"
    end
    puts "KEYWORDS: #{keyInfo}"
    @org_info['keywds'] = keyInfo
  end

  def get_socialInfo(data)
    socialInfo = data.fetch("socialProfiles")
    puts "*****"
    puts "SOCIAL #{socialInfo}"
    puts "*****"
  end

  def get_orgInfo(data)

    ## TRACK METHODS ##
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS

    puts data.keys
    puts data.keys[7]
    if data.has_key? "socialProfiles" then
      fullsocialInfo = data.fetch("socialProfiles") if data.has_key? "socialProfiles"
      puts "****"
      puts "SOCIAL #{fullsocialInfo}"
      puts "****"
      if fullsocialInfo.is_a?(Array) then
        fullsocialInfo.each_with_index do |social, index|
          puts "SOCIAL_link#{index}: #{social}"
          puts social.class
          puts
        end
        puts "All social links listed"
      end
    puts fullsocialInfo.keys if fullsocialInfo.is_a?(Hash)
    end
    fullorgInfo = data.fetch("organization")
    puts "ORG INFO"
    puts fullorgInfo.keys
    fullorgInfo.each do |key, val|
      puts "#{key} = #{val}"
      puts
    end

    nameInfo = self.get_nameInfo(fullorgInfo)
    descInfo = self.get_descInfo(fullorgInfo)
    keyInfo = self.get_keywords(fullorgInfo)
    puts "NAME: #{nameInfo}"
    puts fullorgInfo.keys
    puts "there is a key for Contact" if fullorgInfo.has_key? "contactInfo"
    if fullorgInfo.has_key? "contactInfo" then
      orgInfo = fullorgInfo.fetch("contactInfo")
      contactInfo = orgInfo
      puts "A: #{fullorgInfo}"
      puts "#"
      puts " ORG: #{orgInfo}"
      puts contactInfo.class
    else
      contactInfo = "NONE"
      orgInfo = {}
    end

    puts orgInfo.class
    puts
    puts orgInfo.keys
    orgInfo.each do |key, val|
      puts "#{key} => #{val}"
      puts
      puts
    end
    puts "CONTACT HERE: #{contactInfo}"
    puts orgInfo
    #if contactInfo = "NONE" then
    #  puts "NO CONTACT INFO"
    #else
    phoneInfo = self.get_phoneInfo(orgInfo)
    addressInfo = self.get_addressInfo(orgInfo)
    #end
    return orgInfo
  end

  def run(filename, data)
    #label = self.init_lize(filename)
    #data = self.read_JSON_file(filename)

    ## TRACK METHODS ##
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS

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

  def cycle_through(listings, filename)

    ## TRACK METHODS ##
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS
    puts "THE FILE IS : #{filename}"
    filename = "./read/#{filename}_#{Date.today.to_s}"
    self.init_lize(filename)
    #@listings << "test1"
    #@listings << "test2"
    #@listings << "test3"
    @listings = listings
    puts "THIS IS THE NEXT TEST ITEM"
    puts "BEAR #{listings.count}"
    puts "COUNT: #{@listings.count}"
    puts "DID NOT BREAK"
    listings.each_with_index do |company, index|
      puts "#{index} : #{company}"
      data = self.read_JSON_info(company)
      self.run(filename, data)
    end

  end

  def instance_test

    ## TRACK METHODS ##
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS

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

#x = ContactINFO.new

