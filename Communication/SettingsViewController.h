//
//  SettingsViewController.h
//  CommunicationApp
//
//  Created by mansoor shaikh on 19/04/14.
//  Copyright (c) 2014 MobiWebCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "PictureSetview.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "Alertview/CustomIOS7AlertView.h"

@interface SettingsViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate,UIAlertViewDelegate,UISearchDisplayDelegate,CustomIOS7AlertViewDelegate, UISearchBarDelegate,UIPopoverControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,retain) AppDelegate *appDelegate;
@property(nonatomic,retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain) IBOutlet UILabel *messageNotificationLabel,*calendarNotificationLabel,*lblName,*lblTitle,*lblGender,*lblCompany,*lblAbout,*lblEmail,*lblPassword,*lblPhone,*lblPushNotification;
@property(nonatomic,retain) IBOutlet UITextField *phoneTextField,*nameTextField,*titleTextField,*genderTextField,*companyTextField,*aboutTextField,*emailTextField,*passwordTextField;
@property(nonatomic,retain) IBOutlet UIButton *editBtnPicture;
@property (nonatomic, retain) IBOutlet UISwitch *msgSwitch,*calendarSwitch;
@property(nonatomic,retain) PictureSetview *psv;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic,retain) IBOutlet UIButton *changePassword;
@property(nonatomic,retain) IBOutlet UIButton *upDateBtn,*cancelBtn;
@property(nonatomic,retain) CustomIOS7AlertView *alertView;
@property(nonatomic,retain) IBOutlet UITextField *txtOldPassword,*txtnewPassword;
@property(nonatomic,retain) IBOutlet NSString *OldPassword,*newpwd,*gender;
@property(nonatomic, retain) IBOutlet UISegmentedControl *genderSegmentControl;
@end
