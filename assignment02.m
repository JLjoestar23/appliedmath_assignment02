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

% setup function handle
V_dist = @(x) collision_func(x);

% initialize solver params
solver_params.approx_j = 1;

% initial guess
x0 = [pi/6, 3];

% find roots to the problem
solution = multivariate_newton_solver(V_dist, x0, solver_params);

% visualize simulation
theta_i = solution(1);
t_c = solution(2);
run_simulation(theta_i, t_c);