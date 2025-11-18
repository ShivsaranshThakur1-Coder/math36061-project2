function [value, isterminal, direction] = fox_rabbit_events_var(t, y, cfg, phase)
%FOX_RABBIT_EVENTS_VAR Events for variable-speed fox–rabbit ODE (Question 2).
%
%   Events:
%     1) Capture: ||F - R|| - capture_tol = 0
%     2) Rabbit reaches burrow: dr - arc_length_to_burrow = 0
%     3) Fox reaches gap G (phase 1 only)

Fx = y(1);
Fy = y(2);
df = y(3); %#ok<NASGU>
dr = y(4);

F = [Fx, Fy];

[Rx, Ry] = rabbit_position_from_distance(dr, cfg);
R = [Rx, Ry];

dist_FR = norm(F - R);
capture_value = dist_FR - cfg.capture_tol;

burrow_value = dr - cfg.arc_length_to_burrow;

if phase == 1
    gap_value = norm(F - cfg.G);
else
    gap_value = 1.0;
end

value = [capture_value; burrow_value; gap_value];
isterminal = [1; 1; 1];
direction = [0; 0; 0];
end
