%% ACCURACY TEST FOR AMERICAN PUT OPTION
clear;
clc;
close all;


%% Least Squares Monte-Carlo Method for American put
rng(103);
S0=36;    
K=40; 
r=0.06;     
T=1;      
sigma=0.2;  
N=50;     % Number of points in time grid  
M=100000; % Number of paths
Am_LSM = LSM(S0,K,r,T,sigma,N,M); % Price of American put by LSM


%% Finite Difference Method (Implicit Scheme) for American put
S0=36;    
K=40; 
r=0.06;     
T=1;      
sigma=0.2;
Mx=1400; % Number of grid points per time level
Nt=500;  % Number of time levels
q=0;
Am_FD= FD(S0,Mx,Nt,T,K,sigma,r,q); % Price of American put by FD

%% Test 1: Keeping the number of determination dates fixed N=50 and vary the number of nodes M
S0=36;    
K=40; 
r=0.06;     
T=1;      
sigma=0.2;
N=50;
dy=[0.025,0.05,0.1];
M=2:2:160;
Am_GL=zeros(length(M),length(dy));

for j=1:1:length(dy)
for i=1:1:length(M)
Am_GL(i,j)= GL_AM(S0,M(i),N,T,K,sigma,r,dy(j));
end
end

A3_appendix=[M',Am_GL];% Results for American put option Test 1,
                        % which you can find in Appendix A.3

% Graph: Convergence of an American put option using different grid spaces
% in the lattice algorithm
figure;
plot(M,Am_GL(:,1),'color','black','linestyle','--','LineWidth',1);
hold on
plot(M,Am_GL(:,2),'color','black','linestyle',':','LineWidth', 1);
hold on
plot(M,Am_GL(:,3),'color','black','linestyle','-.','LineWidth', 1);
hold on
BSM_line=refline(0,Am_FD);
BSM_line.LineWidth=1;
BSM_line.Color='black';
grid on
grid minor
legend1=legend('\delta=0.025','\delta=0.05','\delta=0.1','FD');
set(legend1,'Position',[0.58 0.17 0.3 0.165]);
xlabel('Number of Nodes');
ylabel('American Option Price');
saveas(gcf,'Convergence_Am_M.png');



%% Test 2: Keeping the number of nodes fixed M=501 and vary the number of determination dates N
S0=36;    
K=40; 
r=0.06;     
T=1;      
sigma=0.2;
dy=[0.025,0.05,0.1];
N=5:5:100;
M=151;
Am_GL=zeros(length(N),length(dy));

for j=1:1:length(dy)
for i=1:1:length(N)
Am_GL(i,j)= GL_AM(S0,M,N(i),T,K,sigma,r,dy(j));
end
end

A4_appendix=[N',Am_GL];% Results for American put option Test 2,
                        % which you can find in Appendix A.4

% Graph: Relationship between European put option and number of
% determination dates using different grid spaces in the lattice algorithm

figure;
plot(N,Am_GL(:,1),'color','black','linestyle','--','LineWidth',1);
hold on
plot(N,Am_GL(:,2),'color','black','linestyle',':','LineWidth', 1);
hold on
plot(N,Am_GL(:,3),'color','black','linestyle','-.','LineWidth', 1);
hold on
grid on
grid minor
ylim([4.3 4.5])
legend2=legend('\delta=0.025','\delta=0.05','\delta=0.1');
set(legend2,'Position',[0.6 0.18 0.3 0.165]);
xlabel('Number of Excercise Times');
ylabel('American Option Price');
saveas(gcf,'Convergence_Am_N.png');



%% Compare results from LSM, finite differnce method and lattice algorithm under various settings (dy=0.025)

% Data for grid lattice method
% number of different settings: 20;
S0=[32,32,32,32,36,36,36,36,40,40,40,40,44,44,44,44,48,48,48,48];
sigma=[0.1,0.1,0.5,0.5,0.2,0.2,0.4,0.4,0.3,0.3,0.7,0.7,0.4,0.4,0.8,0.8,0.5,0.5,0.9,0.9];
T=[1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2];
N_lattice=[50,100,50,100,50,100,50,100,50,100,50,100,50,100,50,100,50,100,50,100];
M_lattice=151;
K=40; 
r=0.06;     
t=0;
q=0;
dy=0.025;

% Data for finite difference method
M_FD=1400;
N_FD=500;

% Data for least squares Monte Carlo method
N_LSM=50;
M_LSM=100000;

% Set up some vector to store results
FD=zeros(20,1);
time_FD=zeros(20,1);
LSMprice=zeros(20,1);
time_LSM=zeros(20,1);
diff_FD_LSM=zeros(20,1);
lattice=zeros(20,1);
time_lattice=zeros(20,1);
diff_FD_lattice=zeros(20,1);
summary_table_Am=zeros(20,12);

% Running a for-loop for American option test
for i=1:20
           [FD(i),time_FD(i),LSMprice(i),time_LSM(i),diff_FD_LSM(i),lattice(i),time_lattice(i),diff_FD_lattice(i)] = COMPARE_AM(S0(i),M_FD,N_FD,T(i),K,sigma(i),r,q,N_LSM,M_LSM,M_lattice,N_lattice(i),dy);
           summary_table_Am(i,1)=S0(i);
           summary_table_Am(i,2)=sigma(i);
           summary_table_Am(i,3)=T(i);
           summary_table_Am(i,4)=N_lattice(i);
           summary_table_Am(i,5)=FD(i);
           summary_table_Am(i,6)=time_FD(i);
           summary_table_Am(i,7)=LSMprice(i);
           summary_table_Am(i,8)=diff_FD_LSM(i);
           summary_table_Am(i,9)=diff_FD_LSM(i);
           summary_table_Am(i,10)=lattice(i);
           summary_table_Am(i,11)=time_lattice(i);
           summary_table_Am(i,12)=diff_FD_lattice(i);
end


% Save results into an excel sheet
Am_test3 = dataset({summary_table_Am 'S0' 'Sigma' 'T' 'N' 'FD'  'TimeFD' 'LSM' 'TimeLSM' 'DiffFD_LSM' 'Lattice' 'TimeLattice' 'DiffFD_lattice'});
export(Am_test3,'XLSFile','Am_test3.xlsx'); % Results for American put option Test 3
                                           % which is presented directly in the thesis