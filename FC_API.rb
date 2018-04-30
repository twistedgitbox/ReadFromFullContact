#! /usr/bin/env ruby
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)

require_relative './lib/company_checker'

files = File.join(File.dirname(__FILE__),'..','lib','**','*.rb')
Dir.glob(files).each do |file|
  require file
end

class FC_Run

  def init_lize(filename)
    @companycheck = CompanyData.new
    @companycheck.FC_run(filename)
    return filename
  end

end

companycheck = FC_Run.new
companyapi = companycheck.init_lize("FC")
puts companyapi
puts "COMPLETED GETTING DATA FROM FC API"



