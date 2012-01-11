//
//  TDConsoleController.h
//  TooConsole
//
//  Created by Daniele Poggi on 1/7/12.
//  Copyright (c) 2012 Toodev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TDConsoleController : UITableViewController {
    
    NSMutableArray *_logs;
}

@property (nonatomic, retain) NSMutableArray *logs;

@end
