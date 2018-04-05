function [AP,I] = average_precision(probs, labels, m_c)
    [X,I] = sort(probs, 'descend');
    sorted_labels = labels(I);
    n = size(probs,1);
    
    sum_holder = 0;
    for i = 1:n
        if sorted_labels(i)
            TP = sum(sorted_labels(1:i));
            term = TP/i;
            sum_holder = sum_holder + term;
        end
    end
    AP = sum_holder / m_c;
    
end