require 'open-uri'
require 'nokogiri'

Url = 'http://be-side.jp/podcast'

File_url_prefix = 'http://project-phi.ddo.jp/ishikawa/ishikawa'
File_url_suffix = '.mp3'

def parse(url)
  begin
    doc = Nokogiri::HTML.parse(open(url))
  rescue OpenURI::HTTPError
    return
  end

  current_vol = 0

  doc.xpath('//div[@class="text"]').each do |node|
    link = node.at("a").attribute("href").value
    back_number = link.clone
    back_number.slice!(File_url_prefix)
    back_number.slice!(File_url_suffix)

    vol = back_number.split("_")[0]

    description = node.content.strip!.split("\n")

    unless current_vol == vol
      puts '第' + vol + '回'
      puts '========'
      puts ''
      current_vol = vol
    end

    puts 'vol.' + back_number + ' ' + description[0][0..30] + '...'
    puts '----------' + ('--' * description[0][0..30].length) + '---'
    puts ''
    puts "#{link}::"
    puts ''
    description.each do |d|
       puts '   ' + d
    end
    puts ''

    #dropboxupload = "~/github/Dropbox-Uploader/dropbox_uploader.sh upload"
    #upload_path = "radio/"
    #file = "ishikawa#{back_number}#{File_url_suffix}"
    #`wget -q #{link}`
    #`#{dropboxupload} #{file} #{upload_path}/#{file}`
    #`rm *mp3*`
  end
end

y = ARGV[0].to_i

y.downto(y) do |year|
  puts '======'
  puts year.to_s + '年'
  puts '======'
  puts ''
  12.downto(1) do |month|
    parse(Url + "/" + year.to_s + "/" + ("%02d" % month).to_s + "/")
  end
end


