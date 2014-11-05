require 'csv'
require 'pp'
require 'fileutils'
# require 'strftime'
require 'rbconfig'
THIS_FILE = File.expand_path(__FILE__)

RUBY = File.join(RbConfig::CONFIG['bindir'], RbConfig::CONFIG['ruby_install_name'])

dir_string = "F:/TEMP_D/"

def upload(item)
	path = "F:/"
	
	d = DateTime.now
	folderName = d.strftime("%Y%m%d%H%M%S")
	asperaFolder = ("ACCDN" + "#{folderName}")
	FileUtils::mkdir_p("F:/STAGING/YT/#{asperaFolder}")
	temp_dir = "F:/STAGING/YT/#{asperaFolder}/"
	puts "[child] #{temp_dir}"
	FileUtils.mv("F:/TEMP_D/#{item}", "F:/STAGING/YT/#{asperaFolder}/#{item}", :force => true)
	puts "[child] #{item}"
	new_assets_csv  = [] # We create an array to gold the new CSV data
	old_assets_csv = CSV.read('C:/ruby_scripts/ACCDIGITAL_YT_MASTER.csv', headers:true) # Reads the entire content of the CSV into the variable
	old_assets_csv.each do |asset| # old_guests_csv is CSV::Table object which has #each method to iterate over its rows
		asset['filename'] = "#{item}" # Same thing as with our previous code
		asset['title'] = "#{item}"
		new_assets_csv << asset # Add the new row into new_guests_csv
	end
	puts "[child] creating CSV"
	CSV.open("#{temp_dir}"'current_metadata.csv', 'wb') do |csv|
		csv << ['filename', 'title', 'description', 'keywords', 'category', 'privacy']
		new_assets_csv.each do |row|
	
			csv.puts row
		end
	end
	puts "[child] placing in HOT FOLDER"
	FileUtils.mv "F:/STAGING/YT/#{asperaFolder}", "F:/STAGING/ASPERA_YT_HOT", :force => true
	puts "[child] uploading file"
	sleep(30)
	FileUtils.cp_r "F:/STAGING/DC/delivery.complete", "F:/STAGING/ASPERA_YT_HOT/#{asperaFolder}/"
	puts "[child] Complete"
	
	#$stderr.puts "[child] Standard Error!"
	
end

if $PROGRAM_NAME ==__FILE__
	a = 0
	while a == 0
		Dir.foreach(dir_string) do |item|
			next if item == '.' or item == '..'
			output = `#{RUBY} -r#{THIS_FILE} -e 'upload("#{item}")'`
			output.split("/n").each do |line|
			puts "[parent] output: #{line}"
			end
		end
	end

$stdout.sync = true	
sleep(30)
end