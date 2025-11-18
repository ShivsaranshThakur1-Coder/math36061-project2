function v = fox_velocity_const(F, R, cfg, phase)
%FOX_VELOCITY_CONST Fox velocity vector for the constant-speed case.
%
%   v = FOX_VELOCITY_CONST(F, R, cfg, phase) returns a 1x2 velocity vector
%   for the fox at position F given the rabbit position R, configuration
%   cfg (from FOX_RABBIT_CONFIG), and phase (see FOX_TARGET_POINT).
%
%   The fox:
%       - chooses a target point T via FOX_TARGET_POINT,
%       - runs directly towards T at speed cfg.sf,
%       - has zero velocity if F == T (within tolerance).

T = fox_target_point(F, R, cfg, phase);
dir = T - F;
d = norm(dir);

if d < 1e-12
    v = [0.0, 0.0];
else
    v = (cfg.sf / d) * dir;
end
end
