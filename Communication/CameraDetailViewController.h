//
//  CameraDetailViewController.h
//  CommunicationApp
//
//  Created by mansoor shaikh on 14/04/14.
//  Copyright (c) 2014 MobiWebCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
@interface CameraDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate>
@property(nonatomic,retain) AppDelegate *appDelegate;
@property(nonatomic,retain) IBOutlet UITableView *tblView;
@property(nonatomic,retain) IBOutlet UIButton *cameraActionSheetButton,*openCameraButton;
@property(nonatomic,retain) IBOutlet UIView *tblviewContainerView;
@property(nonatomic,retain) UIActionSheet *camerasettingsSheet;
@property(nonatomic,retain) NSMutableArray *activityDetailsArray;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic,retain) UIImage *image_;
@property(nonatomic,retain) NSString *userIdString;
@property(nonatomic,readwrite)int index;
@end
