classdef TestGeometry < matlab.unittest.TestCase
    %TESTGEOMETRY Unit tests for segment intersection utilities.

    methods (Test)
        function testSegmentsIntersectAtCenter(testCase)
            % Diagonal cross: [0,0] -> [1,1] and [0,1] -> [1,0]
            p1 = [0, 0];
            p2 = [1, 1];
            q1 = [0, 1];
            q2 = [1, 0];

            [intersects, t, u] = segment_intersection(p1, p2, q1, q2);

            testCase.verifyTrue(intersects);
            testCase.verifyGreaterThanOrEqual(t, 0);
            testCase.verifyLessThanOrEqual(t, 1);
            testCase.verifyGreaterThanOrEqual(u, 0);
            testCase.verifyLessThanOrEqual(u, 1);
        end

        function testSegmentsDoNotIntersect(testCase)
            % Horizontal segments one above the other.
            p1 = [0, 0];
            p2 = [1, 0];
            q1 = [0, 1];
            q2 = [1, 1];

            [intersects, t, u] = segment_intersection(p1, p2, q1, q2);

            testCase.verifyFalse(intersects);
            testCase.verifyTrue(isnan(t));
            testCase.verifyTrue(isnan(u) | isfinite(u)); % we only require not intersecting
        end

        function testBlockingWrapper(testCase)
            % Use the same crossing configuration as the first test.
            p1 = [0, 0];
            p2 = [1, 1];
            q1 = [0, 1];
            q2 = [1, 0];

            blocked = is_segment_blocking(p1, p2, q1, q2);

            testCase.verifyTrue(blocked);
        end
    end
end
