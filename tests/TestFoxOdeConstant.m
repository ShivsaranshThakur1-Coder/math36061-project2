classdef TestFoxOdeConstant < matlab.unittest.TestCase
    %TESTFOXODECONSTANT Tests for constant-speed fox ODE and events.

    methods (Test)
        function testReachGapEventAtCorrectTime(testCase)
            cfg = fox_rabbit_config();

            y0 = cfg.F0(:);
            phase = 1;

            odefun = @(t, y) fox_rabbit_ode_const(t, y, cfg, phase);
            eventfun = @(t, y) fox_rabbit_events_const(t, y, cfg, phase);

            opts = odeset('Events', eventfun, ...
                          'RelTol', 1e-8, ...
                          'AbsTol', 1e-10);

            tspan = [0, 100];

            [t, y, te, ye, ie] = ode45(odefun, tspan, y0, opts); %#ok<ASGLU>

            testCase.verifyGreaterThanOrEqual(numel(te), 1);
            testCase.verifyEqual(ie(end), 3);

            expected_time_to_G = norm(cfg.G - cfg.F0) / cfg.sf;
            testCase.verifyEqual(te(end), expected_time_to_G, 'AbsTol', 1e-2);
        end
    end
end
