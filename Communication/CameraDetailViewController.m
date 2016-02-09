//
//  CameraDetailViewController.m
//  CommunicationApp
//
//  Created by mansoor shaikh on 14/04/14.
//  Copyright (c) 2014 MobiWebCode. All rights reserved.
//

#import "CameraDetailViewController.h"
#import "SWRevealViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "ImageVO.h"
#import "AsyncImageView.h"
#import <MessageUI/MessageUI.h>
#import "Reachability.h"
#import "UIImage+FontAwesome.h"
#import "NSString+FontAwesome.h"

@interface CameraDetailViewController ()
@end
@implementation CameraDetailViewController
@synthesize appDelegate,camerasettingsSheet;
@synthesize tblView,cameraActionSheetButton,tblviewContainerView,openCameraButton,activityDetailsArray,activityIndicator,image_,userIdString,index;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    }
    if (isSubViews)
    {
        for (UIView *sview in view.subviews)
        {
            [self setFontFamily:fontFamily forView:sview andSubViews:YES];
        }
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

-(void)sendMails:(NSString*)filepath{
    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
     NSData *imagefile = [[NSData alloc] initWithContentsOfFile:filepath];
    [mailVC addAttachmentData:imagefile mimeType:@"image/png" fileName:[[filepath componentsSeparatedByString:@"\/"] objectAtIndex:[[filepath componentsSeparatedByString:@"\/"] count]-1]];
     mailVC.mailComposeDelegate = self;
    
    if ([MFMailComposeViewController canSendMail])
    {
        [self.navigationController presentViewController:mailVC animated:YES completion:^{
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        }];
    }

}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    CameraDetailViewController *cdvc=[[CameraDetailViewController alloc] initWithNibName:@"CameraDetailViewController" bundle:nil];
    [self.navigationController pushViewController:cdvc animated:YES];
}


-(void)showActionSheet:(UIButton*)btn{
    index=btn.tag;
    camerasettingsSheet = [[UIActionSheet alloc] initWithTitle:@""
                                                      delegate:self
                                             cancelButtonTitle:nil
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:@"",@"", @"", @"", nil];
    
    camerasettingsSheet.backgroundColor=[UIColor blackColor];
    camerasettingsSheet.tintColor=[UIColor whiteColor];
    // Show the sheet
    [[[camerasettingsSheet valueForKey:@"_buttons"] objectAtIndex:0] setImage:[UIImage imageNamed:@"closeactionsheet.png"] forState:UIControlStateNormal];
    
    [[[camerasettingsSheet valueForKey:@"_buttons"] objectAtIndex:1] setImage:[UIImage imageNamed:@"sendactionbtn.png"] forState:UIControlStateNormal];
    
    [[[camerasettingsSheet valueForKey:@"_buttons"] objectAtIndex:2] setImage:[UIImage imageNamed:@"savetocameraroll_actionbtn.png"] forState:UIControlStateNormal];
    
    [[[camerasettingsSheet valueForKey:@"_buttons"] objectAtIndex:3] setImage:[UIImage imageNamed:@"deleteactionbtn.png"] forState:UIControlStateNormal];
    
    [camerasettingsSheet showInView:self.view];
}
-(NSString*) saveImage:(int)btnid  {
    NSString *extension=@"png",*foofile;
    NSString * directoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    ImageVO *ivo=[activityDetailsArray objectAtIndex:btnid];
    //Get Image From URL
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:ivo.imagepath]];
    UIImage *image = [UIImage imageWithData:data];
    foofile = [directoryPath stringByAppendingPathComponent:[[ivo.imagepath componentsSeparatedByString:@"\/"] objectAtIndex:[[ivo.imagepath componentsSeparatedByString:@"\/"] count]-1]];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:foofile]) {
        [UIImagePNGRepresentation(image) writeToFile:[directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [[ivo.imagepath componentsSeparatedByString:@"\/"] objectAtIndex:[[ivo.imagepath componentsSeparatedByString:@"\/"] count]-1]]] options:NSAtomicWrite error:nil];
        
        
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:foofile];
        NSLog(@"fileExists %hhd",fileExists);

    }
            return foofile;
}


- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex==1) {
        NSString *filename= [self saveImage:buttonIndex];
        [self sendMails:filename];
    }
    else if (buttonIndex== 2){
        //Save Image to Directory
        [self saveImage:buttonIndex];
    }
    else{
        [self deleteMessage:buttonIndex];
    }
}

- (void) threadStartAnimating:(id)data {
    [activityIndicator startAnimating];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [activityIndicator stopAnimating];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    if(screenHeight>=568 && screenHeight<600){
        
    }else{
        tblviewContainerView.frame=CGRectMake(0, 0, 320, 350);
        [tblviewContainerView removeFromSuperview];
        [self.view addSubview:tblviewContainerView];
        tblView.frame=CGRectMake(0, 0, 320, 350);
        [tblView removeFromSuperview];
        [tblviewContainerView addSubview:tblView];
        cameraActionSheetButton.frame=CGRectMake(0, 350, 320, 40);
        [cameraActionSheetButton removeFromSuperview];
        [self.view addSubview:cameraActionSheetButton];
        openCameraButton.frame=CGRectMake(250, 270, 30, 30);
        [openCameraButton removeFromSuperview];
        [self.view addSubview:openCameraButton];
    }
    
    [self setFontFamily:@"Gotham Narrow" forView:self.view andSubViews:YES];
    // Do any additional setup after loading the view from its nib.
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFrame:CGRectMake(30, 0, 110, 35)];
    [titleLabel setText:@"CAMERA"];
    
    titleLabel.font =[UIFont systemFontOfSize:18];
    self.navigationItem.titleView = titleLabel;
    appDelegate=[[UIApplication sharedApplication] delegate];
    appDelegate.selectedMenuItem=@"CAMERA";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navBar.png"]];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"feedtablebg.png"]];
    SWRevealViewController *revealController = [self revealViewController];
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"reveal-icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom]; [btnRight setFrame:CGRectMake(0, 0, 30, 44)];
    btnRight.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:30];
    [btnRight setTitle:@"\uf067" forState:UIControlStateNormal];
    [btnRight setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(picImage) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtnRight = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    //[barBtnRight setTintColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = barBtnRight;

    //[self getImageList];
}
-(void)viewDidAppear:(BOOL)animated{
    //[self getImageList];
}
-(void)deleteMessage:(int)btnid{
    Reachability *myNetwork = [Reachability reachabilityWithHostname:@"google.com"];
    NetworkStatus myStatus = [myNetwork currentReachabilityStatus];
    if(myStatus == NotReachable)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Communication" message:@"No internet connection available!!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [activityIndicator stopAnimating];
    }else{

    ImageVO *ivo=[activityDetailsArray objectAtIndex:index];
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://millionairesorg.com/communication/deletepicture.php?pictureid=%@",ivo.imageid];
    NSData *mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSString *content = [[NSString alloc]  initWithBytes:[mydata bytes]
                                                  length:[mydata length] encoding: NSUTF8StringEncoding];
    
    
   // [self getImageList];
    }
}

