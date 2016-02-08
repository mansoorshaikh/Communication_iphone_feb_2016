//
//  MediaViewController.h
//  CommunicationApp
//
//  Created by mansoor shaikh on 14/04/14.
//  Copyright (c) 2014 MobiWebCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOS7AlertView.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "AVFoundation/AVFoundation.h"
#import "MediaVO.h"
#import "ActivityVO.h"
@interface MediaViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,retain) CustomIOS7AlertView *alertView;
@property(nonatomic,retain) AppDelegate *appDelegate;
@property(nonatomic,retain) NSMutableArray *mediaArray;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic,retain) IBOutlet UITableView *tblview;
@property(nonatomic,retain) AVPlayer *player;
@property(nonatomic,retain) MediaVO *mvo;
@property(nonatomic,retain)  ActivityVO *avo;
@end
