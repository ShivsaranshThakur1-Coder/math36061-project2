function blocked = is_segment_blocking(p1, p2, q1, q2)
%IS_SEGMENT_BLOCKING True if segment q1-q2 blocks line of sight between p1-p2.
%
%   blocked = IS_SEGMENT_BLOCKING(p1, p2, q1, q2) returns true if the segment
%   from q1 to q2 intersects the segment from p1 to p2. For this project we
%   treat any intersection of the closed segments as a "blockage".

[intersects, ~, ~] = segment_intersection(p1, p2, q1, q2);
blocked = intersects;
end
