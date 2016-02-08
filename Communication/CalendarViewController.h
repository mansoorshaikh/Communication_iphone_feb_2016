//
//  CalendarViewController.h
//  CommunicationApp
//
//  Created by mansoor shaikh on 14/04/14.
//  Copyright (c) 2014 MobiWebCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "VRGCalendarView.h"
#import "CalenderVO.h"
#import "ActivityVO.h"
@interface CalendarViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,VRGCalendarViewDelegate> {
}
@property(nonatomic,retain) AppDelegate *appDelegate;
@property(nonatomic,retain) IBOutlet UITableView *tblview;
@property(nonatomic,retain) IBOutlet UIView *calendarViewDisplay;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic,retain) IBOutlet UITableView *tableViewMain;
@property(nonatomic,retain) NSMutableArray *activityDetailsArray;
@property(nonatomic,retain) NSString *selectedDate;
@property(nonatomic,retain) NSString *eventDate;
@property(nonatomic,retain) CalenderVO *cvo;
@property(nonatomic,retain) ActivityVO *avo;
@end
