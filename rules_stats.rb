# ----------------------------------------
# GET a set of rules and generate stats
# ----------------------------------------

require 'json'
require 'faraday'
require 'yaml'

# Path to yaml file with credentials - alternatively, specify the file path as the first command line argument (ARGV[0])
if ARGV[0].empty?
	config = YAML.load_file('./config/account.yml')
else
	config = YAML.load_file(ARGV[0])
end

username = config['username']
password = config['password']
account_name = config['target_account_name']
stream_label = config['target_stream_label']
format = "----------------------------------------------"

# Make the request
conn = Faraday.new(url: "https://gnip-api.twitter.com")
conn.basic_auth(username, password)
response = conn.get "/rules/powertrack/accounts/#{account_name}/publishers/twitter/#{stream_label}.json" do |req|
  req.headers['X-On-Behalf-Of'] = "#{account_name}"
end

# # Print the response - useful when debugging
# puts response.body

jresp = JSON.parse(response.body)

sent = jresp['sent'].gsub(/\W+/, '')
datestamp = sent[0..-7]

file_name = "#{account_name}_#{stream_label}_#{datestamp}.json"

# Create 'outbox' dir if it doesn't exist
directory_name = "outbox"
Dir.mkdir(directory_name) unless File.exists?(directory_name)

rules_file = File.open("./outbox/#{file_name}", "w+")
rules_file.puts response.body
rules_file.close

# Read file, parse, extract and store rules in 'rules' array
file = File.read("./outbox/#{file_name}")
json = JSON.parse(file)

rules = json["rules"]

# Initialize counter and sum variables
counter = 0
sum = 0
limit = rules.length
rule_length = []

while counter < limit
	# Verbose: puts " #{counter}" + ", " + "#{rules[counter]["value"].length}"
	rule_length.push(rules[counter]["value"].length)
	sum += rules[counter]["value"].length
	counter += 1
end

average = sum / limit
puts "#{format}", "Account name: #{account_name} | Stream: '#{stream_label}'", "#{format}", "Number of rules: #{limit}", "Avg rule length: #{average}", "Min rule lenght: #{rule_length.min}", "Max rule length: #{rule_length.max}"
