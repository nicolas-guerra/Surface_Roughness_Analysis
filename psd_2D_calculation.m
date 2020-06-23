function [f psdm] =psd_2D_calculation(M1,px,py,lambda)
%% Definition:
%psd_2D_calculation calculates a 2D PSD azimuthally averaged of an isotropic surface
%map as a function of spatial frequencies.
%%Input arguments
% M1 is the surface map with Ny rows and Nx columns corrected from Piston,
% Tip/Tilt and Power, each cell gives the surface height in units of waves
% px is a scalar representing the pixel size in x-axis in unit of length(?m)
% py is a scalar representing the pixel size in y-axis in unit of length(?m)
% lambda is a scalar representing the wavelength of the MFT illumination
% system in unit of length (micron)
%% Output arguments
% f is a vector of length sqrt(Nx^2+Ny^2) representing the spatial
% frequencies
% psdm is a vector of the same size as f representing the azimuthally
% averaged 2D PSD in length to the fourth
M=M1*lambda;
[Ny, Nx]=size(M);
% Testing size of the map
if mod(Nx,2) == 0
    Nx= Nx-1;
    M= M(:,1:Nx);
else
    M;
%odd number of columns
end
if mod(Ny,2) == 0
    Ny=Ny-1;
    M= M(1:Ny,:);
else
    M;
%odd number of rows
end
P=px*py/(Nx*Ny)*abs(fftshift(fft2(fftshift(M)))).^2; % 2D PSD calculation
fx=1/(2*px)*linspace(0,1,ceil(Nx/2)); % definition of range of frequencies along x
fy=1/(2*py)*linspace(0,1,ceil(Ny/2)); % definition of range of frequencies along y
[psdm,f]=radialMean(P,fx,fy); %Azimuthal average of the 2D PSD

end