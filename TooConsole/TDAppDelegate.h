//
//  TDAppDelegate.h
//  TooConsole
//
//  Created by Daniele Poggi on 1/7/12.
//  Copyright (c) 2012 Toodev. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kServiceName @"TooConsoleService"
#define kServicePort 11223

@interface TDAppDelegate : UIResponder <UIApplicationDelegate> {
    
    /**
     *	@brief	the FIFO queue on which the logs will be sent to other iDevices connected
     */
    dispatch_queue_t announceQueue;
    
    UIBackgroundTaskIdentifier uploadJobTask;
    
    BOOL interrupted;
}

@property (strong, nonatomic) UIWindow *window;

- (void) announceLogs;
- (void) concealLogs;

@end
