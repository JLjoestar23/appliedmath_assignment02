function V_dist = collision_func(x)
    theta = x(1);
    t = x(2);
    
    V_t = target_traj(t);
    V_p = projectile_traj(theta, t);

    V_dist = V_t - V_p;
end