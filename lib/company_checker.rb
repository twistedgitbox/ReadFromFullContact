#! /usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require_relative 'api_check'
require_relative 'label_reader'
require_relative 'FC_json_reader'
require_relative 'CB_json_reader'

files = File.join(File.dirname(__FILE__),'..','lib','**','*.rb')
Dir.glob(files).each do |file|
  require file
end

class CompanyData

  def initialize
    @key_made = {}
    @key_made = self.get_API_key
    puts "KEYME #{@key_made}"
    @arraylist = Make_List.new
    @CB_arraylist =
    @runlist = []
    @jsonarr = []
    @jsonreader = FC_ContactINFO.new
    @CB_jsonreader = CB_ContactINFO.new
    @errorlist = []
  end

  def get_company_FCinfo(filename, key_made)
    companylist_path = "./read/FC/companylist_#{filename}"
    list = @arraylist.get_companies_from_file(companylist_path)
    @runlist = list
    puts @runlist
    @runlist.each_with_index do |company, index|
      filepath = "./export/FC/json/#{company}_FC.json"
      puts "COMPANY TO GET #{company}"
      if company.nil? || company == "" then
        puts "COMPANY IS NADA"
      else
        puts "FILE LOCATION #{filepath}"
        if File.exist?(filepath) then
          puts "FILE EXISTS IN DIRECTORY"
          obj = @jsonreader.read_JSON_file(company, filepath)
        elsif
          obj = self.get_FCcompanyinfo_from_domain(filename, key_made, company)
          puts
          puts
        end
        json_info = obj.to_json
        puts json_info
        puts "HERE IS THE JSON INFO"
        @jsonarr << json_info
        puts @jsonarr
        puts "MATH"
        #testone = @jsonreader.cycle_through(bear)
        puts "TEST 2:#{@jsonarr}"
        puts "DONE #{company} for #{index}"
      end
    end
    puts "ALL ABOARD"
    puts @jsonarr
    @jsonarr.each_with_index do |company, index|
      puts "***"
      puts "DATA : #{company} & #{index}"
      puts "***"
    end
    listings = @jsonarr
    testone = @jsonreader.cycle_through(listings, filename)
    puts testone
    puts
    puts
    puts "COMPLETE saved in #{filename}"
    puts key_made
  end

  def get_company_CBinfo(filename, key_made)
    companylist_path = "./read/CB/companylist_#{filename}"
    list = @arraylist.get_companies_from_file(companylist_path)
    @runlist = list
    puts @runlist
    @runlist.each_with_index do |company, index|
      filepath = "./export/CB/json/#{company}_CB.json"
      puts "FILE LOCATION #{filepath}"
      if File.exist?(filepath) then
        puts "FILE EXISTS IN DIRECTORY"
        obj = @CB_jsonreader.read_JSON_file(company, filepath)
      elsif
        obj = self.get_CBcompanyinfo_from_domain(filename, key_made, company)
        puts
        puts
      end
      json_info = obj.to_json
      puts json_info
      puts "HERE IS THE JSON INFO"
      @jsonarr << json_info
      puts @jsonarr
      puts "MATH"
      #testone = @jsonreader.cycle_through(bear)
      puts "TEST 2:#{@jsonarr}"
      puts "DONE #{company} for #{index}"
    end
    puts "ALL ABOARD"
    puts @jsonarr
    @jsonarr.each_with_index do |company, index|
      puts "***"
      puts "DATA : #{company} & #{index}"
      puts "***"
    end
    listings = @jsonarr
    testone = @CB_jsonreader.cycle_through(listings, filename)
    puts testone
    puts
    puts
    puts "COMPLETE saved in #{filename}"
    puts key_made
  end

  def get_FCcompanyinfo_from_domain(filename, key_made, company)
    url = "https://api.fullcontact.com/v2/company/lookup.json?domain=#{company}&apiKey=#{key_made[:keyFC]}"
    response = RestClient.get(url)
    obj = JSON.parse(response.body)
    puts obj
    json_info = obj.to_json
    puts json_info.class
    puts json_info
    self.write_FCtest_toJSON(company, obj)
    return obj
  end

  def write_FCtest_toJSON(company, obj)
    filepath = "./export/FC/json/#{company}_FC"
    puts "FILE LOCATION #{filepath}"
    if File.exist?(filepath) then
      puts "FILE EXISTS IN DIRECTORY"
    else
      File.open("#{filepath}.json","w") do |f|
        f.write(obj.to_json)
      end
    # AFTER SAVING FILE LOG RESULT
      msgtest = obj
      msg = "#{Date.today.to_s}_SAVED in #{filepath} for #{company} RESULT: #{msgtest[0...20]}"
      if msgtest.is_a?(Hash) then
        msg = "ERROR #{Date.today.to_s} in #{filepath} for #{company} RESULT: #{obj.to_json}" if msgtest.has_key? "error"
        if msgtest.has_key? "status" then
          statusvalue = msgtest["status"]
          puts "#{statusvalue} STATUS"
        end
        msg = "ERROR #{Date.today.to_s} in #{filepath} for #{company} RESULT: #{obj.to_json}" if msgtest.has_key? "queued"

      end
      filepath = "./export/FC/FC_#{Date.today.to_s}"
      msg = "#{msg}\n"
      File.open("#{filepath}.log","a") do |f|
        puts msg
        f.write(msg)
      end
    end

  end

  def get_CBcompanyinfo_from_domain(filename, key_made, company)
    #iurl = "https://company.clearbit.com/v2/companies/find?domain=#{company}&apiKey=#{key_made[:keyCB]}"
    #response = RestClient.get(url)
    uri = URI.parse("https://company.clearbit.com/v2/companies/find?domain=#{company}")
    puts uri
    request = Net::HTTP::Get.new(uri)
    request.basic_auth(key_made[:keyCB], "")
    puts key_made[:keyCB]

    req_options = {
      use_ssl: uri.scheme == "https",
    }

    response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(request)
    end

    obj = JSON.parse(response.body)
    puts obj
    json_info = obj.to_json
    puts json_info.class
    puts json_info
    self.write_CBtest_toJSON(company, obj)
    return obj
  end

  def write_CBtest_toJSON(company, obj)
    filepath = "./export/CB/json/#{company}_CB"
    puts "FILE LOCATION #{filepath}"
    if File.exist?(filepath) then
      puts "FILE EXISTS IN DIRECTORY"
    else
      File.open("#{filepath}.json","w") do |f|
        puts "#{filepath}"
        f.write(obj.to_json)
      end
      #
      # AFTER SAVING FILE LOG RESULT
      #
      msgtest = obj
      msg = "#{Date.today.to_s}_SAVED in #{filepath} for #{company} RESULT: #{msgtest[0...20]}"
      if msgtest.is_a?(Hash) then
        msg = "ERROR #{Date.today.to_s} in #{filepath} for #{company} RESULT: #{obj.to_json}" if msgtest.has_key? "error"
        msg = "#{msg}\n"
        @errorlist << msg
      end
      filepath = "./export/CB/CB_#{Date.today.to_s}"
      msg = "#{msg}\n"
      File.open("#{filepath}.log","a") do |f|
        puts msg
        f.write(msg)
      end
    end
  end

  def key_set
    key_made = self.get_API_key
    puts "The Key is #{key_made}"
    @key_made = key_made
  end

  def get_API_key
    @api_key = API_checking.new
    key_made = @api_key.check_for_API_key
    return key_made
  end

  def FC_run(filename)
    puts "File Being Run: => #{filename}"
    puts @key_made
    key_made = @key_made
    self.get_company_FCinfo(filename, key_made)
    #self.write_FCtest_toJSON(filename, key_made)
  end

  def CB_run(filename)
    puts "File Being Run: => #{filename}"
    puts @key_made
    key_made = @key_made
    self.get_company_CBinfo(filename, key_made)
    #self.write_FCtest_toJSON(filename, key_made)
    puts @errorlist
  end

end


