#! /usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require_relative './lib/company_checker'

files = File.join(File.dirname(__FILE__),'..','lib','**','*.rb')
Dir.glob(files).each do |file|
  require file
end

class CB_Run

  def init_lize(filename)
    @companycheck = CompanyData.new
    @companycheck.CB_run(filename)
    return filename
  end

end

companycheck = CB_Run.new
companyapi = companycheck.init_lize("CB")
puts companyapi
puts "Completed getting data from ClearBit API. Check Read folder to change company domains list to read from. Check Export folder for CSVs."


