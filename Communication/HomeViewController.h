//
//  HomeViewController.h
//  CommunicationApp
//
//  Created by mansoor shaikh on 13/04/14.
//  Copyright (c) 2014 MobiWebCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SettingsViewController.h"

@interface HomeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIButton *button;
    NSString *string;
    IBOutlet UILabel *dateLabel;

}


@property(nonatomic,retain) AppDelegate *appDelegate;
@property(nonatomic,retain) IBOutlet UIButton *btnNewMsg,*btnNewSurveys,*btnNewMsgnumber,*btnNewServeyNumber,*btnDate,*btnNoNewEvent;
@property(nonatomic,retain) IBOutlet UIImageView *imageViewNewEvent;
@property(nonatomic,retain) IBOutlet UITableView *tableViewMain;
@property(nonatomic,retain) IBOutlet UILabel *lblNewMsg,*lblNewSurveys;
@property (nonatomic, retain) NSString *string;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property(nonatomic,retain) NSMutableArray *activityDetailsArray;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic,retain) SettingsViewController *settingVCUserName;
@property(nonatomic,retain) NSString *deviceToken;

-(IBAction)currentdate:(id)sender;
@end
