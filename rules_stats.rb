# ----------------------------------------
# GET a set of rules and generate stats
# ----------------------------------------

require 'json'
require 'faraday'
require 'optparse'
require 'yaml'

# Path to yaml file with credentials
config = YAML.load_file('./config/p/private.yml')

username = config['username']
password = config['password']
account_name = config['account_name']
stream_label = config['stream_label']

# # Option Parser code
# options = {}

# parser = OptionParser.new do |opts|
# 	opts.on('-t', '--tweet tweet') do |tweet|
# 		options[:tweet] = tweet;
# 	end
# end

# parser.parse!

# Make the request
conn = Faraday.new(url: "https://gnip-api.twitter.com")
conn.basic_auth(username, password)
response = conn.get("/rules/powertrack/accounts/#{account_name}/publishers/twitter/#{stream_label}.json")

jresp = JSON.parse(response.body)

sent = jresp['sent'].gsub(/\W+/, '')
datestamp = sent[0..-7]

fname = "#{stream_label}_rules_#{datestamp}.json"

rules_file = File.open("./files/#{fname}", "w+")
rules_file.puts response.body
rules_file.close

# Read file, parse, extract and store rules in 'rules' array
file = File.read("./files/#{fname}")
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
puts "Avg rule length: #{average}", "Min rule lenght: #{rule_length.min}", "Max rule length: #{rule_length.max}"

