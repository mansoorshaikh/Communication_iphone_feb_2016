//
//  FeedSurveyViewController.m
//  CommunicationApp
//
//  Created by mansoor shaikh on 14/04/14.
//  Copyright (c) 2014 MobiWebCode. All rights reserved.
//

#import "FeedSurveyViewController.h"
#import "SWRevealViewController.h"
#import "FeedDetailsViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "ImageVO.h"
#import "AsyncImageView.h"
#import <MessageUI/MessageUI.h>
#import "Reachability.h"
@interface FeedSurveyViewController ()

@end

@implementation FeedSurveyViewController
@synthesize appDelegate,scrollview,feedSurveyDateLabel,feedSurveyQuestionTextView,selectFeedlist,responseFeed;
@synthesize feedimage,feedquestionTextView,yesButton,noButton,submitButton,backBtn,arrowBtn,msgBtn,cameraBtn,activityDetailsArray,activityIndicator,image_;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setFontFamily:(NSString*)fontFamily forView:(UIView*)view andSubViews:(BOOL)isSubViews
{
    if ([view isKindOfClass:[UILabel class]])
    {
        UILabel *lbl = (UILabel *)view;
        [lbl setFont:[UIFont fontWithName:fontFamily size:[[lbl font] pointSize]]];
    }else if ([view isKindOfClass:[UIButton class]])
    {
        UIButton *btn = (UIButton *)view;
        btn.titleLabel.font = [UIFont fontWithName:fontFamily size:[[btn.titleLabel font] pointSize]];
    }else if ([view isKindOfClass:[UITextField class]])
    {
        UITextField *textfield = (UITextField *)view;
        [textfield setFont:[UIFont fontWithName:fontFamily size:[[textfield font] pointSize]]];
    }else if ([view isKindOfClass:[UITextView class]])
    {
        UITextView *textfield = (UITextView *)view;
        [textfield setFont:[UIFont fontWithName:fontFamily size:[[textfield font] pointSize]]];
    }
    
    if (isSubViews)
    {
        for (UIView *sview in view.subviews)
        {
            [self setFontFamily:fontFamily forView:sview andSubViews:YES];
        }
    }
}

- (void) threadStartAnimating:(id)data {
    [activityIndicator startAnimating];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    }

