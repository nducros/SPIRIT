Single Pixel Image Reconstruction Toolbox (SPIRIT), Version 1.0, 1st February 2017.

-------------------
General Description 
-------------------
This package contains Matlab scripts and functions to simulate the acquisition and reconstruction of an image with a single-pixel camera.
 
-------------------
Content of SPIRIT 1.0
-------------------  
SPIRIT 1.0 implements the ABS-WP technique described in [1].

* Two main scripts are provided : 
    - 'main_abswp_simulation.m' that can process simulated data
    - 'main_abswp_experimental.m' that can process experimental data

* The folder 'function' contains the functions called in the main scripts. Running the main scripts will automatically add the function folder to the Matlab search path.

* The folder 'data' contains :
    - two PNG images that can be reconstructed by main_abswp_simulation.m (simulated data)
    - two experimental datasets (matfile) that can be processed by main_abswp_simulation.m. See the specified 'data/Readme.txt' for more information concerning the datasets.

* The folder 'reference' contains the full text of [1].

A new version of SPIRIT with will be released soon.

-------------------
Toolbox requirement 
-------------------
The following toolboxes are required:
	- Image Processing Toolbox (MathWorks)
	- Wavelab850 (http://statweb.stanford.edu/~wavelab/)
and should be correctly linked. 

The following toolbox might be needed:
	- Statistics and Machine Learning Toolbox (MathWorks), to corrupt data by Poisson noise

-------------------
Contact 
-------------------
nicolas.ducros@insa-lyon.fr, University of Lyon, France.

-------------------
Licence 
-------------------
SPIRIT is given freely under Creative Commons Attribution-ShareAlike 4.0 International license (CC-BY-SA 4.0) http://creativecommons.org/licenses/by-sa/4.0/

-------------------
Reference
-------------------
[1] F. Rousset et al., "Adaptive Basis Scan by Wavelet Prediction for Single-pixel Imaging", IEEE Transactions on Computational Imaging, 2016
    http://dx.doi.org/10.1109/TCI.2016.2637079
	
