classdef TestFoxOdeConstant < matlab.unittest.TestCase
    %TESTFOXODECONSTANT Tests for constant-speed fox ODE and burrow event.

    methods (Test)
        function testBurrowEventAtCorrectTime(testCase)
            cfg = fox_rabbit_config();

            y0 = cfg.F0(:);
            phase = 1;

            odefun = @(t, y) fox_rabbit_ode_const(t, y, cfg, phase);
            eventfun = @(t, y) fox_rabbit_events_const(t, y, cfg, phase);

            opts = odeset('Events', eventfun, ...
                          'RelTol', 1e-8, ...
                          'AbsTol', 1e-10);

            tspan = [0, cfg.time_to_burrow * 2];

            [t, y, te, ye, ie] = ode45(odefun, tspan, y0, opts); %#ok<ASGLU>

            testCase.verifyGreaterThanOrEqual(numel(te), 1);

            testCase.verifyTrue(any(ie == 2), ...
                'Expected a burrow event (index 2) but none was found.');

            te_burrow = te(find(ie == 2, 1, 'first'));
            testCase.verifyEqual(te_burrow, cfg.time_to_burrow, 'AbsTol', 1e-2);
        end
    end
end
