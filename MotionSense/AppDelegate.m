//
//  AppDelegate.m
//  MotionSense
//
//  Created by Alexandra Miller-Browne on 7/2/14.
//  Copyright (c) 2014 Boston University. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //calls log method
    [self redirectLogToDocumentFolder];
    return YES;
}

//this redirects the console log to the app's document folder so able to acces through filesharing
- (void) redirectLogToDocumentFolder
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *logPath = [documentsDirectory stringByAppendingPathComponent:@"logFile14.txt"];
    freopen([logPath fileSystemRepresentation],"a+",stderr);
}

/*-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    completionHandler(UIBackgroundFetchResultNewData);
}*/

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //works for 16 mins
    UIBackgroundTaskIdentifier  taskId = 0;
    taskId = [application beginBackgroundTaskWithExpirationHandler:^{
    }];
    //NSLog(@"Background time Remaining: %f",[[UIApplication sharedApplication] backgroundTimeRemaining]);
    
    //when with this works for a while in background except needs to be connected
    // avoids phone sleeping when this application is running
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
    
    /*
     works for 16 mins
     
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        // Clean up any unfinished task business by marking where you
        // stopped or ending the task outright.
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                   ^{
                       // Do the work associated with the task, preferably in chunks.
                       [application endBackgroundTask:bgTask];
                       bgTask = UIBackgroundTaskInvalid;
                   });
         */
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //[UIApplication sharedApplication].idleTimerDisabled = YES;
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
