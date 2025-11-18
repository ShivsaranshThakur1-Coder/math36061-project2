function sf = fox_speed_var(df, cfg)
%FOX_SPEED_VAR Fox speed as a function of distance travelled (Question 2).
%
%   sf = FOX_SPEED_VAR(df, cfg) returns the fox speed for cumulative distance
%   df using sf(df) = sf0 * exp(-mu_f * df).

sf = cfg.sf0 .* exp(-cfg.mu_f .* df);
end
