% -- Assignment 2
% --Sofia Kafritsa Georganta
clc;
clear;
close all;



%img = imread('fishes.jpg');
%img = imread('dots.jpg');
%img = imread('sunflowers.jpg');
%img = imread('escher.jpg');

img = im2double(rgb2gray(img));

sigma = 1.8;

k = sqrt(2); 
levels = 10;

%threshold = 0.003; %fishes, dots
%threshold = 0.015;  %sunflowers
%threshold  = 0.045;  %escher

detect_blobs(img,sigma,k,levels,threshold,1);
detect_blobs(img,sigma,k,levels,threshold,2);

