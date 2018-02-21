function get_results_q1(image_stack, scriptV)
balanced_indices = [13,1,4,16,19,3,11,14,18,7,10,22,25,8,12,15,23,2,5,17,20,6,9,21,24]
b1 = [61]
b2 = cat(2,b1,[1,56,67,72,73,62,7,6])
b3 = cat(2,b2,[13,2,57,68,79,78,83,84,85,74,63,8,19,18,17,12])
b4 = cat(2,b3,[25,14,3,58,69,80,91,90,89,94,95,96,97,86,75,64,9,20,31,30,29,28,23,24])
b5 = cat(2,b4,[37,26,15,4,59,70,81,92,103,102,101,100,105,106,107,108,109,98,87,76,65,10,21,32,43,42,41,40,39,34,35,36])
b6 = cat(2,b5,[49,38,27,16,5,60,71,82,93,104,115,114,113,112,111,116,117,118,119,120,121,110,99,88,77,66,11,22,33,44,55,54,53,52,51,50,45,46,47,48])

myStyle = hgexport('factorystyle');
myStyle.Format = 'png';
myStyle.Width = 1106;
myStyle.Height = 989;
myStyle.Units = 'point';
myStyle.Resolution = 1100;


[alb1,norm,res] = estimate_alb_nrm(image_stack, scriptV, b1);
fig1 = figure(1);
imshow(alb1);
saveas(fig1,'monkey_alb@1.png') ;


[alb2,norm,res] = estimate_alb_nrm(image_stack, scriptV, b2);
fig2 = figure(2);
imshow(alb2);
saveas(fig2,'monkey_alb@2.png') ;


% [alb3,norm,res] = estimate_alb_nrm(image_stack, scriptV, b3);
% fig3 = figure(3);
% imshow(alb3);
% saveas(fig3,'monkey_alb@3.png') ;
% 
% [alb4,norm,res] = estimate_alb_nrm(image_stack, scriptV, b4);
% fig4 = figure(4)
% imshow(alb4)
% saveas(fig4,'monkey_alb@4.png') 
% 
% [alb5,norm,res] = estimate_alb_nrm(image_stack, scriptV, b5);
% fig5 = figure(5)
% imshow(alb5)
% saveas(fig5,'monkey_alb@5.png') 
% 
% [alb6,norm,res] = estimate_alb_nrm(image_stack, scriptV, b6);
% fig6 = figure(6)
% imshow(alb6)
% saveas(fig6,'monkey_alb@6.png') 

end