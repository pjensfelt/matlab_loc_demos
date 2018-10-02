# matlab_loc_demos
Demos of Extended Kalman Filter and Particle Filter (MCL) for localization developed for demos during lectures

* There are four point landmarks which you can turn on/off. 
* You can control the measurement noise model and you can move the platform around using commands v,w, adjusted by a slider.

Both the EKF and the MCL programs are setup to only use measurements when teh robot has moved a certain distance. This is often good in pratice to avoid the uncertainty reducing too much in a situation where the measurements are often not living up to the requirement that they are independent over time (for exampel due to quantization in sensors). To force an update you can press the button Update

## EKF.m

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

Move the robot around and see how the uncertainty is kept relatively low because of the measurmements. 

Investigate
* how changing the zRhoStd influences this
* add bearing measurmeents as well (slider to the right of the range measurements) and test with these together with rang eor alone


### Disturbances
The extended Kalman filter linearises the model around the current estimate. The Jacobians are evaluated for this points and they together with the state covariance matrix P determine how to calculate the Kalman K gain, which describes how measurements will influence the state estimate. 

Start with
* activate all landmarks 
* Use 1m/s std dev noise in range and no bearings
* Reset the robot and drive it around a bit

Now press the button "Disturb" which will displace the robot randomly. How well does the robot find its pose again?

What happens if you increase the uncertainty by injecting some noise by pressing "Inject"?

What happens with different setting for the measurements?

### Global localization

In many practical applications the robot has no way of knowing where it starts and thus starts with complete uncertainty, corresponding to a uniform probability distribution. We call this problem global localization. Investigate how well the EKF works to deal with this problem by pressing the "Uniform" button.

## MCL.m - Monte Carlo Localization
This program implements a particile filter for localization, usually referred to as 

## Questions

### Data association
In the examples above we assumed that we knew at all times what landmarks we measuremed. This can be implemented in practice if we have a way to distinguish one landmark from the other, for example, using appearance or a radio signature. However, there are plenty of cases where you cannot tell one landmark from another. How would you change the examle program abvove to deal with this?

### Other measurements
In KEF.m and MCL.m we use point landmarks. How would you change the code to use
* Line segments?
* Raw laser scans?
