clear;
clf;
load sixwidesilicon.txt
roughness = sixwidesilicon;
[f, PSD] =psd_2D_calculation(roughness,1,1,.570);

%get k and n
% b(1), a = k2d
% b(2), b = n2d
workspace;
format long g;
format compact;
fontSize = 20;
f = f/1000; % now 1/nm
figure(1)
loglog(f, PSD, 'b', 'LineWidth', 1, 'MarkerSize', 15);
title('PSD loglog');
f = f';
grid on;
hold on;

%q is frequency
modelfun = @(b,q) b(1)./(q.^b(2));
a = 4.31e-30;
b = 2.77;
beta0 = [a,b];
%start from 3000th index to get rid of outliers in beginning
[coefficients,resnorm,~,exitflag,output] = lsqcurvefit(modelfun, beta0, f(120:end), PSD(120:end));
% mdl = fitnlm(tbl,modelfun, beta0);
% coefficients = mdl.Coefficients{:, 'Estimate'}
loglog(f, coefficients(1)./(f.^coefficients(2)), 'r*');
xlabel('frequency 1/nm');
ylabel('PSD m^4')
legend('Experimental Data', 'Model')
titulo = sprintf('log-log PSD Comparison (k2d = %.3e m^4, n2d = %.3f)', coefficients(1), coefficients(2));
title(titulo)
hold off;
