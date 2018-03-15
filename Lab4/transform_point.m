function [x_t,y_t] = transform_point(x,y,transform_params)
    [m1,m2,m3,m4,t1,t2] = get_vars(transform_params);
    M = [m1,m2;m3,m4];
    r= M*[x;y]+[t1;t2];
    x_t = r(1);
    y_t = r(2);
end
