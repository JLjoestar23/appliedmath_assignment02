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