/This script takes the following as inputs
/*sdate = start date of requested data
/*edate = ens date of requested data
/*dir   = where to save the table


args:first each .Q.opt .z.x;
if[not count args`sdate;2"No start date argument";exit 1];
if[null sdate:"D"$args`sdate;-2"Invalid start date argument";exit 2];
if[not count args`edate;2"No end date argument";exit 1];
if[null edate:"D"$args`edate;-2"Invalid end date argument";exit 2];
if[not count dir:args`dir;2"No dir argument";exit 3];

gauge:([]site_no:();dec_lat_va:();dec_long_v:();coord_acy_cd:();dec_coord_datum_cd:())

system"wget -O ",dir,"usgs_gauge_subset.csv \"https://nwis.waterdata.usgs.gov/usa/nwis/uv/?referred_module=sw&state_cd=ne&state_cd=nj&state_cd=ny&state_cd=sc&state_cd=sd&state_cd=va&site_tp_cd=OC&site_tp_cd=OC-CO&site_tp_cd=ES&site_tp_cd=LK&site_tp_cd=ST&site_tp_cd=ST-CA&site_tp_cd=ST-DCH&site_tp_cd=ST-TS&index_pmcode_99065=1&index_pmcode_30207=1&index_pmcode_00065=1&group_key=NONE&format=sitefile_output&sitefile_output_format=rdb&column_name=site_no&column_name=dec_lat_va&column_name=dec_long_va&range_selection=date_range&begin_date=",string[sdate],"&end_date=",string[edate],"&date_format=YYYY-MM-DD&rdb_compression=file&list_of_search_criteria=state_cd%2Csite_tp_cd%2Crealtime_parameter_selection\""

tab:("SS";enlist ",") 0:hsym `$dir,"usgs_gauge_subset.csv"
kk:"\t" vs'string each sg[first cols sg:28_tab];
usgs_gauge_subset:gauge upsert kk;
save 0N!`$dir,"/usgs_gauge_subset.csv"
