clear;
clc;
fileID =fopen('LE(-0.05,0.05)SWtest.tex','r');
formatspac='%f';
LE=fscanf(fileID,formatspac);
fclose(fileID);

fileID =fopen('MC(-0.05,0.05)SWtest.tex','r');
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
mlcst(k,1)=std(Me(((k/k)*(k-1)*110+1:1:k*110),1));
mlcst(k,2)=std(Me(((k/k)*(k-1)*110+1:1:k*110),2));
end
%%
figure(1)
plot(mlc(:,1),mlc(:,2),'+b')
set(gca,'xlim',[-1,0.4]);
set(gca,'ylim',[0,100]);
xlabel('LE');
ylabel('MC');
%%
fileID = fopen('LEmlc_stchastic[-0.05,0.05]SW.tex','a');
fprintf(fileID,'%f\n',mlc(:,1));
fclose(fileID);
fileID = fopen('MCmlc_stchastic[-0.05,0.05]SW.tex','a');
fprintf(fileID,'%f\n',mlc(:,2));
fclose(fileID);
fileID = fopen('MCmlcst_stchastic[-0.05,0.05]SW.tex','a');
fprintf(fileID,'%f\n',mlcst(:,1));
fclose(fileID);
fileID = fopen('MCmlcst_stchastic[-0.05,0.05]SW.tex','a');
fprintf(fileID,'%f\n',mlcst(:,2));
fclose(fileID);
%%

fileID =fopen('LEmlc_stchastic[-0.05,0.05].tex','r');
formatspac='%f';
LE=fscanf(fileID,formatspac);
fclose(fileID);
fileID =fopen('MCmlc_stchastic[-0.05,0.05].tex','r');
formatspac='%f';
MC=fscanf(fileID,formatspac);
fclose(fileID);
figure(1)
plot(LE,MC,'sb','MarkerSize',11)
set(gca,'xlim',[-1,0.4]);
set(gca,'ylim',[0,100]);
xlabel('LE');
ylabel('MC');
fileID =fopen('LEmlc_stchastic[-0.05,0.05]SH.tex','r');
formatspac='%f';
LE=fscanf(fileID,formatspac);
fclose(fileID);
fileID =fopen('MCmlc_stchastic[-0.05,0.05]SH.tex','r');
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
fileID =fopen('LEmlc_stchastic[-0.05,0.05]SF.tex','r');
formatspac='%f';
LE=fscanf(fileID,formatspac);
fclose(fileID);
fileID =fopen('MCmlc_stchastic[-0.05,0.05]SF.tex','r');
formatspac='%f';
MC=fscanf(fileID,formatspac);
fclose(fileID);
hold on
figure(1)
plot(LE,MC,'^k','MarkerSize',11)
set(gca,'xlim',[-1,0.4]);
set(gca,'ylim',[0,100]);
xlabel('LE');
ylabel('MC');
fileID =fopen('LEmlc_stchastic[-0.05,0.05]SW.tex','r');
formatspac='%f';
LE=fscanf(fileID,formatspac);
fclose(fileID);
fileID =fopen('MCmlc_stchastic[-0.05,0.05]SW.tex','r');
formatspac='%f';
MC=fscanf(fileID,formatspac);
fclose(fileID);
hold on
figure(1)
plot(LE,MC,'vg','MarkerSize',11)
set(gca,'xlim',[-1,0.4]);
set(gca,'ylim',[0,100]);
xlabel('LE');
ylabel('MC');
legend('ESN','SHESN','SFESN','SWESN');