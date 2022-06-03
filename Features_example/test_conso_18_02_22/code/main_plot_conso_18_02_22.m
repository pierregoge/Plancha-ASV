 load('data_conso_18_02_22.mat')

%Limit to plot
lim_inf_plot = 82690;
lim_sup_plot = 98580;

%% Speed differences
%Limit for u-turn at 1m/s
lim_inf_u1 = [93530,93990,94440,94970];
lim_sup_u1 = [93740,94210,94740,95260];
%Limit for transect at 1m/s
lim_inf_t1 = [93310,93740,94210,94740];
lim_sup_t1 = [93530,93990,94440,94970];

%Limit for u-turn at 0.8m/s
lim_inf_u0_8 = [83030,83520,84050,84610,85140,85710];
lim_sup_u0_8 = [83270,83720,84350,84870,85440,85960];
%Limit for transect at 0.8m/s
lim_inf_t0_8 = [82780,83270,83720,84350,84870,85440];
lim_sup_t0_8 = [83030,83520,84050,84610,85140,85710];

%Limit for u-turn at 1.2m/s
lim_inf_u1_2 = [87770,88240,88720,89400,89870,90340,90930];
lim_sup_u1_2 = [88010,88490,89200,89670,90170,90730,91290];
%Limit for transect at 1.2m/s
lim_inf_t1_2 = [87610,88010,88490,89200,89670,90170,90730];
lim_sup_t1_2 = [87770,88240,88720,89400,89870,90340,90930];

%% Weigth differences

%Limit for weigth analysis
lim_w1 = [11680, 16530];
lim_w2 = [18080, 23040];
lim_w3 = [24350, 29340];

%Limit for u-turn at 1m/s
lim_inf_uw1 = [11930,12390,12810];
lim_sup_uw1 = [12140,12590,13080];
%Limit for transect at 1m/s
lim_inf_tw1 = [11730,12140,12590];
lim_sup_tw1 = [11930,12390,12810];

%Limit for u-turn at 0.8m/s
lim_inf_uw2 = [18360,18860,19250];
lim_sup_uw2 = [18580,19020,19560];
%Limit for transect at 0.8m/s
lim_inf_tw2 = [18210,18580,19020];
lim_sup_tw2 = [18360,18860,19250];

%Limit for u-turn at 1.2m/s
lim_inf_uw3 = [24630,25070,25520];
lim_sup_uw3 = [24910,25320,25830];
%Limit for transect at 1.2m/s
lim_inf_tw3 = [24360,24910,25320];
lim_sup_tw3 = [24630,25070,25520];



%% Mean calculation for U-turn consumption
conso_u1 = [];
conso_u0_8 = [];
conso_u1_2 = [];

for i=1:length(lim_inf_u1(1,:))
conso_u1 = [conso_u1; conso(lim_inf_u1(1,i):lim_sup_u1(1,i),1)];
end
for i=1:length(lim_inf_u0_8(1,:))
conso_u0_8 = [conso_u0_8; conso(lim_inf_u0_8(1,i):lim_sup_u0_8(1,i),1)];
end
for i=1:length(lim_inf_u1_2(1,:))
conso_u1_2 = [conso_u1_2; conso(lim_inf_u1_2(1,i):lim_sup_u1_2(1,i),1)];
end

mean_conso_u1 = mean(conso_u1);
mean_conso_u0_8 = mean(conso_u0_8);
mean_conso_u1_2 = mean(conso_u1_2);


%% Mean calculation for transect consumption
conso_t1 = [];
conso_t0_8 = [];
conso_t1_2 = [];


for i=1:length(lim_inf_t1(1,:))
conso_t1 = [conso_t1; conso(lim_inf_t1(1,i):lim_sup_t1(1,i),1)];
end
for i=1:length(lim_inf_t0_8(1,:))
conso_t0_8 = [conso_t0_8; conso(lim_inf_t0_8(1,i):lim_sup_t0_8(1,i),1)];
end
for i=1:length(lim_inf_t1_2(1,:))
conso_t1_2 = [conso_t1_2; conso(lim_inf_t1_2(1,i):lim_sup_t1_2(1,i),1)];
end

mean_conso_t1 = mean(conso_t1);
mean_conso_t0_8 = mean(conso_t0_8);
mean_conso_t1_2 = mean(conso_t1_2);

%% Mean Time U-turn
for i=1:length(lim_inf_u1(1,:))
t_u1(1,i) = lim_sup_u1(1,i)-lim_inf_u1(1,i);
end
for i=1:length(lim_inf_u0_8(1,:))
t_u0_8(1,i) = lim_sup_u0_8(1,i)-lim_inf_u0_8(1,i);
end
for i=1:length(lim_inf_u1_2(1,:))
t_u1_2(1,i) = lim_sup_u1_2(1,i)-lim_inf_u1_2(1,i);
end

