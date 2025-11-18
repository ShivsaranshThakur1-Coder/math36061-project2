function dydt = fox_rabbit_ode_var(t, y, cfg, phase)
%FOX_RABBIT_ODE_VAR Variable-speed fox–rabbit ODE (Question 2).
%
%   State y:
%       y(1) = Fx, y(2) = Fy : fox position coordinates
%       y(3) = df           : cumulative fox distance travelled
%       y(4) = dr           : cumulative rabbit distance travelled
%
%   Speeds:
%       sf(df) = sf0 * exp(-mu_f * df)
%       sr(dr) = sr0 * exp(-mu_r * dr)
%
%   Phases (same geometric logic as constant case):
%       phase = 1 : fox runs from F0 to gap G.
%       phase = 2 : fox chases rabbit (with fence blocking via FOX_TARGET_POINT).

Fx = y(1);
Fy = y(2);
df = y(3);
dr = y(4);

F = [Fx, Fy];

sf = fox_speed_var(df, cfg);
sr = rabbit_speed_var(dr, cfg);

[Rx, Ry] = rabbit_position_from_distance(dr, cfg);
R = [Rx, Ry];

switch phase
    case 1
        T = cfg.G;
    case 2
        T = fox_target_point(F, R, cfg, 2);
    otherwise
        error('fox_rabbit_ode_var:InvalidPhase', ...
              'Unsupported phase: %d', phase);
end

dir = T - F;
d = norm(dir);

if d < 1e-12
    vF = [0.0, 0.0];
else
    vF = (sf / d) * dir;
end

dydt = [
    vF(1);
    vF(2);
    sf;
    sr;
];
end
