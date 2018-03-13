function varargout = get_vars(thing)
    n = length(thing);
    varargout = cell(1,n);
    for k = 1:n
        varargout{k} = thing(k);
    end
end