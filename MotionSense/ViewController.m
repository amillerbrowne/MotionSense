//
//  ViewController.m
//  MotionSense
//
//  Created by Alexandra Miller-Browne on 7/2/14.
//  Copyright (c) 2014 Boston University. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

//#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])

@interface ViewController ()

@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.motionManager = [[CMMotionManager alloc] init];
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(getValues:) userInfo:nil repeats:YES];
    
    self.motionManager.accelerometerUpdateInterval = 0.05;  // 20 Hz = .05 = 20 times a second
    [self.motionManager startAccelerometerUpdates];
    //[self.motionManager stopAccelerometerUpdates];
    
    self.motionManager.gyroUpdateInterval = 0.05;  // 20 Hz
    [self.motionManager startGyroUpdates];
    
    self.motionManager.deviceMotionUpdateInterval = 0.05; // 20 Hz
    [self.motionManager startDeviceMotionUpdates];
    

    //compass using magnetic
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingHeading];
    [self.locationManager startUpdatingLocation];

}
-(void) getValues:(NSTimer *) timer {
    //acceleration values in terms of G's (multiply by 9.8 to get it in m/s^2) - acceleration due to gravity
    self.accX.text = [NSString stringWithFormat:@"%.2f",self.motionManager.accelerometerData.acceleration.x];
    
    self.accY.text = [NSString stringWithFormat:@"%.2f",self.motionManager.accelerometerData.acceleration.y];
    self.accZ.text = [NSString stringWithFormat:@"%.2f",self.motionManager.accelerometerData.acceleration.z];
    NSLog(@"Acceleration x: %@", self.accX.text);
    NSLog(@"Acceleration y: %@", self.accY.text);
    NSLog(@"Acceleration z: %@", self.accZ.text);
    
    //userAcceleration - acceleraton of device not including gravity
    
    
    //NSLog(@"User Acceleration x: %@", self.accX.text);
    //NSLog(@"User Acceleration y: %@", self.accY.text);
    //NSLog(@"User Acceleration z: %@", self.accZ.text);
    
    //orientation in regular terms (maybe make a range of .9-1)
    //acceleration values in 1g correspond to the position of the phone
    NSString * accelX = self.accX.text;
    NSString * accelY = self.accY.text;
    NSString * accelZ = self.accZ.text;
    NSInteger ax = [accelX  integerValue];
    NSInteger ay = [accelY  integerValue];
    NSInteger az = [accelZ  integerValue];

    //try to get this in a range
    
    //orientation using method
    /*
    switch (self.interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            self.orientation.text = @"Landscape Left";
            break;
        case UIInterfaceOrientationLandscapeRight:
            self.orientation.text = @"Landscape Right";
            break;
        case UIInterfaceOrientationPortrait:
            self.orientation.text = @"Portrait";
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            self.orientation.text = @"Upside Down";
            break;
    
    }*/


    if (ax == 0.0 && ay == -1.0 && az == 0.0){
        NSString * phonePosition = @"Vertical Upright Position";
        self.orientation.text = phonePosition;
    }
    else if (ax == 1.0 && ay == 0.0 && az == 0.0){
        NSString * phonePosition = @"Landscape Left";
        self.orientation.text = phonePosition;
    }
    else if (ax == -1.0 && ay == 0.0 && az == 0.0){
        NSString * phonePosition = @"Landscape Right";
        self.orientation.text = phonePosition;
    }
    else if (ax == 0.0 && ay == 1.0 && az == 0.0){
        NSString * phonePosition = @"Upside Down";
        self.orientation.text = phonePosition;
    }
    else if (ax == 0.0 && ay == 0.0 && az == -1.0){
        NSString * phonePosition = @"Flat Up";
        self.orientation.text = phonePosition;
    }
    else if (ax == 0.0 && ay == 0.0 && az == 1.0){
        NSString * phonePosition = @"Flat Down";
        self.orientation.text = phonePosition;
    }
    else {
        NSString * phonePosition = @"Detecting Position...";
        self.orientation.text = phonePosition;
    }
    

     NSLog(@"Orientation: %@", self.orientation.text);
    
    

    //gyroscope - rate of rotation of device in rad/s
    self.gyroX.text = [NSString stringWithFormat:@" %.2f",self.motionManager.gyroData.rotationRate.x];
    self.gyroY.text = [NSString stringWithFormat:@" %.2f",self.motionManager.gyroData.rotationRate.y];
    self.gyroZ.text = [NSString stringWithFormat:@" %.2f",self.motionManager.gyroData.rotationRate.z];
    
    NSLog(@"Rotation Rate in x: %@", self.gyroX.text);
    NSLog(@"Rotation Rate in y: %@", self.gyroY.text);
    NSLog(@"Rotation Rate in z: %@", self.gyroZ.text);
    
    
    
    //Euler angles: yaw, pitch, roll in radians - roll is elevation(yz)
    //longitudinal = z = roll
    //vertical axis = y = yaw
    //lateral = x = pitch
    
    self.roll.text = [NSString stringWithFormat:@"%.2f",(180/M_PI)*self.motionManager.deviceMotion.attitude.roll];
    self.yaw.text = [NSString stringWithFormat:@"%.2f",(180/M_PI)*self.motionManager.deviceMotion.attitude.yaw];
    self.pitch.text = [NSString stringWithFormat:@"%.2f",(180/M_PI)*self.motionManager.deviceMotion.attitude.pitch];
    
    //position?
    self.posX.text = [NSString stringWithFormat:@"%.2f",cos(self.motionManager.deviceMotion.attitude.yaw)*cos(self.motionManager.deviceMotion.attitude.pitch)];
    self.posY.text = [NSString stringWithFormat:@"%.2f",sin(self.motionManager.deviceMotion.attitude.yaw)*cos(self.motionManager.deviceMotion.attitude.pitch)];
    self.posZ.text = [NSString stringWithFormat:@"%.2f",sin(self.motionManager.deviceMotion.attitude.pitch)];
    
    NSLog(@"Position x: %@", self.posX.text);
    NSLog(@"Position y: %.@", self.posY.text);
    NSLog(@"Position z: %@", self.posZ.text);
    

    //zenith = pi/2 - angle of elevation
    //azimuth = rotation about the Z' axis - xy
    //tilt = angle of rotation about the z axis
    
    //could use magnetometer for heading
    self.zenith.text = [NSString stringWithFormat:@"%.2f",(180/M_PI)*((M_PI/2)-self.motionManager.deviceMotion.attitude.roll)];
    self.azimuth.text = [NSString stringWithFormat:@"%.2f", (180/M_PI)*self.motionManager.deviceMotion.attitude.yaw];
    self.tilt.text = [NSString stringWithFormat:@"%.2f",(180/M_PI)*self.motionManager.deviceMotion.attitude.roll];
    
    NSLog(@"Zenith: %@", self.zenith.text);
    NSLog(@"Azimuth: %@", self.azimuth.text);
    NSLog(@"Tilt x: %@", self.tilt.text);
    
    //afternoon wed + morn thurs - log data to file
    //friday - position, azimuth, check file is working, etc
    
    NSLog(self.compass.text, @"degrees");
    NSLog(@"\n");


}



