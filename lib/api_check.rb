#! /usr/bin/env ruby

class API_checking

  def check_for_API_key
    api_key_path = "./.api_key_test"
    keyhash = {}
    f = File.open(api_key_path, 'r')
    if !f.nil? && File.exist?(f)
      f.close unless f.closed?
      lines = IO.readlines(api_key_path)
      puts lines.length
      key_FC = lines[1]
      key_CB = lines[3]
      key_FC.chomp!
      key_CB.chomp!
    elsif
      puts "NO API KEY FILE"
      key_FC = "NOKEY FOR FC"
      key_CB = "NOKEY FOR CB"
    end
    keyhash[:keyFC] = key_FC
    keyhash[:keyCB] = key_CB
    return keyhash
  end

end
