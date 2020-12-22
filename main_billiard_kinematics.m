clear all; close all; clc;

%Jonathan Klassen | 903
%Ansgar Elles | 9026433

% main script "elastic collisions"
% the goal is to simulate the kinematics of balls on a pool table 

tic

% initiate constants 
global m d r endvelocity

m=0.17; d=0.15; r=0.0285;    %mass, friction, radius
tspan = 0:0.02:10;  

k = 1; %while loop counter
stillrolling = 1;   % while loop, entry value 
endvelocity = 0.1;  % end speed at which simulation stops
options = odeset('Events', @event_collision);

% set parameters for balls
vals_blueball = [1 -7 1 4];      %[sx vx sy vy]
vals_redball = [0.5 2 2 3];

figure('NumberTitle','Off','Name','elastic_collision');
axis([0 1.78 0 3.57]); axis equal; hold on;         %Frage: Bringt hier "hold on" etwas?
title('Billiard table');
playingfield = rectangle('Position',[0 0 1.78 3.57],'FaceColor','g');
blueball = rectangle('Position',[0 0 2*r 2*r],'Curvature',[1,1],'FaceColor','b');
redball = rectangle('Position',[0 0 2*r 2*r],'Curvature',[1,1],'FaceColor','r');

t_blue_total = zeros(1,1);
y_blue_total = zeros(1,4);
t_red_total = zeros(1,1);
y_red_total = zeros(1,4);

%% While loop
while stillrolling == 1
    
    [t_blue,y_blue,te_blue] = ode45(@kugel,tspan,vals_blueball,options);
    [t_red,y_red,te_red] = ode45(@kugel,tspan,vals_redball,options);
    
    %Termination when velocity too low
    if sqrt((y_blue(end,2))^2 + (y_blue(end,4))^2)-endvelocity && ...   
       sqrt((y_red(end,2))^2 + (y_red(end,4))^2)-endvelocity <= 0      % sobald eine Kugel stoppt wird bei dieser permanet das Event getriggert
        disp('Die Kugeln rollen nicht mehr.')
        stillrolling = 0;
    end

    %new start values, elastic collision with border
    if y_blue(end,1) <= r || y_blue(end,1) >= 1.78-r  %collision with the vertical border, x-velocity *(-1)
        vals_blueball = [y_blue(end,1)^(1/1.001) -y_blue(end,2) y_blue(end,3) y_blue(end,4)];   % x or y position must be modified too so that event function can not be triggered again instantly 
    elseif y_blue(end,3) <= r || y_blue(end,3) >= 3.57-r %collision with the horizontal border, y-velocity *(-1)
        vals_blueball = [y_blue(end,1) y_blue(end,2) y_blue(end,3)^(1/1.001) -y_blue(end,4)];       
    end
    
    if y_red(end,1) <= r || y_red(end,1) >= 1.78-r  %collision with the vertical border, x-velocity *(-1)
        vals_redball = [y_red(end,1)^(1/1.001) -y_red(end,2) y_red(end,3) y_red(end,4)];   % x or y position must be modified too so that event function can not be triggered again instantly 
    elseif y_red(end,3) <= r || y_red(end,3) >= 3.57-r  %collision with the horizontal border, y-velocity *(-1)
        vals_redball = [y_red(end,1) y_red(end,2) y_red(end,3)^(1/1.001) -y_red(end,4)];       
    end

    % visualize 
%     for i = 1:length(t_blue)  %min([length(t_blue), length(t_red)])  %time steps are beeing lost
%         set(blueball,'Position',[y_blue(i,1)-r, y_blue(i,3)-r, 2*r, 2*r]);
%         pause(0.2)
%         drawnow; hold on;
%         %animation(i) = getframe%(pooltable);
%         %movieVector(i) = getframe(fig1, [0 0 340 434]);
%     end
%     for i = 1:length(t_red)
%         set(redball,'Position',[y_red(i,1)-r, y_red(i,3)-r, 2*r, 2*r]);
%         pause(0.2)
%         drawnow; hold on;
%     end
    
    t_blue_total = [t_blue_total; t_blue];
    y_blue_total = [y_blue_total; y_blue];
    t_red_total  = [t_red_total; t_red];
    y_red_total = [y_red_total; y_red];
 
    k = k+1;
end
%% Animation/Graphics
for i = 2:min([length(t_blue_total), length(t_red_total)])
    set(blueball,'Position',[y_blue_total(i,1)-r, y_blue_total(i,3)-r, 2*r, 2*r]);
    set(redball,'Position',[y_red_total(i,1)-r, y_red_total(i,3)-r, 2*r, 2*r]);
    drawnow
    pause(0.1)
end
    % myWriter = VideoWriter('pooltable');
% myWriter.FrameRate = 20; 
% open(myWriter);
% writeVideo(myWriter, movieVector);
% close(myWriter);
% myWriter = VideoWriter('curve');
% myWriter.FrameRate = 30;
% open(myWriter);
% writeVideo(myWriter,animation);
% close(myWriter);
% imshow(animation.cdata);
% movie(pooltable)

toc

    