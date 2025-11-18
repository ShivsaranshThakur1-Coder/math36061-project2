function plot_constant_case()
%PLOT_CONSTANT_CASE Plot fox and rabbit paths for the constant-speed case.

addpath('src');
cfg = fox_rabbit_config();
result = simulate_constant_case();

t = result.t;
F = result.F;
R = result.R;

figure;
plot(F(:,1), F(:,2), 'b-', 'LineWidth', 1.5); hold on;
plot(R(:,1), R(:,2), 'r--', 'LineWidth', 1.5);

theta = linspace(0, 2*pi, 400);
xc = cfg.r_circle * sin(theta);
yc = cfg.r_circle * cos(theta);
plot(xc, yc, 'k:', 'LineWidth', 1);

plot(cfg.G(1), cfg.G(2), 'go', 'MarkerFaceColor', 'g');
plot(cfg.A(1), cfg.A(2), 'ko', 'MarkerFaceColor', 'k');
plot(cfg.E(1), cfg.E(2), 'ko', 'MarkerFaceColor', 'k');
plot(cfg.burrow(1), cfg.burrow(2), 'ro', 'MarkerFaceColor', 'r');

line([cfg.A(1), cfg.E(1)], [cfg.A(2), cfg.E(2)], 'Color', 'k', 'LineStyle', '-', 'LineWidth', 1);

axis equal;
xlabel('x (m)');
ylabel('y (m)');
legend({'Fox', 'Rabbit', 'Fence circle', 'Gap G', 'Fence A,E', 'Burrow'}, ...
       'Location', 'best');
title('Constant-speed fox–rabbit chase');
grid on;
end
