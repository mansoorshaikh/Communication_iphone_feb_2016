//
//  FeedSurveyViewController.h
//  CommunicationApp
//
//  Created by mansoor shaikh on 14/04/14.
//  Copyright (c) 2014 MobiWebCode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Feedlist.h"
#import "AsyncImageView.h"

@interface FeedSurveyViewController : UIViewController<UIImagePickerControllerDelegate>
@property(nonatomic,retain) AppDelegate *appDelegate;
@property(nonatomic,retain) IBOutlet UILabel *feedSurveyDateLabel;
@property(nonatomic,retain) IBOutlet UITextView *feedSurveyQuestionTextView;
@property(nonatomic,retain) IBOutlet AsyncImageView *feedimage;
@property(nonatomic,retain) IBOutlet UITextView *feedquestionTextView;
@property(nonatomic,retain) IBOutlet UIButton *yesButton,*noButton,*submitButton;
@property(nonatomic,retain) IBOutlet UIScrollView *scrollview;
@property(nonatomic,retain) IBOutlet UIButton *backBtn,*arrowBtn,*msgBtn,*cameraBtn;
@property(nonatomic,retain) Feedlist *selectFeedlist;
@property(nonatomic,retain) NSString *responseFeed;
@property(nonatomic,retain) IBOutlet UIActivityIndicatorView *activityIndicator;
@property(nonatomic,retain) NSMutableArray *activityDetailsArray;
@property(nonatomic,retain) UIImage *image_;


-(IBAction)popViewController;
@end
