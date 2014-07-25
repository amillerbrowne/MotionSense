//
//  LEDViewController.m
//  MotionSense
//
//  Created by Alexandra Miller-Browne on 7/24/14.
//  Copyright (c) 2014 Boston University. All rights reserved.
//

#import "LEDViewController.h"
//#import "ViewController.h"


@interface LEDViewController ()

@end

@implementation LEDViewController

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

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) {
        self.shake.text = @"OFF";
    }
    [super motionEnded:motion withEvent:event];
}
-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event{
    if (event.subtype == UIEventSubtypeMotionShake){
        self.shake.text = @"ON again";
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.shake.text = @"This is on";

}

-(IBAction)turnOn:(id)sender{
    if ([self.shake.text  isEqual: @"ON"]) {
        NSURL * url = [NSURL URLWithString:@"http://ipaddress/$1"];//$1 is on
        NSURLRequest * req = [NSURLRequest requestWithURL:url];
        
    }
    else {
        NSURL * url = [NSURL URLWithString:@"http://ipaddress/$2"];//$2 is off
        NSURLRequest * req = [NSURLRequest requestWithURL:url];
        
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
