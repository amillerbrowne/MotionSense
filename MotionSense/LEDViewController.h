//
//  LEDViewController.h
//  MotionSense
//
//  Created by Alexandra Miller-Browne on 7/31/14.
//  Copyright (c) 2014 Boston University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreMotion/CoreMotion.h>

@interface LEDViewController : UIViewController <CLLocationManagerDelegate>{
    CMMotionManager *motionManager;
    NSOperationQueue *queue;
    IBOutlet UILabel *stopButton;
    IBOutlet UILabel *startButton;
}

@property (strong, nonatomic) IBOutlet UILabel *accelX;
@property (strong, nonatomic) IBOutlet UILabel *accelY;
@property (strong, nonatomic) IBOutlet UILabel *accelZ;

@property (strong, nonatomic) IBOutlet UILabel *positionForColors;

@property (weak, nonatomic) IBOutlet UIImageView *table;
//@property (strong, nonatomic) IBOutlet UILabel *brightnessLabel;
@property (weak, nonatomic) IBOutlet UILabel *compassDegrees;

@property (strong, nonatomic) IBOutlet UILabel *currentColor;
@property (strong, nonatomic) IBOutlet UILabel *colorTemp;

- (IBAction)stopButton:(id)sender;
- (IBAction)startButton:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *stopButton;
@property (strong, nonatomic) IBOutlet UIButton *startButton;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CMMotionManager *motionManager;

@end
