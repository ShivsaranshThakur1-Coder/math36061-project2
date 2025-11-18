function cfg = fox_rabbit_config()
%FOX_RABBIT_CONFIG Configuration for MATH36031 Project 2 (constant-speed case).
%
%   cfg = FOX_RABBIT_CONFIG() returns a struct with geometric parameters and
%   speeds for the fox–rabbit chase problem in Project 2.

cfg = struct();

% Speeds (m/s)
cfg.sf = 16.0;  % fox speed
cfg.sr = 13.0;  % rabbit speed

% Geometry
cfg.r_circle = 800.0;       % radius of circular fence (m)
cfg.theta_burrow = pi/3;    % burrow angle in radians (x = r sin theta, y = r cos theta)

% Key points
cfg.F0 = [0.0, 0.0];                     % initial fox position
cfg.R0 = [0.0, cfg.r_circle];            % initial rabbit position (0, 800)
cfg.burrow = cfg.r_circle * [sin(cfg.theta_burrow), cos(cfg.theta_burrow)];
cfg.G = [0.0, 300.0];                    % gap G coordinates
cfg.A = [380.0, 600.0];                  % fence point A
cfg.E = [450.0, 320.0];                  % fence point E

% Capture tolerance (m)
cfg.capture_tol = 0.1;

% Derived quantities
cfg.arc_length_to_burrow = cfg.r_circle * cfg.theta_burrow;
cfg.time_to_burrow = cfg.arc_length_to_burrow / cfg.sr;
end
