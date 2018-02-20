function[] = get_results_q1(image_stack, scriptV)
%balanced_indices = [13,1,4,16,19,3,11,14,18,7,10,22,25,8,12,15,23,2,5,17,20,6,9,21,24]
%used_indices = balanced_indices(1:batch_size)
% res_lengths = zeros(1,7)
% [alb,norm,res] = estimate_alb_nrm(image_stack, scriptV, 7);
% alb_file = sprintf('albedo_single_shadowtrick.jpeg')
% norm_file = sprintf('norm_single_shadowtrick.jpeg')
% imwrite(alb, alb_file);
% imwrite(norm, norm_file);
[alb,norm,res] = estimate_alb_nrm(image_stack, scriptV, [25,7]);
alb_file = sprintf('albedo_double_shadowtrick.jpeg')
norm_file = sprintf('norm_double_shadowtrick.jpeg')
imwrite(alb, alb_file);
imwrite(norm, norm_file);

% for i = 1:4:25]
%     [alb,norm,res] = estimate_alb_nrm(image_stack, scriptV, (i),false);
%     alb_file = sprintf('albedo_s%d_NOshadowtrick.jpeg',i)
%     norm_file = sprintf('norm_s%d_NOshadowtrick.jpeg',i)
%     imwrite(alb, alb_file);
%     imwrite(norm, norm_file);
%     res_lengths(i) = res;
%     disp(i);
% end

disp(res_lengths);
end