//
//  PictureSetview.h
//  Communication
//
//  Created by mansoor shaikh on 23/03/15.
//  Copyright (c) 2015 MobiWebCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOS7AlertView.h"
#import "AppDelegate.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface PictureSetview : CustomIOS7AlertView<UIPopoverControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIScrollViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,UISearchDisplayDelegate,CustomIOS7AlertViewDelegate, UISearchBarDelegate,UIPopoverControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, retain) UIPopoverController *popover;

@property(nonatomic,retain) AppDelegate *appDelegate;
@property (nonatomic, retain) IBOutlet UIView *demoView;

@end
