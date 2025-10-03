% Computes the theta derivatives of each vertex coordinate for the Jansen
% linkage using finite differences method
% 
% INPUTS:
% vertex_coords: a column vector containing the (x,y) coordinates of every vertex
% these are assumed to be legal values that are roots of the error funcs!
% leg_params: a struct containing the parameters that describe the linkage
% theta: the current angle of the crank
% 
% OUTPUTS:
% dVdtheta: a column vector containing the theta derivates of each vertex coord
function dVdtheta = finite_differences_compute_velocity(vertex_coords, leg_params, theta)
    % finite difference step
    h = 1e-6;
    
    % evaluating the vertex coords at each end of the finite difference
    vertex_coords_next = compute_coords(vertex_coords, leg_params, theta + h/2);
    vertex_coords_prev = compute_coords(vertex_coords, leg_params, theta - h/2);
    
    % calculating dVdtheta
    dVdtheta = (vertex_coords_next - vertex_coords_prev) / h;
end