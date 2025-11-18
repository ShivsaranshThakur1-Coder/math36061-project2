classdef TestVariableScenario < matlab.unittest.TestCase
    %TESTVARIABLESCENARIO Structural tests for variable-speed simulation.

    methods (Test)
        function testSimulationRunsAndShapesAreConsistent(testCase)
            cfg = fox_rabbit_config();

            result = simulate_variable_case();

            testCase.verifyGreaterThan(result.T, 0);
            testCase.verifyLessThanOrEqual(result.T, 1e5);

            testCase.verifySize(result.fox_pos_T, [1, 2]);

            testCase.verifyEqual(size(result.F, 1), numel(result.t));
            testCase.verifyEqual(size(result.R, 1), numel(result.t));
            testCase.verifyEqual(size(result.df, 1), numel(result.t));
            testCase.verifyEqual(size(result.dr, 1), numel(result.t));

            testCase.verifyEqual(size(result.F, 2), 2);
            testCase.verifyEqual(size(result.R, 2), 2);

            testCase.verifyEqual(result.fox_distance, result.df(end), 'AbsTol', 1e-6);
            testCase.verifyEqual(result.rabbit_distance, result.dr(end), 'AbsTol', 1e-6);
        end

        function testVariableCaseSlowerThanConstantBurrowTime(testCase)
            cfg = fox_rabbit_config();
            const_burrow_time = cfg.time_to_burrow;

            result = simulate_variable_case();

            testCase.verifyGreaterThan(result.T, const_burrow_time);
        end
    end
end
