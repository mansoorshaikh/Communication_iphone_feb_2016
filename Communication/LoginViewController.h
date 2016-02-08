//
//  LoginViewController.h
//  CommunicationApp
//
//  Created by mansoor shaikh on 12/04/14.
//  Copyright (c) 2014 MobiWebCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOS7AlertView.h"
#import "AsyncImageView.h"
#import "PictureSetview.h"

@interface LoginViewController : UIViewController<UITextFieldDelegate,CustomIOS7AlertViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate,UISearchDisplayDelegate, UISearchBarDelegate,UIPopoverControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property(nonatomic,retain) CustomIOS7AlertView *alertViewLogin;
@property(nonatomic,retain) IBOutlet UILabel *requestAccessButton;
@property(nonatomic,retain) IBOutlet UIButton *userPicture,*loginClickButton,*uiRequestAccessBtn;
@property(nonatomic,retain) IBOutlet UILabel *rememberLbl;
@property(nonatomic,retain) IBOutlet UITextField *txtUserName,*txtPassword;
@property (nonatomic, retain) IBOutlet UISwitch *onoff;
@property (nonatomic, retain) IBOutlet UIImageView *userImageView;
@property(nonatomic,retain) PictureSetview *psv;
@property(nonatomic,retain) UIImage *image;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;

-(IBAction)loginAction;

@end

