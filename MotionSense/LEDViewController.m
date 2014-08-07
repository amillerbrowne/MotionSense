//
//  LEDViewController.m
//  MotionSense
//
//  Created by Alexandra Miller-Browne on 7/31/14.
//  Copyright (c) 2014 Boston University. All rights reserved.
//

#import "LEDViewController.h"
#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>


@interface LEDViewController ()

@end

@implementation LEDViewController



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.motionManager = [[CMMotionManager alloc] init];
    
    //calls accelerometer, gyroscope updates
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(getColor:) userInfo:nil repeats:YES];
    
    //accelerometer
    self.motionManager.accelerometerUpdateInterval = 0.05;  // 20 Hz = .05 = 20 times a second
    [self.motionManager startAccelerometerUpdates];
    
    //gyroscope
    self.motionManager.gyroUpdateInterval = 0.05;  // 20 Hz
    [self.motionManager startGyroUpdates];

    
    //compass
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingHeading];
    [self.locationManager startUpdatingLocation];
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
    self.compassDegrees.text = [NSString stringWithFormat:@"%.0f", newHeading.magneticHeading];
    NSString * mHeading = self.compassDegrees.text;
    NSInteger degrees = [mHeading integerValue];

    
    if ((degrees >= 203 && degrees < 239) || (degrees >= 36 && degrees < 72)){
        self.brightnessLabel.text = @"Dimmest";
        
        /*
         an option to count through degree values, updates compass readings slower
         
         for(int i = 0;i < 51;i++){
            count = count + 1;
            NSLog(@"count = %d", count);
            NSLog(@"i = %d", i);
        }*/
    }
    
    else if ((degrees >= 239 && degrees < 275) || (degrees >= 72 && degrees < 108)){
        self.brightnessLabel.text = @"Dimmer";
    }
    else if ((degrees >= 275 && degrees < 311) || (degrees >= 108 && degrees < 144)){
        self.brightnessLabel.text = @"Normal";
    }
    else if ((degrees >= 311 && degrees < 347) || (degrees >= 144 && degrees < 180)){
        self.brightnessLabel.text = @"Brighter";
    }
    else if ((degrees >= 347 && degrees < 360) || (degrees >= 0 && degrees < 36 )|| (degrees >= 180 && degrees < 203)){
        self.brightnessLabel.text = @"Brightest";
    }
    

}


