function [f_val, jacobian] = test_function02(x)
    x1 = x(1);
    x2 = x(2);
    x3 = x(3);

    y1 = 3*x1^2 + .5*x2^2 + 7*x3^2-100;
    y2 = 9*x1-2*x2+6*x3;

    f_val = [y1; y2];
    jacobian = [6*x1, 1*x2, 14*x3;
                9,    -2,   6];
end