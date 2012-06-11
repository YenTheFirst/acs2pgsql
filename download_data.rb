#download all geo files:
#mkdir all_data
#wget -r -nd -nc 'ftp://ftp.census.gov/acs2010_5yr/summaryfile/2006-2010_ACSSF_By_State_By_Sequence_Table_Subset' -A 'g*.txt' -P all_data

STATES = ['ak', 'al', 'ar', 'az', 'ca', 'co', 'ct', 'dc', 'de', 'fl', 'ga', 'hi', 'la', 'id', 'il', 'in', 'ks', 'ky', 'la', 'ma', 'md', 'me', 'mi', 'mn', 'mo', 'ms', 'mt', 'nc', 'nd', 'ne', 'nh', 'nj', 'nm', 'nv', 'ny', 'oh', 'ok', 'or', 'pa', 'pr', 'ri', 'sc', 'sd', 'tn', 'tx', 'ut', 'va', 'vt', 'wa', 'wi', 'wv', 'wy']

def prepare_acs_subject_file(seqnum)
  #todo: check if downloaded already
  #
  `wget -r -nc -np -nH --cut-dirs=4 'ftp://ftp.census.gov/acs2010_5yr/summaryfile/2006-2010_ACSSF_By_State_By_Sequence_Table_Subset' -A '*#{seqnum}.zip'`
  Dir.chdir('All_Geographies_Not_Tracts_Block_Groups')
    `unzip '*#{seqnum}.zip'`
  Dir.chdir('..')

  Dir.chdir("Tracts_Block_Groups_Only")
    `unzip '*#{seqnum}.zip'`
    files = Dir.glob("[me]*txt")
  Dir.chdir("..")

  STATES.each do |state|
    ['m','e'].each do |type|
      filename = "#{type}20105#{state}#{seqnum}.txt"
      `sort -k26,32 -m All_Geographies_Not_Tracts_Block_Groups/#{filename} Tracts_Block_Groups_Only/#{filename} -o all_data/#{filename}`
    end
  end

end

#tables:
#sex by age B01001 10 7,55
#houshold income in past 12 months B19001 53 7,23
#aggregate housheold income? B19025 53 195
#per capita income b19301 59, 172
#aggregate income b19313 59 182
#ACSSF,B14005,39,,7,29 CELLS,,SEX BY SCHOOL ENROLLMENT BY EDUCATIONAL ATTAINMENT BY EMPLOYMENT STATUS FOR THE POPULATION 16 TO 19 YEARS,School Enrollment
#ACSSF,B23001,69,,7,173 CELLS,,SEX BY AGE BY EMPLOYMENT STATUS FOR THE POPULATION 16 YEARS AND OVER,Employment Status
#ACSSF,B15001,40,,7,83 CELLS,,SEX BY AGE BY EDUCATIONAL ATTAINMENT FOR THE POPULATION 18 YEARS AND OVER,Educational Attainment
#means of transportation to work - many tables
#aggregate travel time to work
#
#
# download_seq_num = "%04d000" % seq_num
# in acs, prepare_acs_subject_file
# in all_data, create_acs_table <full_table>, <seq_num>, <index-0 range>
# psql copy
# create appropriate model mapping in app
