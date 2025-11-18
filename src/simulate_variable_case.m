function result = simulate_variable_case()
%SIMULATE_VARIABLE_CASE Run diminishing-speed fox–rabbit chase (Question 2).
%
%   result = SIMULATE_VARIABLE_CASE() runs a two-phase simulation with
%   variable speeds:
%
%       sf(df) = sf0 * exp(-mu_f * df)
%       sr(dr) = sr0 * exp(-mu_r * dr)
%
%   State:
%       y = [Fx; Fy; df; dr]
%
%   Phases:
%       Phase 1: fox runs from F0 to G (ignoring rabbit for targeting).
%       Phase 2: fox chases rabbit (with blocking via FOX_TARGET_POINT).
%
%   Events (via FOX_RABBIT_EVENTS_VAR):
%       1) Capture (fox within cfg.capture_tol of rabbit)
%       2) Rabbit reaches burrow (dr >= arc_length_to_burrow)
%       3) Fox reaches G (phase 1 only)
%
%   The function returns a struct:
%       result.captured       : logical, true if fox captures rabbit first.
%       result.T              : stopping time (capture or burrow).
%       result.fox_pos_T      : [Fx, Fy] at time T.
%       result.fox_distance   : df(T).
%       result.rabbit_distance: dr(T).
%       result.t              : time vector for full path.
%       result.F              : [N x 2] fox positions.
%       result.R              : [N x 2] rabbit positions.
%       result.df             : [N x 1] fox distance trace.
%       result.dr             : [N x 1] rabbit distance trace.

cfg = fox_rabbit_config();

%-------------------------------
% Initial state
%-------------------------------
t0 = 0.0;
Fx0 = cfg.F0(1);
Fy0 = cfg.F0(2);
df0 = 0.0;
dr0 = 0.0;
y0 = [Fx0; Fy0; df0; dr0];

Tmax = 1e4;

%-------------------------------
% Phase 1: fox runs towards G
%-------------------------------
phase1 = 1;
odefun1 = @(t, y) fox_rabbit_ode_var(t, y, cfg, phase1);
eventfun1 = @(t, y) fox_rabbit_events_var(t, y, cfg, phase1);

opts1 = odeset('Events', eventfun1, ...
               'RelTol', 1e-8, ...
               'AbsTol', 1e-10);

[t1, y1, te1, ye1, ie1] = ode45(odefun1, [t0, Tmax], y0, opts1);

t_all = t1;
y_all = y1;

if ~isempty(te1)
    last_event = ie1(end);
    T = te1(end);
    yT = ye1(end, :).';

    switch last_event
        case 1
            captured = true;
        case 2
            captured = false;
        case 3
            captured = [];
        otherwise
            error('simulate_variable_case:UnknownEvent', ...
                  'Unknown event index in phase 1: %d', last_event);
    end
else
    last_event = NaN;
    T = t1(end);
    yT = y1(end, :).';
    captured = [];
end

if isempty(te1) || last_event ~= 3
    [result, cfg] = pack_variable_result(cfg, t_all, y_all, T, yT, captured);
    return;
end

%-------------------------------
% Phase 2: chase with blocking
%-------------------------------
phase2 = 2;
t0_2 = T;
y0_2 = yT;

odefun2 = @(t, y) fox_rabbit_ode_var(t, y, cfg, phase2);
eventfun2 = @(t, y) fox_rabbit_events_var(t, y, cfg, phase2);

opts2 = odeset('Events', eventfun2, ...
               'RelTol', 1e-8, ...
               'AbsTol', 1e-10);

[t2, y2, te2, ye2, ie2] = ode45(odefun2, [t0_2, t0_2 + Tmax], y0_2, opts2);

t_all = [t_all; t2];
y_all = [y_all; y2];

if ~isempty(te2)
    last_event2 = ie2(end);
    T = te2(end);
    yT = ye2(end, :).';

    switch last_event2
        case 1
            captured = true;
        case 2
            captured = false;
        otherwise
            error('simulate_variable_case:UnknownEventPhase2', ...
                  'Unknown event index in phase 2: %d', last_event2);
    end
else
    T = t2(end);
    yT = y2(end, :).';
    captured = false;
end

[result, cfg] = pack_variable_result(cfg, t_all, y_all, T, yT, captured);
end

%----------------------------------------------------------------------
function [result, cfg] = pack_variable_result(cfg, t_all, y_all, T, yT, captured)
%PACK_VARIABLE_RESULT Helper to assemble result struct for variable case.

Fx_all = y_all(:, 1);
Fy_all = y_all(:, 2);
df_all = y_all(:, 3);
dr_all = y_all(:, 4);

F_all = [Fx_all, Fy_all];

[xR, yR] = rabbit_position_from_distance(dr_all, cfg);
R_all = [xR, yR];

df_T = yT(3);
dr_T = yT(4);
F_T = yT(1:2).';

result = struct();
result.captured = logical(captured);
result.T = T;
result.fox_pos_T = F_T;
result.fox_distance = df_T;
result.rabbit_distance = dr_T;
result.t = t_all;
result.F = F_all;
result.R = R_all;
result.df = df_all;
result.dr = dr_all;
end
