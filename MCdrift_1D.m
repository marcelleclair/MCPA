function MCdrift_1D(n_particles)

% initial conditions
%m = 9.109e-13; % electron rest mass (kg)
m = ones(1,n_particles);
x = zeros(1,n_particles);
v = zeros(1,n_particles);
vd = v; % drift velocities of each particle
vd_total = mean(vd); % average drift velocity of all particles
F = 1;
t = 0;
t_max = 1;
n = 1; % number of itterations
dt = 1e-3;

% P = 0.05; % probability of scattering
tau = 0.02;
P = 1 - exp(-dt / tau);
re = 0;


% figures
fig = tiledlayout(2,1);
ax_x = nexttile;
ylabel(ax_x, "Position (m)");
hold(ax_x, 'on');
ax_v = nexttile;
ylabel(ax_v, "Velocity (m/s)");
xlabel(ax_v, "Time (s)");
hold(ax_v, 'on');

while t < t_max
    % update plot
    fprintf("time = %3.3E s / %3.3E s\n", t, t_max);
    plot(ax_x, t, x, '.r');
    title(fig, "Drift Velocity = " + vd_total + "m/s");
    plot(ax_v, t, v, '.b');
    plot(ax_v, t, vd_total, 'og');
    pause(0.01);
    % advance clock
    t = t + dt;
    n = n + 1;
    % compute new position by VE
    % velocity calculation assumes constant accelleration over time
    x = x + (v .* dt) + (0.5 .* F .* (dt ^ 2) ./ m);
    sc = rand(1,n_particles) < P;
    v = (sc .* v .* re) + (~sc .* (v + (dt .* F ./ m)));
%     % original method, only works for one particle
%     if rand() < P
%         v = v*re;
%     else
%         v = v + (dt .* F ./ m);
%     end
    vd = vd + (v - vd)./n;
    vd_total = mean(vd);
end

end