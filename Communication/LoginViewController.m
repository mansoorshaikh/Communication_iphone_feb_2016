//
//  LoginViewController.m
//  CommunicationApp
//
//  Created by mansoor shaikh on 12/04/14.
//  Copyright (c) 2014 MobiWebCode. All rights reserved.
//

#import "LoginViewController.h"
#import "SWRevealViewController.h"
#import "MainViewController.h"
#import "UIColor+Expanded.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize requestAccessButton;
@synthesize uiRequestAccessBtn,userPicture,loginClickButton,txtUserName,txtPassword,rememberLbl,onoff,userImageView,alertViewLogin,psv,image,activityIndicator;
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

-(IBAction)requestAction
{
    [self loginAction];
}
-(IBAction)loginAction{
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if ([emailTest evaluateWithObject:txtUserName.text] == NO) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Test!" message:@"Please Enter Valid Email Address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        return;
    }else if ([txtUserName.text isEqualToString:@""] || [txtPassword.text isEqualToString:@""]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Communication"
                                                        message:@"Please fill in username and password."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else if(image==nil){
        Reachability *myNetwork = [Reachability reachabilityWithHostname:@"google.com"];
        NetworkStatus myStatus = [myNetwork currentReachabilityStatus];
        if(myStatus == NotReachable)
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Communication" message:@"No internet connection available!!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [activityIndicator stopAnimating];
        }else{

    NSString *urlString = [[NSString alloc]initWithFormat:@"http://millionairesorg.com/communication/login.php?email=%@&password=%@",txtUserName.text,txtPassword.text];
    NSData *mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    NSString *content = [[NSString alloc]  initWithBytes:[mydata bytes]
                                                  length:[mydata length] encoding: NSUTF8StringEncoding];
        if([content isEqualToString:@"-3"])
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Communication" message:@"Your password is wrong please check!!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            
        }
        else if([content isEqualToString:@"-2"])
        {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Communication" message:@"Sorry this email does not belong to company register   !!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            
        }
        else if([content isEqualToString:@"-1"])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Communication" message:@"Your access has been rehoked, please contact admin !!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }else if([content isEqualToString:@"0"])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Communication" message:@"Please wait for permission granted to admin " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else{
        if(onoff.on == YES)
        {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:content forKey:@"loggedin"];
        [prefs synchronize];
        }
        MainViewController *mainvc=[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
        [self.navigationController pushViewController:mainvc animated:YES];
    
    }
    }
    }
    else{
        [self saveuserdetails];
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

    NSString *urlString = @"http://millionairesorg.com/communication/login_iphone.php";
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
    NSString *content = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"return string %@",content);
    NSString* string2 = [content stringByReplacingOccurrencesOfString:@" " withString:@""];

    if([string2 isEqualToString:@"-3"])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Communication" message:@"Your password is wrong please check!!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
    else if([string2 isEqualToString:@"-2"])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Communication" message:@"Sorry this email does not belong to any of company registered on communication app !!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
    else if([string2 isEqualToString:@"-1"])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Communication" message:@"Your access has been rehoked, please contact admin !!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }else if([string2 isEqualToString:@"0"])
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Communication" message:@"Please wait for permission granted to admin " delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
    }
    else{
        if(onoff.on == YES)
        {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:content forKey:@"loggedin"];
        [prefs synchronize];
        }
        MainViewController *mainvc=[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
        [self.navigationController pushViewController:mainvc animated:YES];
        
    }
    }
    
    return true;
    [activityIndicator stopAnimating];
    

}
-(void)saveuserdetails{
        NSString *serverString=[[NSString alloc] initWithFormat:@"%@_%@_",txtUserName.text,txtPassword.text];
        [self uploadImage:UIImageJPEGRepresentation([userPicture backgroundImageForState:UIControlStateNormal], 1.0) filename:serverString];
}

