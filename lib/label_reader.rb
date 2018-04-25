#! /usr/bin/env ruby

class Make_List

  def init_lize(filename)
    filepath = "../export/#{filename}.csv"
    if File.exist?(filepath) then
      File.truncate(filepath, 0)
    end
    @list = ""
  end

  def list_from_file(filename)
    list = File.readlines(filename)
    return list
  end

  def get_companies_from_file(filename)
    list = self.list_from_file(filename)
    list = self.clean_list(list)
    checkarrx = list
    puts filename
    self.save_created_list(checkarrx, filename)


  end

  def clean_list(list)
    list.map! {|x| x.chomp }
    list.reject! { |e| e.to_s.empty? }
    list.uniq!
    puts list
    puts "NEXT"
    puts list.class
    list  = self.remove_url(list)
    list.uniq!
    puts "CLEAN#{list}"
    return list
  end

  def remove_url(list)
    puts "Another #{list}"
    testarr = list
    testarr.each_with_index do |company, index|
      company.sub!(/^https?\:\/\/(www.)?/,'')
      company.sub!(/^www./,'')
      company.chomp!("/")
      puts index, company
    end
    return list
  end

  def read_labels(filename, label)
    self.init_lize(filename)
    list = self.list_from_file(filename)
    list.reject! { |e| e.to_s.empty? }
    list.uniq!
    #puts list
    self.read_in_labels(filename, label, list)
    list = @list
    return list
  end

  def clean(input)
    input.gsub(/^[\s]*$\n/, "").strip
  end

  def read_in_labels(filename, label, list)
    checkarrx = []
    labelsize = (label.length+1)
    puts "LENGTH #{labelsize} FOR #{label}"
    list.reject! { |item| item.nil? || item == '' }
    list.each do |line|
      if line.start_with?("#{label}:")
        puts "MATCH #{line}"
        line2 = line[labelsize..-1]
        line2 = line2.strip
        checkarrx << line2
      end
    end

    checkarrx.reject! { |item| item.nil? || item == '' }
    puts checkarrx
    self.save_created_list(checkarrx)
    return checkarrx
  end

  def save_created_list(checkarrx, filename)
    fixedfile = filename.sub(/^.\//,'')
    newfile = "./export/#{fixedfile}.new"
    puts newfile
    File.open(newfile, "w+") do |f|
      f.puts(checkarrx)
    end
    @createdlist = checkarrx
    puts "NOW #{checkarrx}"
    puts "THEN"
    return checkarrx
  end

  def list_run(filename, label)
    list = self.list_test(filename, label)
    puts list
    return list
  end

  def list_test(filename, label)
    list = self.read_labels(filename, label)
    return list
  end

end

#x = LabeltoCleanList.new

#x.list_run("StartList", "COMPANY")
#("StartList", "COMPANY")
#x.test_bad_companies