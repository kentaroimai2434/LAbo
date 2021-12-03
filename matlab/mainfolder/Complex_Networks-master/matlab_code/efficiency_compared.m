clc;
clear;
close all;
warning off;

figure;
load A_random\atrack3.mat
plot(Pset,Eg,'b','linewidth',2);
hold on
load B_scalefree\atrack3.mat
plot(Pset,Eg,'r','linewidth',2);
hold on
load C_С����\atrack3.mat
plot(Pset,Eg,'k','linewidth',2);
hold on
load D_NWС����\atrack3.mat
plot(Pset,Eg,'g','linewidth',2);
hold on
load E_�Ľ��ṹ����\atrack3.mat
plot(Pset,Eg,'m','linewidth',2);
hold on

legend('�������','�ޱ������','WSС��������','NWС��������','�Ľ���С����+�ޱ��ͳһ�ṹģ��');
xlabel('p = fraction of removed nodes'); 
ylabel('efficiency'); 
axis([0,1,0,0.5]);