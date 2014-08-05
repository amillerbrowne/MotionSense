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

//int brightnessMax = 255;
//int brightnessMin = 0;

//for dimming - rotating within a compass direction

- (void)viewDidLoad
{
    [super viewDidLoad];
    _table.image = [UIImage imageNamed:@"compassTable1.png"];
    
    self.motionManager = [[CMMotionManager alloc] init];
    //[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(getColor:) userInfo:nil repeats:YES];
    self.motionManager.accelerometerUpdateInterval = 0.05;  // 20 Hz = .05 = 20 times a second
    [self.motionManager startAccelerometerUpdates];
    
    
    //[self getColorTemp];
    
    //compass using magnetic
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
        //self.brightnessLabel.text = @"Dimmest";
        [[UIScreen mainScreen] setBrightness:0.0];
    }
    
    else if ((degrees >= 239 && degrees < 275) || (degrees >= 72 && degrees < 108)){
        //self.brightnessLabel.text = @"Dimmer";
        [[UIScreen mainScreen] setBrightness:0.2];
    }
    else if ((degrees >= 275 && degrees < 311) || (degrees >= 108 && degrees < 144)){
        //self.brightnessLabel.text = @"Normal";
        [[UIScreen mainScreen] setBrightness:0.5];
    }
    else if ((degrees >= 311 && degrees < 347) || (degrees >= 144 && degrees < 180)){
        //self.brightnessLabel.text = @"Brighter";
        [[UIScreen mainScreen] setBrightness:0.8];
    }
    else if ((degrees >= 347 && degrees < 360) || (degrees >= 0 && degrees < 36 )|| (degrees >= 180 && degrees < 203)){
        //self.brightnessLabel.text = @"Brightest";
        [[UIScreen mainScreen] setBrightness:1.0];
    }
    

}


-(void) getColor:(NSTimer *) timer {
    //if (!self.motionManager.isAccelerometerActive) {
        //[self.motionManager.startAccelerometerUpdatesToQueue: [NSOperationQueue queue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error)]{
    
   /* switch (self.interfaceOrientation) {
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
 

    self.accelX.text = [NSString stringWithFormat:@"%.4f",self.motionManager.accelerometerData.acceleration.x];
    
    self.accelY.text = [NSString stringWithFormat:@"%.4f",self.motionManager.accelerometerData.acceleration.y];
    self.accelZ.text = [NSString stringWithFormat:@"%.4f",self.motionManager.accelerometerData.acceleration.z];
    
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

    
    //start of color temp readings
    
    if (ax == -1.0 && ay == 0.0 && az == 0.0){
        NSString * phonePosition = @"Warm: 2700K";
        self.colorTemp.text = phonePosition;
    }
    else if (ax == 0.08 && ay == -0.58 && az == -0.81){
        NSString * phonePosition = @"Halogen: 3000K";
        self.colorTemp.text = phonePosition;
    }
    else if (ax == -0.0 && ay == -0.15 && az == -1.0){
        NSString * phonePosition = @"Natural White: 4000K";
        self.colorTemp.text = phonePosition;
    }
    else if (ax == 0.19 && ay == 0.4 && az == -0.89){
        NSString * phonePosition = @"Day White: 5700K";
        self.colorTemp.text = phonePosition;
    }
    else if (ax == 0.04 && ay == 0.6 && az == -0.8){
        NSString * phonePosition = @"Warm: 7000K";
        self.colorTemp.text = phonePosition;
    }
}


/*NSRange warmRange = NSMakeRange(2700, 3199);
NSRange halogenRange = NSMakeRange(3200, 3999);
NSRange naturalRange = NSMakeRange(4000, 4500);
NSRange dayRange = NSMakeRange(5700, 6000);
NSRange warmRange = NSMakeRange(7000, 7500);
*/

/*
    
    
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
    }*/



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//start recording again
- (IBAction)stopButton:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSString *title=btn.titleLabel.text;
    if ([title isEqualToString:@"Stop"])
    {
        [self.motionManager stopAccelerometerUpdates];
        [self.locationManager stopUpdatingHeading];
        [self.locationManager stopUpdatingLocation];
        //[stopButton setText:@"Release Position"];
        
    }
}

- (IBAction)startButton:(id)sender {
    UIButton *btn = (UIButton *)sender;
    NSString *title=btn.titleLabel.text;
    if([title isEqualToString:@"Start"])
    {
        [self.motionManager startAccelerometerUpdates];
        [self.locationManager startUpdatingHeading];
        [self.locationManager startUpdatingLocation];
        //[stopButton setText:@"Hold Position"];
        
    }

}
@end
