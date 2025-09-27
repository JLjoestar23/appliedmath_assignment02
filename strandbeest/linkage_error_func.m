%% Error function that encodes all necessary linkage constraints
% 
% INPUTS:
% vertex_coords: a column vector containing the (x,y) coordinates of every vertex
% leg_params: a struct containing the parameters that describe the linkage
% theta: the current angle of the crank
% 
% OUTPUTS:
% error_vec: a vector describing each constraint on the linkage
% when error_vec is all zeros, the constraints are satisfied
function error_vec = linkage_error_func(vertex_coords, leg_params, theta)

    % enforce linkage distance constraints
    length_errors = link_length_error_func(vertex_coords, leg_params);
    % enforce fixed vertex constraints
    coord_errors = fixed_coord_error_func(vertex_coords, leg_params, theta);
    
    error_vec = [length_errors; coord_errors];
end

%% Error function that encodes the link length constraints
% 
% INPUTS:
% vertex_coords: a column vector containing the (x,y) coordinates pairs of 
% every vertex in the linkage. 
% 
% leg_params: a struct containing the parameters that describe the linkage
% importantly, leg_params.link_lengths is a list of linkage lengths
% and leg_params.link_to_vertex_list is a two column matrix where
% leg_params.link_to_vertex_list(i,1) and
% leg_params.link_to_vertex_list(i,2) are the pair of vertices connected
% by the ith link in the mechanism
% 
% OUTPUTS:
% length_errors: a column vector describing the current distance error of
% the ith link: length_errors(i) = (xb-xa)ˆ2 + (yb-ya)ˆ2 - d_iˆ2
% where (xa,ya) and (xb,yb) are the coordinates of the vertices that
% are connected by the ith link, and d_i is the length of the ith link
function length_errors = link_length_error_func(vertex_coords, leg_params)
    
    % converting from column vector to nx2 matrix
    vertex_coords = column_to_matrix(vertex_coords);

    % initialize empty column vector half the size of vertex_coords
    length_errors = zeros(leg_params.num_linkages, 1);

    for i=1:leg_params.num_linkages

        % gets vertex index from the vertex adjacency list
        a_idx = leg_params.link_to_vertex_list(i, 1);
        b_idx = leg_params.link_to_vertex_list(i, 2);
        
        % assigning values
        xa = vertex_coords(a_idx, 1);
        ya = vertex_coords(a_idx, 2);
        xb = vertex_coords(b_idx, 1);
        yb = vertex_coords(b_idx, 2);
        di = leg_params.link_lengths(i);
        
        % populating the column vector
        length_errors(i) = (xb - xa)^2 + (yb - ya)^2 - di^2;
    end
end

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