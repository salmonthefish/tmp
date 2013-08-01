require 'csv'

class CSVSorter
  attr_accessor :path, :table, :outfile

  def self.read(path)
    @@table = CSV.read(path, headers: true)
  end

  def self.generate_sorted_csv(outfile)
    write_to_file(generate_csv(@@table.headers, sort_by_age(@@table)), outfile)
  end

  private

  def self.sort_by_age(table)
    if table.headers.include? 'Age'
      table.sort_by { |row| row['Age'].to_i }.reverse
    else
      table
    end
  end

  def self.generate_csv(headers, rows)
    headers.to_csv + rows.map(&:to_csv).join
  end

  def self.write_to_file(csv_string, outfile)
    File.open(outfile, 'w') do |file|
      file.write(csv_string)
    end
  end
end
