%% The Henon Map time series
% Created by Moysis Lazaros.
%
% This is a simple implementation of the Henon
% system. It is a discrete time system that maps a point $(x_n,y_n)$ in the
% following fashion:
%
% $x_{n+1}=1-a x_n^2 + y_n$
%
% $y_{n+1}=b x_n$
%
% where a and b are the system parameters
%% The code
clear;
clc;
a=1.4;    %�G�m���ʑ��p�����[�^
b=0.3;     %�G�m���ʑ��p�����[�^
L=10000;    %����
x(1)=0;
y(1)=0;
%x(2)=1-a*(x(1)^2)+y(1);
%y(2)=b*x(1);
y(2)=0;
z=0.05.*randn(1,L)+0.00000001;    %����
for i=3:L
    %y(i)=b-((a/b)*(y(i-1)^2))+b*y(i-2);  %�G�m�����n��X�V
    y(i)=1-a*(y(i-1)^2)+b*y(i-2);  %����x�̎��n��
end
%% ���ꂼ��̎��n��p�ɒ���
yy=y;
yyy=2*(yy-0.5)+z;        %-0.5�V�t�g��2�{
ly = fncLyapunovExponentsFromTimeSeries(yyy(1:500), 2, 1, 500)
%% �f�[�^�ۑ�
%{

fileID = fopen('Henon_Map_time_series_ex12.tex','w');
fprintf(fileID,'%f\n',yyy);
fclose(fileID);
%}
%% �v���b�g
figure(1)
plot(y(1:200),"-")
figure(2)
histogram(z)
figure(3)
plot(yyy(1:999),yyy(2:1000),".")
xlabel('y(t)')
ylabel('y(t+1)')
figure(4)
plot(yyy,"-")
stats = [mean(z) std(z) var(z)]