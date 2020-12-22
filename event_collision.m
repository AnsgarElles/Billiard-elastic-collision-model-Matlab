function [value,isterminal,direction] = event_collision(t,y)

%event-Funktion beendet Integration sobald einer der Werte in "value" null
%wird (entspricht Beruehrung der Bande, siehe "isterminal" ==1 d.h. Terminierung auf "true").
global r endvelocity
value=[y(1)-r, y(3)-r, y(1)+r-1.78, y(3)+r-3.57, sqrt((y(2))^2 + (y(4))^2)-endvelocity];    %wird negativ, wird negativ, wird positiv, wird positiv (bei verlassen des Spielfeldes)
isterminal=[1 1 1 1 1];
direction=zeros(1,5);
end