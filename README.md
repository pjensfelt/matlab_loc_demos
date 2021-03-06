# Matlab localization demos
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

Make sure that you understand the how the update part of the EKF works. Whines lines in the code are connected to this?

### Disturbances
The extended Kalman filter linearises the model around the current estimate. The Jacobians are evaluated for this points and they together with the state covariance matrix P determine how to calculate the Kalman K gain, which describes how measurements will influence the state estimate. 

Start with
* activate all landmarks 
* Use 1m std dev noise in range and no bearings
* Reset the robot and drive it around a bit

Now press the button "Disturb" which will displace the robot randomly. How well does the robot find its pose again?

What happens if you increase the uncertainty by injecting some noise by pressing "Inject"?

What happens with different setting for the measurements?

### Global localization

In many practical applications the robot has no way of knowing where it starts and thus starts with complete uncertainty, corresponding to a uniform probability distribution. We call this problem global localization. Investigate how well the EKF works to deal with this problem by pressing the "Uniform" button.

## MCL.m - Monte Carlo Localization
This program implements a particile filter for localization, usually referred to as Monte Carlo Localization.

In the particle filter the probability distribution is presented by a set of particles. Each particle encodes a state and it also has an associated weight. You can look at the partcile set with or without color codes corresponding to the weight, you control this with the button "Color".

You can change the number of particles used with a drop down meny.

### Pure prediction

Repeat the experiment from the EKF but now with the particle filter. 

Make sure that you understand which part of the code that implements the prediction in the particle filter.

The particle filter can presents any distribution given enough samples. Use this fact to investigate how well (visually) the Gaussian assumption that is made in the EKF holds.


### Investigate the likelihood function

The likelihood function tells us how likely a certain measurement is given a state, p(z|x). The particle filter gives us a nice way to visuale this. 

Start by:
* Deactiviate all but one landmark
* Deactivate bearing measurements and use 1m std dev for range measurements
* Ensure that "Color" is selected
* Select 10000 particles
* Click "Uniform" to spread the particles uniformly over the state space.

How do you expect the distribution to look if you use one range measurements? Check by clicking "Update" once.

How would you expect the distribution to look of you use two different raneg measurement? Check! (press uniform first if you want to clean things)

What if you use a single landmark measurement (directly after pressing "Uniform")?

What happens if you use two range measurments wirth a single update and then start moving without measurements? Why?

### Pose tracking

Repeat experiments from EKF

### Disturbances

Repeat experiments from EKF

### Global localization

Repeat experiments from EKF


## Questions

### Simulation and actual filter
The code in EKF. and MCL.m provide both simulation and the actual localization. Which parts of the code belong to which?

### Data association
In the examples above we assumed that we knew at all times what landmarks we measuremed. This can be implemented in practice if we have a way to distinguish one landmark from the other, for example, using appearance or a radio signature. However, there are plenty of cases where you cannot tell one landmark from another. How would you change the examle program abvove to deal with this?

### IMU
How would you incorporate information from an IMU into the filter?

### Other measurements
In EKF.m and MCL.m we use point landmarks. How would you change the code to use
* Line segments? What does the measurement model look like?
* Raw laser scans? Represented how? Measurement model?


