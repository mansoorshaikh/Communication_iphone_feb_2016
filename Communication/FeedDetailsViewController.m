//
//  FeedDetailsViewController.m
//  CommunicationApp
//
//  Created by mansoor shaikh on 14/04/14.
//  Copyright (c) 2014 MobiWebCode. All rights reserved.
//

#import "FeedDetailsViewController.h"
#import "SWRevealViewController.h"
#import "FeedDetailsViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "ImageVO.h"
#import "AsyncImageView.h"
#import <MessageUI/MessageUI.h>
#import "Reachability.h"
@interface FeedDetailsViewController ()

@end

@implementation FeedDetailsViewController
@synthesize appDelegate,feedtopLabel,feedDetailsTextView,dateLabel,backBtn,arrowBtn,msgBtn,cameraBtn,imageviewPicture,selectFeedlist,fvc,activityIndicator,image_;
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

- (void) threadStartAnimating:(id)data {
    [activityIndicator startAnimating];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
    
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    [activityIndicator stopAnimating];
     NSLog(@"%@",selectFeedlist);
    fvc=[[FeedViewController alloc]initWithNibName:@"FeedViewController" bundle:nil];
   // [self setFontFamily:@"Gotham Narrow" forView:self.view andSubViews:YES];
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFrame:CGRectMake(30, 0, 110, 35)];
    [titleLabel setText:@"FEEDS DETAILS"];
    
    titleLabel.font =[UIFont systemFontOfSize:18];
    feedtopLabel.font =[UIFont fontWithName:@"Gotham Narrow" size:17.0f];
    feedDetailsTextView.font =[UIFont fontWithName:@"Open Sans" size:18.0f];
    //dateLabel.font =[UIFont fontWithName:@"Proxima Nova" size:8.0f];
    
    self.navigationItem.titleView = titleLabel;
    appDelegate=[[UIApplication sharedApplication] delegate];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navBar.png"]];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"feedtablebg.png"]];
   
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
        
        feedtopLabel.layer.frame=CGRectMake(10,40,310,60);
        [feedtopLabel setText:selectFeedlist.feedtext];
        [feedtopLabel removeFromSuperview];
        [self.view addSubview:feedtopLabel];
        
        dateLabel.layer.frame=CGRectMake(10,100,100,30);
        [dateLabel setText:selectFeedlist.time];
        [dateLabel removeFromSuperview];
        [self.view addSubview:dateLabel];
        
        feedDetailsTextView.layer.frame=CGRectMake(10,140,310,100);
        [feedDetailsTextView setText:selectFeedlist.feeddescription];
        [feedDetailsTextView removeFromSuperview];
        [self.view addSubview:feedDetailsTextView];
        
        
       imageviewPicture=[[AsyncImageView alloc] initWithFrame:CGRectMake(5,250,310,120)];
        [imageviewPicture loadImageFromURL:[NSURL URLWithString:selectFeedlist.feedimage]];
        [imageviewPicture setBackgroundColor:[UIColor clearColor]];

        [imageviewPicture removeFromSuperview];
        [self.view addSubview:imageviewPicture];
        
        
        
        
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
        
        feedtopLabel.layer.frame=CGRectMake(10,40,310,60);
        [feedtopLabel setText:selectFeedlist.feedtext];
        [feedtopLabel removeFromSuperview];
        [self.view addSubview:feedtopLabel];
        
        dateLabel.layer.frame=CGRectMake(10,100,100,30);
        [dateLabel setText:selectFeedlist.time];
        [dateLabel removeFromSuperview];
        [self.view addSubview:dateLabel];
        
        feedDetailsTextView.layer.frame=CGRectMake(10,140,310,100);
         [feedDetailsTextView setText:selectFeedlist.feeddescription];
        [feedDetailsTextView removeFromSuperview];
        [self.view addSubview:feedDetailsTextView];
        
        imageviewPicture=[[AsyncImageView alloc] initWithFrame:CGRectMake(5,250,310,120)];
        [imageviewPicture loadImageFromURL:[NSURL URLWithString:selectFeedlist.feedimage]];
        [imageviewPicture setBackgroundColor:[UIColor clearColor]];

        [imageviewPicture removeFromSuperview];
        [self.view addSubview:imageviewPicture];
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
        
        feedtopLabel.layer.frame=CGRectMake(10,40,310,60);
        [feedtopLabel setText:selectFeedlist.feedtext];
        [feedtopLabel removeFromSuperview];
        [self.view addSubview:feedtopLabel];
        
        dateLabel.layer.frame=CGRectMake(10,100,100,30);
        [dateLabel setText:selectFeedlist.time];
        [dateLabel removeFromSuperview];
        [self.view addSubview:dateLabel];
        
        feedDetailsTextView.layer.frame=CGRectMake(10,140,310,100);
         [feedDetailsTextView setText:selectFeedlist.feeddescription];
        [feedDetailsTextView removeFromSuperview];
        [self.view addSubview:feedDetailsTextView];
        
        
        imageviewPicture=[[AsyncImageView alloc] initWithFrame:CGRectMake(5,250,310,120)];
        [imageviewPicture loadImageFromURL:[NSURL URLWithString:selectFeedlist.feedimage]];
        [imageviewPicture setBackgroundColor:[UIColor clearColor]];
        [imageviewPicture removeFromSuperview];
        [self.view addSubview:imageviewPicture];
    }
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
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            newSize = CGSizeMake(768, 1024);
        }
        else {
            newSize  = CGSizeMake(320, 480);  //whaterver size
        }
        
        UIGraphicsBeginImageContext(newSize);
        [image_ drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
        UIGraphicsEndImageContext();
        
        
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    
    [self uploadImage:UIImageJPEGRepresentation(image_, 1.0) filename:[prefs stringForKey:@"loggedin"]];
    
    
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
    
    NSString *urlString = @"http://millionairesorg.com/communication/mobile_uploadpicture.php";
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
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Communication"
                                                    message:@"Image uploaded successfully."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    }
    return true;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
