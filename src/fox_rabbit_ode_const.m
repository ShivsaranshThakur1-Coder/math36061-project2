function dydt = fox_rabbit_ode_const(t, y, cfg, phase)
%FOX_RABBIT_ODE_CONST Fox ODE for the constant-speed chase.
%
%   dydt = FOX_RABBIT_ODE_CONST(t, y, cfg, phase) returns the time
%   derivative of the fox state y at time t, for the constant-speed case.
%
%   State y:
%       y(1) = Fx, y(2) = Fy : fox position coordinates.
%
%   The rabbit position R(t) is computed from t via RABBIT_POSITION_CONST.

Fx = y(1);
Fy = y(2);
F = [Fx, Fy];

[Rx, Ry] = rabbit_position_const(t, cfg);
R = [Rx, Ry];

v = fox_velocity_const(F, R, cfg, phase);

dydt = [v(1); v(2)];
end
