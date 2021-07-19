         Format of out from loadrdi_sbi.m STEP 1
         =======================================
                     10/20/2015

Output format from loadrdi_sbi.m. Modified to save ensemble number.

read_bga10.m
============
read_bga10.m - Each station has a specific read program. Here editting 
criteria, start times, positions, file names, etc were all set. The
following editting criteria were applied to all stations:

Input:  DPL1_000.000 - Raw binary ADCP data.
Output: BGY10_A_step1_raw.mat - Mat file of semi-processed ADCP data.

p.pglim = 20 %     - Minimum percent good threshold.
p.elim  = 0.05 m/s - Maximum error velocity.
p.magFLAG = 5;     - Magnetic Variation Flag.
p.drot  = 0;       - Magnetic variation at station.

% Compute magnetic variation correction.
% magFLAG=0;  no correction
% magFLAG=1;  manual correction; enter angle as given on chart
% magFLAG=2;  constant correction; Use old magdev to compute  
% magFLAG=3;  constant correction; Use new geomag60 compute  
% magFLAG=4;  variable correction; Use new geomag60 compute 
% magFLAG=5;  variable correction; Use new magdec from Firing (until 2015)
% magFLAG=6;  variable correction; Assumes magFLAG=5 has already been run.
% magnetic variation angle in degree (as given on chart)

Magnetic variation correction was applied to each ensemble.

Data exceeding the thresholds above were set to NaN. Velocity data 
were rotated to True North by adding magnetic variation angle to 
direction and converted to U and V components.

The read_bga10.m program sets these parameters and calls loadrdi_sbi.m 
to read the binary ADCP data and save into mat files. The saved mat 
files have the following format:

>> whos
  Name      Size               Bytes  Class     Attributes

  d         1x1             23063240  struct              
  f         1x1                  678  struct              
  p         1x1                 1812  struct 

>> d
 
d = 

     mag: [7291x1 double]                  % Magnetic variation at each time
      fl: [30 160 2 0.8800 3.0700 2.1400 50.3800 600 1 1.4418e+10]  % fixed leader data
      vl: [7291x25 double]                 % variable leader data
     vel: [7291x30x4 double]               % velocity data
    corr: [7291x30x4 double]               % correlation data
    echo: [7291x30x4 double]               % echo amplitude data
      pg: [7291x30x4 double]               % percent good data
      bt: [7291x16 double]                 % Bottom track data

>> f

f = 

    adcp: 'DPL1_000.000'
     cid: 'BGY10'
      mc: ''
     uls: 'uls10a'
     res: 'A'

>> p

p = 


              sn: 9999
    adcp_station: 'A'
            name: 'A'
      time_start: [2008 8 14 0 0 0]
        time_end: [2012 10 12 2 0 0]
          timoff: 0
           drift: 0
            poss: [74 0.0630 -139 59.4799]
         magFLAG: 6
            drot: 0
           pglim: 20
            elim: 0.0500
            freq: 600
       firm_vers: 50.3800
          cpu_sn: 1.4418e+10
    orient_start: 'up'


Fixed leader data
-----------------
d.fl(1) -  % number of depth cells
d.fl(2) -  % pings per ensemble
d.fl(3) -  % depth cell length (m)
d.fl(4) -  % blank after transmit (m)
d.fl(5) -  % distance to the middle of the first depth cell (m)
d.fl(6) -  % transmit pulse length (m)
d.fl(7) -  % firmware version
d.fl(8) -  % ADCP frequency (kHz)
d.fl(9) -  % ADCP start orientation (0=down,1=up)
d.fl(10)-  % ADCP unique cpu ID

Variable leader data
--------------------
d.vl(:,1)  -    % true time (Julian days)
d.vl(:,2)  -    % pitch
d.vl(:,3)  -    % roll
d.vl(:,4)  -    % heading
d.vl(:,5)  -    % ADCP temperature (deg C)
d.vl(:,6)  -    % ADCP Salinity (from ES) (psu) (usually 35)
d.vl(:,7)  -    % ADCP Speed of Sound used by ADCP (m/s) 
d.vl(:,8)  -    % Transmit voltage (V)
d.vl(:,9)  -    % ADCP pressure (dbar)
d.vl(:,10) -    % Year Day (for plotting)
d.vl(:,11) -    % Date [yr] (Start of sample)
d.vl(:,12) -    % Date [mo] (Start of sample)
d.vl(:,13) -    % Date [da] (Start of sample)
d.vl(:,14) -    % Date [hr] (Start of sample)
d.vl(:,15) -    % Date [mn] (Start of sample)
d.vl(:,16) -    % Date [sc] (Start of sample)
d.vl(:,17) -    % Transmit current
d.vl(:,18) -    % Transmit voltage
d.vl(:,19) -    % Ambient temperature
d.vl(:,20) -    % Pressure (+)
d.vl(:,21) -    % Pressure (-)
d.vl(:,22) -    % Attitude temperature
d.vl(:,23) -    % Attitude
d.vl(:,24) -    % Contamination sensor
d.vl(:,25) -    % ADCP Orientation (0=dn, 1=up)
d.vl(:,26) -    % Ensemble number


Velocity data (m=ensembles,n=bins)
-------------
d.vel(m,n,1) -  % Corrected U component velocity (m/s)
d.vel(m,n,2) -  % Corrected V component velocity (m/s)
d.vel(m,n,3) -  % Corrected W component velocity (m/s)
d.vel(m,n,4) -  % Error velocity (m/s)

Correlation data
----------------
d.corr(:,:,1) - % Beam 1 correlation
d.corr(:,:,2) - % Beam 2 correlation
d.corr(:,:,3) - % Beam 3 correlation
d.corr(:,:,4) - % Beam 4 correlation

Echo amplitude data
-------------------
d.echo(:,:,1) - % Beam 1 echo amplitude
d.echo(:,:,2) - % Beam 2 echo amplitude
d.echo(:,:,3) - % Beam 3 echo amplitude
d.echo(:,:,4) - % Beam 4 echo amplitude
d.mn_ea(:,:)  - % Mean echo amplitude of all 4 beams

Percent good data
-----------------
d.pg(:,:,1)   - % Percent good 3-beam solutions
d.pg(:,:,2)   - % Percent transformations rejected
d.pg(:,:,3)   - % Percent more than one beam bad
d.pg(:,:,4)   - % Percent good 4-beam solutions

Bottom track data
-----------------
d.bt(:,1:4)   - % Beam 1-4 BT range (not counting pitch and roll)
d.bt(:,5)     - % East component of bottom velocity
d.bt(:,6)     - % North component of bottom velocity
d.bt(:,7)     - % Vertical component (+ towards surface)
d.bt(:,8)     - % Error component of bottom velocity
d.bt(:,9:12)  - % Beam 1-4 BT correlation
d.bt(:,13:16) - % Beam 1-4 BT percent good
