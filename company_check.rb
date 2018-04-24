#! /usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require_relative 'lib/api_check'

files = File.join(File.dirname(__FILE__),'..','lib','**','*.rb')
Dir.glob(files).each do |file|
  require file
end

class CompanyData

  def initialize
    @key_made = ""
    key_made = "NONE"
    @key_made = self.get_API_key
    puts "KEYME #{@key_made}"
  end

  def write_FCtest_toJSON(filename, key_made)
    filepath = "./#{filename}"
    company_collect = "fullcontact.com"
    url = "https://api.fullcontact.com/v2/company/lookup.json?domain=#{company_collect}&apiKey=#{key_made}"
    response = RestClient.get(url)
    obj = JSON.parse(response.body)
    puts obj
    json_screen = obj.to_json
    File.open("#{filepath}.json","w") do |f|
      f.write(obj.to_json)
    end
    puts json_screen.class
    puts json_screen

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

  def run(filename)
    puts "DOGFOOD"
    puts @key_made
    key_made = @key_made
    self.write_FCtest_toJSON(filename, key_made)
  end

end

companycheck = CompanyData.new

companycheck.run("FullMe")
