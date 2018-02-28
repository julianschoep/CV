function LoG = Laplacian2D(sigma)
LoG = zeros(101);
x = -2:.1:2;
y = -2:.1:2;
[X,Y] = meshgrid(x,y);

LoG = -(1/(pi*sigma^4))*(1-((X.^2+Y.^2)/(2*sigma^2))).*exp(-((X.^2+Y.^2)/(2*sigma^2)));

end