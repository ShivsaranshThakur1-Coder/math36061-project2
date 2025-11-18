function result = simulate_constant_case_tol(relTol, absTol)
%SIMULATE_CONSTANT_CASE_TOL Constant-speed chase with configurable tolerances.
%
%   result = SIMULATE_CONSTANT_CASE_TOL(relTol, absTol) runs the same
%   constant-speed simulation as SIMULATE_CONSTANT_CASE, but uses the given
%   solver tolerances RelTol and AbsTol for both phases.
%
%   The returned struct has the same fields as SIMULATE_CONSTANT_CASE:
%       result.captured
%       result.T
%       result.fox_pos_T
%       result.fox_distance
%       result.t
%       result.F
%       result.R

cfg = fox_rabbit_config();

%-------------------------------
% Phase 1: fox runs from F0 to G
%-------------------------------
phase1 = 1;
t0 = 0.0;
y0 = cfg.F0(:);

time_to_G = norm(cfg.G - cfg.F0) / cfg.sf;
tspan1 = [t0, time_to_G];

odefun1 = @(t, y) fox_rabbit_ode_const(t, y, cfg, phase1);
opts1 = odeset('RelTol', relTol, 'AbsTol', absTol);

[t1, y1] = ode45(odefun1, tspan1, y0, opts1);

%-------------------------------
% Phase 2: chase with blocking
%-------------------------------
phase2 = 2;
tspan2 = [t1(end), cfg.time_to_burrow];
y0_2 = y1(end, :).';

odefun2 = @(t, y) fox_rabbit_ode_const(t, y, cfg, phase2);
eventfun2 = @(t, y) fox_rabbit_events_const(t, y, cfg, phase2);

opts2 = odeset('Events', eventfun2, ...
               'RelTol', relTol, ...
               'AbsTol', absTol);

[t2, y2, te, ye, ie] = ode45(odefun2, tspan2, y0_2, opts2);

%-------------------------------
% Decide outcome and final time T
%-------------------------------
if isempty(te)
    T = t2(end);
    F_T = y2(end, :);
    captured = false;
else
    T = te(end);
    F_T = ye(end, :);
    captured = (ie(end) == 1);
end

%-------------------------------
% Build full paths
%-------------------------------
t_all = [t1; t2];
F_all = [y1; y2];

[Rx_all, Ry_all] = rabbit_position_const(t_all, cfg);
R_all = [Rx_all, Ry_all];

%-------------------------------
% Distance travelled by fox
%-------------------------------
fox_distance = cfg.sf * T;

%-------------------------------
% Pack result struct
%-------------------------------
result = struct();
result.captured = captured;
result.T = T;
result.fox_pos_T = F_T;
result.fox_distance = fox_distance;
result.t = t_all;
result.F = F_all;
result.R = R_all;
end
