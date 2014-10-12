function newpot=convertGaussianMomentToGaussianCanonical(pot)   
C=pot.table.covariance;
mu = pot.table.mean;
newpot.table.invcovariance=inv(C);
newpot.table.invmean=newpot.table.invcovariance*mu;
newpot.table.logprefactor=pot.table.logprefactor-0.5*mu'*newpot.table.invmean-0.5*logdet(2*pi*C);
newpot.table.type='GaussianCanonical';
newpot.variables=pot.variables;
newpot.table.dim=pot.table.dim;