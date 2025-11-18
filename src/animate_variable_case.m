function animate_variable_case()
%ANIMATE_VARIABLE_CASE Create an animation for the variable-speed case.

addpath('src');
cfg = fox_rabbit_config();
res = simulate_variable_case();

t = res.t;
F = res.F;
R = res.R;

N = numel(t);
maxFrames = 400;
step = max(1, floor(N / maxFrames));
idx = 1:step:N;

theta = linspace(0, 2*pi, 400);
xc = cfg.r_circle * sin(theta);
yc = cfg.r_circle * cos(theta);

v = VideoWriter('docs/variable_case_animation.mp4','MPEG-4');
v.FrameRate = 30;
open(v);

fig = figure('Visible','off');
for k = idx
    clf;
    plot(xc, yc, 'k:'); hold on;
    plot(cfg.G(1), cfg.G(2), 'go', 'MarkerFaceColor','g');
    plot(cfg.A(1), cfg.A(2), 'ko', 'MarkerFaceColor','k');
    plot(cfg.E(1), cfg.E(2), 'ko', 'MarkerFaceColor','k');
    plot(cfg.burrow(1), cfg.burrow(2), 'ro', 'MarkerFaceColor','r');
    line([cfg.A(1), cfg.E(1)], [cfg.A(2), cfg.E(2)], 'Color','k','LineWidth',1);

    plot(F(1:k,1), F(1:k,2), 'b-');
    plot(R(1:k,1), R(1:k,2), 'r--');
    plot(F(k,1), F(k,2), 'bo', 'MarkerFaceColor','b');
    plot(R(k,1), R(k,2), 'ro', 'MarkerFaceColor','r');

    axis equal;
    xlabel('x (m)'); ylabel('y (m)');
    title(sprintf('Variable-speed chase, t = %.2f s', t(k)));
    xlim([-900,900]); ylim([-900,900]);
    grid on;

    frame = getframe(fig);
    writeVideo(v, frame);
end

close(v);
close(fig);
end