- (void) threadStartAnimating:(id)data {
    [activityIndicator startAnimating];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [activityIndicator stopAnimating];

    self.navigationController.navigationBarHidden=YES;
    [self setFontFamily:@"Open Sans" forView:self.view andSubViews:YES];
//    requestAccessButton.font = [UIFont fontWithName:@"Gotham Narrow" size:[requestAccessButton font].pointSize];
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if(height>=480 && height<568){
        //iphone 4
        [userPicture removeFromSuperview];
        [userPicture.layer setFrame:CGRectMake(110,50,100,100)];
        //[userPicture setBackgroundImage:[UIImage imageNamed:@"user.png"] forState:UIControlStateNormal];
        [self.view addSubview:userPicture];
        
        txtUserName.layer.frame=CGRectMake(60,170,200,35);
        [txtUserName removeFromSuperview];
        [self.view addSubview:txtUserName];
        
        txtPassword.layer.frame=CGRectMake(60,220,200,35);
        [txtPassword removeFromSuperview];
        [self.view addSubview:txtPassword];
        
        [loginClickButton removeFromSuperview];
        [loginClickButton.layer setFrame:CGRectMake(60,265,200,35)];
        [loginClickButton setBackgroundImage:[UIImage imageNamed:@"login.png"] forState:UIControlStateNormal];
        [self.view addSubview:loginClickButton];
        
        requestAccessButton.layer.frame=CGRectMake(60,310,150,35);
        [requestAccessButton removeFromSuperview];
        [self.view addSubview:requestAccessButton];
        
        [onoff.layer setFrame:CGRectMake(205,320,40,40)];
        [onoff removeFromSuperview];
        [self.view addSubview:onoff];
        
        uiRequestAccessBtn.layer.frame=CGRectMake(60,375,200,30);
        [requestAccessButton removeFromSuperview];
        [self.view addSubview:requestAccessButton];
        
    }else if(height>=568 && height<600){
        //iphone 5
        
        [userPicture removeFromSuperview];
        [userPicture.layer setFrame:CGRectMake(110,50,100,100)];
        //[userPicture setBackgroundImage:[UIImage imageNamed:@"user.png"] forState:UIControlStateNormal];
        [self.view addSubview:userPicture];
        
        txtUserName.layer.frame=CGRectMake(60,170,200,35);
        [txtUserName removeFromSuperview];
        [self.view addSubview:txtUserName];
        
        txtPassword.layer.frame=CGRectMake(60,220,200,35);
        [txtPassword removeFromSuperview];
        [self.view addSubview:txtPassword];
        
        [loginClickButton removeFromSuperview];
        [loginClickButton.layer setFrame:CGRectMake(60,265,200,35)];
        [loginClickButton setBackgroundImage:[UIImage imageNamed:@"login.png"] forState:UIControlStateNormal];
        [self.view addSubview:loginClickButton];
    
        requestAccessButton.layer.frame=CGRectMake(60,310,150,35);
        [requestAccessButton removeFromSuperview];
        [self.view addSubview:requestAccessButton];
        
        [onoff.layer setFrame:CGRectMake(205,320,40,40)];
        [onoff removeFromSuperview];
        [self.view addSubview:onoff];
        
        uiRequestAccessBtn.layer.frame=CGRectMake(60,375,200,30);
        [requestAccessButton removeFromSuperview];
        [self.view addSubview:requestAccessButton];

    }else{
        
        [userPicture removeFromSuperview];
        [userPicture.layer setFrame:CGRectMake(110,50,100,100)];
        [userPicture setBackgroundImage:[UIImage imageNamed:@"user.png"] forState:UIControlStateNormal];
        [self.view addSubview:userPicture];
        
        txtUserName.layer.frame=CGRectMake(60,170,200,35);
        [txtUserName removeFromSuperview];
        [self.view addSubview:txtUserName];
        
        txtPassword.layer.frame=CGRectMake(60,220,200,35);
        [txtPassword removeFromSuperview];
        [self.view addSubview:txtPassword];
        
        [loginClickButton removeFromSuperview];
        [loginClickButton.layer setFrame:CGRectMake(60,265,200,35)];
        [loginClickButton setBackgroundImage:[UIImage imageNamed:@"login.png"] forState:UIControlStateNormal];
        [self.view addSubview:loginClickButton];
        
        requestAccessButton.layer.frame=CGRectMake(60,310,150,35);
        [requestAccessButton removeFromSuperview];
        [self.view addSubview:requestAccessButton];
        
        [onoff.layer setFrame:CGRectMake(205,320,40,40)];
        [onoff removeFromSuperview];
        [self.view addSubview:onoff];
        
        uiRequestAccessBtn.layer.frame=CGRectMake(60,375,200,30);
        [requestAccessButton removeFromSuperview];
        [self.view addSubview:requestAccessButton];

    }
    
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([prefs stringForKey:@"loggedin"]!=nil){
        MainViewController *mainvc=[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
        [self.navigationController pushViewController:mainvc animated:YES];

    }
    //[self getUserDetails];
}

-(IBAction)rememberUser:(id)sender
{
    
    {
       
    }
    
}

-(IBAction)pickImage{
    psv=[[PictureSetview alloc] init];
    
    UIButton *galleryOption=[[UIButton alloc] initWithFrame:CGRectMake(0,50, 300,48)];
    [galleryOption setTitle:@"Gallery" forState:UIControlStateNormal];
    [galleryOption addTarget:self
                      action:@selector(galleryOption)
            forControlEvents:UIControlEventTouchUpInside];
    [galleryOption setBackgroundColor:[UIColor blackColor]];
    galleryOption.tag=1;
    [psv.demoView addSubview:galleryOption];
    
    UIButton *cameraOption=[[UIButton alloc] initWithFrame:CGRectMake(0,102, 300,50)];
    [cameraOption setTitle:@"Camera" forState:UIControlStateNormal];
    [cameraOption addTarget:self
                     action:@selector(cameraOption)
           forControlEvents:UIControlEventTouchUpInside];
    [cameraOption setBackgroundColor:[UIColor blackColor]];
    cameraOption.tag=1;
    [psv.demoView addSubview:cameraOption];
    
    [psv show];
    
}
-(void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        [controller setMediaTypes:[NSArray arrayWithObject:(NSString *)kUTTypeImage]];
        [controller setDelegate:self];
        
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:controller];
        [popover setDelegate:self];
        [popover presentPopoverFromRect:CGRectMake(455, 665, 30, 30) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
        popover.popoverContentSize = CGSizeMake(315, 500);
        // [controller release];
        
    }
    else
    {
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
-(void)galleryOption{
    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
    [psv close];
}
-(void)cameraOption{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertView *altView = [[UIAlertView alloc]initWithTitle:@"" message:@"Sorry, you do not have a camera" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [altView show];
        //[altView release];
        return;
    }
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
    [psv close];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    if([title isEqualToString:@"Camera"]){
        [self galleryOption];
    }
    else if([title isEqualToString:@"Gallery"]){
        [self cameraOption];
    }else if([title isEqualToString:@"Cancel"]){
        [alertView dismissWithClickedButtonIndex:2 animated:YES];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
    [self dismissModalViewControllerAnimated:YES];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        [userPicture setBackgroundImage:image forState:UIControlStateNormal];
        
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
    //[self performSelector:@selector(pushView) withObject:nil afterDelay:0.2];
}


-(void)closeAlert1:(id)sender{
    [alertViewLogin close];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

