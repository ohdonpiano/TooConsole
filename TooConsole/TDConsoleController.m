//
//  TDConsoleController.m
//  TooConsole
//
//  Created by Daniele Poggi on 1/7/12.
//  Copyright (c) 2012 Toodev. All rights reserved.
//

#import "TDConsoleController.h"
#import "TDMulticast.h"

@implementation TDConsoleController

@synthesize tableView=_tableView, logs=_logs, filteredLogs=_filteredLogs, service=_service;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.logs = [[NSMutableArray alloc] init];
    self.filteredLogs = [[NSMutableArray alloc] init];
    
    // Refresh button
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStyleBordered target:self action:@selector(reload)];
    self.navigationItem.rightBarButtonItem = right;
}

- (void) reload {
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[_logs count]-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)viewDidUnload
{
    _tableView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receive:) name:kTDMulticastDidReceiveElement object:nil];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.tableView reloadData];
    });
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (tableView == self.tableView)
        return [_logs count];
    else if (tableView == self.searchDisplayController.searchResultsTableView)
        return [_filteredLogs count];
    else
        return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ConsoleCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    NSDictionary *log = nil;
    
    if (tableView == self.tableView) {
        
        log = [_logs objectAtIndex:indexPath.row];
        
    } else if (tableView == self.searchDisplayController.searchResultsTableView) {
        
        log = [_filteredLogs objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = [log objectForKey:@"message"];
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    cell.textLabel.numberOfLines = 0;
    cell.detailTextLabel.text = [log objectForKey:@"peerName"];
    
    return cell;
}

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath
{
    // Use the method that you would have created above to get the cell.
    // Any other method seems to result in infinite recursion like you said.
    UITableViewCell *cell = (UITableViewCell*)[self tableView:tableView cellForRowAtIndexPath:indexPath];
	
	NSString *text = cell.textLabel.text;
	CGFloat height = [text sizeWithFont:cell.textLabel.font constrainedToSize:CGSizeMake(cell.bounds.size.width,1000) lineBreakMode:UILineBreakModeWordWrap].height;
	//return MAX(height, MinHeight);
	return height+30; 
}

#pragma mark - TDMulticast Receive

- (void) receive:(NSNotification*)notif {
    
    @try {
        NSDictionary *message = notif.object;
        NSDictionary *peer = notif.userInfo;
        
        NSDictionary *log = [NSDictionary dictionaryWithObjectsAndKeys:[message objectForKey:@"message"],@"message",[peer objectForKey:@"peerName"],@"peerName", nil];
        
        [self.logs addObject:log];
    } @catch (NSException* ex) {
        // IGNORE
    }
}

#pragma mark - UISearchDisplayController Delegate

- (void) filterLogsWithText:(NSString*)text {
    
    [_filteredLogs removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"message contains[cd] %@",text];
    NSArray *filtered = [_logs filteredArrayUsingPredicate:predicate];
    NSLog(@"%s found %i logs matching", __PRETTY_FUNCTION__, [filtered count]);
    [_filteredLogs addObjectsFromArray:filtered];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)aSearchText {
    [self filterLogsWithText:aSearchText];
}

@end
