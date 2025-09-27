function leg_drawing = update_leg_drawing(complete_vertex_coords, leg_drawing, leg_params)
    % Convert vertex coordinate vector into nx2 matrix
    complete_vertex_coords = column_to_matrix(complete_vertex_coords);
    
    % --------- Update link lines ---------
    for linkage_idx = 1:leg_params.num_linkages
        a_idx = leg_params.link_to_vertex_list(linkage_idx, 1);
        b_idx = leg_params.link_to_vertex_list(linkage_idx, 2);
        line_x = [complete_vertex_coords(a_idx, 1), complete_vertex_coords(b_idx, 1)];
        line_y = [complete_vertex_coords(a_idx, 2), complete_vertex_coords(b_idx, 2)];
        set(leg_drawing.linkages{linkage_idx}, 'XData', line_x, 'YData', line_y);
    end
    
    % --------- Update vertices ---------
    for vertex_idx = 1:leg_params.num_vertices
        dot_x = complete_vertex_coords(vertex_idx, 1);
        dot_y = complete_vertex_coords(vertex_idx, 2);
        set(leg_drawing.vertices{vertex_idx}, 'XData', dot_x, 'YData', dot_y);
    end
    
    % --------- Update crank ---------
    crank_x = [leg_params.vertex_pos0(1), complete_vertex_coords(1, 1)];
    crank_y = [leg_params.vertex_pos0(2), complete_vertex_coords(1, 2)];
    set(leg_drawing.crank, 'XData', crank_x, 'YData', crank_y);
    
    % --------- Plot trajectory of vertex #7 (leg) ---------
    leg_drawing.leg_traj.x(end+1) = complete_vertex_coords(7,1);
    leg_drawing.leg_traj.y(end+1) = complete_vertex_coords(7,2);
    set(leg_drawing.leg_traj.h, ...
        'XData', leg_drawing.leg_traj.x, ...
        'YData', leg_drawing.leg_traj.y);
end
