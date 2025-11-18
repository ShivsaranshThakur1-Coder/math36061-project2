classdef TestVariableSpeeds < matlab.unittest.TestCase
    %TESTVARIABLESPEEDS Unit tests for variable-speed functions.

    methods (Test)
        function testFoxSpeedDecay(testCase)
            cfg = fox_rabbit_config();
            df = [0, 1000];
            sf = fox_speed_var(df, cfg);

            testCase.verifyEqual(sf(1), cfg.sf0, 'AbsTol', 1e-12);
            testCase.verifyLessThan(sf(2), cfg.sf0);
        end

        function testRabbitSpeedDecay(testCase)
            cfg = fox_rabbit_config();
            dr = [0, 1000];
            sr = rabbit_speed_var(dr, cfg);

            testCase.verifyEqual(sr(1), cfg.sr0, 'AbsTol', 1e-12);
            testCase.verifyLessThan(sr(2), cfg.sr0);
        end

        function testRabbitPositionFromDistance(testCase)
            cfg = fox_rabbit_config();

            dr0 = 0;
            [x0, y0, theta0] = rabbit_position_from_distance(dr0, cfg);
            testCase.verifyEqual(theta0, 0, 'AbsTol', 1e-12);
            testCase.verifyEqual(x0, 0, 'AbsTol', 1e-9);
            testCase.verifyEqual(y0, cfg.r_circle, 'AbsTol', 1e-9);

            drB = cfg.arc_length_to_burrow;
            [xB, yB, thetaB] = rabbit_position_from_distance(drB, cfg);
            expected = cfg.burrow;
            testCase.verifyEqual(thetaB, cfg.theta_burrow, 'AbsTol', 1e-9);
            testCase.verifyEqual([xB, yB], expected, 'AbsTol', 1e-6);

            dr_after = 2 * cfg.arc_length_to_burrow;
            [xA, yA, thetaA] = rabbit_position_from_distance(dr_after, cfg);
            testCase.verifyEqual(thetaA, cfg.theta_burrow, 'AbsTol', 1e-9);
            testCase.verifyEqual([xA, yA], expected, 'AbsTol', 1e-6);
        end
    end
end
