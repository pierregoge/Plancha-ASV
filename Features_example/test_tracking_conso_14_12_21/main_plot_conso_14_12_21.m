 load('data_conso_14_12_21.mat')
 
lim_inf = 50000;
lin_sup = 100000;

figure(2)
geoplot(lat_asv(lim_inf:lin_sup,1),lon_asv(lim_inf:lin_sup,1),'r');
geobasemap("satellite");
legend('ASV trajectory','AutoUpdate','off')


mean_conso = mean(conso(lim_inf:lin_sup,1));
min_conso = min(conso(lim_inf:lin_sup,1));
max_conso = max(conso(lim_inf:lin_sup,1));
str_mean = sprintf('Mean current consumption = %.2f A',mean_conso);
% str_min = sprintf(,min_conso);
% str_max = sprintf('max = %.1f A ',max_conso);

figure(3)
plot(conso(lim_inf:lin_sup,1))
xlim([0 lin_sup-lim_inf]);
legend(str_mean,'FontSize',12,'FontWeight','bold')
xlabel('Time (s)','FontSize',12,'FontWeight','bold')
ylabel('Current consumption (A)','FontSize',12,'FontWeight','bold')

