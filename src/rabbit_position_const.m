function [x, y, theta] = rabbit_position_const(t, cfg)
%RABBIT_POSITION_CONST Rabbit position on circular fence (constant-speed).
%
%   [x, y, theta] = RABBIT_POSITION_CONST(t, cfg) returns the coordinates
%   (x, y) and polar angle theta (radians) of the rabbit at time t (seconds),
%   assuming it moves along the circular fence of radius cfg.r_circle
%   from the initial point R0 = (0, cfg.r_circle) toward the burrow angle
%   cfg.theta_burrow at constant speed cfg.sr.
%
%   t can be a scalar or a vector (row or column). The outputs x, y, theta
%   preserve the same shape as t. Once the rabbit reaches the burrow angle,
%   its position is clamped at the burrow point for all later times.

origSize = size(t);
t = t(:);

r = cfg.r_circle;
theta_target = cfg.theta_burrow;

% Arc length travelled at time t (non-negative)
s = max(0, cfg.sr .* t);

% Corresponding angle; starting angle is 0 at (0, r)
theta = s ./ r;

% Clamp to burrow angle
theta = min(theta, theta_target);

x = r .* sin(theta);
y = r .* cos(theta);

% Reshape outputs to match original input shape
x = reshape(x, origSize);
y = reshape(y, origSize);
theta = reshape(theta, origSize);
end
