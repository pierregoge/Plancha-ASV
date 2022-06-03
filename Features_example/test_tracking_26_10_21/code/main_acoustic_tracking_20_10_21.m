% Author : Pierre Gogendeau
% Date : 27/10/21

clear all
close all

addpath(genpath('..\Code\Matlab\Functions'));      
addpath(genpath('D:\Seafile\These Pierre\Code\Matlab\Scripts_analyse'));
addpath(genpath('D:\Seafile\These Pierre\Code\Matlab\Scripts globaux'));  
addpath(genpath('D:\Seafile\These Pierre\Code\Matlab\Autre travaux\madgwick_algorithm_matlab'));


%% Variables 
% Waterlinked
filename = 'waterlinked\20211026-102247/mainLog.log';
hours_offset_waterlinked = 3;
% If strange offset of the waterlinked. Use Z axis of RTK to find it
minutes_offset_waterlinked = 0;
seconds_offset_waterlinked = 0;

srate = [100 10];

% Time range of analysis
limit_analyse_1 = "2021-26-10 13:24:00"; 
limit_analyse_2 = "2021-26-10 13:49:00"; 

%% IMU offset
% 11/08 Lagon paddle
magoffset = [-0.011936489569589,1.083923327302343,-1.050923592778087]; %26/10/21
gyrooffset = [-2.443709175685595,-1.354120303129685,-0.556896234499938];
acceloffset = [0 0 0];

%% Debug and plot
debug_geo_traj = 1;
debug_traj = 1;

%% Import file
% Openlogger variables
compute_data_logger =1;
seconds_offset_openlogger = -111;
plot_raw_data_logger = 0;

%% Import file

%% Waterlinked
mainLog = importfile_log_waterlinked(filename);
% Creation of time tables for waterlinked
[waterlinked] = compute_waterlinked_log(mainLog,hours_offset_waterlinked,minutes_offset_waterlinked,seconds_offset_waterlinked);

%% openlogger tag
% Import data from openlogger tag and apply calibration 
if compute_data_logger == 0
    data_raw = openlogger_load_time(); % load data file
else
  load('data_26_10_2.mat')
end

[data_tag, data, duration] = compute_openLogger_time_2(srate,data_raw,limit_analyse_1,limit_analyse_2,seconds_offset_openlogger,plot_raw_data_logger,magoffset,gyrooffset,acceloffset);

clear plot_raw_data_logger debug_signal_analyzer seconds_offset_openlogger

%% Synchronize waterlinked with openlogger tag and apply time range
t1 = datetime(limit_analyse_1,'InputFormat','yyyy-dd-MM HH:mm:ss');
t2 = datetime(limit_analyse_2,'InputFormat','yyyy-dd-MM HH:mm:ss');
TR = timerange(t1,t2);
data_w = data(TR,:);
waterlinked  = waterlinked(TR,:);
waterlinked_2 = synchronize(waterlinked,data_w);
waterlinked_3 = rmmissing(waterlinked_2);

x = smoothdata(waterlinked_3.x_w(:,1)-waterlinked_3.x_w(1,1),'movmean','SmoothingFactor',0.01);
y = smoothdata(waterlinked_3.y_w(:,1)-waterlinked_3.y_w(1,1),'movmean','SmoothingFactor',0.01);

data_w = retime(data_w,'regular','fillwithmissing','TimeStep',seconds(1));

clear waterlinked_2 waterlinked_3


%% Plot

figure(16)
geoplot(waterlinked.lat_w(:,1),waterlinked.lon_w(:,1),'g'); %1260
geobasemap("satellite");
hold on
geoplot(waterlinked.lat_g(:,1),waterlinked.lon_g(:,1),'r'); %1260
legend('2D Acoustic position','ASV GPS position','AutoUpdate','off')
