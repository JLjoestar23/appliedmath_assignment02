%% Error function that encodes the fixed vertex constraints
% INPUTS:
% vertex_coords: a column vector containing the (x,y) coordinates pairs of 
% every vertex in the linkage. 
%
% leg_params: a struct containing the parameters that describe the linkage
% importantly, leg_params.crank_length is the length of the crank
% and leg_params.vertex_pos0 and leg_params.vertex_pos2 are the
% fixed positions of the crank rotation center and vertex 2.
% theta: the current angle of the crank
%
% OUTPUTS:
% coord_errors: a column vector of height four corresponding to the differences
% between the current values of (x1,y1),(x2,y2) and
% the fixed values that they should be
function coord_errors = fixed_coord_error_func(vertex_coords, leg_params, theta)
    
    x1 = vertex_coords(1);
    y1 = vertex_coords(2);
    x2 = vertex_coords(3);
    y2 = vertex_coords(4);

    x1_correct = leg_params.crank_length * cos(theta);
    y1_correct = leg_params.crank_length * sin(theta);
    x2_correct = leg_params.vertex_pos2(1);
    y2_correct = leg_params.vertex_pos2(2);
    
    coord_errors = [x1; y1; x2; y2] - [x1_correct; y1_correct; x2_correct; y2_correct];
end