function export_all_figures()
%EXPORT_ALL_FIGURES Regenerate all figures used in the report.

addpath('src');

cfg = fox_rabbit_config(); %#ok<NASGU>

plot_constant_case();
print('-dpng','docs/constant_case_paths.png');
close;

plot_variable_case();
print('-dpng','docs/variable_case_paths.png');
close;
end
