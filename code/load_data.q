// Utils for data loading

// prepend site names with 0 if only 7 values in name
prepsite:{`${$[7=count x;"0",;]x}each string x}

// update nlcd table
/* x = table
/* y = year
nlcdupd:{
 col:`site_no`INTPTLAT`INTPTLON`Measure`REACHCODE`distance`imp`year;
 impcol:`$"imp_nlcd_",string 2000+y;
 ?[x;();0b;col!((prepsite;`SOURCE_FEA);`INTPTLAT;`INTPTLON;`Measure;`REACHCODE;`distance;impcol;y)]}

// read in and update the nlcd data for a given year
nlcdread:{nlcdupd[;x]("SFFFFFSFFSFSFFFFSFSSFSSFFFSFFSFF";enlist",")0:hsym`$"../data/other/snap_sampled_imp_nlcd_",string[2000+x],".csv"}


// load in precipitation, nlcd, gauges, basin characteristics, warnings and time to peak tables from csv/shape files

precipall:raze{flip `site_no`long`lat`elv`date`ppt!flip value each 10_("SFFFDF";enlist ",")0: 
               hsym `$"../data/other/prism/",string[x]}each key `$":../data/other/prism"

nlcd:raze nlcdread each 6 11 16

gauges:update prepsite site_no from ("SFFSS";enlist ",") 0:`$":../data/other/usgs_gauge_subset.csv";

basin:("S",242#"F";enlist ",") 0:`$":../data/other/gages_with_basin_attr.csv"

warnings:.ml.df2tab gp[`:read_file]["../data/other/national_shapefile_obs.shp"][`:dropna][`subset pykw (`Action;`Flood;`Moderate;`Major)][`:reset_index][`drop pykw 1b]

flash_cols:`site_no`lat`lon`start_time`end_time`peak_q`peak_time`delta_time
flash_tab :flash_cols xcol raze {("FFFZZFZF";enlist ",")0:x}each hsym `$"../data/other/flash/",/:string each -1_key `:../data/other/flash
peak:update prepsite site_no,date:`date$start_time from flash_tab
peak:`start_time xasc select from peak where date>=2009.07.01

//Load hdb's into memory

\l ../data/gauges_hdb
max_ht_str:0!select max height by site_no,date from str
