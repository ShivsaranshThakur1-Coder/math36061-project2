function blocked = is_line_of_sight_blocked(F, R, cfg)
%IS_LINE_OF_SIGHT_BLOCKED True if fence AE blocks line of sight F->R.
%
%   blocked = IS_LINE_OF_SIGHT_BLOCKED(F, R, cfg) returns true if the line
%   segment from fox position F (1x2) to rabbit position R (1x2) intersects
%   the fence segment from cfg.A to cfg.E.

blocked = is_segment_blocking(F, R, cfg.A, cfg.E);
end
