this is a work-in-progress ruby script to easily import individual subjects from the Census American Community Survey 2010 5-year summaryinto a postgres database.

dependencies:
ruby
rake
wget
unzip
unix-based system

current steps:
	1. `rake setup`, once
	1. consult the census website to determine which table you desire. table numbers look like B00001 or B15002, for example
	1. `rake create_acs_table[<table_num>]`
	1. run psql <your settings> -f create_<table_num>.sql`
