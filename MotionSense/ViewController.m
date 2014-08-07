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

//a way to get rid of the timestamp from the log statements
//#define NSLog(FORMAT, ...) printf("%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String])

@interface ViewController ()

@end

@implementation ViewController


//intitalizing the rgby on/off variables
int rOn = 000;
int gOn = 000;
int bOn = 000;
int yOn = 000;

int rOff = 255;
int gOff = 255;
int bOff = 255;
int yOff = 255;


-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void) viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
    [super viewDidAppear:animated];
}

- (void) viewDidDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewDidDisappear:animated];
}

//when shake motion ends, it turns off
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) {
        self.colorTemp.text = @"OFF";
        if ([self.colorTemp.text  isEqual: @"0FF"]){
            rOff = 255;
            gOff = 255;
            bOff = 255;
            yOff = 255;
            //NSLog(@"r = %d", rOff);
            
        }
        
    }
    [super motionEnded:motion withEvent:event];
}

//when motion starts, it turns on
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (event.subtype == UIEventSubtypeMotionShake){
        self.colorTemp.text = @"ON";
        
        if ([self.colorTemp.text  isEqual: @"ON"]) {
            rOn = 000;
            gOn = 000;
            bOn = 000;
            yOn = 000;
        }
    }
}

//this method is what is used to set up the TCP with the TiLED
-(void)streamOpenWithIp:(NSString *)ip withPortNumber:(int)portNumber;
{
    CFReadStreamRef readStream;
    CFWriteStreamRef writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (__bridge CFStringRef)ip, portNumber, &readStream, &writeStream);

    if(readStream && writeStream)
    {
        //property for socket streams - close and release the sockets
        CFReadStreamSetProperty(readStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
        CFWriteStreamSetProperty(writeStream, kCFStreamPropertyShouldCloseNativeSocket, kCFBooleanTrue);
        
        //Setup input stream
        inputStream = (__bridge NSInputStream *)readStream;
        [inputStream setDelegate:self];
        [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [inputStream open];
        
        //Setup output stream
        outputStream = (__bridge NSOutputStream *)writeStream;
        [outputStream setDelegate:self];
        [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        [outputStream open];
    }
    
    NSString *response  = @"This is a Test";
    NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
    [outputStream write:[data bytes] maxLength:[data length]];
}

//sending data - want to send the rgby values


//TCP Receive
-(void) stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode{
    NSLog(@"stream event %u", eventCode);
	
	switch (eventCode) {
        case NSStreamEventOpenCompleted:
			NSLog(@"Stream opened");
            break;
            
		case NSStreamEventHasBytesAvailable:
            NSLog(@"Event has bytes available");
            if (aStream == inputStream)
			{
				uint8_t buffer[1024];
				long len;
				
				while ([inputStream hasBytesAvailable])
				{
					len = [inputStream read:buffer maxLength:sizeof(buffer)];
					if (len > 0)
					{
						NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
						
						if (nil != output)
						{
							NSLog(@"TCP Client - Server sent: %@", output);
						}
                        
                        
                        
                }
			}
            break;
            
        case NSStreamEventErrorOccurred:
			NSLog(@"Can not connect to the host!");
			break;
            
        case NSStreamEventEndEncountered:
            NSLog(@"TCP Client - End encountered");
            [aStream close];
            [aStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
            //[aStream release];
            aStream = nil;
			break;
            
		default:
			NSLog(@"Unknown event");
	}

    }
}


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
    
    self.colorTemp.text = @"Shake for quick ON/OFF";
    
    [self stream:inputStream handleEvent:NSStreamEventOpenCompleted];
    [self streamOpenWithIp:@"128.197.53.32" withPortNumber:23];

}
-(void) getValues:(NSTimer *) timer {
    //acceleration values in terms of G's (multiply by 9.8 to get it in m/s^2) - acceleration due to gravity
    self.accX.text = [NSString stringWithFormat:@"%.6f",self.motionManager.accelerometerData.acceleration.x];
    
    self.accY.text = [NSString stringWithFormat:@"%.6f",self.motionManager.accelerometerData.acceleration.y];
    self.accZ.text = [NSString stringWithFormat:@"%.6f",self.motionManager.accelerometerData.acceleration.z];
    

    
    //orientation in regular terms (maybe make a range of .9-1)
    //acceleration values in 1g correspond to the position of the phone
    NSString * accelX = self.accX.text;
    NSString * accelY = self.accY.text;
    NSString * accelZ = self.accZ.text;
    NSInteger ax = [accelX  integerValue];
    NSInteger ay = [accelY  integerValue];
    NSInteger az = [accelZ  integerValue];

    //another orientation method
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
    

    //gyroscope - rate of rotation of device in rad/s
    self.gyroX.text = [NSString stringWithFormat:@" %.2f",self.motionManager.gyroData.rotationRate.x];
    self.gyroY.text = [NSString stringWithFormat:@" %.2f",self.motionManager.gyroData.rotationRate.y];
    self.gyroZ.text = [NSString stringWithFormat:@" %.2f",self.motionManager.gyroData.rotationRate.z];
    
    
    //Euler angles: yaw, pitch, roll in radians - roll is elevation(yz)
    //longitudinal = z = roll
    //vertical axis = y = yaw
    //lateral = x = pitch
    
    self.roll.text = [NSString stringWithFormat:@"%.2f",(180/M_PI)*self.motionManager.deviceMotion.attitude.roll];
    self.yaw.text = [NSString stringWithFormat:@"%.2f",(180/M_PI)*self.motionManager.deviceMotion.attitude.yaw];
    self.pitch.text = [NSString stringWithFormat:@"%.2f",(180/M_PI)*self.motionManager.deviceMotion.attitude.pitch];
    
    /*
     attempt at establishing position 
     
    self.posX.text = [NSString stringWithFormat:@"%.2f",cos(self.motionManager.deviceMotion.attitude.yaw)*cos(self.motionManager.deviceMotion.attitude.pitch)];
    self.posY.text = [NSString stringWithFormat:@"%.2f",sin(self.motionManager.deviceMotion.attitude.yaw)*cos(self.motionManager.deviceMotion.attitude.pitch)];
    self.posZ.text = [NSString stringWithFormat:@"%.2f",sin(self.motionManager.deviceMotion.attitude.pitch)];
     */

    //zenith = pi/2 - angle of elevation
    //azimuth = rotation about the Z' axis - xy
    //tilt = angle of rotation about the z axis
    
    self.zenith.text = [NSString stringWithFormat:@"%.2f",(180/M_PI)*((M_PI/2)-self.motionManager.deviceMotion.attitude.roll)];
    self.azimuth.text = [NSString stringWithFormat:@"%.2f", (180/M_PI)*self.motionManager.deviceMotion.attitude.yaw];
    self.tilt.text = [NSString stringWithFormat:@"%.2f",(180/M_PI)*self.motionManager.deviceMotion.attitude.roll];

    //organizing the csv file
    NSString* headerRow;
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self dataFilePath]]) {
        [[NSFileManager defaultManager] createFileAtPath: [self dataFilePath] contents:nil attributes:nil];
        
        headerRow = @"Acceleration x (G's), Acceleration y (G's), Acceleration z (G's), Rotation Rate in x (rad/s), Rotation Rate in y (rad/s), Rotation Rate in z (rad/s), Zenith (Degrees), Azimuth (Degrees), Tilt (Degrees), Compass (Degrees), Orientation\n";
    }
    
    NSString* results = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@,%@\n",
                         self.accX.text,
                         self.accY.text,
                         self.accZ.text,
                         self.gyroX.text,
                         self.gyroY.text,
                         self.gyroY.text,
                         self.zenith.text,
                         self.azimuth.text,
                         self.tilt.text,
                         self.compass.text,
                         self.direction.text,
                         self.orientation.text];
    
    NSFileHandle * fileHandle= [NSFileHandle fileHandleForUpdatingAtPath:[self dataFilePath]];
    [fileHandle seekToEndOfFile];
    if (headerRow != nil) {
        [fileHandle writeData:[headerRow dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [fileHandle writeData:[results dataUsingEncoding:NSUTF8StringEncoding]];
    //NSLog(@"Info saved");

}



//compass in degrees (with magnetic heading parameter not true north)
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

- (NSString *)dataFilePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"Data1.csv"];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//when view is about to be dismissed
- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
	[inputStream close];
	[outputStream close];
	inputStream = nil;
	outputStream = nil;
    OutputData = nil;

}

@end

