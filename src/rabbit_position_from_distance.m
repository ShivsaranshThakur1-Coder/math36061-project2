function [x, y, theta] = rabbit_position_from_distance(dr, cfg)
%RABBIT_POSITION_FROM_DISTANCE Rabbit position on circle given distance dr.
%
%   [x, y, theta] = RABBIT_POSITION_FROM_DISTANCE(dr, cfg) returns the
%   coordinates (x, y) and angle theta (radians) of the rabbit given a
%   cumulative distance dr travelled along the circular fence of radius
%   cfg.r_circle, starting from R0 = (0, r) at theta = 0 moving towards
%   cfg.theta_burrow.
%
%   dr can be scalar or array. Position is clamped at the burrow once
%   dr >= cfg.arc_length_to_burrow.

origSize = size(dr);
dr = dr(:);

r = cfg.r_circle;
theta_target = cfg.theta_burrow;
s_to_burrow = cfg.arc_length_to_burrow;

dr_clamped = min(dr, s_to_burrow);
theta = dr_clamped ./ r;
theta = min(theta, theta_target);

x = r .* sin(theta);
y = r .* cos(theta);

x = reshape(x, origSize);
y = reshape(y, origSize);
theta = reshape(theta, origSize);
end