-(void)getImageList{
    Reachability *myNetwork = [Reachability reachabilityWithHostname:@"google.com"];
    NetworkStatus myStatus = [myNetwork currentReachabilityStatus];
    if(myStatus == NotReachable)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Communication" message:@"No internet connection available!!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [activityIndicator stopAnimating];
    }else{

    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];

    activityDetailsArray=[[NSMutableArray alloc] init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    NSString *urlString = [[NSString alloc]initWithFormat:@"http://millionairesorg.com/communication/imagelist.php?userid=%@",[prefs objectForKey:@"loggedin"]];
    NSData *mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    NSString *content = [[NSString alloc]  initWithBytes:[mydata bytes]
                                                  length:[mydata length] encoding: NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:mydata options:0 error:&error];
        if (! json==nil)
        {

    if(![content isEqualToString:@"no"]){
        @try{
    NSArray *imageArray=[[json objectForKey:@"imagedetails"] objectForKey:@"image"];
    for (int count=0; count<[imageArray count]; count++) {
        @try {

        NSDictionary *activityData=[imageArray objectAtIndex:count];
        ImageVO *imgvo=[[ImageVO alloc]init];
        imgvo.imageid=[[NSString alloc] init];
        imgvo.imagepath=[[NSString alloc] init];
        
        
        imgvo.imageid=[activityData objectForKey:@"imageid"];
        imgvo.imagepath=[activityData objectForKey:@"imagepath"];

        [activityDetailsArray addObject:imgvo];
        }
        @catch (NSException * e) {
            NSLog(@"Exception: %@", e);
            NSDictionary *activityData=[[json objectForKey:@"imagedetails"] objectForKey:@"image"];
            ImageVO *imgvo=[[ImageVO alloc]init];
            imgvo.imageid=[[NSString alloc] init];
            imgvo.imagepath=[[NSString alloc] init];
            
            
            imgvo.imageid=[activityData objectForKey:@"imageid"];
            imgvo.imagepath=[activityData objectForKey:@"imagepath"];
            
            [activityDetailsArray addObject:imgvo];
        }
    }
        }       @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
        

    }
    }
    
    [tblView reloadData];
        }
    [activityIndicator stopAnimating];
    }
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
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

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
    //[self getImageList];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Communication"
                                                    message:@"Image uploaded successfully."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    }
    return true;
}


-(IBAction)submitButtonClicked {
    
        //[self uploadImage:UIImageJPEGRepresentation(image_, 1.0) filename:serverrateString];
        [activityIndicator stopAnimating];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma marl - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d",[activityDetailsArray count]/2);
    /*if([activityDetailsArray count]%2==0)
        return [activityDetailsArray count]/2;
    else
        return ([activityDetailsArray count]/2)+1;
*/
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    NSInteger row = 0;
    
    if(indexPath.row==0)
    {
        row=1;
    }else{
        row=((indexPath.row+1)*2)-1;
    }
    
   // ImageVO *imgaeVo=[activityDetailsArray objectAtIndex:row-1];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor=[UIColor whiteColor];
    
    
    AsyncImageView *mediaImage=[[AsyncImageView alloc] initWithFrame:CGRectMake(5, 5, 155, 150)];
    [mediaImage setBackgroundColor:[UIColor clearColor]];
    //[mediaImage loadImageFromURL:[NSURL URLWithString:imgaeVo.imagepath]];
    mediaImage.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"feed1.png"]];

    UIButton *transperentBtn=[[UIButton alloc] initWithFrame:CGRectMake(5, 0, 155, 150)];
    transperentBtn.tag=row-1;
    [transperentBtn addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [cell.contentView addSubview:mediaImage];
    [cell.contentView addSubview:transperentBtn];
    
       if([activityDetailsArray count]>row){
           //imgaeVo=[activityDetailsArray objectAtIndex:row];
        
        AsyncImageView *mediaImage2=[[AsyncImageView alloc] initWithFrame:CGRectMake(160, 5, 155, 150)];
        [mediaImage2 setBackgroundColor:[UIColor clearColor]];
        //[mediaImage2 loadImageFromURL:[NSURL URLWithString:imgaeVo.imagepath]];
           mediaImage2.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"feed2.png"]];

           UIButton *transperentBtn2=[[UIButton alloc] initWithFrame:CGRectMake(160, 0, 155, 150)];
           transperentBtn2.tag=row;
           //[transperentBtn2 addTarget:self action:@selector(showActionSheet:) forControlEvents:UIControlEventTouchUpInside];
           
        [cell.contentView addSubview:mediaImage2];
           [cell.contentView addSubview:transperentBtn2];

            }
    
    return cell;
}

@end
