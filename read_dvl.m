% mfile: read_cs2.m
%
% Read adcp mooring data.
%
% Based on LDEO LADCP software
% applied for BOEM 2013-2014 deployments.
%
% Daniel Torres, WHOI, 3/2016
%
% 04/22/08 - Added geomag60 for computing magnetic variation
%          - Calculates for each ensemble

clear

%%%%%%%%%%% User parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Filenames
% f.adcp='CS1BO001.000';                   % ADCP mooring file
f.adcp='DVL_5_18_clean.txt';
f.cid='DVL_5_18';                           % cruise ID
p.sn=3;                              % ADCP instrument s/n
p.adcp_station='';                    % ADCP station number
f.mc='';                    % Microcat processed mat file
f.mc='';                     % Microcat processed mat file
f.uls='';                                % ULS processed mat file
f.res=[p.adcp_station];                  % base filename (without extension)
p.name=f.res;                            % station name

% Parameter 
p.time_start=[NaN NaN NaN NaN NaN NaN];   % ADCP start time [yr,mn,da,hr,mn,sc]
p.time_end=  [NaN NaN NaN NaN NaN NaN];   % ADCP end time [yr,mn,da,hr,mn,sc]

% time offset if ADCP time was set incorrect
p.timoff=0;
% seconds of linear clock drift (subtract to correct clock)
p.drift=0;

% start and end GPS position (needs to be quite accurate <20m)
% [degrees N, minutes N, degrees E, minutes E]
% for west and south derees use minus sign on BOTH degree and minute
p.poss=[72 18.018 -157 -43.522];

% Compute magnetic variation correction.
% magFLAG=0;  no correction
% magFLAG=1;  manual correction; enter angle as given on chart
% magFLAG=2;  constant correction; Use old magdev to compute  
% magFLAG=3;  constant correction; Use new geomag60 compute  
% magFLAG=4;  variable correction; Use new geomag60 (until 2010) 
% magFLAG=5;  variable correction; Use new magdec from Firing (until 2015)
% magFLAG=6;  variable correction; Assumes magFLAG=5 has already been run.
% magnetic variation angle in degree (as given on chart)
p.magFLAG=0;
p.drot=0;     % Use p.magFLAG=1 to use this value.

% Editting criteria
p.uvlim=99;                          % maximum velocity
p.pglim=30.0;                        % minimum % good
p.elim=0.08;                         % maximum error velocity  [m/s]
p.pglim=0.0;                        % minimum % good
p.elim=99;                         % maximum error velocity  [m/s]

tic
if length(f.res)>1
 if exist([f.res,'.log'])==exist('loadadcp.m')
  eval(['delete ',f.res,'.log'])
 end
 diary([f.res,'.log'])
 diary on
end

% Load ADCP raw data
[d,p]=loadrdi_dvl(f,p);

disp(['==> load data took ',int2str(toc),' seconds'])
toco=toc;

% disp(['Actual ADCP start time: ' num2str(d.vl(1,[11:16]))])
% disp(['Actual ADCP   end time: ' num2str(d.vl(end,[11:16]))])

diary off

d.fl=d.fl(1:8);

eval(['save ' f.cid '' f.res '.mat f p d'])


