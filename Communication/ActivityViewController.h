//
//  ActivityViewController.h
//  CommunicationApp
//
//  Created by mansoor shaikh on 14/04/14.
//  Copyright (c) 2014 MobiWebCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface ActivityViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,retain) AppDelegate *appDelegate;
@property(nonatomic,retain) NSMutableArray *activityDetailsArray;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic,retain) IBOutlet UITableView *tableViewMain;
@end
