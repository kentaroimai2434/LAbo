clear;
clc;
Z=zeros(150,150);%ƒ‰ƒ“ƒ_ƒ€‚ÉÚ‘±‚·‚éêŠ
for z=1:1:4500% 20%‚¾‚¯Ú‘±
    rr=randi(150,1);%150‚Ì”‚©‚çƒ‰ƒ“ƒ_ƒ€‚Éˆê‚Â
    rrr=randi(150,1);
    Z(rr,rrr)=1;
end
%save('CONEX.mat','Z');