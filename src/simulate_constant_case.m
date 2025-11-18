function result = simulate_constant_case()
%SIMULATE_CONSTANT_CASE Run the constant-speed fox–rabbit chase (Question 1).
%
%   result = SIMULATE_CONSTANT_CASE() runs a two-phase simulation:
%
%       Phase 1: Fox runs from F0 directly to the gap G at speed sf, ignoring the rabbit.
%       Phase 2: From G onward, fox chases the rabbit according to FOX_VELOCITY_CONST
%                with phase = 2, including line-of-sight blocking by fence AE.
%
%   Events in phase 2:
%       - Capture: fox within cfg.capture_tol of rabbit (event index 1).
%       - Rabbit reaches burrow (event index 2).
%
%   The function returns a struct:
%
%       result.captured       : logical, true if fox captures rabbit before it reaches burrow.
%       result.T              : time at which simulation stops (capture or burrow), seconds.
%       result.fox_pos_T      : [Fx, Fy] at time T.
%       result.fox_distance   : total distance travelled by fox up to T (m).
%       result.t              : time vector for the concatenated path.
%       result.F              : [N x 2] fox positions along result.t.
%       result.R              : [N x 2] rabbit positions along result.t.

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

opts1 = odeset('RelTol', 1e-8, 'AbsTol', 1e-10);

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
               'RelTol', 1e-8, ...
               'AbsTol', 1e-10);

[t2, y2, te, ye, ie] = ode45(odefun2, tspan2, y0_2, opts2); %#ok<ASGLU>

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
% Build full paths for fox and rabbit
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
