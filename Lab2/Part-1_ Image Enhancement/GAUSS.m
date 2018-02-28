function plot_approx()
x = -2:.1:2;
log = Laplacian(0.5);
dog1 = dog(0.8,0.5);
dog1 = dog(0.5,0.2);
plot(x,log);
hold on
plot(x,dog1);
plot(x,dog2);
end