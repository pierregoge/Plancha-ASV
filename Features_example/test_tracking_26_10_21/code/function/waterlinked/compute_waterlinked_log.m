function [waterlinked] = compute_waterlinked_log(mainLog,hours_offset_waterlinked,minutes_offset_waterlinked,seconds_offset_waterlinked)


a = string(mainLog.VarName1);
b = string(mainLog.VarName2);
time_bw = datetime(strcat(a,{' '},b),'InputFormat','uuuu-MM-dd HH:mm:ss');
time_bw = time_bw + hours(hours_offset_waterlinked) + minutes(minutes_offset_waterlinked) + seconds(seconds_offset_waterlinked);

catnames = categories(mainLog.VarName15);
catnames2 = categories(mainLog.VarName20);
%catnames3 = categories(mainLog.VarName26);
mainLog.Start = string(mainLog.Start);

for i = 1:length(time_bw(:,1))
    if  strcmp(mainLog.Start(i,1),'Waterlinked')
        %waterlinked_pos(i,1) = str2double(catnames(mainLog.VarName18(i,1))); %waterlinked lat
        waterlinked_pos(i,1) = str2double(catnames(mainLog.VarName15(i,1)));
        waterlinked_pos(i,2) = str2double(catnames2(mainLog.VarName20(i,1))); %waterlinked lon
        waterlinked_pos(i,3) = mainLog.VarName23(i,1); %waterlinked lon
        waterlinked_pos(i,4) = 0; %waterlinked lon
    else
        waterlinked_pos(i,1) = NaN;
        waterlinked_pos(i,2) = NaN;
         waterlinked_pos(i,3) = NaN;
         waterlinked_pos(i,4) = NaN;

    end
end

catnames3 = categories(mainLog.Thu);
catnames4 = categories(mainLog.VarName20);

for i = 1:length(time_bw(:,1))
    if  strcmp(mainLog.Start(i,1),'GPS')
        board_pos(i,1) = str2double(catnames3(mainLog.Thu(i,1)));
        board_pos(i,2) = mainLog.VarName17(i,1); %board lon
        board_pos(i,3) = str2double(catnames4(mainLog.VarName20(i,1)));
    else
        board_pos(i,1) = NaN;
        board_pos(i,2) = NaN;
        board_pos(i,3) = NaN;
    end
end

%Creation of timetable
varNames = {'lat','lon','z','std'};
gps_w = timetable(time_bw, waterlinked_pos(:,1),waterlinked_pos(:,2),waterlinked_pos(:,3),waterlinked_pos(:,4),'VariableNames',varNames);

%Creation of timetable
varNames = {'lat','lon','z'};
board = timetable(time_bw, board_pos(:,1),board_pos(:,2),board_pos(:,3),'VariableNames',varNames);

board = rmmissing(board);

natRowTimes = ismissing(gps_w.lat);
gps_w = gps_w(~natRowTimes,:);

data = synchronize(gps_w,board);
data = rmmissing(data);

% GPS to XYZ
x = deg2km(data.lat_gps_w);
y = deg2km(data.lon_gps_w);
x_board = deg2km(data.lat_board);
y_board = deg2km(data.lon_board);


%Creation of timetable
varNames = {'lat_w','lon_w','lat_g','lon_g','x_w','y_w','z_w','x_g','y_g','z_g','std'};
waterlinked = timetable(data.time_bw, data.lat_gps_w,data.lon_gps_w,data.lat_board,data.lon_board...
    ,x,y,data.z_gps_w,x_board,y_board,data.z_board,data.std,'VariableNames',varNames);

clear data

end

