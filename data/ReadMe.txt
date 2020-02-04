--------------------------------------
# Single-Pixel Camera Datasets
Version 1.1, 29th April 2018.
--------------------------------------
Initial release: 1st February 2017.
Current version: 1.1 (comptatible with SPIRiT 2.0).
Last Update: 29 April 2018.

-------------------
General Description
-------------------
We provide experimental datasets that we acquired using a single-pixel camera. The data format allows straighforward reconstruction using the Single-Pixel Image Reconstruction Toolbox (SPIRiT).

-------------------
Content 
-------------------
The Jaszczak target was acquired with two type of wavelet patterns. Two datasets are provided:
   - `Jaszczak_Haar_4_128x128.mat`: 128-by-128 **Haar** patterns are considered. The decomposition level J is set to 4. All the wavelet coefficients have been acquired except the ones at the finest scale j = 1. In total, 64x64 coefficients were acquired with 64x64x2 measurements (positive/negative splitting).
   - `Jaszczak_LeGall_4_128x128.mat`: 128-by-128 **LeGall**'s wavelet (CDF 5/3) patterns are considered. Same parameters as above, i.e., J = 4 and 4 <= j < 1.

Each MAT-file contains:
   - a CCD image of the Jaszczak target (`N`-by-`N` matrix `F`)
   - the acquired wavelet coefficients (`N`-by-`N` matrix `W`)
   - the wavelet decomposition level (scalar `J`)
   - the image size (scalar `N`); the image is assumed to be `N` x `N`
   - the wavelet name (string `wav`) 
   - an additional parameter required for some wavelets (scalar `par`)
   - an affine geometric transformation that maps the SPC image onto the CCD image (structure `tform`)

The datasets were initially published in [1].

-------------------
Experimental setup
-------------------
The experimental setup (Department of Physics, Politecnico di Milano, Italy) was composed of:
   - a supercontinuum pulsed laser source (SC-450, Fianium)
   - an IF filter with center wavelength at 650 nm for uniform illumination of the object
   - a 1024×768 DMD (DLP7000 - V7001, Vialux)
   - a lens
   - a photomultiplier (HPM-100-50, Becker & Hickl GmbH). 

Contact 
cosimo.dandrea@polimi.it, Politecnico di Milano, Italy.
nicolas.ducros@insa-lyon.fr, University of Lyon, France.

-------------------
License
-------------------
SPIRiT is distributed freely under Creative Commons Attribution-ShareAlike 4.0 International license ([CC-BY-SA 4.0](http://creativecommons.org/licenses/by-sa/4.0/)) 

-------------------
References
-------------------
[1] F. Rousset et al., "Adaptive basis scan by wavelet prediction for single-pixel imaging", IEEE Transactions on Computational Imaging, 3, 36-46, 2017. 
http://dx.doi.org/10.1109/TCI.2016.2637079
https://hal.archives-ouvertes.fr/hal-01314314v2/document

	
	
	