m_t_u1 = mean(t_u1);
m_t_u0_8 = mean(t_u0_8);
m_t_u1_2 = mean(t_u1_2);

%% Mean Time transect
for i=1:length(lim_inf_t1(1,:))
t_t1(1,i) = lim_sup_t1(1,i)-lim_inf_t1(1,i);
end
for i=1:length(lim_inf_t0_8(1,:))
t_t0_8(1,i) = lim_sup_t0_8(1,i)-lim_inf_t0_8(1,i);
end
for i=1:length(lim_inf_t1_2(1,:))
t_t1_2(1,i) = lim_sup_t1_2(1,i)-lim_inf_t1_2(1,i);
end

m_t_t1 = mean(t_t1);
m_t_t0_8 = mean(t_t0_8);
m_t_t1_2 = mean(t_t1_2);




%% Mean weigth
% Mean calculation for U-turn consumption
conso_uw1 = [];
conso_uw2 = [];
conso_uw3 = [];

for i=1:length(lim_inf_uw1(1,:))
conso_uw1 = [conso_uw1; conso(lim_inf_uw1(1,i):lim_sup_uw1(1,i),1)];
end
for i=1:length(lim_inf_uw2(1,:))
conso_uw2 = [conso_uw2; conso(lim_inf_uw2(1,i):lim_sup_uw2(1,i),1)];
end
for i=1:length(lim_inf_uw3(1,:))
conso_uw3 = [conso_uw3; conso(lim_inf_uw3(1,i):lim_sup_uw3(1,i),1)];
end

mean_conso_uw1 = mean(conso_uw1);
mean_conso_uw2 = mean(conso_uw2);
mean_conso_uw3 = mean(conso_uw3);


%% Mean calculation for transect consumption
conso_tw1 = [];
conso_tw2 = [];
conso_tw3 = [];

for i=1:length(lim_inf_tw1(1,:))
conso_tw1 = [conso_tw1; conso(lim_inf_tw1(1,i):lim_sup_tw1(1,i),1)];
end
for i=1:length(lim_inf_tw2(1,:))
conso_tw2 = [conso_tw2; conso(lim_inf_tw2(1,i):lim_sup_tw2(1,i),1)];
end
for i=1:length(lim_inf_tw3(1,:))
conso_tw3 = [conso_tw3; conso(lim_inf_tw3(1,i):lim_sup_tw3(1,i),1)];
end

mean_conso_tw1 = mean(conso_tw1);
mean_conso_tw2 = mean(conso_tw2);
mean_conso_tw3 = mean(conso_tw3);



%% Mean Weigth Time U-turn
for i=1:length(lim_inf_uw1(1,:))
t_uw1(1,i) = lim_sup_uw1(1,i)-lim_inf_uw1(1,i);
end
for i=1:length(lim_inf_uw2(1,:))
t_uw2(1,i) = lim_sup_uw2(1,i)-lim_inf_uw2(1,i);
end
for i=1:length(lim_inf_uw3(1,:))
t_uw3(1,i) = lim_sup_uw3(1,i)-lim_inf_uw3(1,i);
end

m_t_uw1 = mean(t_uw1);
m_t_uw2 = mean(t_uw2);
m_t_uw3 = mean(t_uw3);

%% Mean Weigth Time transect
for i=1:length(lim_inf_tw1(1,:))
t_tw1(1,i) = lim_sup_tw1(1,i)-lim_inf_tw1(1,i);
end
for i=1:length(lim_inf_tw2(1,:))
t_tw2(1,i) = lim_sup_tw2(1,i)-lim_inf_tw2(1,i);
end
for i=1:length(lim_inf_tw3(1,:))
t_tw3(1,i) = lim_sup_tw3(1,i)-lim_inf_tw3(1,i);
end

m_t_tw1 = mean(t_tw1);
m_t_tw2 = mean(t_tw2);
m_t_tw3 = mean(t_tw3);







%% Plot
%str_mean = sprintf('Mean current consumption = %.2f A',mean_conso);
% str_min = sprintf(,min_conso);
% str_max = sprintf('max = %.1f A ',max_conso);

figure(3)
plot(conso(lim_inf_plot:lim_sup_plot,1))
xlim([0 lim_sup_plot-lim_inf_plot]);
%legend(str_mean,'FontSize',12,'FontWeight','bold')
xlabel('Time (s)','FontSize',12,'FontWeight','bold')
ylabel('Current consumption (A)','FontSize',12,'FontWeight','bold')

