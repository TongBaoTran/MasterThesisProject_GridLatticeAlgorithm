%% COMPARE_AM: COMPUTE THE PRICE OF AMERICAN PUT OPTION BY BSM AND GRID LATTICE ALGORITHM
function [BS,P_Eu_lattice,diff] = COMPARE_EU(S0,K,T,t,q,r,sigma,M,N,dy)
BS = BSMP(S0,K,T,t,q,r,sigma);
P_Eu_lattice=GL_EU(S0,M,N,T,K,sigma,r,dy);
diff=abs(BS-P_Eu_lattice)/BS*100;
end

