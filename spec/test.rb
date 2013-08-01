require 'minitest/spec'
require 'minitest/autorun'
require 'tempfile'
require_relative '../csv_sorter'

describe CSVSorter do
  let(:testdata) do
    <<-eos
ID,First,Last,Age,GithubAcct,Date of 3rd Grade Graduation
2,David,Block,76,,6/24/40
5,Jason,,30,haruska,
1,Matt,Conway,22,wr0ngway,6/25/01
3,,Robiner,16,,6/25/07
4,Rob,May,,,6/25/88
    eos
  end

  it 'sorts by the age descending' do
    table_data = CSV.parse(testdata, headers: true)
    result = CSVSorter.send(:sort_by_age, table_data)
    result.map { |row| row['Age'] }.must_equal ['76', '30', '22', '16', nil]
  end

  it 'generates a csv string from CSV::Rows' do
    table_data = CSV.parse(testdata, headers: true)
    CSVSorter.send(:generate_csv, table_data.headers, table_data).must_equal testdata
  end

  it 'writes to file' do
    file = Tempfile.new(['results','.csv'])
    CSVSorter.send(:write_to_file, 'hello, world', file.path)
    file.read.must_equal 'hello, world'
    file.unlink
  end

  it 'reads in a csv, sorts by age, and writes to file' do
    file = Tempfile.new(['foo','.csv'])
    file.write(testdata)
    file.close

    outfile = Tempfile.new(['result', '.csv'])

    CSVSorter.read(file.path)
    CSVSorter.generate_sorted_csv(outfile.path)

    outfile.read.must_equal <<-eos
ID,First,Last,Age,GithubAcct,Date of 3rd Grade Graduation
2,David,Block,76,,6/24/40
5,Jason,,30,haruska,
1,Matt,Conway,22,wr0ngway,6/25/01
3,,Robiner,16,,6/25/07
4,Rob,May,,,6/25/88
    eos

    file.unlink
    outfile.unlink
  end
end
