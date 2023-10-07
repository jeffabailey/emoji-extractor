# encoding: US-ASCII
# stolen largely from http://www.ruby-forum.com/topic/140784

require 'stringio'
require 'fileutils'
require 'chunky_png'

def extract_png(input)
  chunk_data = ChunkyPNG::Image.from_io(input)
  height, width = chunk_data.height, chunk_data.width

  FileUtils.mkdir_p(dir = "images")

  chunk_data.save("#{dir}/#{Time.now.to_i}.png", :fast_rgba)

end

begin
  @ttf = File.new("/System/Library/Fonts/Apple Color Emoji.ttf","rb")
rescue
  @ttf = File.new("/System/Library/Fonts/Apple Color Emoji.ttc","rb")
else
  puts "Could not find the Apple Color Emoji font file. Exiting."
end

ttf_data = @ttf.read

pos = 0
while m = /\211PNG/.match(ttf_data[pos..-1])

  raise "no PNG found" if !m
  pos += m.begin(0) + 1
  @ttf.seek(pos-1)

  extract_png(@ttf)
end
