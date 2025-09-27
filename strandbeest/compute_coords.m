%Computes the vertex coordinates that describe a legal linkage configuration
%INPUTS:
%vertex_coords_guess: a column vector containing the (x,y) coordinates of every vertex
% these coords are just a GUESS! It's used to seed Newton's method
%leg_params: a struct containing the parameters that describe the linkage
%theta: the desired angle of the crank
%OUTPUTS:
%vertex_coords_root: a column vector containing the (x,y) coordinates of every vertex
% these coords satisfy all the kinematic constraints!
function vertex_coords_root = compute_coords(vertex_coords_guess, leg_params, theta)
    
    error_vec_fun = @(x) linkage_error_func(x, leg_params, theta);
    
    solver_params.approx_j = 1;
    solver_params.dx_tol = 1e-13;
    solver_params.f_tol = 1e-13;

    vertex_coords_root = multivariate_newton_solver(error_vec_fun, vertex_coords_guess, solver_params);
end