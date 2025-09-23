function approx_j = approximate_jacobian(fun, x)
    
    input_dim = length(x);
    output_dim = length(fun(x));

    J = zeros(output_dim, input_dim);

    h = 1e-8;
    
    for i=1:input_dim
        std_basis_vec = zeros(input_dim, 1);
        std_basis_vec(i) = h;
        J(:, i) = (fun(x + std_basis_vec) - fun(x - std_basis_vec)) / (2*h);
    end

    approx_j = J;
end