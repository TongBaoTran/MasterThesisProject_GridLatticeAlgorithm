%% GL_AM- PRICE AN AMERICAN PUT OPTION VIA GRID LATTICE ALGORITHM

function [P_Am0,time_lattice]= GL_AM(S0,M,N,T,K,sigma,r,dy)
%% Inputs:
%   S0: initial stock price
%   M: number of grid points per time level
%   N: number of time levels
%   T: time to maturity
%   K: strike price
%   sigma: volatility
%   r: interest rate
%   dy: grid space

 
tic; % Start counting computing time
%% Step 1: Define variables
dt = T/N;   % Time steps
t=dt:dt:T;
A=dy*(M-1)/2;
y=(-A:dy:A)';
S=zeros(M,N);
P_Am=zeros(M,N);
P_c_Am=zeros(M,N-1);

for i=1:N  
    S(:,i)=S0.*exp(r*t(i)+sigma.^2/2.*t(i)+sigma.*y);
end

%% Step 2: Payoff at the maturity T
P_Am(:,end) = max(K-S(:,end),0); % Payoff at time T

%% Step 3 and 4: Find the option value at time nodes N-1:-1:1
for i=N-1:-1:1 % time space
  for j=1:M % y space
    
    % Calculations for American option
    P_c_Am(j,i)=exp(-r.*dt)./sqrt(2.*pi.*dt).*dy./2....
    .*sum(  P_Am(2:M,i+1).*exp(-(y(2:M)-y(j)+sigma.*dt).^2./(2*dt)) ...
    +P_Am(1:M-1,i+1).*exp(-(y(1:M-1)-y(j)+sigma.*dt).^2./(2*dt))    );

    P_Am(j,i)=max(K-S(j,i),P_c_Am(j,i));
    
  end
end

%% Step 5: Option value at time 0
Pc0_Am=exp(-r.*dt)./sqrt(2.*pi.*dt).*dy./2....
    .*sum(  P_Am(2:M,1).*exp(-(y(2:M)+sigma.*dt).^2./(2*dt)) ...
    +P_Am(1:M-1,1).*exp(-(y(1:M-1)+sigma.*dt).^2./(2*dt))    );

P_Am0=max(K-S0,Pc0_Am);

time_lattice=toc; % Finish counting computation time

end
