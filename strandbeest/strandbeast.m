% initialize leg_params structure
leg_params = struct();

% number of vertices in linkage
leg_params.num_vertices = 7;

% number of links in linkage
leg_params.num_linkages = 10;

% matrix relating links to vertices
leg_params.link_to_vertex_list = ...
[ 1, 3;... % link 1 adjacency
  3, 4;... % link 2 adjacency
  2, 3;... % link 3 adjacency
  2, 4;... % link 4 adjacency
  4, 5;... % link 5 adjacency
  2, 6;... % link 6 adjacency
  1, 6;... % link 7 adjacency
  5, 6;... % link 8 adjacency
  5, 7;... % link 9 adjacency
  6, 7 ... % link 10 adjacency
  ];

%list of lengths for each link in the leg mechanism
leg_params.link_lengths = ...
[ 50.0,... %link 1 length
  55.8,... %link 2 length
  41.5,... %link 3 length
  40.1,... %link 4 length
  39.4,... %link 5 length
  39.3,... %link 6 length
  61.9,... %link 7 length
  36.7,... %link 8 length
  65.7,... %link 9 length
  49.0 ... %link 10 length
  ];

%length of crank shaft
leg_params.crank_length = 15.0;

%fixed position coords of vertex 0
leg_params.vertex_pos0 = [0;0];

%fixed position coords of vertex 2
leg_params.vertex_pos2 = [-38.0;-7.8];

%% Testing

%column vector of initial guesses
%for each vertex location.
%in form: [x1;y1;x2;y2;...;xn;yn]
vertex_coords_guess = [...
[ 0; 50];... %vertex 1 guess
[ -50; 0];... %vertex 2 guess
[ -50; 50];... %vertex 3 guess
[-100; 0];... %vertex 4 guess
[-100; -50];... %vertex 5 guessclc
[ -50; -50];... %vertex 6 guess
[ -50; -100]... %vertex 7 guess
];

dt = 1/24; % targeting 24 fps
complete_rotations = 3; % 5 complete rotations
angular_vel = pi/2;
thetas = 0:angular_vel*dt:complete_rotations*2*pi; % initializing animation list

% if recording is enabled, initialize VideoWriter object
recording = 0;
if recording == 1
    v = VideoWriter('strandbeest_linkage_animation.mp4','MPEG-4');
    v.FrameRate = 1/dt; % match simulation dt for real-time
    open(v);
end

fig = figure('Color', 'w');
hold on;
axis equal;
xlim([-150, 50]);
ylim([-150, 50]);

ax = gca;
ax.XLimMode = 'manual';
ax.YLimMode = 'manual';

% initialize the relevant drawing data structures
leg_drawing = initialize_leg_drawing(leg_params);

for i=1:length(thetas)

    % compute vertex coordinates
    vertex_coords_root = compute_coords(vertex_coords_guess, leg_params, thetas(i));

    % compute vertex velocities
    dVdtheta = compute_velocities(vertex_coords_root, leg_params, thetas(i));
    
    % get x and y velocity components for the leg
    leg_vel_x = dVdtheta(13);
    leg_vel_y = dVdtheta(14);
    leg_vel = [leg_vel_x; leg_vel_y];
    
    % update guess to current root to ensure convergence next time step
    vertex_coords_guess = vertex_coords_root;
    
    % update drawing
    leg_drawing = update_leg_drawing(vertex_coords_root, leg_vel, leg_drawing, leg_params);

    drawnow;
    
    % capture frame and write to video
    if recording == 1
        frame = getframe(fig);
        writeVideo(v, frame);
    end

    pause(dt);
end

hold off;

if recording == 1
    close(v);
end

%% Plotting x and y leg velocities from theta = [0, 2pi]

%column vector of initial guesses
%for each vertex location.
%in form: [x1;y1;x2;y2;...;xn;yn]
vertex_coords_guess = [...
[ 0; 50];... %vertex 1 guess
[ -50; 0];... %vertex 2 guess
[ -50; 50];... %vertex 3 guess
[-100; 0];... %vertex 4 guess
[-100; -50];... %vertex 5 guessclc
[ -50; -50];... %vertex 6 guess
[ -50; -100]... %vertex 7 guess
];

thetas = linspace(0, 2*pi, 500);
leg_vels_x = zeros(length(thetas), 2);
leg_vels_y = zeros(length(thetas), 2);

for i=1:length(thetas)
    % compute vertex coordinates
    vertex_coords_root = compute_coords(vertex_coords_guess, leg_params, thetas(i));

    % compute vertex velocities via Jacobian methods
    dVdtheta = compute_velocities(vertex_coords_root, leg_params, thetas(i));

    % compute vertex velocities via finite differences of position
    dVdtheta_fd = finite_differences_compute_velocity(vertex_coords_root, leg_params, thetas(i));
    
    % get x and y velocity components for the leg
    leg_vels_x(i, 1) = dVdtheta(13);
    leg_vels_x(i, 2) = dVdtheta_fd(13);
    leg_vels_y(i, 1) = dVdtheta(14);
    leg_vels_y(i, 2) = dVdtheta_fd(14);
    
    % update guess to current root to ensure convergence next time step
    vertex_coords_guess = vertex_coords_root;
end

figure();
subplot(2, 1, 1);
hold on;
plot(thetas, leg_vels_x(:, 1), "b-", 'LineWidth', 1.5);
plot(thetas, leg_vels_x(:, 2), "r--", 'LineWidth', 1.5);
title('Comparing Computed Leg Horizontal Velocities');
legend('Implicit Method', 'Finite Differences Method');
xlabel('\theta (rads)');
ylabel('Velocity (m/s)');
xlim([thetas(1) thetas(end)])
hold off;

subplot(2, 1, 2);
hold on;
plot(thetas, leg_vels_y(:, 1), 'b-', 'LineWidth', 1.5);
plot(thetas, leg_vels_y(:, 2), 'r--', 'LineWidth', 1.5);
title('Comparing Computed Leg Vertical Velocities');
legend('Implicit Method', 'Finite Differences Method');
xlabel('\theta (rads)');
ylabel('Velocity (m/s)');
xlim([thetas(1) thetas(end)])
hold off;