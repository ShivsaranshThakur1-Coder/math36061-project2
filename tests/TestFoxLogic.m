classdef TestFoxLogic < matlab.unittest.TestCase
    %TESTFOXLOGIC Unit tests for fox line-of-sight and target selection.

    methods (Test)
        function testLineOfSightBlockedByAE(testCase)
            cfg = fox_rabbit_config();

            % Choose F and R such that the segment FR intersects AE.
            % Here we use F below and R at A, so the segment meets AE at A.
            F = [cfg.A(1), 0];      % x-coordinate aligned with A, y below
            R = cfg.A;              % at A itself

            blocked = is_line_of_sight_blocked(F, R, cfg);

            testCase.verifyTrue(blocked);
        end

        function testLineOfSightNotBlockedByAE(testCase)
            cfg = fox_rabbit_config();

            % Choose F and R well to the left of AE so FR does not cross AE.
            F = [-100, 0];
            R = [-100, 600];

            blocked = is_line_of_sight_blocked(F, R, cfg);

            testCase.verifyFalse(blocked);
        end

        function testTargetPhase1IsGap(testCase)
            cfg = fox_rabbit_config();

            F = cfg.F0;
            R = cfg.R0;

            T = fox_target_point(F, R, cfg, 1);

            testCase.verifyEqual(T, cfg.G, 'AbsTol', 1e-9);
        end

        function testTargetPhase2VisibleRabbit(testCase)
            cfg = fox_rabbit_config();

            % Put fox and rabbit vertically aligned far to the left of AE.
            F = [-100, 0];
            R = [-100, 600];

            T = fox_target_point(F, R, cfg, 2);

            testCase.verifyEqual(T, R, 'AbsTol', 1e-9);
        end

        function testTargetPhase2BlockedGoesToA(testCase)
            cfg = fox_rabbit_config();

            % Use the same configuration as the blocked case.
            F = [cfg.A(1), 0];
            R = cfg.A;

            T = fox_target_point(F, R, cfg, 2);

            testCase.verifyEqual(T, cfg.A, 'AbsTol', 1e-9);
        end
    end
end
