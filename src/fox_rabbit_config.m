function cfg = fox_rabbit_config()
%FOX_RABBIT_CONFIG Configuration for MATH36031 Project 2.
%
%   cfg = FOX_RABBIT_CONFIG() returns a struct with geometric parameters,
%   speeds and decay parameters for the fox–rabbit chase problem.

cfg = struct();

% Constant speeds used in Question 1
cfg.sf = 16.0;  % fox speed (m/s)
cfg.sr = 13.0;  % rabbit speed (m/s)

% Initial speeds for diminishing-speed case (Question 2)
cfg.sf0 = cfg.sf;   % initial fox speed
cfg.sr0 = cfg.sr;   % initial rabbit speed

% Decay parameters for diminishing-speed case (Question 2)
cfg.mu_f = 0.0002;
cfg.mu_r = 0.0008;

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

% Derived quantities for rabbit motion along the circle
cfg.arc_length_to_burrow = cfg.r_circle * cfg.theta_burrow;
cfg.time_to_burrow = cfg.arc_length_to_burrow / cfg.sr;
end
