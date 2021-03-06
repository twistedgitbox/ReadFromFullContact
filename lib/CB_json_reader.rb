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
    #CSV.open(datafile, 'wb') do |csv|
    #  csv << info_hash.keys
    #  puts info_hash.keys
    #  puts info_hash.values
    #  max_len = info_hash.values.map(&:length).max
    #  (0...max_len).zip(*info_hash.values).each do |_, *row|
    #    csv << row
    #  end
    #end
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

    if data.has_key? "domain" then
      webInfo = data.fetch("domain")
      webInfo = "https://www.#{webInfo}"
    else
      webInfo == "NONE"
    end

    puts "URL: #{webInfo}"
    puts webInfo.class
    @org_info['url'] = webInfo
    return webInfo
  end

  def get_siteInfo(data)
    ## TRACK METHODS ##
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS

    if data.has_key? "site" then
      siteInfo = data.fetch("site")
      self.get_phoneInfo(siteInfo) if siteInfo.is_a?(Hash)
    else
      siteInfo = "NONE"
    end

    mainphoneInfo = self.get_mainphone_info(data)

    puts "site: #{siteInfo}"
    return siteInfo

  end

  def get_nameInfo(data, company)

    ## TRACK METHODS ##
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS

    if data.has_key? "name" then
      nameInfo = data.fetch("name")
    else
      nameInfo = "NONE FOUND FOR #{company}"
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

    if data.has_key? "description" then
      descInfo = data.fetch("description")
    else
      descInfo = "NONE"
    end

    #descInfo = data.fetch("overview")
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
    puts phone1.class


    if phone1.is_a?(Hash) then
      phone = phone1.fetch("number") if  phone1.has_key? "number"
      phone = phone1.fetch("Number") if phone1.has_key? "Number"
    elsif phone1.is_a?(Array) then
      phone = phone1[0]
    else
      phone = phone1
    end

    phone = phone.to_s

    puts "PHONE #{phone}"
    @org_info['hq_phone'] = phone
    return phone
  end

  def get_addressInfo(data)

    ## TRACK METHODS ##
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS

    if data.has_key? "location" then
      addressInfo = data.fetch("location")
    else
      line1 = "NONE"
    end

    if data.has_key? "geo" then
      addressInfo = data.fetch("geo")
    else
      addressInfo = "NONE"
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
      city = address1.fetch("city") if address1.has_key? "city"
      zip = address1.fetch("postalCode") if address1.has_key? "postalCode"
      stateInfo = address1.fetch("region") if address1.has_key? "region"
      countryInfo = address1.fetch("countryCode") if address1.has_key? "countryCode"
      stateInfo = address1.fetch("stateCode") if address1.key?("stateCode")
      latInfo = address1.fetch("lat") if address1.has_key? "lat"
      lngInfo = address1.fetch("lng") if address1.has_key? "lng"
      if stateInfo.kind_of?(Hash) then
        state = stateInfo.fetch("state") if stateInfo.has_key? "state"
        puts "StateInfo #{stateInfo}"
      else
        state = stateInfo
      end

      if countryInfo.kind_of?(Hash) then
        country = countryInfo.fetch("country") if countryInfo.has_key? "country"
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
    puts "Latitude: #{latInfo}"
    puts "Longitude: #{lngInfo}"
    @org_info['address1'] = line1
    @org_info['city'] = city
    @org_info['state'] = stateInfo
    @org_info['zipcode'] = zip
    @org_info['country'] = countryInfo
    @org_info['lat'] = latInfo
    @org_info['lng'] = lngInfo
    return address1
  end

  def get_keywords(data)

    ## TRACK METHODS ##
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS
    if data.has_key? "tags" then
      keyInfo = data.fetch("tags")
    elsif
      keyInfo == "NONE"
    end
    puts "KEYWORDS: #{keyInfo}"
    @org_info['keywds'] = keyInfo
    return keyInfo
  end

  def get_categoryInfo(data)
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS
    if data.has_key? "category" then
      catInfo = data.fetch("category")
    else
      catInfo = "NONE"
    end
    puts "CATEGORY_INFO: #{catInfo}"
    @org_info['category_info'] = catInfo
    return catInfo
  end

  def get_socialInfo(data)
    puts "*****"
    puts "SOCIAL "
    puts "*****"
    linkedInfo = self.get_linkedin_info(data)
    facebookInfo = self.get_facebook_info(data)
    twitterInfo = self.get_twitter_info(data)
    crunchbaseInfo = self.get_crunchbase_info(data)
    puts linkedInfo
    puts facebookInfo
    puts twitterInfo
    puts crunchbaseInfo
    socialInfo = [linkedInfo, facebookInfo, twitterInfo, crunchbaseInfo]
    return socialInfo
  end


  def get_linkedin_info(data)
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS
    if data.has_key? "linkedin" then
      linkedinInfo = data.fetch("linkedin")
    else
      linkedinInfo = "NONE"
    end
    puts "linkedin_INFO: #{linkedinInfo}"
    @org_info['linkedin_info'] = linkedinInfo
    return linkedinInfo
  end

  def get_facebook_info(data)
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS
    if data.has_key? "facebook" then
      facebookInfo = data.fetch("facebook")
    else
      facebookInfo = "NONE"
    end
    puts "Facebook_INFO: #{facebookInfo}"
    @org_info['facebook_info'] = facebookInfo
    return facebookInfo
  end

  def get_twitter_info(data)
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS
    if data.has_key? "twitter" then
      twitterInfo = data.fetch("twitter")
    else
      twitterInfo = "NONE"
    end
    puts "Twitter_INFO: #{twitterInfo}"
    @org_info['twitterInfo'] = twitterInfo
    return twitterInfo
  end

  def get_crunchbase_info(data)
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS
    if data.has_key? "crunchbase" then
      crunchbaseInfo = data.fetch("crunchbase")
    else
      crunchbaseInfo = "NONE"
    end
    puts "crunchbase_INFO: #{crunchbaseInfo}"
    @org_info['crunchbase_info'] = crunchbaseInfo
    return crunchbaseInfo
  end

  def get_mainphone_info(data)
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS
    if data.has_key? "phone" then
      phoneInfo = data.fetch("phone")
      phoneInfo = data.fetch("phoneNumbers") if data.has_key? "phoneNumbers"
      puts "mainphone_key #{phoneInfo}"

      if phoneInfo.is_a?(Hash)
        puts "HASH"
        phone1 = phoneInfo
      elsif phoneInfo.is_a?(Array)
        puts "ARRAY"
        phone1 = phoneInfo[0]
      else
        phone1 = phoneInfo
      end

      puts "MAINPHONESET: #{phone1}"
      puts phone1.class

      if phone1.is_a?(Hash) then
        phone = phone1.fetch("number") if  phone1.has_key? "number"
        phone = phone1.fetch("Number") if phone1.has_key? "Number"
      elsif phone1.is_a?(Array) then
        phone = phone1[0]
      else
        phone = phone1
      end

    else
      phone = "NONE"
    end

    phone = phone.to_s

    puts "Main Phone: #{phone}"
    @org_info['main_phone'] = phone
    return phone
  end

  def get_orgInfo(data, company)

    ## TRACK METHODS ##
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS

    puts data.keys
    puts data.keys[7]

    nameInfo = self.get_nameInfo(data, company)
    webInfo = self.get_webInfo(data)
    siteInfo = self.get_siteInfo(data)
    descInfo = self.get_descInfo(data)
    addressInfo = self.get_addressInfo(data)
    keyInfo = self.get_keywords(data)
    catInfo = self.get_categoryInfo(data)
    socialInfo = self.get_socialInfo(data)
    puts "###OUTPUT####"
    puts nameInfo
    puts siteInfo
    puts descInfo
    puts addressInfo
    puts keyInfo
    puts catInfo
    puts socialInfo
  end

  def run(filename, data, company)
    #label = self.init_lize(filename)
    #data = self.read_JSON_file(filename)

    ## TRACK METHODS ##
    puts "CALLING METHOD: #{caller[0] =~ /`([^']*)'/ and $1}"
    puts "CURRENT METHOD: #{__method__.to_s}"
    ## PUT IN CODE TO TRACK METHOD CALLS

    self.reset_variables(filename)
    puts "FILE: #{filename}"
    puts
    puts
    orgInfo = self.get_orgInfo(data, company)
    puts @org_info
    self.convert_DATA_to_CSV(@org_info)
    self.write_csv(@org_info)
    my_hash = @org_info.inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
    puts my_hash
    my_hash = @org_info

    @org_info.each do |key, value|
      puts  "#{key} #{value}"
      puts
    end

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
      self.run(filename, data, company)
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

