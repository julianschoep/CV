function[] = q2_results(image_stack, scriptV)
[h, w, ~] = size(image_stack);
balanced_indices = [13,1,4,16,19,3,11,14,18,7,10,22,25,8,12,15,23,2,5,17,20,6,9,21,24];


for i = 1:4:25
    used_indices = balanced_indices(1:i)
    [alb,norm] = estimate_alb_nrm(image_stack, scriptV, used_indices);
    [p, q, SE] = check_integrability(norm);
    threshold = 0.005;
    SE(SE <= threshold) = NaN; % for good visualization
    outl = sum(sum(SE > threshold));
    fprintf('Number of outliers: %d out of %d total \n\n', outl, length(SE(:)));
    
    figure()
    [X, Y] = meshgrid(1:w, 1:h);
    title(['Integrability check: (dp / dy - dq / dx) ^2 with ' num2str(i) 'images']);
    surf(X, Y, SE, gradient(SE));
    
%     plot_file = sprintf('outliers_s%d.jpeg',i);
%     imwrite(plot, plot_file);
    outliers(i) = outl;
end

disp(outliers);
end