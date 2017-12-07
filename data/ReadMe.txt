Single Pixel Camera Datasets

Acquisition: Department of Physics, Politecnico di Milano, Italy
Release: 1st February 2017

-------------------
General Description 
-------------------
Acquisition of the wavelet coefficients of the Jaszczak target using a single-pixel camera setup
 
-------------------
Content 
-------------------  
Two datasets are provided:
    - Jaszczak_Haar_4_128x128.mat : 128x128 Haar patterns are considered. The decomposition level J is set to 4. All the wavelet coefficients have been acquired except the ones at the finest scale j = 1. In total, 64x64 coefficients were acquired with 64x64x2 measurements (positive/negative separation).
    - Jaszczak_LeGall_4_128x128.mat : 128x128 LeGall's wavelet (CDF 5/3) patterns. Same parameters as above, i.e., J = 4 and 4 <= j < 1.

Each data set contains:
    - a CCD image of the Jaszczak image (matrix F)
    - the acquired wavelet coefficients (matrix F_WT)
    - the decomposition level (scalar J)
    - the image size (scalar N); the image is assumed to be N x N
    - the wavelet name (string wavelet_name) 
    - an additional parameter required for some wavelets (scalar par)
	- a registration transform that maps the SPC image to the CCD image (structure tform)

The datasets were initially published in [1]

-------------------
Experimental setup
-------------------
The experimental setup was composed of :
    - a supercontinuum pulsed laser source (SC-450, Fianium)
    - an IF filter with center wavelength at 650 nm for uniform illumination of the object
    - a 1024×768 DMD (DLP7000 - V7001, Vialux)
    - a lens
    - a photomultiplier (HPM-100-50, Becker & Hickl GmbH). 

-------------------
Contact 
-------------------
cosimo.dandrea@polimi.it, Politecnico di Milano, Italy.
nicolas.ducros@insa-lyon.fr, University of Lyon, France.

-------------------
Licence 
-------------------
The data sets are given freely under Creative Commons Attribution-ShareAlike 4.0 International license (CC-BY-SA 4.0) http://creativecommons.org/licenses/by-sa/4.0/

-------------------
Reference
-------------------
[1] F. Rousset et al., "Adaptive Basis Scan by Wavelet Prediction for Single-pixel Imaging", IEEE Transactions on Computational Imaging, 2016
    http://dx.doi.org/10.1109/TCI.2016.2637079
	
	
	
	
	



