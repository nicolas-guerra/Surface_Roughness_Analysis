function [m f] = radialMean(A, fx, fy)
% Credit: Nakhoda, Kashmira “Prediction of the BRDF with Microfinish Topographer Roughness
% Measurements” University of Arizona, 2013

%% Definition: radialMean calculates the azimuthal average of a 2D PSD
%%Input arguments
% A is the map of size [Ny,Nx] that needs to be azimuthally averaged,
% making sure Ny and Nx are odd values
% fx is a vector of length ceil(Nx/2)representing the x-axis in Cartesian coordinates
% fy is a vector of length ceil(Ny/2)representing the y-axis in Cartesian coordinates
%% Output arguments
% f is a vector of length L=sqrt(length(fx)^2+length(fy)^2)
% m is a vector of same length as f representing the result of the
% azimuthal average as a function of f
s = size(A);
N = floor(sqrt((s(1)/2).^2+(s(2)/2).^2));
f = linspace(0, sqrt(max(fx).^2+max(fy).^2), N);
Fy = [-fliplr(fy(2:end)) fy];
Fx = [-fliplr(fx(2:end)) fx];
[U V] = meshgrid(Fx,Fy);
F = sqrt(U.^2+V.^2);
m = zeros(length(f)-1, 1);
K = ones(size(A));
% Azimuthal averaging of map A
for i=2:length(f)
n = sum(sum(K(and(F>=f(i-1),F<f(i)))));
e = sum(sum(A(and(F>=f(i-1),F<f(i)))));
m(i-1) =e/n;
end
f = (f(2:end) + f(1:end-1))/2;
