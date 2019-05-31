%% FD: PRICE AMERICAN PUT OPTION USING IMPLICIT SCHEME

function [FD_price,time_FD] = FD(S0,M,N,T,K,sigma,r,q)
%% Inputs:
%   M: number of grid points per time level
%   N: number of time levels
%   T: time to maturity
%   K: strike price
%   sigma: volatility
%   r: interest rate;
%   q: dividend rate;
%   S0: initial stock price

tic; % Start counting computation time
h=r-q; %carry costs
Smax = 2*max(S0,K)*exp(r*T); % Maximum price considered;
%% Definition of variables
u1=zeros(M+1,1);

%% Defining the grid
hh=Smax./M; % Space step
kk=T./N; % Time step
rx=kk./hh^2;
% Initial values
S=(0:M)'.*hh;
u0=max(K-S,0); % Boundary condition: Derivative at the maturity

%% Now find points either side of the initial price,
%% so that we can calculate the price of the option via interpolation
idx = find(S < S0); idx = idx(end); a = S0-S(idx); b = S(idx+1)-S0;
Z = 1/(a+b)*[a b]; % Interpolation vector

%% Time independent coefficients
aa=0.5.*sigma^2.*(0:M)'.*(0:M)'.*hh.*hh;
bb=h.*(0:M)'.*hh; 
cc=-r;
d1=-aa.*rx+0.5.*bb.*rx.*hh;
d2=2.*aa.*rx-cc.*kk+1;
d3=-aa.*rx-0.5.*bb.*rx.*hh;

%% Correction of d1 due to the right boundary at Mx (S=Smax)
d1(M+1)=d1(M+1)+d3(M+1);

%% Construction of the tridiagonal matrix A
A=diag(d1(3:M+1),-1)+diag(d2(2:M+1),0)+diag(d3(2:M),1);

% Step 1: LR-Decomposition of the system Au=d into Au=LRu=Ly=d
[L,R]=lu(A);

for nn=1:N %main loop, where nn is counted on the advanced time level 
    
    % Left boundary for index i=0 "Dirichlet"
    u1(1)=K.*exp(-r.*nn.*kk);  
    
    % Definition of the vector d4 (RHS of equation system)
    d4=u0;
    d4(2)=d4(2)-d1(2).*u1(1);
    
    % Step 2 and step 3 in one line
    u1(2:M+1)=R\(L\d4(2:M+1));   
    
    % Timeshift
    u0=max(u1,K-S);
    
end

%% Extract the final price
FD_price = Z*u0(idx:idx+1);

time_FD=toc; % Finish counting computation time
end





