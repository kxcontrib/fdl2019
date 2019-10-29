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

gages:(27#"S";enlist ",") 0:`:../data/other/usgs_gage_subset.csv;
sites:string each gages[`site_no]
sites:4#{$[7=count x;"0",x;x]}each sites

streamtab:([] agency:();site_no:();datetime:();unk:();height:();auth:());

// This function pulls down data relating to stream gauges from the USGS waterdata database
/* dt_st = start date of requested data
/* dt_e  = end date for requested data
/* dir   = directory to save the data
/* stn   = site number
loadstream:{[dt_st;dt_e;dir;stn]
    0N!stn;
    system "wget -O ",dir,"/site",stn,".csv ","\"https://nwis.waterdata.usgs.gov/nwis/uv?cb_00065=on&format=rdb&site_no=",stn,"&period=&begin_date=",dt_st,"&end_date=",dt_e,"\""," >/dev/null 2>&1";
    strtab:("SS";enlist ",") 0:hsym `$dir,"/site",stn,".csv";
    kk:"\t" vs'string each sg[first cols sg:29_strtab];
    system"rm ",dir,"/site",stn,".csv"; 
    streamtab upsert kk where 6=count each kk
    }


stream:raze loadstream[string sdate;string edate;dir]each sites;

stream[`datetime]:"Z"$stream[`datetime];
stream[`height]:"F"$stream[`height];

if["/"=string[dir][0]0;dir:raze 1_string dir]
dstdir:hsym `$(raze system"pwd"),"/",dir

savestr:{[dir;t;d]0N!.Q.par[dir;d;`$"str/"]set .Q.en[dir]select from t where d="d"$datetime}
savestr[dstdir;stream]each exec distinct"d"$datetime from stream;
.Q.chk dstdir;
