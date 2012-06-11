
def download_lookup_table
  `wget http://www2.census.gov/acs2010_5yr/summaryfile/Sequence_Number_and_Table_Number_Lookup.txt`
end

def lookup_table(table_name)
  lookup_line = File.open('Sequence_Number_and_Table_Number_Lookup.txt').lines.find do |l|
    l.split(',')[1] == table_name
  end

  sequence_num, first_col, num_cols = lookup_line.split(',').values_at(2,4,5).map(&:to_i)
  start_col = first_col - 1

  return sequence_num, (start_col .. start_col+num_cols -1)
end
