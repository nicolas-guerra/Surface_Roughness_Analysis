clf;
clear;
%REPLACE BELOW WITH YOUR ROUGHNESS DATA
load sislice.txt
x = [];
for i = 1:length(sislice)
    x = [x sislice(i, :)];
end
fs = 1; %one measurement taken at each micron
N = length(x);
X = fft(x);
X_mag = abs(X); %magnitude of fft
%scaled magnitude by dividing (since we just want the first half, second
%half is redundant) the first half of the X_mag by half the length of the
%full X_mag.
X_mag = X_mag(1:length(X_mag)/2)/(length(X_mag)/2);
new_bins = 0:length(X_mag(1:length(X)/2))-1;
f_new = new_bins/N*fs;

figure(1)
loglog(f_new, X_mag);
xlabel('frequency 1/um')
ylabel('magnitude m')
title('FFT of silicon')
%recall f = bin_num/N*fs
%middle of full X_mag always corresponds to half fs

figure(2)
loglog(f_new, (X_mag.^2)); %PSD method from IDL (PSD = A^2/2 = F^2)
title('PSD loglog');
xlabel('frequency 1/um');
ylabel('PSD m^2');

%%%%%%%%%%%%%%%%%%%%%%%%%IDL DATA%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%REPLACE psd4.txt WITH YOUR DATA NAME
load psd4.txt
%PSD done by idl from silicon slice taken at (1:8025, 1000)
%smoothed with width of 4 by idl
PSD = [];
%REPLACE psd4 WITH DATA NAME FROM ABOVE
for i = 1:length(psd4)
    %REPLACE psd4 WITH DATA NAME FROM ABOVE
    PSD = [PSD psd4(i, :)];
end
PSD = PSD(1:end -1);
bins = 1:length(PSD);
%size of roughness data (different from above because slice different) 
%REPLACE N WITH SIZE DATA YOU TOOK FFT_POWERSPECTRUM OF
N = 8025; 
f = bins/N*fs; %changes from bins to frequency 1/um
f = f/1000; %now 1/nm

%plot PSD by itself
figure(3)
loglog(f,PSD);
title('IDL PSD loglog');
xlabel('frequency 1/nm');
ylabel('PSD m^2');

%get k and n
% b(1),a = k
% b(2),b = n
workspace;
format long g;
format compact;
fontSize = 20;
figure(4)
loglog(f, PSD, 'b', 'LineWidth', 1, 'MarkerSize', 15);
grid on;
hold on;

%q is frequency
modelfun = @(b,q) b(1)./(q.^b(2));
%initial predictions
a = 1.8596e-29;
b = 1.77;
beta0 = [a,b];
%start from 7th index to get rid of outliers in beginning
[coefficients,resnorm,~,exitflag,output] = lsqcurvefit(modelfun, beta0, f(7:end), PSD(7:end));
loglog(f, coefficients(1)./(f.^coefficients(2)), 'r*');
xlabel('frequency 1/nm');
ylabel('PSD m^2')
legend('Experimental Data', 'Model')

k = coefficients(1);
n = coefficients(2);

%get k2d and n2d assuming isotropic surface
k2d = (gamma((n+1)/2)/(2*gamma(1/2)*gamma(n/2)))*k;
n2d = n + 1;

k2d = round(k2d * 1e35)/1e35
n2d = round(n2d * 1e5)/1e5

titulo = sprintf('log-log PSD Comparison (k2d = %.3e m^4, n2d = %.3f)', k2d, n2d);
title(titulo)
hold off

%we want (off for official)
noff = 1.77;
%k2doff = 4.31e-30 m^4
koff = (4.31e-30*2*gamma(1/2)*gamma(noff/2))/gamma((noff+1)/2);