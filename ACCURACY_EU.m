%% ACCURACY TEST FOR EUROPEAN PUT OPTION
clear;
clc;
close all;


%% Black-Scholes model for European put
S0=36;    
K=40; 
r=0.06;     
T=1;      
sigma=0.2;
q=0;
t=0;
Eu_BSM = BSMP(S0,K,T,t,q,r,sigma); % Price of European put by BSM


%% Test 1: Keeping the number of determination dates fixed N=50 and vary the number of nodes M
S0=36;    
K=40; 
r=0.06;     
T=1;      
sigma=0.2;
N=50;
dy=[0.025,0.05,0.1];
M=50:5:400;
Eu_GL=zeros(length(M),length(dy));
for j=1:1:length(dy)
for i=1:1:length(M)
Eu_GL(i,j) = GL_EU(S0,M(i),N,T,K,sigma,r,dy(j));
end
end

A1_appendix=[M',Eu_GL]; % Results for European put option Test 1,
                        % which you can find in Appendix A.1

% Graph: Convergence of a European put option using different grid spaces
% in the lattice algorithm
figure;
plot(M,Eu_GL(:,1),'color','black','linestyle','--','LineWidth',1);
hold on
plot(M,Eu_GL(:,2),'color','black','linestyle',':','LineWidth', 1);
hold on
plot(M,Eu_GL(:,3),'color','black','linestyle','-.','LineWidth', 1);
hold on
BSM_line=refline(0,Eu_BSM);
BSM_line.LineWidth=1;
BSM_line.Color='black';
grid on
grid minor
legend1=legend('\delta=0.025','\delta=0.05','\delta=0.1', 'BSM');
set(legend1,'Position',[0.58 0.17 0.3 0.165]);
xlabel('Number of Nodes M');
ylabel('European Option Price');
saveas(gcf,'Convergence_EU_M.png');



%% Test 2: Keeping the number of nodes fixed M=501 and vary the number of determination dates N
S0=36;    
K=40; 
r=0.06;     
T=1;      
sigma=0.2;
dy=[0.025,0.05,0.1];
N=5:5:100;
M=501;
Eu_GL=zeros(length(N),length(dy));
for j=1:1:length(dy)
for i=1:1:length(N)
Eu_GL(i,j) = GL_EU(S0,M,N(i),T,K,sigma,r,dy(j));
end
end


A2_appendix=[N',Eu_GL]; % Results for European put option Test 2,
                        % which you can find in Appendix A.2

% Graph: Relationship between European put option and number of
% determination dates using different grid spaces in the lattice algorithm

figure;
plot(N,Eu_GL(:,1),'color','black','linestyle','--','LineWidth',1);
hold on
plot(N,Eu_GL(:,2),'color','black','linestyle',':','LineWidth', 1);
hold on
plot(N,Eu_GL(:,3),'color','black','linestyle','-.','LineWidth', 1);
hold on
BSM_line=refline(0,Eu_BSM);
BSM_line.LineWidth=1;
BSM_line.Color='black';
xlim([5 100])
grid on
grid minor
ylim([3.84 3.85])
legend2=legend('\delta=0.025','\delta=0.05','\delta=0.1', 'BSM');
set(legend2,'Position',[0.6 0.18 0.3 0.165]);
xlabel('Number of Determination Dates N');
ylabel('European Option Price');
saveas(gcf,'Convergence_EU_N.png');



%% Test 3: Compare results from BSM model and lattice algorithm under various settings (dy=0.1)
% Data for grid lattice method
% number of different settings: 20;
S0=[32,32,32,32,36,36,36,36,40,40,40,40,44,44,44,44,48,48,48,48];
sigma=[0.1,0.1,0.5,0.5,0.2,0.2,0.6,0.6,0.3,0.3,0.7,0.7,0.4,0.4,0.8,0.8,0.5,0.5,0.9,0.9];
T=[1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2,1,2];
N_lattice=[50,100,50,100,50,100,50,100,50,100,50,100,50,100,50,100,50,100,50,100];
M_lattice=151;
K=40; 
r=0.06;     
t=0;
q=0;
dy=0.1;

BS=zeros(20,1);
lattice=zeros(20,1);
diff=zeros(20,1);
summary_table_Eu=zeros(20,7);

 for i=1:20
           [BS(i),lattice(i),diff(i)]=COMPARE_EU(S0(i),K,T(i),t,q,r,sigma(i),M,N_lattice(i),dy);
           summary_table_Eu(i,1)=S0(i);
           summary_table_Eu(i,2)=sigma(i);
           summary_table_Eu(i,3)=T(i);
           summary_table_Eu(i,4)=N_lattice(i);
           summary_table_Eu(i,5)=BS(i);
           summary_table_Eu(i,6)=lattice(i);
           summary_table_Eu(i,7)=diff(i);
 end
Eu_test3 = dataset({summary_table_Eu 'S0' 'Sigma' 'T' 'N' 'BS'  'Lattice' 'Difference'});
export(Eu_test3,'XLSFile','Eu_test3.xlsx'); % Results for European put option Test 3
                                            % which is presented directly in the thesis 