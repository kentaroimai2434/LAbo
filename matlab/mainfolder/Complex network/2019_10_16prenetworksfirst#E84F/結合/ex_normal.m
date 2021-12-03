clc;
clear;
rng(0,'twister');
a = 5;
b = 0;
y = a.*randn(1000,1) + b;
stats = [mean(y) std(y) var(y)]