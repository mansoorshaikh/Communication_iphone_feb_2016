//
//  FeedDetailsViewController.h
//  CommunicationApp
//
//  Created by mansoor shaikh on 14/04/14.
//  Copyright (c) 2014 MobiWebCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Feedlist.h"
#import "FeedViewController.h"
#import "AsyncImageView.h"
@interface FeedDetailsViewController : UIViewController<UIImagePickerControllerDelegate>
@property(nonatomic,retain) AppDelegate *appDelegate;
@property(nonatomic,retain) FeedViewController *fvc;
@property(nonatomic,retain) IBOutlet UILabel *feedtopLabel,*dateLabel;
@property(nonatomic,retain) IBOutlet UITextView *feedDetailsTextView;
@property(nonatomic,retain) IBOutlet UIButton *backBtn,*arrowBtn,*msgBtn,*cameraBtn;
@property(nonatomic,retain) IBOutlet AsyncImageView *imageviewPicture;
@property(nonatomic,retain) Feedlist *selectFeedlist;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic,retain) UIImage *image_;
-(IBAction)popViewController;
@end
