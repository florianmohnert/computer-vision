function [files] = read_lines(path, prefix)
    f_in = fopen(path);
    files = textscan(f_in, '%s', 'delimiter', '\n'); % read each line
    fclose(f_in);

    if nargin > 1 % if prefix is provided, append to each entry
       files = strcat(prefix, files{1}, '.jpg');
    end
end
