WP = importWP('WP1.waypoints');

load('C:\Users\pgogende\Downloads\2022-01-11 13-53-55.tlog.mat')
lon_asv = lon_mavlink_gps2_raw_t(:,2)/10000000;
lat_asv = lat_mavlink_gps2_raw_t(:,2)/10000000;
conso = current_battery_mavlink_sys_status_t(:,2);

clearvars -except lon_asv lat_asv WP conso

lim_inf = 1900;
lin_sup = 2800;

figure(2)
geoplot(WP(:,1),WP(:,2),'g');
hold on
geoplot(lat_asv(lim_inf:lin_sup,1),lon_asv(lim_inf:lin_sup,1),'r');
geobasemap("satellite");
hold off
legend('WP trajectory','ASV trajectory','AutoUpdate','off')

mean_conso = mean(conso(lim_inf:lin_sup,1)/100);
min_conso = min(conso(lim_inf:lin_sup,1)/100);
max_conso = max(conso(lim_inf:lin_sup,1)/100);
str_mean = sprintf('Mean current consumption = %.2f A',mean_conso);
% str_min = sprintf(,min_conso);
% str_max = sprintf('max = %.1f A ',max_conso);


figure(3)
plot(conso(lim_inf:lin_sup,1)/100)
xlim([0 lin_sup-lim_inf]);
legend(str_mean,'FontSize',12,'FontWeight','bold')
xlabel('Time (s)','FontSize',12,'FontWeight','bold')
ylabel('Current consumption (A)','FontSize',12,'FontWeight','bold')