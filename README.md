# surface_roughness_analysis
This code takes the roughness of a surface, finds its power spectral density, and fits a power law to its PSD data.

This README file will be used as a set of steps.

1. After measuring the roughness of a surface, save the data as matrix in IDL.
2. Take a slice of the data. (Ex: slice = XY[0:8250,1000])
3. Take the PSD of the data. (Ex: PSD = fft_powerspectrum(slice))
4. Convert that slice and PSD to a .txt file. They should then be in your home directory.
(Ex.
IDL> restore, 'si_pds'
IDL> file = 'slice.txt'
IDL> get_lun, unit
IDL> openw, unit, file
IDL> printf, unit, slice
IDL> close, unit
IDL> free_lun, unit)

5. (Since I was using windows, this is how I downloaded the files locally)
Download the files in windows by opening a cmd window and inputting the following with you credentials.
pscp.exe username@computer.edu:slice.txt C:\Put\Directory\You\Want\It\In

6. Open roughness_analysis.m and change the surface slice data and PSD data with your own.
7. Make sure the x and y axes are consistent.
(recall that the last point in the FFT and PSD should be half of the sampling frequency)
8. You might have to change the starting point of the fit to get rid of influence from outliers.
9. Replace any titles and labels with your own
