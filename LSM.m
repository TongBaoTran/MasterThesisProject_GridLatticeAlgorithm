%% LSM - PRICE AN AMERICAN PUT OPTION VIA LEAST-SQUARES MONTE CARLO METHOD
%% (LONGSTAFF-SCHWARTZ METHOD)
function [LSM_price,time_LSM] = LSM(S0,K,r,T,sigma,N,M)
%% Inputs:
%   S0      Initial asset price
%   K       Strike Price
%   r       Interest rate
%   T       Time to maturity of option
%   sigma   Volatility of underlying asset
%   N       Number of points in time grid 
%   M       Number of paths
tic; %Start counting computation time
dt = T/N;   % Time steps

%% Simulate stock prices
R = exp((r-sigma^2/2)*dt+sigma*sqrt(dt)*randn(N,M));
S = cumprod([S0*ones(1,M); R]);
S=S';

%% Main algorithm to value American options
CF = zeros(M,N+1); % Cash flow matrix
CF(:,end) = max(K-S(:,end),0); % Payoff at time T
for i = N:-1:2    
    Idx = find(K>S(:,i)); % Find paths that are in the money at time i  
    X = S(Idx,i); % Prices for in-the-money paths
    Y = CF(Idx,i+1).*exp(-r*dt); % Discounted cashflow 
    
    R = [ones(size(X)) (1-X) 1/2*(2-4*X-X.^2)];
    beta = R\Y; % Linear regression step  
    C = R*beta; % Estimated value of continuation
    
    E=max(K-X,0) ;     % Value of immediate excercise   
    exP=Idx(E>C); % Paths where it's better to excercise
    nexP = setdiff((1:M),exP); % Rest of the paths  
    CF(exP,i) = max(K-X(E>C),0); % Better to excercise, insert value in payoff vector
    CF(nexP,i) = CF(nexP,i+1).*exp(-r*dt); % Better to continue,
                                           % insert previous payoff and discount back one step
end

LSM_price = mean(CF(:,2))*exp(-r*dt);
time_LSM=toc; % Finish counting computation time
end

