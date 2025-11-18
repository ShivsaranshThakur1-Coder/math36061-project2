classdef TestFoxVelocity < matlab.unittest.TestCase
    %TESTFOXVELOCITY Unit tests for fox_velocity_const.

    methods (Test)
        function testVelocityMagnitudePhase1(testCase)
            cfg = fox_rabbit_config();

            F = cfg.F0;
            R = cfg.R0;
            phase = 1;

            v = fox_velocity_const(F, R, cfg, phase);

            speed = norm(v);
            testCase.verifyEqual(speed, cfg.sf, 'RelTol', 1e-12);
        end

        function testVelocityDirectionTowardsGInPhase1(testCase)
            cfg = fox_rabbit_config();

            F = cfg.F0;
            R = cfg.R0;
            phase = 1;

            v = fox_velocity_const(F, R, cfg, phase);
            T = cfg.G;

            dir_expected = T - F;
            dir_expected = dir_expected / norm(dir_expected);

            dir_actual = v / norm(v);

            testCase.verifyEqual(dir_actual, dir_expected, 'AbsTol', 1e-12);
        end

        function testZeroVelocityAtTarget(testCase)
            cfg = fox_rabbit_config();

            % Phase 1 target is cfg.G, so place fox at G.
            F = cfg.G;
            R = cfg.R0;
            phase = 1;

            v = fox_velocity_const(F, R, cfg, phase);

            testCase.verifyEqual(v, [0, 0], 'AbsTol', 1e-12);
        end

        function testVelocityPhase2TowardsRabbitWhenVisible(testCase)
            cfg = fox_rabbit_config();

            % Use a configuration where rabbit is visible (no blocking by AE).
            F = [-100, 0];
            R = [-100, 600];
            phase = 2;

            v = fox_velocity_const(F, R, cfg, phase);

            dir_actual = v / norm(v);
            dir_expected = (R - F) / norm(R - F);

            testCase.verifyEqual(dir_actual, dir_expected, 'AbsTol', 1e-12);
            testCase.verifyEqual(norm(v), cfg.sf, 'RelTol', 1e-12);
        end
    end
end
