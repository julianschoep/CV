function [assignments] = get_visual_words(descriptors, vocabulary)
    
    n = size(descriptors,2);
    assignments = [];
    v_size = size(vocabulary,2);
    hist = zeros(1,v_size);
    for i = 1:n
       d = descriptors(:,i);
       [closest_word, closest_word_number] = get_closest_word(d,vocabulary);
       assignments = [assignments, closest_word_number];
    end
    
end


function [closest_word, closest_word_number] = get_closest_word(descriptor, vocabulary)
    closest_word = 0;
    closest_word_number = 0;
    smallest_dist = 10000000000;
    v_size = size(vocabulary,2);
    for i = 1:v_size
       visual_word = double(vocabulary(:,i));
       dist = euclid_dist(descriptor, visual_word);
       if dist < smallest_dist
          smallest_dist = dist;
          closest_word = visual_word;
          closest_word_number = i;
       end
    end
end

function [dist] = euclid_dist(d1, d2)
    term = 0;
    n_dims = size(d1,1);
    d1 = double(d1);
    d2 = double(d2);
    assert(n_dims == size(d2,1),'Dimensions must agree');
    for x = 1:n_dims
       dim_dif = (d1(x) - d2(x))^2;
       term = term+dim_dif;
    end
    dist = sqrt(double(term));
end