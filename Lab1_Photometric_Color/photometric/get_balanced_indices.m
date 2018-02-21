function [batches] = get_balanced_indices(views)

n = length(views);
steps = sqrt(n);
step_size = 2/(steps-1); % Range -1 to 1 has length 2
% Range is always from -1 to 1. 
matrix = zeros(steps, steps);
for i = 1:121
    x = views(i,1);
    y = views(i,2);
    x_ind = int8((x/step_size) + 6)
    y_ind = int8((y/step_size) + 6)
    matrix(x_ind, y_ind) = i;
end 
mid = ((steps-1)/2)+1
b1 = [61]
b2 = cat(2,b1,[1,56,67,72,73,62,7,6])
b3 = cat(2,b2,[13,2,57,68,79,78,83,84,85,74,63,8,19,18,17,12])
b4 = cat(2,b3,[25,14,3,58,69,80,91,90,89,94,95,96,97,86,75,64,9,20,31,30,29,28,23,24])
b5 = cat(2,b4,[37,26,15,4,59,70,81,92,103,102,101,100,105,106,107,108,109,98,87,76,65,10,21,32,43,42,41,40,39,34,35,36])
b6 = cat(2,b5,[49,38,27,16,5,60,71,82,93,104,115,114,113,112,111,116,117,118,119,120,121,110,99,88,77,66,11,22,33,44,55,54,53,52,51,50,45,46,47,48])

end