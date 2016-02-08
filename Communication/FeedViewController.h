//
//  FeedViewController.h
//  CommunicationApp
//
//  Created by mansoor shaikh on 14/04/14.
//  Copyright (c) 2014 MobiWebCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "FeedTypeVO.h"
#import "ActivityVO.h"
@interface FeedViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain) AppDelegate *appDelegate;
@property(nonatomic,retain) IBOutlet UISegmentedControl *segmentedControl;
@property(nonatomic,retain) NSMutableArray *feedArray,*feedTypeArray,*feedButtonArray;

@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic,retain) IBOutlet UITableView *tableView;
@property(nonatomic,retain) NSMutableArray *activityDetailsArray;
@property(nonatomic,retain) FeedTypeVO *feedTypelist;
@property(nonatomic,retain) NSString *feedtypeString,*selectFeed;
@property(nonatomic,retain) ActivityVO *avo;
@end