-(void)PostResponse{
    Reachability *myNetwork = [Reachability reachabilityWithHostname:@"google.com"];
    NetworkStatus myStatus = [myNetwork currentReachabilityStatus];
    if(myStatus == NotReachable)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Communication" message:@"No internet connection available!!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [activityIndicator stopAnimating];
    }else{

        [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

        NSString *urlString = [[NSString alloc]initWithFormat:@"http://millionairesorg.com/communication/feedsurvey.php?feedid=%@&response=%@&userid=%@",selectFeedlist.feedid,responseFeed,[prefs objectForKey:@"loggedin"]];
        NSData *mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
        NSString *content = [[NSString alloc]  initWithBytes:[mydata bytes]
                                                  length:[mydata length] encoding: NSUTF8StringEncoding];
    if([content isEqualToString:@" 0"])
    {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Communication"
                                                    message:@"Response alerady submitted for this feed."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Communication"
                                                        message:@"Feed Survey submitted successfully."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    [activityIndicator stopAnimating];
    }
}

-(IBAction)yesButtonFunction{
    responseFeed=@"Yes";
    if(image_ != nil)
    {
        [self uploadImage];
    }else{
        [self PostResponse];

    }
    
}
-(IBAction)noButtonFunction{
    responseFeed=@"No";
    
    if(image_ != nil)
    {
        [self uploadImage];
    }else{
        [self PostResponse];
        
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [activityIndicator stopAnimating];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenHeight = screenRect.size.height;
    if(screenHeight<568)
    scrollview.contentSize=CGSizeMake(320, screenHeight+150);
//    [self setFontFamily:@"Gotham Narrow" forView:self.view andSubViews:YES];
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFrame:CGRectMake(30, 0, 110, 35)];
    [titleLabel setText:@"FEEDS SURVEY"];
    
    titleLabel.font =[UIFont systemFontOfSize:18];
    feedquestionTextView.font =[UIFont fontWithName:@"Gotham Narrow" size:15.0f];
    self.navigationItem.titleView = titleLabel;
       appDelegate=[[UIApplication sharedApplication] delegate];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navBar.png"]];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"feedtablebg.png"]];
    responseFeed=[[NSString alloc] init];
    SWRevealViewController *revealController = [self revealViewController];
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"reveal-icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if(height>=480 && height<568){
        //iphone 4
        backBtn.layer.frame=CGRectMake(10,10,40,20);
        [backBtn removeFromSuperview];
        [self.view addSubview:backBtn];
        
        arrowBtn.layer.frame=CGRectMake(200,10,25,25);
        [arrowBtn removeFromSuperview];
        [self.view addSubview:arrowBtn];
        
        msgBtn.layer.frame=CGRectMake(235,10,25,25);
        [msgBtn removeFromSuperview];
        [self.view addSubview:msgBtn];
        
        cameraBtn.layer.frame=CGRectMake(275,10,25,25);
        [cameraBtn removeFromSuperview];
        [self.view addSubview:cameraBtn];
        
        feedSurveyDateLabel.layer.frame=CGRectMake(10,35,100,30);
        [feedSurveyDateLabel setText:selectFeedlist.time];

        [feedSurveyDateLabel removeFromSuperview];
        [self.view addSubview:feedSurveyDateLabel];
        
        
        feedimage=[[AsyncImageView alloc] initWithFrame:CGRectMake(10,90,300,150)];
        [feedimage loadImageFromURL:[NSURL URLWithString:selectFeedlist.feedimage]];
        [feedimage setBackgroundColor:[UIColor clearColor]];
        [feedimage removeFromSuperview];
        [self.view addSubview:feedimage];
        
        feedquestionTextView.layer.frame=CGRectMake(10,195,300,90);
        [feedquestionTextView setText:selectFeedlist.feedtext];
        [feedquestionTextView removeFromSuperview];
        [self.view addSubview:feedquestionTextView];
        
        yesButton.layer.frame=CGRectMake(10,290,300,40);
        [yesButton removeFromSuperview];
        [self.view addSubview:yesButton];
        
        noButton.layer.frame=CGRectMake(10,330,300,40);
        [noButton removeFromSuperview];
        [self.view addSubview:noButton];
        
        
        
    }else if(height>=568 && height<600){
        //iphone 5
        
        backBtn.layer.frame=CGRectMake(10,10,40,20);
        [backBtn removeFromSuperview];
        [self.view addSubview:backBtn];
        
        arrowBtn.layer.frame=CGRectMake(200,10,25,25);
        [arrowBtn removeFromSuperview];
        [self.view addSubview:arrowBtn];
        
        msgBtn.layer.frame=CGRectMake(235,10,25,25);
        [msgBtn removeFromSuperview];
        [self.view addSubview:msgBtn];
        
        cameraBtn.layer.frame=CGRectMake(275,10,25,25);
        [cameraBtn removeFromSuperview];
        [self.view addSubview:cameraBtn];
        
        feedSurveyDateLabel.layer.frame=CGRectMake(10,50,100,30);
        [feedSurveyDateLabel setText:selectFeedlist.time];

        [feedSurveyDateLabel removeFromSuperview];
        [self.view addSubview:feedSurveyDateLabel];
        
        
        feedimage=[[AsyncImageView alloc] initWithFrame:CGRectMake(10,90,300,150)];
        [feedimage loadImageFromURL:[NSURL URLWithString:selectFeedlist.feedimage]];
        [feedimage setBackgroundColor:[UIColor clearColor]];
        [feedimage removeFromSuperview];
        [self.view addSubview:feedimage];
        
        feedquestionTextView.layer.frame=CGRectMake(10,250,300,100);
        [feedquestionTextView setText:selectFeedlist.feedtext];
        [feedquestionTextView removeFromSuperview];
        [self.view addSubview:feedquestionTextView];
        
        yesButton.layer.frame=CGRectMake(10,360,300,40);
        [yesButton removeFromSuperview];
        [self.view addSubview:yesButton];
        
        noButton.layer.frame=CGRectMake(10,400,300,40);


        [noButton removeFromSuperview];
        [self.view addSubview:noButton];
        
       
    }else{
        
        backBtn.layer.frame=CGRectMake(10,10,40,20);
        [backBtn removeFromSuperview];
        [self.view addSubview:backBtn];
        
        arrowBtn.layer.frame=CGRectMake(200,10,25,25);
        [arrowBtn removeFromSuperview];
        [self.view addSubview:arrowBtn];
        
        msgBtn.layer.frame=CGRectMake(235,10,25,25);
        [msgBtn removeFromSuperview];
        [self.view addSubview:msgBtn];
        
        cameraBtn.layer.frame=CGRectMake(275,10,25,25);
        [cameraBtn removeFromSuperview];
        [self.view addSubview:cameraBtn];
        
        feedSurveyDateLabel.layer.frame=CGRectMake(10,50,100,30);
        [feedSurveyDateLabel setText:selectFeedlist.time];

        [feedSurveyDateLabel removeFromSuperview];
        [self.view addSubview:feedSurveyDateLabel];
        
        
        feedimage=[[AsyncImageView alloc] initWithFrame:CGRectMake(10,90,300,150)];
        [feedimage loadImageFromURL:[NSURL URLWithString:selectFeedlist.feedimage]];
        [feedimage setBackgroundColor:[UIColor clearColor]];
        [feedimage removeFromSuperview];
        [self.view addSubview:feedimage];

        
        feedquestionTextView.layer.frame=CGRectMake(10,250,300,100);
        [feedquestionTextView setText:selectFeedlist.feedtext];
        [feedquestionTextView removeFromSuperview];
        [self.view addSubview:feedquestionTextView];
        
        yesButton.layer.frame=CGRectMake(10,360,300,40);
        [yesButton removeFromSuperview];
        [self.view addSubview:yesButton];
        
        noButton.layer.frame=CGRectMake(10,400,300,40);
        [noButton removeFromSuperview];
        [self.view addSubview:noButton];
        
        
    }
   [self.view addSubview: activityIndicator];
}

