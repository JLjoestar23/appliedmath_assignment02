%% Testing Multivariate Newton's Method

fun = @test_function02;
x0 = [1; 10; 5];

% testing with numerically computed Jacobian
solver_params.approx_j = 1;
root_approx_num_j = multivariate_newton_solver(fun, x0, solver_params);

% testing with analytically computed jacobian
solver_params.approx_j = 0;
root_approx_ana_j = multivariate_newton_solver(fun, x0, solver_params);

%% Trajectory Test Problem



%projectile motion function
%theta is angle projectile is fired at (in radians)
%t is time in seconds
function V_p = projectile_traj(theta,t)
    g = 2.3; %gravity in m/sˆ2
    v0 = 14; %initial speed in m/s
    px0 = 2; %initial x position
    py0 = 4; %initial y position
    %compute position vector
    V_p = [v0*cos(theta)*t+px0; -.5*g*t.^2+v0*sin(theta)*t+py0];
end