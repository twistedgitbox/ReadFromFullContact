#! /usr/bin/env ruby

class API_checking

  def check_for_API_key
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
    return testme
  end

end
