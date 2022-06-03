import csv
import numpy as np
import matplotlib.pyplot as plt
from scipy.interpolate import interp1d,LinearNDInterpolator,NearestNDInterpolator
from scipy.spatial import KDTree
import transforms3d as t3d # Module to install
import pyproj # Module to install

print("Process started") #Parsing the log file

LOG_PATH = 'input7.log'  # Mission planner .log file

DATE=28102020
NB_DAYS_WEEK=4  #first day is sunday on GPS week - day in the week 
OFFSET_POSITION=[-0.278,0] # Offset from GPS to Single Beam, in format [X,Y] with X facing forward and Y facing left
Z_GPS=0.2
Z_SONDEUR=-0.109
DEPTH_COEF=1530.5/1500 #VOS fournie par TVA - calculée moyennée sur 6 mesures
OFFSET_GPS_SONDEUR=Z_GPS-Z_SONDEUR

DEPTH_TIME_WINDOW=0.05# Median filtering window half size in seconds
DEPTH_MAX = 15
DEPTH_MIN = 0.2
VALID_DEPTH_PROPORTION = 0.5  #Minimum proportion of valid depth values within time window to keep a point
ANGLE_MAX = 15 #Max angle for roll and pitch in degrees

MAKE_PLOTS=True

depth_list=[] #[time,depth]
attitude_list=[] #[time,roll,pitch,yaw]  Angles in degrees
gps2_list=[] #[Mavlinktime,latitude,longitude,altitude,GPStime]

print("Reading logs") #Parsing the log file
with open(LOG_PATH) as file:
    parsed=csv.reader(file,delimiter=',')
    for line in parsed:
        if line[0]=='DPTH':
            depth_list.append([float(line[1]),float(line[4])])
        elif line[0]=='ATT':
            attitude_list.append([float(line[1]),float(line[3]),float(line[5]),float(line[7])])
        elif line[0]=='GPS':
            if float(line[2])>2 and float(line[6])<=2:  #Checking status and HDOP <= 2
                gps2_list.append([float(line[1]),float(line[7]),float(line[8]),float(line[9]),float(line[3])])

#Building linear interpolator for attitude
attitude_itp=interp1d(np.array(attitude_list)[:,0],np.rad2deg(np.unwrap(np.deg2rad(np.array(attitude_list)[:,1::]),axis=0)),axis=0,fill_value='extrapolate')

#Building median filter for depth
def depth_med(depth_array, time_tree, time, radius, min_depth, max_depth):
    radius_indices=time_tree.query_ball_point([time], radius)
    values = depth_array[radius_indices, 1]
    inliers = np.where(np.logical_and(values > min_depth , values < max_depth))[0]  # Valid depth values
    if len(inliers) <= VALID_DEPTH_PROPORTION * len(values):  # Removing point (value -1) if not enough depth values are valid
        return (-1)
    else:  # Otherwise compute median of valid depths
        return (np.median(values[inliers]))

#Building projection from WGS84 to utm 40
wgs2utm = pyproj.Proj(proj='utm', zone='40', ellps='GRS80',south=True)

depth_array=np.array(depth_list)
time_tree=KDTree(depth_array[:,0,None])

output=[]
details=[]

