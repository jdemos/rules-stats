# # ----------------------------------------
# # Read rules file and produce stats on it
# # ----------------------------------------

require 'json'
# require 'faraday'
# require 'optparse'
# require 'yaml'

# # # # Add in ability to make GET request to pull rules

# # # config = YAML.load_file('credentials.yml')

# # # username = config['username']
# # # password = config['password']

# # # # Option Parser code
# # # options = {}

# # # parser = OptionParser.new do |opts|
# # # 	opts.on('-t', '--tweet tweet') do |tweet|
# # # 		options[:tweet] = tweet;
# # # 	end
# # # end

# # parser.parse!

# account_name = "INSERT"
# stream_label = "INSERT"

# # Make the request
# conn = Faraday.new(url: "https://gnip-api.twitter.com/rules/powertrack/accounts/#{account_name}/publishers/twitter/")
# conn.basic_auth(username, password)
# response = conn.get("#{stream_label}.json")

# Read file, parse, extract and store rules in 'rules' array
file = File.read("./files/falcon_social_rules.json")
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

