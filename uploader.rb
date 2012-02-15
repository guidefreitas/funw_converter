require 'rubygems'
require 'optparse'
require 'fileutils'

ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)
require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

require 'RMagick'

def help
  puts "Help"
  puts "Usage: ruby uploader.rb <image_path>"
  puts "       ruby uploader.rb -D <directory_path>"
  puts "Arguments:"
  puts "       -a : Convert to all formats"
  puts "       -ipad : Convert to ipad"
  puts "       -iphone : Converto to iphone"
  puts "       -ipad_retina : Convert to ipad retina display"
  puts "       -iphone_retina : Converto to iphone retina display"
  puts "       -1920x1080 : Convert to 1920x1080"
  puts "       -1024x768 : Convert to 1024x768"
  puts "       -1280x800 : Convert to 1280x800"
  puts "       -1280x900 : Convert to 1280x900"
  puts "       -800x600 : Convert to 800x600"
  
end

def create_dir(filepath)  
  if File.exists?(filepath)  
    if File.directory?(filepath)
      FileUtils.remove_dir(filepath, true)
    else
      File.delete(filepath)  
    end
  end  
  
  FileUtils.mkdir_p(filepath)
end

def convert(filepath, size)
  GC.start
  puts "Converting image #{filepath} to #{size} \n"
  tmp_dir = "tmp/#{File.basename(filepath, File.extname(filepath))}/#{size}"
  create_dir(tmp_dir)
  tmp_dir = "#{tmp_dir}/#{File.basename(filepath)}"
  
  begin
    image = Magick::Image.read(filepath).first
    image.change_geometry!(size){ |cols, rows, img|    
      newimg = img.resize(cols, rows)    
      
      newimg.write(tmp_dir)
      newimg = nil
    }
    
    image.destroy!
  rescue
  end
end

def convert_to_formats(filepath)
  sizes = ["800x600", "1024x768", "1280x800"]
  sizes.each do |size|
    convert(filepath, size)
  end
  
end

puts "Starting Funw Uploader"
puts "Creating tmp dir"
tmp_dir_base = "tmp"
create_dir(tmp_dir_base)

puts "Converting image"

if ARGV[0] == "-D"
  dirname = ARGV[1]
  Dir.foreach(dirname) do |file|
    filepath = "#{dirname}/#{file}"
    if !File.directory?(filepath)
      convert_to_formats(filepath)
    end
    
  end
else
  filename = ARGV[0]
  convert_to_formats(filepath)
end

puts "Finished"



