classdef TestConstantScenario < matlab.unittest.TestCase
    %TESTCONSTANTSCENARIO Basic structural tests for simulate_constant_case.

    methods (Test)
        function testSimulationRunsAndShapesAreConsistent(testCase)
            cfg = fox_rabbit_config();

            result = simulate_constant_case();

            testCase.verifyGreaterThan(result.T, 0);
            testCase.verifyLessThanOrEqual(result.T, 2 * cfg.time_to_burrow);

            testCase.verifySize(result.fox_pos_T, [1, 2]);

            testCase.verifyEqual(size(result.F, 1), numel(result.t));
            testCase.verifyEqual(size(result.R, 1), numel(result.t));

            testCase.verifyEqual(size(result.F, 2), 2);
            testCase.verifyEqual(size(result.R, 2), 2);
        end
    end
end
