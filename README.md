# NoiseEstimationGUI
A MATLAB GUI, where a picture is imported and then a noise type is added to the picture in which then a portion of the picture is selected to plot the its histogram distribution and probability density function.


-----
The file `NoiseEstimator.mlapp` contains the MATLAB GUI file. <br>
The file `code.m` contains the code implemented. <br> <br>

## The App

![guss](https://user-images.githubusercontent.com/108863344/195920442-8e868bfe-8715-4aac-80dc-2b7e6584da45.png) <br> <br>

> First select the type of noise, where: <br>
* Normal is no noise added
* or Guassian noise added
* or Salt & Pepper noise added
> Select **Read Image** to add an image of your choice to add noise to. <br> <br>
> Select **Crop Image** to choose a portion of the image or the whole image to calculate the Histogram and PDF. <br> <br>
> Finally, click on **Histogram** button to: <br>
* View the Histogram and PDF graphs
* Type of distribution
* Mean
* Variance
* Standard Deviation
