function sr = rabbit_speed_var(dr, cfg)
%RABBIT_SPEED_VAR Rabbit speed as a function of distance travelled (Question 2).
%
%   sr = RABBIT_SPEED_VAR(dr, cfg) returns the rabbit speed for cumulative
%   distance dr using sr(dr) = sr0 * exp(-mu_r * dr).

sr = cfg.sr0 .* exp(-cfg.mu_r .* dr);
end
