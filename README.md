# matlab_loc_demos
Demos of EKF and PF developed for demos during lectures

There are four point landmarks which you can turn on/off. You can control the measurement noise model and you can move the platform around using commands v,w, adjusted by a slider.



## EKF
EKF.m

This is the main program to use to play around with Extended Kalman filter based localization. 

### Pure prediction
In this first test we will look at how the uncertainty of the robot increases when we move through the environment

* Make sure that the landmarks are deactivated (L1-L4 are not "pushed")

Use the sliders for v and w to move the robot around. Look at the uncertainty, captured by an ellipse and a "wedge", change as we move. The ellipse represents a level curve from the x,y part of the covariance matrix (a 2D Gaussian) and the wedge shows the variance in the orientation (lower right element in the covariance matrix).

Experiment with modifying the parameters tdStd, rdaStd and rdStd in the file simulation_parameters.m (lines 49-59). They describe how the noise influences the model. The default values were 0.1 for all of them (rather arbitrary).

Make sure that you understand the code in EKF.m that actually does the prediction part. This is in lines 60-75. 

### Position tracking
In this test we will look at how the position is tracked by the filter. 

Start by
* activate all landmarks 
* drag the slider that says "No range" to the far right so that it says "zRhoStd=1m", ie that we have a 1m standard deviation in the range measurements

Move the robot around and see how the uncertainty is kept relatively low because of the measurmements. Investigate
* how changing the zRhoStd influences this
* add bearing measurmeents as well (slider to the right of the range measurements) and with with that and only with that


### Disturbances


### Global localization



## Monte Carlo Localization
MCL.m

