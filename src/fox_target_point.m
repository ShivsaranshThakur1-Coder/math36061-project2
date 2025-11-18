function T = fox_target_point(F, R, cfg, phase)
%FOX_TARGET_POINT Compute current target point for the fox.
%
%   T = FOX_TARGET_POINT(F, R, cfg, phase) returns a 1x2 vector T giving the
%   point towards which the fox should run at the current time, given:
%       F     : current fox position [x, y]
%       R     : current rabbit position [x, y]
%       cfg   : configuration struct from FOX_RABBIT_CONFIG
%       phase : integer phase indicator
%
%   Phases for the constant-speed problem:
%       phase = 1 : Fox runs straight from F0 to the gap G, ignoring rabbit.
%       phase = 2 : Fox has passed G; if line-of-sight to the rabbit is not
%                   blocked by fence AE, target the rabbit. Otherwise target A.

arguments
    F (1,2) double
    R (1,2) double
    cfg struct
    phase (1,1) double {mustBeInteger}
end

switch phase
    case 1
        % Run towards gap G
        T = cfg.G;

    case 2
        % After reaching G: go for rabbit if visible, otherwise go to A
        if is_line_of_sight_blocked(F, R, cfg)
            T = cfg.A;
        else
            T = R;
        end

    otherwise
        error('fox_target_point:InvalidPhase', ...
              'Unsupported phase value: %d', phase);
end
end
