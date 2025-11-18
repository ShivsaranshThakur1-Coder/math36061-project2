classdef TestRabbitMotion < matlab.unittest.TestCase
    %TESTRABBITMOTION Unit tests for rabbit motion on circular fence.

    methods (Test)
        function testInitialPosition(testCase)
            cfg = fox_rabbit_config();
            t0 = 0;
            [x, y, theta] = rabbit_position_const(t0, cfg);

            testCase.verifyEqual(theta, 0, 'AbsTol', 1e-12);
            testCase.verifyEqual(x, 0, 'AbsTol', 1e-9);
            testCase.verifyEqual(y, cfg.r_circle, 'AbsTol', 1e-9);
        end

        function testBurrowPositionAtTimeToBurrow(testCase)
            cfg = fox_rabbit_config();
            tB = cfg.time_to_burrow;

            [x, y, theta] = rabbit_position_const(tB, cfg);

            testCase.verifyEqual(theta, cfg.theta_burrow, 'AbsTol', 1e-9);
            expected = cfg.burrow;
            testCase.verifyEqual([x, y], expected, 'AbsTol', 1e-6);
        end

        function testClampingAfterBurrow(testCase)
            cfg = fox_rabbit_config();
            t_after = 2 * cfg.time_to_burrow;

            [x, y, theta] = rabbit_position_const(t_after, cfg);

            testCase.verifyEqual(theta, cfg.theta_burrow, 'AbsTol', 1e-9);
            expected = cfg.burrow;
            testCase.verifyEqual([x, y], expected, 'AbsTol', 1e-6);
        end

        function testVectorTimeInput(testCase)
            cfg = fox_rabbit_config();
            t = linspace(0, cfg.time_to_burrow, 5);
            [x, y, theta] = rabbit_position_const(t, cfg);

            testCase.verifySize(x, size(t));
            testCase.verifySize(y, size(t));
            testCase.verifySize(theta, size(t));

            testCase.verifyGreaterThanOrEqual(theta, 0);
            testCase.verifyLessThanOrEqual(theta, cfg.theta_burrow + 1e-12);
        end
    end
end
