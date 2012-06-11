STATES = ['ak', 'al', 'ar', 'az', 'ca', 'co', 'ct', 'dc', 'de', 'fl', 'ga', 'hi', 'la', 'id', 'il', 'in', 'ks', 'ky', 'la', 'ma', 'md', 'me', 'mi', 'mn', 'mo', 'ms', 'mt', 'nc', 'nd', 'ne', 'nh', 'nj', 'nm', 'nv', 'ny', 'oh', 'ok', 'or', 'pa', 'pr', 'ri', 'sc', 'sd', 'tn', 'tx', 'ut', 'va', 'vt', 'wa', 'wi', 'wv', 'wy']

def download_geographies
  `wget -r -nd -nc 'ftp://ftp.census.gov/acs2010_5yr/summaryfile/2006-2010_ACSSF_By_State_By_Sequence_Table_Subset' -A 'g*.txt' -P all_data`
end

def prepare_acs_subject_file(seqnum)
  seqnum = "%04d000" % seqnum

  #check if the subject file already exists for each state
  return if STATES.all do |state|
    filename = "all_data/#{type}20105#{state}#{seqnum}.txt"
    File.exists? filename
  end

  current_dir = Dir.pwd

  begin

    #download all the data, for each state, and each geography type
    `wget -r -nc -np -nH --cut-dirs=4 'ftp://ftp.census.gov/acs2010_5yr/summaryfile/2006-2010_ACSSF_By_State_By_Sequence_Table_Subset' -A '*#{seqnum}.zip'`

    #unzip our data, get list of filenames
    Dir.chdir('All_Geographies_Not_Tracts_Block_Groups')
      `unzip '*#{seqnum}.zip'`
    Dir.chdir('..')

    Dir.chdir("Tracts_Block_Groups_Only")
      `unzip '*#{seqnum}.zip'`
      files = Dir.glob("[me]*txt")
    Dir.chdir("..")

    #merge the downloaded data into a usable subject file
    STATES.each do |state|
      ['m','e'].each do |type|
        filename = "#{type}20105#{state}#{seqnum}.txt"
        `sort -k26,32 -m All_Geographies_Not_Tracts_Block_Groups/#{filename} Tracts_Block_Groups_Only/#{filename} -o all_data/#{filename}`
      end
    end

  ensure
    Dir.chdir(current_dir)
  end


end

# download_seq_num = "%04d000" % seq_num
# in acs, prepare_acs_subject_file
# in all_data, create_acs_table <full_table>, <seq_num>, <index-0 range>
# psql copy
# create appropriate model mapping in app
