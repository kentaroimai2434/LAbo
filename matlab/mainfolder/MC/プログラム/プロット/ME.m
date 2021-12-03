clear;
clc;
fileID =fopen('LEWS.tex','r');
formatspac='%f';
LE=fscanf(fileID,formatspac);
fclose(fileID);
fileID =fopen('MCWS.tex','r');
formatspac='%f';
MC=fscanf(fileID,formatspac);
fclose(fileID);
figure(1);
plot(LE,MC,'+b');
set(gca,'xlim',[-1,0.4]);
set(gca,'ylim',[0,100]);
xlabel('LE');
ylabel('MC');
%%
Me=[LE,MC];

%%
for k=1:1:11
mlc(k,1)=mean(Me(((k/k)*(k-1)*110+1:1:k*110),1));
mlc(k,2)=mean(Me(((k/k)*(k-1)*110+1:1:k*110),2));
end
%%
figure(1)
plot(mlc(:,1),mlc(:,2),'+b')
set(gca,'xlim',[-1,0.4]);
set(gca,'ylim',[0,100]);
xlabel('LE');
ylabel('MC');
%%

fileID = fopen('LEmlcSWESN_makey.tex','a');
fprintf(fileID,'%f\n',mlc(:,1));
fclose(fileID);
fileID = fopen('MCmlcSWESN_makey.tex','a');
fprintf(fileID,'%f\n',mlc(:,2));
fclose(fileID);
%%
fileID =fopen('LEmlcESN_makey.tex','r');
formatspac='%f';
LE=fscanf(fileID,formatspac);
fclose(fileID);
fileID =fopen('MCmlcESN_makey.tex','r');
formatspac='%f';
MC=fscanf(fileID,formatspac);
fclose(fileID);
figure(1)
plot(LE,MC,'sb','MarkerSize',11)
set(gca,'xlim',[-1,0.4]);
set(gca,'ylim',[0,100]);
xlabel('LE');
ylabel('MC');
fileID =fopen('LEmlcSHESN_makey.tex','r');
formatspac='%f';
LE=fscanf(fileID,formatspac);
fclose(fileID);
fileID =fopen('MCmlcSHESN_makey.tex','r');
formatspac='%f';
MC=fscanf(fileID,formatspac);
fclose(fileID);
hold on
figure(1)
plot(LE,MC,'dr','MarkerSize',11)
set(gca,'xlim',[-1,0.4]);
set(gca,'ylim',[0,100]);
xlabel('LE');
ylabel('MC');
fileID =fopen('LEmlcSFESN_makey.tex','r');
formatspac='%f';
LE=fscanf(fileID,formatspac);
fclose(fileID);
fileID =fopen('MCmlcSFESN_makey.tex','r');
formatspac='%f';
MC=fscanf(fileID,formatspac);
fclose(fileID);
hold on
figure(1)
plot(LE,MC,'^g','MarkerSize',11)
set(gca,'xlim',[-1,0.4]);
set(gca,'ylim',[0,100]);
xlabel('LE');
ylabel('MC');
fileID =fopen('LEmlcSWESN_makey.tex','r');
formatspac='%f';
LE=fscanf(fileID,formatspac);
fclose(fileID);
fileID =fopen('MCmlcSWESN_makey.tex','r');
formatspac='%f';
MC=fscanf(fileID,formatspac);
fclose(fileID);
hold on
figure(1)
grid on
plot(LE,MC,'vk','MarkerSize',11)
set(gca,'xlim',[-1,0.4]);
set(gca,'ylim',[0,100]);
xlabel('LE');
ylabel('MC');
legend('ESN','SHESN','SFESN','SWESN');