-(void) getColor:(NSTimer *) timer {
    

    //acceleration readings for color control
    
    self.accelX.text = [NSString stringWithFormat:@"%.4f",self.motionManager.accelerometerData.acceleration.x];
    
    self.accelY.text = [NSString stringWithFormat:@"%.4f",self.motionManager.accelerometerData.acceleration.y];
    self.accelZ.text = [NSString stringWithFormat:@"%.4f",self.motionManager.accelerometerData.acceleration.z];
    
    //convert to integer values to put in if/else statements
    NSString * accelerationX = self.accelX.text;
    NSString * accelerationY = self.accelY.text;
    NSString * accelerationZ = self.accelZ.text;
    NSInteger ax = [accelerationX  integerValue];
    NSInteger ay = [accelerationY  integerValue];
    NSInteger az = [accelerationZ  integerValue];
   
    if (ax == 0.0 && ay == -1.0 && az == 0.0){
        //Vertical Upright Position
        NSString * phonePosition = @"Red";
        _positionForColors.textColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:1.0];
        self.positionForColors.text = phonePosition;
    }
    else if (ax == 1.0 && ay == 0.0 && az == 0.0){
        //Landscape Left
        NSString * phonePosition = @"Blue";
        self.positionForColors.text = phonePosition;
        _positionForColors.textColor = [UIColor colorWithRed:0 green:0 blue:255 alpha:1.0];
        
    }
    else if (ax == -1.0 && ay == 0.0 && az == 0.0){
        //Landscape Right
        NSString * phonePosition = @"Green";
        self.positionForColors.text = phonePosition;
        _positionForColors.textColor = [UIColor colorWithRed:0 green:255 blue:0 alpha:1.0];
    }
    else if (ax == 0.0 && ay == 1.0 && az == 0.0){
        //Upside Down
        NSString * phonePosition = @"Amber";
        self.positionForColors.text = phonePosition;
        _positionForColors.textColor = [UIColor colorWithRed:255 green:194 blue:0 alpha:1.0];
    }
    
    else {
        NSString * phonePosition = @"No Color";
        self.positionForColors.text = phonePosition;
    }

    
    /*
     alternate way of doing color readings
     switch (self.interfaceOrientation) {
        case UIInterfaceOrientationLandscapeLeft:
            _positionForColors.textColor = [UIColor colorWithRed:255 green:0 blue:0 alpha:1.0];
            self.positionForColors.text = @"Red";
            break;
        case UIInterfaceOrientationLandscapeRight:
            _positionForColors.textColor = [UIColor colorWithRed:0 green:0 blue:255 alpha:1.0];
            self.positionForColors.text = @"Blue";
            break;
        case UIInterfaceOrientationPortrait:
            _positionForColors.textColor = [UIColor colorWithRed:0 green:255 blue:0 alpha:1.0];
            self.positionForColors.text = @"Green";
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            _positionForColors.textColor = [UIColor colorWithRed:255 green:194 blue:0 alpha:1.0];
            self.positionForColors.text = @"Amber";
            break;
     }*/

    
    
    //gyroscope readings for color temp control
    
    self.gyroscopeX.text = [NSString stringWithFormat:@" %.2f",self.motionManager.gyroData.rotationRate.x];
    self.gyroscopeY.text = [NSString stringWithFormat:@" %.2f",self.motionManager.gyroData.rotationRate.y];
    self.gyroscopeZ.text = [NSString stringWithFormat:@" %.2f",self.motionManager.gyroData.rotationRate.z];
    
    NSString * gyrosX = self.gyroscopeX.text;
    NSString * gyrosY = self.gyroscopeY.text;
    NSString * gyrosZ = self.gyroscopeZ.text;
    NSInteger gx = [gyrosX  integerValue];
    NSInteger gy = [gyrosY  integerValue];
    NSInteger gz = [gyrosZ  integerValue];
    

    //start of color temp readings (suggested but not tested)
    
    if (gx == 0.0 && gy == -0.2 && gz == -1.0){
        //Flat Up
        NSString * phonePosition = @"Warm: 2700K";
        self.colorTemp.text = phonePosition;
    }
    else if (gx == 0.0 && gy == -0.5 && gz == 0.0){
        NSString * phonePosition = @"Halogen: 3000K";
        self.colorTemp.text = phonePosition;
    }
    else if (gx == 0.0 && gy == 0.0 && gz == 0.0){
        NSString * phonePosition = @"Natural White: 4000K";
        self.colorTemp.text = phonePosition;
    }
    else if (gx == 0.01 && gy == 0.2 && gz == 0.0){
        NSString * phonePosition = @"Day White: 5700K";
        self.colorTemp.text = phonePosition;
    }
    else if (gx == 0.0 && gy == 0.5 && gz == 0.0){
        NSString * phonePosition = @"Cool White: 7000K";
        self.colorTemp.text = phonePosition;
    }
}


/*
 [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(1,9)];
NSRange warmRange = NSMakeRange(2700, 3199);
NSRange halogenRange = NSMakeRange(3200, 3999);
NSRange naturalRange = NSMakeRange(4000, 4500);
NSRange dayRange = NSMakeRange(5700, 6000);
NSRange warmRange = NSMakeRange(7000, 7500);
*/




- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//stop displaying info
- (IBAction)stopButton:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSString *title=btn.titleLabel.text;
    if ([title isEqualToString:@"Stop"])
    {
        [self.motionManager stopAccelerometerUpdates];
        [self.locationManager stopUpdatingHeading];
        [self.locationManager stopUpdatingLocation];
        [self.motionManager stopGyroUpdates];
        //[stopButton setText:@"Release Position"];
        
    }
}

//start displaying info again
- (IBAction)startButton:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSString *title=btn.titleLabel.text;
    if([title isEqualToString:@"Start"])
    {
        [self.motionManager startAccelerometerUpdates];
        [self.locationManager startUpdatingHeading];
        [self.locationManager startUpdatingLocation];
        [self.motionManager startGyroUpdates];
        //[stopButton setText:@"Hold Position"];
        
    }

}
@end