print("Computing correction")
for gps2 in gps2_list:

    time=gps2[0]

    attitude = attitude_itp(time)  # Interpolating attitude
    attitude_centered = np.mod(attitude + np.array([180, 180, 0]), 360) - np.array([180, 180, 0])  # Putting roll/pitch in [-180,180] and yaw in [0,360]

    if abs(attitude_centered[0])<ANGLE_MAX and abs(attitude_centered[1])<ANGLE_MAX: #Checking the angle is valid

        depth=depth_med(depth_array,time_tree,time,1000000*DEPTH_TIME_WINDOW,DEPTH_MIN,DEPTH_MAX) #Filtering depth
        if depth !=-1 : #Keeping only valid points
            depthcorr=depth*DEPTH_COEF

            #Vector that goes from the gps to the detected point on the ground - used for XY calculations
            vect_gps2pt=[OFFSET_POSITION[0],OFFSET_POSITION[1],-OFFSET_GPS_SONDEUR-depthcorr]

            # Vector that goes from the waterline to the detected point on the ground - used for Z calculations
            vect_waterline2pt = [OFFSET_POSITION[0], OFFSET_POSITION[1],Z_SONDEUR-depthcorr]

            #Rotating the vector according to attitude to get its coordinates in a global coordinate sytem
            #with X facing North and Y facing West
            rollrad , pitchrad, yawrad = np.deg2rad(attitude)
            rot_vect_gps2pt=np.dot(t3d.euler.euler2mat(-rollrad,-pitchrad,-yawrad,axes='sxyz'),vect_gps2pt)
            rot_vect_waterline2pt = np.dot(t3d.euler.euler2mat(-rollrad, -pitchrad, -yawrad, axes='sxyz'), vect_waterline2pt)

            hauteur=gps2[3]
            lat,long = gps2[1:3]
            utm_x,utm_y=wgs2utm(long,lat)
            time_GPS=gps2[4]

            #Correcting the position using rotated vector
            utm_x_corr=utm_x-rot_vect_gps2pt[1]
            utm_y_corr=utm_y+rot_vect_gps2pt[0]

            #Calcutating real depth during survey

            prof_real=rot_vect_waterline2pt[2]

            #Writing output
            output.append([utm_x_corr,utm_y_corr,prof_real,time_GPS/1000-24*3600*(NB_DAYS_WEEK-1),int(DATE)]) 
            details.append(np.concatenate(([time / 1000000], attitude_centered, [depthcorr], vect_gps2pt , rot_vect_gps2pt,[utm_x,utm_y] ,[utm_x_corr,utm_y_corr], [hauteur])))

print("Saving")
np.savetxt("output.log",output,fmt='%f',header="UTM_x(m) UTM_y(m) profondeur_reel(m) temps UTC (s) date")
np.savetxt("details.log", details, fmt='%f', header="temps roll pitch yaw depthcorr vect_gps2pt rot_vect_gps2pt position_utm position_utm_corr")

if MAKE_PLOTS:
    POINT_SIZE=0.5
    IMAGE_DPI=300

    print("Making plots")

    #Plotting raw values from input log file

    plt.subplots()
    plt.plot(depth_array[:,0]/1000000,depth_array[:,1],'.',markersize=POINT_SIZE,label='depth (m)')
    plt.legend(loc="best")
    plt.savefig("depth_raw.png",dpi=IMAGE_DPI)

    attitude_array=np.array(attitude_list, dtype=object)

    plt.subplots()
    plt.plot(attitude_array[:, 0] / 1000000, attitude_array[:, 1],'.',markersize=POINT_SIZE, label='roll (degrees)')
    plt.plot(attitude_array[:, 0] / 1000000, attitude_array[:, 2],'.',markersize=POINT_SIZE, label='pitch (degrees)')
    plt.legend(loc="best")
    plt.savefig("roll_pitch_raw.png",dpi=IMAGE_DPI)

    gps2_array=np.array(gps2_list,dtype=object)

    plt.subplots()
    plt.plot(gps2_array[:, 0] / 1000000, gps2_array[:, 3],'.',markersize=POINT_SIZE, label='altitude (m)')
    plt.legend(loc="best")
    plt.savefig("gps_altitude_raw.png",dpi=IMAGE_DPI)

    #Plotting values from the valid points in the output data

    details_array=np.array(details,dtype=object)

    plt.subplots()
    plt.plot(details_array[:, 0], details_array[:, 4],'.',markersize=POINT_SIZE, label='depth (m)')
    plt.legend(loc="best")
    plt.savefig("depth_filtered_corr.png",dpi=IMAGE_DPI)

    plt.subplots()
    plt.plot(details_array[:, 0] , details_array[:, 1],'.',markersize=POINT_SIZE, label='roll (degrees)')
    plt.plot(details_array[:, 0] , details_array[:, 2],'.',markersize=POINT_SIZE, label='pitch (degrees)')
    plt.legend(loc="best")
    plt.savefig("roll_pitch_filtered.png",dpi=IMAGE_DPI)

print("Process finished") #Parsing the log file