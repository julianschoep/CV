function [Irot] = imtool(I,theta,background_color)
    Irot = imrotate(I,theta);
    Mrot = ~imrotate(true(size(I)),theta);
    Irot(Mrot&~imclearborder(Mrot)) = background_color;
    
end