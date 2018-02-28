function LoG = Laplacian(sigma)
%LoG = zeros(101);
X = -2:.1:2;
%y = -2:.1:2;
%[X,Y] = meshgrid(x,y);

LoG = -(1/(pi*sigma^4))*(1-((X.^2)/(2*sigma^2))).*exp(-((X.^2)/(2*sigma^2)));

end