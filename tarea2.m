clc , close all , clear all

g=9.81;
grey = 1/255*[200,200,200];

%% CARGA REGISTRO FALTANTE 
%cargar registro faltante
% R=dlmread('/Users/bastiancataldo/Desktop/Registros/RSN1101_KOBE_AMA000.AT2','',4,0);
% R2=reshape(R.',size(R,1)*size(R,2),1);
% fprintf(fopen('/Users/bastiancataldo/Desktop/Registros/RSN1101_KOBE_AMA000.th','w'),'%.10f\r\n',R2);


%% RESULTADOS  II-DAP

%% PARTE 1

[EDP_1,IM_1] = getIdaCurves('sistema1.mat'); % EDP en [m] y IM en [m/s2]
[EDP_2,IM_2] = getIdaCurves('sistema2.mat'); 
IM_1=IM_1./g;
IM_2=IM_2./g;

median_EDP_1=median(EDP_1,2);
median_EDP_2=median(EDP_2,2);



figure;
subplot(2,1,1)
plot(EDP_1,IM_1,'color',grey,'DisplayName','Curvas IDA con los registros')
hold on 
plot(median_EDP_1,IM_1,'k','linewidth',2,'DisplayName','Mediana')
plot(0.0559,0.1,'or','Markerfacecolor','red','MarkerSize',4,'linewidth',2,'DisplayName','Punto de fluencia')
ylim([0 3])
ylabel('S_a(T_1,5%) [g]'),xlabel('\delta [m]'),title('Curvas IDA Sistema 1')

subplot(2,1,2)
plot(EDP_1,IM_1,'color',grey,'DisplayName','Curvas IDA con los registros')
hold on 
plot(median_EDP_1,IM_1,'k','linewidth',2,'DisplayName','Mediana')
plot(0.0559,0.1,'or','Markerfacecolor','red','MarkerSize',4,'linewidth',2,'DisplayName','Punto de fluencia')
ylim([0 0.15])
xlim([0 0.08])
ylabel('S_a(T_1,5%) [g]'),xlabel('\delta [m]'),title('Curvas IDA Sistema 1')


 figure;
 subplot(2,1,1)
plot(EDP_2,IM_2,'color',grey,'DisplayName','Curvas IDA con los registros')
hold on 
plot(median_EDP_2,IM_2,'k','linewidth',2,'DisplayName','Mediana')
plot(0.0045,0.2,'or','Markerfacecolor','red','MarkerSize',4,'linewidth',2,'DisplayName','Punto de fluencia')
ylim([0 3])
ylabel('S_a(T_1,5%) [g]'),xlabel('\delta [m]'),title('Curvas IDA Sistema 2')

subplot(2,1,2)
plot(EDP_2,IM_2,'color',grey,'DisplayName','Curvas IDA con los registros')
hold on 
plot(median_EDP_2,IM_2,'k','linewidth',2,'DisplayName','Mediana')
plot(0.0045,0.2,'or','Markerfacecolor','red','MarkerSize',4,'linewidth',2,'DisplayName','Punto de fluencia')
ylim([0 0.25])
xlim([0 0.008])
ylabel('S_a(T_1,5%) [g]'),xlabel('\delta [m]'),title('Curvas IDA Sistema 2')


%% PARTE 2 

mean_EDP_1=mean(EDP_1,2)
mean_EDP_2=mean(EDP_2,2)

std_EDP_1=std(EDP_1,0,2)
std_EDP_2=std(EDP_2,0,2)

sigma_lnEDP_1=sqrt(log((std_EDP_1./mean_EDP_1).^2+1))
sigma_lnEDP_2=sqrt(log((std_EDP_2./mean_EDP_2).^2+1))

mu_lnEDP_1=log(median_EDP_1)
mu_lnEDP_2=log(median_EDP_2)

mu_EDP_1=median_EDP_1.*exp(0.5.*sigma_lnEDP_1.^2)
mu_EDP_2=median_EDP_2.*exp(0.5.*sigma_lnEDP_2.^2)


figure;
subplot(2,1,1)
plot(median_EDP_1,IM_1(:,1),'k','linewidth',2,'DisplayName','Mediana')
box on
ylabel('Median EDP'),xlabel('Sa [g]'),title('Curvas IDA Sistema 1')

subplot(2,1,2)
plot(sigma_lnEDP_1,IM_1(:,1),'b','linewidth',2,'DisplayName','\sigma_lnEDp')
ylabel('\sigma_{lnEDP}'),xlabel('Sa [g]'),title('Curvas IDA Sistema 1')
box on

figure;
subplot(2,1,1)
plot(median_EDP_2,IM_2(:,1),'k','linewidth',2,'DisplayName','Mediana')
box on
ylabel('Median EDP'),xlabel('Sa [g]'),title('Curvas IDA Sistema 2')

subplot(2,1,2)
plot(sigma_lnEDP_2,IM_2(:,1),'b','linewidth',2,'DisplayName','\sigma_lnEDp')
ylabel('\sigma_{lnEDP}'),xlabel('Sa [g]'),title('Curvas IDA Sistema 2')
box on

figure;
subplot(2,1,1)
plot(median_EDP_1,IM_1(:,1),'k','linewidth',2,'DisplayName','Mediana')
box on
hold on
plot(mu_EDP_1,IM_1(:,1),'--k','linewidth',2,'DisplayName','Media')
ylabel('EDP'),xlabel('Sa [g]'),title('Curvas IDA Sistema 1')


subplot(2,1,2)
plot(median_EDP_2,IM_2(:,1),'k','linewidth',2,'DisplayName','Mediana')
box on
hold on
plot(mu_EDP_2,IM_2(:,1),'--k','linewidth',2,'DisplayName','Media')
ylabel(' EDP'),xlabel('Sa [g] '),title('Curvas IDA Sistema 2')



%% PARTE 4


x=[0:0.05:1.5];
P1=normcdf((log(x)-mu_lnEDP_1(11))/sigma_lnEDP_1(11))*100;
P2=normcdf((log(x)-mu_lnEDP_2(11))/sigma_lnEDP_2(11))*100;
P1_exc=100-P1
P2_exc=100-P2
figure;
subplot(2,1,1)
plot(x,P1,'-ok')
xlim([0 1])
xticks([0:0.05:1])
subplot(2,1,2)
plot(x,P2,'-ok')
xlim([0 0.25])
xticks([0:0.05:1.5])

% media=0.614;
% disp=0.51;
% sigma1=sqrt(log((disp/media)^2+1))
% mu1=log(media)-0.5*disp^2;
% x=[0:0.01:3];
% p=logncdf(x,mu1,disp);
% loyolagray = 1/450*[200,200,200];
% figure
% hold on
% plot(x,p,'Color', loyolagray)
% plot(x(26),p(26),'o')
% grid on
% xlabel('\delta [m]')
% ylabel('p[\delta>0.25 [m] | IM= 1g]')
% legend('CDF Lognormal',strcat('p[\delta>0.25 [m] | IM= 1g] = ', num2str(p(26))))

%%           PROBABILIDAD DE TENER SOBRE 25 cm EN 1g - estructura 2

% media=0.057;
% disp=0.504;
% sigma1=sqrt(log((disp/media)^2+1))
% mu1=log(media)-0.5*disp^2;
% x=[0:0.001:0.26];
% p=logncdf(x,mu1,disp);
% loyolagray = 1/450*[200,200,200];
% figure
% hold on
% plot(x,p,'Color', loyolagray)
% plot(x(251),p(251),'o')
% grid on
% xlabel('\delta [m]')
% ylabel('p[\delta>0.25 [m] | IM= 1g]')
% legend('CDF Lognormal',strcat('p[\delta>0.25 [m] | IM= 1g] = ', num2str(p(251))))
