source 'https://supermarket.chef.io'

metadata

Dir.glob("#{__dir__}/test/support/cookbooks/*/metadata.rb").each do |metadata_file|
  cookbook_path = File.dirname(metadata_file)
  cookbook_name = File.basename(cookbook_path)
  cookbook cookbook_name, path: cookbook_path
end
