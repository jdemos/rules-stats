# rules-stats

This is Ruby utility that allows you to specify a target (Gnip) account and PowerTrack stream to GET a rule set and generate basic stats such as the average rule length for that ruleset.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes:

1. Clone respository.
2. Run `bundle install`. See project Gemfile for required gems.
3. Configure the config/account.yml file with account details target stream

Run on the command line:

`$ ruby rules_stats.rb`

Alternatively, you can pass a different config file path as the first command line argument (ARGV[0]).

`$ ruby rules_stats.rb 'config/some-other-file.yml'

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## TODO

- Print out the longest rule in the stdout summary