- (IBAction) takePicture
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"" message:@"Sorry, you do not have a camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [altView show];
        return;
    }
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}

- (void) picImage
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"" message:@"Sorry, you do not have a camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [altView show];
        return;
    }
    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}


- (void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // The device is an iPad running iPhone 3.2 or later.
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        //		[controller setMediaTypes:[NSArray arrayWithObject:(NSString *)kUTTypeImage]];
        [controller setDelegate:self];
        
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:controller];
        [popover setDelegate:self];
        [popover presentPopoverFromRect:CGRectMake(455, 665, 30, 30) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
        popover.popoverContentSize = CGSizeMake(315, 500);
    }
    else
    {
        //iPhone
        NSArray *mediaTypes = [UIImagePickerController
                               availableMediaTypesForSourceType:sourceType];
        UIImagePickerController *picker =
        [[UIImagePickerController alloc] init];
        picker.mediaTypes = mediaTypes;
        picker.delegate = self;
        picker.allowsEditing = NO;
        picker.sourceType = sourceType;
        [self presentModalViewController:picker animated:YES];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
    [self dismissModalViewControllerAnimated:YES];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        
        image_ = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        CGSize newSize;
      
            newSize  = CGSizeMake(60, 60);  //whaterver size
       
        
        UIGraphicsBeginImageContext(newSize);
        [image_ drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIGraphicsEndImageContext();
        
        
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
    //NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    
    //[self uploadImage:UIImageJPEGRepresentation(image_, 1.0) filename:[prefs stringForKey:@"loggedin"]];
    
    
}

- (BOOL)uploadImage:(NSData *)imageData filename:(NSString *)filename{
    Reachability *myNetwork = [Reachability reachabilityWithHostname:@"google.com"];
    NetworkStatus myStatus = [myNetwork currentReachabilityStatus];
    if(myStatus == NotReachable)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Communication" message:@"No internet connection available!!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [activityIndicator stopAnimating];
    }else{

    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    
    NSString *urlString = @"http://millionairesorg.com/communication/mobile_feedsurvey.php";
    NSLog(@"urlstring is %@",urlString);
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    //image filename
    [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"userfile\"; filename=\"%@\"\r\n",filename]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"return string %@",returnString);
    //[self clearAllData];
    [activityIndicator stopAnimating];
    
   if([returnString isEqualToString:@" 0"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Communication"
                                                        message:@"Response alerady aubmitted for this feed."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Communication"
                                                        message:@"Feed Survey submitted successfully."
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    }
    return true;
}

-(void)uploadImage{
    
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSString *serverString=[[NSString alloc] initWithFormat:@"%@_%@_%@",selectFeedlist.feedid,responseFeed,[prefs objectForKey:@"loggedin"]];
        [self uploadImage:UIImageJPEGRepresentation(image_, 1.0) filename:serverString];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
