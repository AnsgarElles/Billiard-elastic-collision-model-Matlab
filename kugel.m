function [kugeldgl] = kugel(t,y)
 global m d r
 kugeldgl = [y(2); -d/m*y(2); y(4); -d/m*y(4)];
end