%% Defines the model and runs Gibbs sampling on it...

epsilon = 0.05; % noise parameter for (otherwise) deterministic CPDs

% P(c,r,d,p,h,o,v) = P(c)P(o|c)P(h|o)P(p|c)P(d|c)P(d,r|c)P(v|r,d,p,h,o)
P.c = ones(1,6)/6;
