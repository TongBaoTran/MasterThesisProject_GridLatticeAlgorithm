%% GL_EU - Price an European put option via grid lattice algorithm

function P_Eu0= GL_EU(S0,M,N,T,K,sigma,r,dy)

%% Inputs:
%   S0: initial stock price
%   M: number of grid points per time level
%   N: number of time levels
%   T: time to maturity
%   K: strike price
%   sigma: volatility
%   r: interest rate
%   dy: grid space

 

%% Step 1: Define variables
dt = T/N;   % Time steps
t=dt:dt:T;
A=dy*(M-1)/2;
y=(-A:dy:A)';
S=zeros(M,N);
P_Eu=zeros(M,N);

for i=1:N  
    S(:,i)=S0.*exp(r*t(i)+sigma.^2/2.*t(i)+sigma.*y);
end

%% Step 2: Payoff at the maturity T
P_Eu(:,end) = max(K-S(:,end),0); % Payoff at time T

%% Step 3 and 4: Find the option value at time nodes N-1:-1:1
for i=N-1:-1:1 % time space
for j=1:M % y space
    
    P_Eu(j,i)=exp(-r.*dt)./sqrt(2.*pi.*dt).*dy./2....
    .*sum(  P_Eu(2:M,i+1).*exp(-(y(2:M)-y(j)+sigma.*dt).^2./(2*dt)) ...
    +P_Eu(1:M-1,i+1).*exp(-(y(1:M-1)-y(j)+sigma.*dt).^2./(2*dt))    );
    
end
end

%% Step 5: Option value at time 0

Pc0_Eu=exp(-r.*dt)./sqrt(2.*pi.*dt).*dy./2....
    .*sum(  P_Eu(2:M,1).*exp(-(y(2:M)+sigma.*dt).^2./(2*dt)) ...
    +P_Eu(1:M-1,1).*exp(-(y(1:M-1)+sigma.*dt).^2./(2*dt))    );

P_Eu0=Pc0_Eu; 

end

