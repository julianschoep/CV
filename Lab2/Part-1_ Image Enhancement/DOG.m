function DoG = DOG(sigma1,sigma2)

X = -2:.1:2
DoG = normpdf(X,0,sigma1) - normpdf(X,0,sigma2);

end