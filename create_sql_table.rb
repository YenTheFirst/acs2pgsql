
STATES = ['ak', 'al', 'ar', 'az', 'ca', 'co', 'ct', 'dc', 'de', 'fl', 'ga', 'hi', 'la', 'id', 'il', 'in', 'ks', 'ky', 'la', 'ma', 'md', 'me', 'mi', 'mn', 'mo', 'ms', 'mt', 'nc', 'nd', 'ne', 'nh', 'nj', 'nm', 'nv', 'ny', 'oh', 'ok', 'or', 'pa', 'pr', 'ri', 'sc', 'sd', 'tn', 'tx', 'ut', 'va', 'vt', 'wa', 'wi', 'wv', 'wy']

DELIM = '|'

def parse_geo(line)
  #return a dict of geo headers  
  {
    "LOGRECNO" => line[13,7],
    "SUMLEV" => line[8,3],
    "COMPONENT" => line[11,2],
    "GEOID" => line[178,40].strip,
  }
end

def create_acs_table(table_name, sequence_num, column_range)
  Dir.chdir('all_data')

  out_file_name = "#{table_name}.csv"
  out_file = File.new(out_file_name, "w")

  STATES.each do |state| 
    puts "creating table for #{state}"

    geo_file = File.new("g20105#{state}.txt", "r")
    est_file = File.new("e20105%s%04d000.txt" % [state, sequence_num], "r")
    moe_file = File.new("m20105%s%04d000.txt" % [state, sequence_num], "r")
    
    geo_file.each do |geo_line|
      geo_line = parse_geo(geo_line)
      est_line = est_file.readline().split(',').map(&:strip)
      moe_line = moe_file.readline().split(',').map(&:strip)

      #don't pull records with a geographic limitation, for now
      next unless geo_line["COMPONENT"] == '00'

      #ensure we're still valid
      if geo_line["LOGRECNO"] != est_line[5] or geo_line["LOGRECNO"] != moe_line[5]
        $stderr.puts("lines that don't match up!")
        $stderr.puts geo_line
        $stderr.puts est_line*", "
        $stderr.puts moe_line*", "
        exit 1
      end

      #get the relevant columns
      columns = est_line[column_range].zip(moe_line[column_range])

      #and output
      out_file << geo_line["SUMLEV"] << DELIM << geo_line["GEOID"][7..-1] << DELIM << columns.flatten.join(DELIM) << "\n"
    end
  
    geo_file.close
    est_file.close
    moe_file.close
  end
  
  out_file.close

  #create the SQL loading command
  File.open("create_#{table_name}.sql", "w") do |f|
    f.puts 'SET CLIENT_ENCODING TO UTF8;'
    f.puts 'SET STANDARD_CONFORMING_STRINGS TO ON;'
    f.puts 'BEGIN;'
    f.puts ''
    sql_name = "census_acs_#{table_name.downcase}"
    f.puts "CREATE TABLE \"#{sql_name}\"("
    f.puts "  sumlev varchar(3),"
    f.puts "  geoid varchar(40),"
    num_cols = column_range.end - column_range.begin + 1
    f << (1..num_cols).map do |col_num|
      "  col_%04d integer, margin_%04d integer" % [col_num, col_num]
    end * ",\n"
    f.puts ');'
    f.puts ''
    f.puts "\\copy #{sql_name} from '#{out_file_name}' DELIMITER '#{DELIM}' NULL ''"
    f.puts "CREATE INDEX #{sql_name}_sumlev on #{sql_name}(sumlev);"
    f.puts "CREATE INDEX #{sql_name}_geoid on #{sql_name}(geoid);"
    f.puts 'COMMIT;'
  end


  Dir.chdir('..')
end
