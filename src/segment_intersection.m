function [intersects, t, u] = segment_intersection(p1, p2, q1, q2)
%SEGMENT_INTERSECTION Check intersection of two line segments in 2D.
%
%   [intersects, t, u] = SEGMENT_INTERSECTION(p1, p2, q1, q2) checks whether
%   the segment from p1 to p2 intersects the segment from q1 to q2.
%
%   Inputs:
%       p1, p2, q1, q2 : 1x2 vectors [x, y].
%
%   Outputs:
%       intersects : logical scalar, true if the closed segments intersect.
%       t, u       : parametric coordinates along each segment such that
%                    p(t) = p1 + t*(p2 - p1)
%                    q(u) = q1 + u*(q2 - q1)
%                    at the intersection point, when intersects is true.

r = p2 - p1;
s = q2 - q1;

den = r(1) * s(2) - r(2) * s(1);

% Parallel or nearly parallel: treat as non-intersecting for this project.
if abs(den) < 1e-12
    intersects = false;
    t = NaN;
    u = NaN;
    return;
end

qp = q1 - p1;

t = (qp(1) * s(2) - qp(2) * s(1)) / den;
u = (qp(1) * r(2) - qp(2) * r(1)) / den;

intersects = (t >= 0) && (t <= 1) && (u >= 0) && (u <= 1);
end
