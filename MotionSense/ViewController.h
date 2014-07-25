//
//  ViewController.h
//  MotionSense
//
//  Created by Alexandra Miller-Browne on 7/2/14.
//  Copyright (c) 2014 Boston University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>


@interface ViewController : UIViewController <CLLocationManagerDelegate> {
    
    CMMotionManager *motionManager;
    NSOperationQueue *queue;
}

@property (strong, nonatomic) IBOutlet UILabel *accX;
@property (strong, nonatomic) IBOutlet UILabel *accY;
@property (strong, nonatomic) IBOutlet UILabel *accZ;

@property (strong, nonatomic) IBOutlet UILabel *gyroX;
@property (strong, nonatomic) IBOutlet UILabel *gyroY;
@property (strong, nonatomic) IBOutlet UILabel *gyroZ;

@property (weak, nonatomic) IBOutlet UILabel *roll;
@property (weak, nonatomic) IBOutlet UILabel *yaw;
@property (weak, nonatomic) IBOutlet UILabel *pitch;

@property (strong, nonatomic) IBOutlet UILabel *shake;

@property (strong, nonatomic) IBOutlet UILabel *zenith;
@property (strong, nonatomic) IBOutlet UILabel *azimuth;
@property (strong, nonatomic) IBOutlet UILabel *tilt;

@property (strong, nonatomic) IBOutlet UILabel *posX;
@property (strong, nonatomic) IBOutlet UILabel *posY;
@property (strong, nonatomic) IBOutlet UILabel *posZ;

@property (weak, nonatomic) IBOutlet UILabel *compass;
@property (strong, nonatomic) IBOutlet UILabel *direction;

@property (strong, nonatomic) IBOutlet UILabel *orientation;

@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end
