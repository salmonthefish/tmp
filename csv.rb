require 'optparse'
require_relative 'csv_sorter'

options = {}
OptionParser.new do |opts|
  opts.on('-o n', '--output') do |file|
    options[:output] = file
  end
end.parse!

raise "filename required" if ARGV.first.nil?

CSVSorter.read(ARGV.first)
CSVSorter.generate_sorted_csv(options[:output] || 'results.csv')
