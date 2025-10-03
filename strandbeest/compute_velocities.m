% Computes the theta derivatives of each vertex coordinate for the Jansen
% using an implicit method
% 
% INPUTS:
% vertex_coords: a column vector containing the (x,y) coordinates of every vertex
% these are assumed to be legal values that are roots of the error funcs!
% leg_params: a struct containing the parameters that describe the linkage
% theta: the current angle of the crank
% 
% OUTPUTS:
% dVdtheta: a column vector containing the theta derivates of each vertex coord
function dVdtheta = compute_velocities(vertex_coords, leg_params, theta)
    
    % function handle to pass into approximate_jacobian()
    error_vec_fun = @(x) link_length_error_func(x, leg_params);
    
    % approximates Jacobian for the linkage error function 
    approx_J = approximate_jacobian(error_vec_fun, vertex_coords);
    
    % initialize derivatives for x1, y1, x2, y2 constraints
    dx1dtheta = -leg_params.crank_length * sin(theta);
    dy1dtheta = leg_params.crank_length * cos(theta);
    dx2dtheta = 0;
    dy2dtheta = 0;
    
    % structure B vector and M matrix
    B_top = [dx1dtheta; dy1dtheta; dx2dtheta; dy2dtheta];
    B_bottom = zeros(10, 1);
    M_top = [eye(4), zeros(4, 10)];
    M_bottom = approx_J;
    
    B = [B_top; B_bottom];
    M = [M_top; M_bottom];
    
    % solve for dVdtheta
    dVdtheta = M\B;
end