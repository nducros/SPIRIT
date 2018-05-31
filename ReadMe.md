# SPIRiT
*Single-Pixel Image Reconstruction Toolbox (SPIRiT)
Version 2.0, 29th April 2018.*

This package contains Matlab scripts and functions that simulate the acquisition and reconstruction of an image with a single-pixel camera.

## Content of version 2.0
SPIRiT 2.0 implements:
  - the ABS-WP acquisition method described in [1].
  - the SNMF pattern generalization method described in [2].

Two main scripts are provided: 
   - `main_abswp_simulation.m` that simulates data acquisition
   - `main_abswp_experimental.m` that processes experimental data

The `.\function\` folder contains all the functions called in the main scripts. 
> **Note:** Running one of the main scripts will automatically add the function folder to your Matlab search path.

The `.\data\` folder contains:
   - three PNG images that can be reconstructed by `main_abswp_simulation.m`
    - two experimental datasets (MAT-files) that can be processed by `main_abswp_simulation.m`. See `.\data\Readme.txt` for details about the datasets.

The `.\reference\` folder contains the references [1] and [2].

## New Features!
  - Help & documentation. Check it out!
```
help spiritopt
```
  - SNMF-based solver for pattern generalization 
```
help cnsnmf
```

## Installation
SPIRiT requires the following toolboxes to run:
   - [Image Processing Toolbox](https://fr.mathworks.com/products/image.html) (MathWorks)
   - [Statistics and Machine Learning Toolbox](https://fr.mathworks.com/products/statistics.html) (MathWorks), to corrupt data with Poisson noise
   - [Wavelab850](http://statweb.stanford.edu/~wavelab/). 
> **Note:** Make sure Wavelab850 appears at the top of your search path to avoid conflits

## Contact
nicolas.ducros@insa-lyon.fr, University of Lyon, France.

## License
SPIRiT is distributed freely under Creative Commons Attribution-ShareAlike 4.0 International license ([CC-BY-SA 4.0](http://creativecommons.org/licenses/by-sa/4.0/)) 

## References
[1] F. Rousset et al., "Adaptive basis scan by wavelet prediction for single-pixel imaging", IEEE Transactions on Computational Imaging, 3, 36-46, 2017. 
http://dx.doi.org/10.1109/TCI.2016.2637079
https://hal.archives-ouvertes.fr/hal-01314314v2/document
   
[2] F. Rousset et al., "A semi nonnegative matrix factorization technique for pattern generalization in single-pixel imaging", IEEE Transactions on Computational Imaging, in press
https://doi.org/10.1109/TCI.2018.2811910
https://hal.archives-ouvertes.fr/hal-01635461/document