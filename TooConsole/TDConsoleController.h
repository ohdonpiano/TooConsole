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
    NSMutableArray *_filteredLogs;
    
    NSString *_service; 
}

@property (nonatomic, retain) NSMutableArray *logs;
@property (nonatomic, retain) NSMutableArray *filteredLogs;
@property (nonatomic, retain) NSString *service; 

@end
