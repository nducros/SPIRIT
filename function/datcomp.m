function Y = datcomp(X, mu, C)

ind1 = find(X==0);  % index of coefficients to complete
ind2 = find(X~=0);  % index of coefficients that have been acquired

C12 = C(ind1,ind2);   
C22 = C(ind2,ind2);
mu1 = mu(ind1);
mu2 = mu(ind2);

%-- Completion using conditional means
y2 = X(ind2);
y = mu1 + C12*(C22\(y2 - mu2));
%
Y = X;
Y(ind1) = y;

end