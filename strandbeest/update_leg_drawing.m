function leg_drawing = update_leg_drawing(complete_vertex_coords, leg_vel, leg_drawing, leg_params)
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
    trail_length = 50;

    leg_drawing.leg_traj.x(end+1) = complete_vertex_coords(7,1);
    leg_drawing.leg_traj.y(end+1) = complete_vertex_coords(7,2);

    % Keep only the most recent 'trail_length' points
    if numel(leg_drawing.leg_traj.x) > trail_length
        leg_drawing.leg_traj.x = leg_drawing.leg_traj.x(end-trail_length+1:end);
        leg_drawing.leg_traj.y = leg_drawing.leg_traj.y(end-trail_length+1:end);
    end

    set(leg_drawing.leg_traj.h, ...
        'XData', leg_drawing.leg_traj.x, ...
        'YData', leg_drawing.leg_traj.y);

    % --------- Plot velocity vector of vertex #7 (leg) ---------
    scale = 2;
    leg_drawing.leg_vel.x = leg_vel(1);
    leg_drawing.leg_vel.y = leg_vel(2);
    set(leg_drawing.leg_vel.h, ...
        'XData', complete_vertex_coords(7,1), ...
        'YData', complete_vertex_coords(7,2), ...
        'UData', scale * leg_drawing.leg_vel.x, ...
        'VData', scale * leg_drawing.leg_vel.y);
end
