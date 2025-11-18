function convergence_study()
%CONVERGENCE_STUDY Simple tolerance study for the constant-speed case.
%
%   CONVERGENCE_STUDY() runs SIMULATE_CONSTANT_CASE_TOL for several pairs of
%   (RelTol, AbsTol) and prints the resulting terminal time and fox distance,
%   together with errors relative to a tight-reference run.

addpath('src');

cfg = fox_rabbit_config(); %#ok<NASGU>

relTols = [1e-6, 1e-8, 1e-10];
absTols = [1e-8, 1e-10, 1e-12];

relTol_ref = relTols(end);
absTol_ref = absTols(end);

res_ref = simulate_constant_case_tol(relTol_ref, absTol_ref);
T_ref = res_ref.T;
df_ref = res_ref.fox_distance;
steps_ref = numel(res_ref.t);

fprintf('Reference (RelTol = %.1e, AbsTol = %.1e): T = %.8f, d_f = %.6f, steps = %d\n', ...
    relTol_ref, absTol_ref, T_ref, df_ref, steps_ref);
fprintf('\n');
fprintf('%12s %12s %14s %14s %10s %14s %14s\n', ...
    'RelTol', 'AbsTol', 'T', 'd_f', 'steps', '|T - T_ref|', '|d_f - d_f_ref|');
fprintf('%s\n', repmat('-', 1, 96));

for k = 1:numel(relTols)
    rt = relTols(k);
    at = absTols(k);

    res = simulate_constant_case_tol(rt, at);
    T = res.T;
    df = res.fox_distance;
    steps = numel(res.t);

    errT = abs(T - T_ref);
    errDf = abs(df - df_ref);

    fprintf('%12.1e %12.1e %14.8f %14.6f %10d %14.6e %14.6e\n', ...
        rt, at, T, df, steps, errT, errDf);
end
end