//compass in degrees (with magnetic heading not true north)
-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    self.compass.text = [NSString stringWithFormat:@"%.0f", newHeading.magneticHeading];
    NSString * mHeading = self.compass.text;
    NSInteger degrees = [mHeading integerValue];
    
    if (degrees >= 0 && degrees < 23){
        NSString * north = @"N";
        self.direction.text = north;
    }
    else if (degrees >= 23 && degrees < 68){
        NSString * northeast = @"NE";
        self.direction.text = northeast;
    }
    else if (degrees >= 68 && degrees < 113){
        NSString * east = @"E";
        self.direction.text = east;
    }
    else if (degrees >= 113 && degrees < 158){
        NSString * southeast = @"SE";
        self.direction.text = southeast;
    }
    else if (degrees >=158 && degrees < 203){
        NSString * south = @"S";
        self.direction.text = south;
    }
    else if (degrees >= 203 && degrees < 248){
        NSString * southwest = @"SW";
        self.direction.text = southwest;
    }
    else if (degrees >= 248 && degrees < 293){
        NSString * west = @"W";
        self.direction.text = west;
    }
    else if (degrees >= 293 && degrees < 360){
        NSString * northwest = @"NW";
        self.direction.text = northwest;
    }
    else {
        self.direction.text = @"Detecting Position...";
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

