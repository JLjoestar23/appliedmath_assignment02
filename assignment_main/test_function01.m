function [f_val, jacobian] = test_function01(x)
    f_val = [x(1)^2 + x(2)^2 - 6 - x(3)^5;
             x(1)*x(3) + x(2) - 12;
             sin(x(1) + x(2) + x(3))];

    jacobian = [ 2*x(1),         2*x(2),       -5*x(3)^4;
                 x(3),           1,            x(1);
                 cos(sum(x)),    cos(sum(x)),  cos(sum(x)) ];
end