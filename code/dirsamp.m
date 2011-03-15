function v = dirsamp(alpha, dim)

v = gamrnd(alpha, ones(dim,1));
v = v ./ sum(v);