# SPIRiT
*Single-Pixel Image Reconstruction Toolbox (SPIRiT)
Version 2.1, 1st April 2020.*

This package contains Matlab scripts and functions that simulate the acquisition and reconstruction of an image with a single-pixel camera.

## New Features!
  - Recontruction by completion of missing data
  ```
help datcomp
```
  - Fast Hadamard 2D transform
```
help fwht2
```
  - Pre-processing and playing with the STL-10 database
```
help preprocess_stl10
help loadprep_stl10
```

## Content of version 2.1
SPIRiT 2.1 implements:
  * (from v2.1) The Bayesian completion method described in [3]. 
  See `main_completion_stl10.m`.
  * (from v2.0) The SNMF pattern generalization method described in [2].
  See `main_abswp_simulation.m` and `main_abswp_experimental.m`.
  * (from v2.0) The ABS-WP adaptive acquisition method described in [1].
  See `main_abswp_simulation.m` and `main_abswp_experimental.m`.

The `.\function\` folder contains the functions that are called in the above scripts. 
The `.\data\` folder contains:
   - three PNG images that are processed in `main_abswp_simulation.m`
   - two experimental datasets (MAT-files) that can be processed by `main_abswp_experimental.m`. For details, see `.\data\Readme.txt`.

The `.\reference\` folder contains the PDF of [1], [2], and [3].

## Datasets
We provide: 
* A function to preprocess the STL-10 database that can be downloaded at https://ai.stanford.edu/~acoates/stl10/
* Two experimental datasets (Department of Physics, Politecnico di Milano, Italy) of the Jaszczak target acquired using wavelet patterns, initially published in [1]. For details, see `.\data\Readme.txt`.

## Illustration
![main_completion_stl10.png](main_completion_stl10.png "Hadamard acquisition for a 10% sampling ratio (see `main_completion_stl10.m`)")

## Installation
Just make sure to add `.\function\` to your Matlab search path.
```
path(fullfile(pwd,'function'),path);
```
SPIRiT may require one of the following toolboxes to run:
   - [Image Processing Toolbox](https://fr.mathworks.com/products/image.html) (MathWorks)
   - [Statistics and Machine Learning Toolbox](https://fr.mathworks.com/products/statistics.html) (MathWorks), to corrupt data with Poisson noise
   - [Wavelab850](http://statweb.stanford.edu/~wavelab/). 
> **Note:** If required, make sure Wavelab850 appears at the top of your search path to avoid conflits

## Contact
nicolas.ducros@insa-lyon.fr, University of Lyon, France.

## License
SPIRiT is distributed freely under Creative Commons Attribution-ShareAlike 4.0 International license ([CC-BY-SA 4.0](http://creativecommons.org/licenses/by-sa/4.0/)) 

## References
[3] N. Ducros et al., "A completion network for reconstruction from compressed acquisition', IEEE ISBI, 2020.
https://hal.archives-ouvertes.fr/hal-02342766/document

[2] F. Rousset et al., "A semi nonnegative matrix factorization technique for pattern generalization in single-pixel imaging", IEEE Transactions on Computational Imaging, 4(2), 284-294, 2018.
https://doi.org/10.1109/TCI.2018.2811910
https://hal.archives-ouvertes.fr/hal-01635461/document

[1] F. Rousset et al., "Adaptive basis scan by wavelet prediction for single-pixel imaging", IEEE Transactions on Computational Imaging, 3(1), 36-46, 2017. 
http://dx.doi.org/10.1109/TCI.2016.2637079
https://hal.archives-ouvertes.fr/hal-01314314/document