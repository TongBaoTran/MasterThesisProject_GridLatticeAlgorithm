%% COMPARE_AM: COMPUTE THE PRICE OF AMERICAN PUT OPTION AND COMPUTATION TIME USING THREE NUMERICAL METHODS

function [FDprice,time_FD,LSMprice,time_LSM,diff_FD_LSM,P_Am_lattice,time_lattice,diff_FD_lattice] = COMPARE_AM(S0,M_FD,N_FD,T,K,sigma,r,q,N_LSM,M_LSM,M_lattice,N_lattice,dy)
%% Compute American put by finite difference method
[FDprice,time_FD]=FD(S0,M_FD,N_FD,T,K,sigma,r,q);

%% Compute American put by least square Monte-Carlo method
[LSMprice,time_LSM]=LSM(S0,K,r,T,sigma,N_LSM,M_LSM);
diff_FD_LSM=abs(FDprice-LSMprice)/FDprice*100;

%% Compute American put by grid lattice method
[P_Am_lattice,time_lattice]=GL_AM(S0,M_lattice,N_lattice,T,K,sigma,r,dy);
diff_FD_lattice=abs(FDprice-P_Am_lattice)/FDprice*100;

end

