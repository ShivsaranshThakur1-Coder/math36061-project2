function profile_simulations()
%PROFILE_SIMULATIONS Simple profiling of constant and variable cases.

addpath('src');

fprintf('--- Profiling constant-speed case ---\n');
tic;
res_const = simulate_constant_case();
t_const = toc;
fprintf('Constant case: T = %.6f s, fox_distance = %.3f m, steps = %d\n', ...
    res_const.T, res_const.fox_distance, numel(res_const.t));

fprintf('--- Profiling variable-speed case ---\n');
tic;
res_var = simulate_variable_case();
t_var = toc;
fprintf('Variable case: T = %.6f s, fox_distance = %.3f m, steps = %d\n', ...
    res_var.T, res_var.fox_distance, numel(res_var.t));

fprintf('Runtime: constant = %.3f s, variable = %.3f s\n', t_const, t_var);
end
