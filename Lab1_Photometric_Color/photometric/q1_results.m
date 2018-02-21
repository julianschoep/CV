function[] = get_results_q1(image_stack, scriptV)
balanced_indices = [13,1,4,16,19,3,11,14,18,7,10,22,25,8,12,15,23,2,5,17,20,6,9,21,24]
%used_indices = balanced_indices(1:batch_size)
% res_lengths = zeros(1,7)
% [alb,norm,res] = estimate_alb_nrm(image_stack, scriptV, 7);
% alb_file = sprintf('albedo_single_shadowtrick.jpeg')
% norm_file = sprintf('norm_single_shadowtrick.jpeg')
% imwrite(alb, alb_file);
% imwrite(norm, norm_file);
% [alb,norm,res] = estimate_alb_nrm(image_stack, scriptV, [25,7]);
% alb_file = sprintf('albedo_double_shadowtrick.jpeg')
% norm_file = sprintf('norm_double_shadowtrick.jpeg')
% imwrite(alb, alb_file);
% imwrite(norm, norm_file);
residuals_shadow = [0,2.30756,2.219408,2.36836,2.21052,2.18863,2.12048,2.04474,1.968353,1.924407,1.8,1.69704,1.625822,1.63252,1.63451,1.572833,1.51805,1.532558,1.4833,1.46198,1.422588,1.43518,1.416815,1.38294,1.35326];
residuals = zeros(1,25)
x = [1:25]
for i = 1:25
    used_indices = balanced_indices(1:i)
    [alb,norm,res] = estimate_alb_nrm(image_stack, scriptV, used_indices,false);
    disp('RESIDUAL :');
    disp(res);
    residuals(i) = res*100;
    alb_file = sprintf('albedo_s%d_REALNOshadowtrick_r%d.jpeg',i,res)
    norm_file = sprintf('norm_s%d_REALNOshadowtrick_r%d.jpeg',i,res)
    imwrite(alb, alb_file);
    imwrite(norm, norm_file);
    disp(i);
end
fig = figure(1)
plot(x,residuals_shadow);
hold on
plot(x,residuals,'--')
hold off
legend('shadow trick applied', 'vanilla')
xlabel('batch size')
ylabel('average residual per pixel (x10\^-2)')
title('Average least squares residual per batch size')
saveas(fig,'residual_over_batchsize.png')
end