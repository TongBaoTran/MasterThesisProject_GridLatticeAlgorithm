%% BSMP:COMPUTE THE VALUE OF EUROPEAN PUT OPTION ACCORDING TO BlACK-SCHOLES MODEL
function Put = BSMP(S0,K,T,t,q,r,sigma)
d1 = (log(S0./K)+(r-q+0.5.*sigma.*sigma).*(T-t))/(sigma.*sqrt((T-t)));
d2 = d1 - sigma.*sqrt((T-t));

Put = -S0.*exp(-q.*(T-t)).*N(-d1) + K.*exp(-r.*(T-t)).*N(-d2);