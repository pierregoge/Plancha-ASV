clear all
close all

%% import output

output = importOutput('test_bathy_europa_09_10_20\bathy\output.log');
x = output(1:end/2,1);
y = output(1:end/2,2);
z = output(1:end/2,3);


%%  Apply delaunay triangulation
tri = delaunay(x,y);

v = [-7 -6 -5 -4 -3 -2 -1];

% for n=1:length(output)/2
%     ix = find(x==output(n,1));
%     iy = find(y==output(n,2));
%     depth( ix, iy) = output(n,3);
% end

%% Plot it with TRISURF
h = trisurf(tri, x, y, z,...
'SpecularExponent',20,...
'FaceLighting','phong',...
'FaceColor','interp',...
'EdgeColor','none');
 light1 = light('Style','local',...
     'Position',[145 70 900000]);
daspect([1 1 0.5])
colormap default
xlabel('UTM x axis (m)','FontSize',12,'FontWeight','bold')
ylabel('UTM y axis (m)','FontSize',12,'FontWeight','bold')
zlabel('Depth (m)','FontSize',12,'FontWeight','bold')
c = colorbar;
c.Label.String = 'Depth (m)';
c.Label.FontSize = 12;
c.Label.FontWeight = 'bold';
colormap jet
% contour3(z,v,...
%     'Color','w')
% demcmap(z)
% light1 = light('Style','local',...
%     'Position',[145 70 900000]);