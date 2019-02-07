namespace :fed_scope_download do
  desc "TODO"
  task download_fed_zip: :environment do
	  puts "Pulling new requests..."
	  require 'open-uri'
    require 'nokogiri'
    require 'rubygems'
    require 'zip/zip'
    FileUtils.rm_rf(Dir[Rails.root.join("remote_files/*")])
    doc = Nokogiri::HTML(open("https://www.opm.gov/data/index.aspx"))
    table = doc.css('table.DataTable').first
    # url_download = table.css('tr > td[3]> span> a')[0].attributes["href"].value
    table.css('tr > td[1]').children.each_with_index do |cube,index|
      if cube.text.include? "FedScope Employment Cube"
        # cube.text.include? "FedScope Employment Cube"
        if 1.year.ago.strftime("%Y") <= Date.today.strftime("%Y")
          if cube.text.include? Date.today.strftime("%Y")
            @url_download = table.css('tr > td[3]> span> a')[index].attributes["href"].value
            break
          elsif cube.text.include?  1.year.ago.strftime("%Y")
            @url_download = table.css('tr > td[3]> span> a')[index].attributes["href"].value
            break
          end
        end
      end
    end
    @url_download = "https://www.opm.gov"+@url_download

    open(@url_download) do |remote_file|
      unless File.exists?(Rails.root.join('remote_files', "fedscope"))
        File.open("remote_files/" + "fedscope.zip", "wb") do |local_file|
          local_file.write(remote_file.read)
          unzip_file("remote_files/fedscope.zip", "remote_files/")
        end
      end
    end
	  puts "done."
  end

  def unzip_file (file, destination)
    Zip::ZipFile.open(file) { |zip_file|
      zip_file.each { |f|
         f_path=File.join(destination, f.name)
         FileUtils.mkdir_p(File.dirname(f_path))
         zip_file.extract(f, f_path) unless File.exist?(f_path)
      }
    }
  end
end