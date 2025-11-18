function [value, isterminal, direction] = fox_rabbit_events_const(t, y, cfg, phase)
%FOX_RABBIT_EVENTS_CONST Event function for constant-speed fox–rabbit ODE.
%
%   [value, isterminal, direction] = FOX_RABBIT_EVENTS_CONST(t, y, cfg, phase)
%   defines events for use with ODE45:
%
%   1) Capture: fox within cfg.capture_tol of rabbit.
%   2) Rabbit reaches burrow: t reaches cfg.time_to_burrow.
%
%   Phase is included for a consistent signature, but not used here.

Fx = y(1);
Fy = y(2);
F = [Fx, Fy];

[Rx, Ry] = rabbit_position_const(t, cfg);
R = [Rx, Ry];

dist_FR = norm(F - R);
capture_value = dist_FR - cfg.capture_tol;

burrow_value = cfg.time_to_burrow - t;

value = [capture_value; burrow_value];
isterminal = [1; 1];
direction = [0; 0];
end
