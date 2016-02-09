//
//  SettingsViewController.m
//  CommunicationApp
//
//  Created by mansoor shaikh on 19/04/14.
//  Copyright (c) 2014 MobiWebCode. All rights reserved.
//

#import "SettingsViewController.h"
#import "SWRevealViewController.h"
#import "UIColor+Expanded.h"
#import <QuartzCore/QuartzCore.h>
#import "Reachability.h"
@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize appDelegate,scrollView,phoneTextField;
@synthesize messageNotificationLabel,calendarNotificationLabel,lblName,lblTitle,lblGender,lblCompany,lblAbout,lblEmail,lblPassword,lblPhone,lblPushNotification,activityIndicator;
@synthesize nameTextField,titleTextField,genderTextField,companyTextField,aboutTextField,emailTextField,passwordTextField,editBtnPicture,msgSwitch,calendarSwitch,psv,changePassword,upDateBtn,cancelBtn,alertView,txtOldPassword,txtnewPassword,OldPassword,newpwd,genderSegmentControl,gender;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)changedGender{
       if (genderSegmentControl.selectedSegmentIndex==0)
    {
        gender=@"Male";
        
    }else
    {
        gender=@"Female";
    }
   
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

- (void) threadStartAnimating:(id)data {
    [activityIndicator startAnimating];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
}

-(void)viewWillAppear:(BOOL)animated{
   // [self getUserDetails];
}

-(void)saveuserdetails{
    NSString *emailRegEx = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    
    if ([emailTest evaluateWithObject:emailTextField.text] == NO) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Test!" message:@"Please Enter Valid Email Address." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
        return;
    }else
    {
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSString *serverString=[[NSString alloc] initWithFormat:@"%@_%@_%@_%@_%@_%@_%@_%@",nameTextField.text,aboutTextField.text,titleTextField.text,gender,companyTextField.text,emailTextField.text,phoneTextField.text,[prefs stringForKey:@"loggedin"]];
    [self uploadImage:UIImageJPEGRepresentation([editBtnPicture backgroundImageForState:UIControlStateNormal], 1.0) filename:serverString];
}
}

- (void)viewDidLoad

{
    [super viewDidLoad];
    gender=[[NSString alloc]init];
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveuserdetails)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    [activityIndicator stopAnimating];
    [self setFontFamily:@"Open Sans" forView:self.view andSubViews:YES];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if(height>=568){
        scrollView.contentSize=CGSizeMake(width, height+250);
    }else{
        scrollView.contentSize=CGSizeMake(width, height+300);
    }
    
    // Do any additional setup after loading the view from its nib.
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFrame:CGRectMake(30, 0, 110, 35)];
    [titleLabel setText:@"SETTINGS"];
    
    titleLabel.font =[UIFont systemFontOfSize:18];
    messageNotificationLabel.font =[UIFont fontWithName:@"Gotham Narrow" size:[messageNotificationLabel font].pointSize];
    calendarNotificationLabel.font =[UIFont fontWithName:@"Gotham Narrow" size:[calendarNotificationLabel font].pointSize];
    self.navigationItem.titleView = titleLabel;
    appDelegate=[[UIApplication sharedApplication] delegate];
    appDelegate.selectedMenuItem=@"SETTINGS";

    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navBar.png"]];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"feedtablebg.png"]];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"feedtablebg.png"]];
    SWRevealViewController *revealController = [self revealViewController];
    
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"reveal-icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleDefault;
    numberToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelNumberPad)],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [numberToolbar sizeToFit];

    phoneTextField.inputAccessoryView = numberToolbar;
    
    CGFloat yheight = [UIScreen mainScreen].bounds.size.height;
    if(yheight>=480 && yheight<568){
        //iphone 4
        
        [editBtnPicture removeFromSuperview];
        [editBtnPicture.layer setFrame:CGRectMake(110,10,110,110)];
        [editBtnPicture setBackgroundColor:[UIColor clearColor]];
        [editBtnPicture setBackgroundImage:[UIImage imageNamed:@"user.png"] forState:UIControlStateNormal];
        [self.scrollView addSubview:editBtnPicture];
        
        lblName.layer.frame=CGRectMake(30,120,100,30);
        [lblName removeFromSuperview];
        [self.scrollView addSubview:lblName];
        
        nameTextField.layer.frame=CGRectMake(30,150,250,30);
        [nameTextField removeFromSuperview];
        [self.scrollView addSubview:nameTextField];
        
        lblTitle.layer.frame=CGRectMake(30,175,100,30);
        [lblTitle removeFromSuperview];
        [self.scrollView addSubview:lblTitle];
        
        titleTextField.layer.frame=CGRectMake(30,205,250,30);
        [titleTextField removeFromSuperview];
        [self.scrollView addSubview:titleTextField];
        
        lblGender.layer.frame=CGRectMake(30,235,90,30);
        [lblGender removeFromSuperview];
        [self.scrollView addSubview:lblGender];
        
        genderTextField.layer.frame=CGRectMake(30,260,90,30);
        [genderTextField removeFromSuperview];
        [self.scrollView addSubview:genderTextField];
        
        lblCompany.layer.frame=CGRectMake(130,235,100,30);
        [lblCompany removeFromSuperview];
        [self.scrollView addSubview:lblCompany];
        
        companyTextField.layer.frame=CGRectMake(130,260,150,30);
        [companyTextField removeFromSuperview];
        [self.scrollView addSubview:companyTextField];
        
        lblAbout.layer.frame=CGRectMake(30,290,200,30);
        [lblAbout removeFromSuperview];
        [self.scrollView addSubview:lblAbout];
        
        aboutTextField.layer.frame=CGRectMake(30,310,250,30);
        [aboutTextField removeFromSuperview];
        [self.scrollView addSubview:aboutTextField];
        
        lblEmail.layer.frame=CGRectMake(30,340,200,30);
        [lblEmail removeFromSuperview];
        [self.scrollView addSubview:lblEmail];
        
        emailTextField.layer.frame=CGRectMake(30,370,250,30);
        emailTextField.enabled=false;
        [emailTextField removeFromSuperview];
        [self.scrollView addSubview:emailTextField];
        
        lblPassword.layer.frame=CGRectMake(30,400,200,30);
        [lblPassword removeFromSuperview];
        [self.scrollView addSubview:lblPassword];
        
        genderSegmentControl.layer.frame=CGRectMake(30,430,250,30);
        [genderSegmentControl addTarget:self action:@selector(changedGender) forControlEvents:UIControlEventValueChanged];
        [genderSegmentControl removeFromSuperview];
        [self.scrollView addSubview:genderSegmentControl];
        
        changePassword.layer.frame=CGRectMake(30,460,200,30);
        [changePassword addTarget:self action:@selector(UpdatePassword) forControlEvents:UIControlEventTouchUpInside];
        [changePassword removeFromSuperview];
        [self.scrollView addSubview:changePassword];

        
        lblPhone.layer.frame=CGRectMake(30,490,200,30);
        [lblPhone removeFromSuperview];
        [self.scrollView addSubview:lblPhone];
        
        phoneTextField.layer.frame=CGRectMake(30,520,250,30);
        [phoneTextField removeFromSuperview];
        [self.scrollView addSubview:phoneTextField];
        
        lblPushNotification.layer.frame=CGRectMake(30,550,200,30);
        [lblPushNotification removeFromSuperview];
        [self.scrollView addSubview:lblPushNotification];
        
        messageNotificationLabel.layer.frame=CGRectMake(30,580,200,30);
        [messageNotificationLabel removeFromSuperview];
        [self.scrollView addSubview:messageNotificationLabel];
        
        [msgSwitch.layer setFrame:CGRectMake(235,580,40,40)];
        [msgSwitch removeFromSuperview];
        [self.scrollView addSubview:msgSwitch];
        
        [calendarNotificationLabel.layer setFrame:CGRectMake(30,610,200,30)];
        [calendarNotificationLabel removeFromSuperview];
        [self.scrollView addSubview:calendarNotificationLabel];
        
        [calendarSwitch.layer setFrame:CGRectMake(235,620,40,40)];
        [calendarSwitch removeFromSuperview];
        [self.scrollView addSubview:calendarSwitch];
        
    }else if(yheight>=568 && yheight<600){
        //iphone 5
        
        [editBtnPicture.layer setFrame:CGRectMake(110,10,110,110)];
        [editBtnPicture setBackgroundColor:[UIColor clearColor]];
        [editBtnPicture setBackgroundImage:[UIImage imageNamed:@"user.png"] forState:UIControlStateNormal];
        [self.scrollView addSubview:editBtnPicture];
        
        lblName.layer.frame=CGRectMake(30,120,100,30);
        [lblName removeFromSuperview];
        [self.scrollView addSubview:lblName];
        
        nameTextField.layer.frame=CGRectMake(30,150,250,30);
        [nameTextField removeFromSuperview];
        [self.scrollView addSubview:nameTextField];
        
        lblTitle.layer.frame=CGRectMake(30,175,100,30);
        [lblTitle removeFromSuperview];
        [self.scrollView addSubview:lblTitle];
        
        titleTextField.layer.frame=CGRectMake(30,205,250,30);
        [titleTextField removeFromSuperview];
        [self.scrollView addSubview:titleTextField];
        
        lblGender.layer.frame=CGRectMake(30,235,90,30);
        [lblGender removeFromSuperview];
        [self.scrollView addSubview:lblGender];
        
        genderSegmentControl.layer.frame=CGRectMake(30,260,90,30);
        //[genderSegmentControl addTarget:self action:@selector(changedGender) forControlEvents:
         //UIControlEventTouchUpInside];
         [genderSegmentControl addTarget:self action:@selector(changedGender) forControlEvents:UIControlEventValueChanged];
        [genderSegmentControl removeFromSuperview];
        [self.scrollView addSubview:genderSegmentControl];
        
        lblCompany.layer.frame=CGRectMake(130,235,100,30);
        [lblCompany removeFromSuperview];
        [self.scrollView addSubview:lblCompany];
        
        companyTextField.layer.frame=CGRectMake(130,260,150,30);
        [companyTextField removeFromSuperview];
        [self.scrollView addSubview:companyTextField];
        
         lblAbout.layer.frame=CGRectMake(30,290,200,30);
        [lblAbout removeFromSuperview];
        [self.scrollView addSubview:lblAbout];
        
        aboutTextField.layer.frame=CGRectMake(30,310,250,30);
        [aboutTextField removeFromSuperview];
        [self.scrollView addSubview:aboutTextField];
        
        lblEmail.layer.frame=CGRectMake(30,340,200,30);
        [lblEmail removeFromSuperview];
        [self.scrollView addSubview:lblEmail];
        
        emailTextField.layer.frame=CGRectMake(30,370,250,30);
        emailTextField.enabled=false;
        [emailTextField removeFromSuperview];
        [self.scrollView addSubview:emailTextField];
        
       lblPassword.layer.frame=CGRectMake(30,400,200,30);
        [lblPassword removeFromSuperview];
        [self.scrollView addSubview:lblPassword];
        
        passwordTextField.layer.frame=CGRectMake(30,430,250,30);
        [passwordTextField removeFromSuperview];
        [self.scrollView addSubview:passwordTextField];
        
        
        changePassword.layer.frame=CGRectMake(30,460,200,30);
        [changePassword addTarget:self action:@selector(UpdatePassword) forControlEvents:UIControlEventTouchUpInside];
       
        [changePassword removeFromSuperview];
        [self.scrollView addSubview:changePassword];
        
        lblPhone.layer.frame=CGRectMake(30,490,200,30);
        [lblPhone removeFromSuperview];
        [self.scrollView addSubview:lblPhone];
        
        phoneTextField.layer.frame=CGRectMake(30,520,250,30);
        [phoneTextField removeFromSuperview];
        [self.scrollView addSubview:phoneTextField];
        
        lblPushNotification.layer.frame=CGRectMake(30,550,200,30);
        [lblPushNotification removeFromSuperview];
        [self.scrollView addSubview:lblPushNotification];
        
        messageNotificationLabel.layer.frame=CGRectMake(30,580,200,30);
        [messageNotificationLabel removeFromSuperview];
        [self.scrollView addSubview:messageNotificationLabel];
        
        [msgSwitch.layer setFrame:CGRectMake(235,580,40,40)];
        [msgSwitch removeFromSuperview];
        [self.scrollView addSubview:msgSwitch];
        
        [calendarNotificationLabel.layer setFrame:CGRectMake(30,610,200,30)];
        [calendarNotificationLabel removeFromSuperview];
        [self.scrollView addSubview:calendarNotificationLabel];
        
        [calendarSwitch.layer setFrame:CGRectMake(235,620,40,40)];
        [calendarSwitch removeFromSuperview];
        [self.scrollView addSubview:calendarSwitch];

        
    }else{
        
        
        [editBtnPicture removeFromSuperview];
        [editBtnPicture.layer setFrame:CGRectMake(110,10,110,110)];
        [editBtnPicture setBackgroundColor:[UIColor clearColor]];
        [editBtnPicture setBackgroundImage:[UIImage imageNamed:@"user.png"] forState:UIControlStateNormal];
        [self.scrollView addSubview:editBtnPicture];
        
        lblName.layer.frame=CGRectMake(30,120,100,30);
        [lblName removeFromSuperview];
        [self.scrollView addSubview:lblName];
        
        nameTextField.layer.frame=CGRectMake(30,150,250,30);
        [nameTextField removeFromSuperview];
        [self.scrollView addSubview:nameTextField];
        
        lblTitle.layer.frame=CGRectMake(30,175,100,30);
        [lblTitle removeFromSuperview];
        [self.scrollView addSubview:lblTitle];
        
        titleTextField.layer.frame=CGRectMake(30,205,250,30);
        [titleTextField removeFromSuperview];
        [self.scrollView addSubview:titleTextField];
        
        lblGender.layer.frame=CGRectMake(30,235,90,30);
        [lblGender removeFromSuperview];
        [self.scrollView addSubview:lblGender];
        
        genderSegmentControl.layer.frame=CGRectMake(30,260,90,30);
        [genderSegmentControl addTarget:self action:@selector(changedGender) forControlEvents:UIControlEventTouchUpInside];
        [genderSegmentControl removeFromSuperview];
        [self.scrollView addSubview:genderSegmentControl];
        
        lblCompany.layer.frame=CGRectMake(130,235,100,30);
        [lblCompany removeFromSuperview];
        [self.scrollView addSubview:lblCompany];
        
        companyTextField.layer.frame=CGRectMake(130,260,150,30);
        [companyTextField removeFromSuperview];
        [self.scrollView addSubview:companyTextField];
        
        lblAbout.layer.frame=CGRectMake(30,290,200,30);
        [lblAbout removeFromSuperview];
        [self.scrollView addSubview:lblAbout];
        
        aboutTextField.layer.frame=CGRectMake(30,310,250,30);
        [aboutTextField removeFromSuperview];
        [self.scrollView addSubview:aboutTextField];
        
        lblEmail.layer.frame=CGRectMake(30,340,200,30);
        [lblEmail removeFromSuperview];
        [self.scrollView addSubview:lblEmail];
        
        emailTextField.layer.frame=CGRectMake(30,370,250,30);
        emailTextField.enabled=false;
        [emailTextField removeFromSuperview];
        [self.scrollView addSubview:emailTextField];
        
        lblPassword.layer.frame=CGRectMake(30,400,200,30);
        [lblPassword removeFromSuperview];
        [self.scrollView addSubview:lblPassword];
        
        passwordTextField.layer.frame=CGRectMake(30,430,250,30);
        [passwordTextField removeFromSuperview];
        [self.scrollView addSubview:passwordTextField];
        
        changePassword.layer.frame=CGRectMake(30,460,200,30);
        [genderSegmentControl addTarget:self action:@selector(changedGender) forControlEvents:UIControlEventValueChanged];
        [changePassword removeFromSuperview];
        [self.scrollView addSubview:changePassword];
        
        lblPhone.layer.frame=CGRectMake(30,490,200,30);
        [lblPhone removeFromSuperview];
        [self.scrollView addSubview:lblPhone];
        
        phoneTextField.layer.frame=CGRectMake(30,520,250,30);
        [phoneTextField removeFromSuperview];
        [self.scrollView addSubview:phoneTextField];
        
        lblPushNotification.layer.frame=CGRectMake(30,550,200,30);
        [lblPushNotification removeFromSuperview];
        [self.scrollView addSubview:lblPushNotification];
        
        messageNotificationLabel.layer.frame=CGRectMake(30,580,200,30);
        [messageNotificationLabel removeFromSuperview];
        [self.scrollView addSubview:messageNotificationLabel];
        
        [msgSwitch.layer setFrame:CGRectMake(235,580,40,40)];
        [msgSwitch removeFromSuperview];
        [self.scrollView addSubview:msgSwitch];
        
        [calendarNotificationLabel.layer setFrame:CGRectMake(30,580,200,30)];
        [calendarNotificationLabel removeFromSuperview];
        [self.scrollView addSubview:calendarNotificationLabel];
        
        
        [calendarSwitch.layer setFrame:CGRectMake(235,620,40,40)];
        [calendarSwitch removeFromSuperview];
        [self.scrollView addSubview:calendarSwitch];
    }
}
-(IBAction)messageOnOff{
    if(msgSwitch.on == YES)
    {
        NSUserDefaults *prefsmsg = [NSUserDefaults standardUserDefaults];
        [prefsmsg setObject:@"yes" forKey:@"message"];
        [prefsmsg synchronize];
    }else{
        NSUserDefaults *prefsmsg = [NSUserDefaults standardUserDefaults];
        [prefsmsg setObject:@"no" forKey:@"message"];
        [prefsmsg synchronize];
  
    }

}

-(IBAction)calendarOnOff{
    if(calendarSwitch.on == YES)
    {
        NSUserDefaults *prefscal = [NSUserDefaults standardUserDefaults];
        [prefscal setObject:@"yes" forKey:@"calendar"];
        [prefscal synchronize];
    }else{
    
        NSUserDefaults *prefscal = [NSUserDefaults standardUserDefaults];
        [prefscal setObject:@"no" forKey:@"calendar"];
        [prefscal synchronize];

    }
    
 
}
-(void)getUserDetails{
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
    
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://millionairesorg.com/communication/getuserdetail_Android.php?userid=%@",[prefs stringForKey:@"loggedin"]];
    NSData *mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    NSString *content = [[NSString alloc]  initWithBytes:[mydata bytes]
                                                  length:[mydata length] encoding: NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:mydata options:0 error:&error];
    
    NSDictionary *userdetails=[[json objectForKey:@"userdetails"] objectForKey:@"user"];
    @try {
        nameTextField.text=[userdetails objectForKey:@"username"];    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    @try {
        titleTextField.text=[userdetails objectForKey:@"title"];
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    
    @try {
       phoneTextField.text=[userdetails objectForKey:@"phone"];
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    
    @try {
        if([[[userdetails objectForKey:@"gender"] lowercaseString] isEqualToString:@"male"])
        {
            genderSegmentControl.selectedSegmentIndex=0;
            
        }else
        {
            genderSegmentControl.selectedSegmentIndex=1;
        }
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
   
    @try {
        companyTextField.text=[userdetails objectForKey:@"company"];
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    
    @try {
        aboutTextField.text=[userdetails objectForKey:@"about"];
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    
    @try {
        emailTextField.text=[userdetails objectForKey:@"email"];
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    
    @try {
        passwordTextField.text=[userdetails objectForKey:@"password"];
    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    
    @try {
        NSURL *url = [NSURL URLWithString:[[userdetails objectForKey:@"picture"] stringByReplacingOccurrencesOfString:@"\/" withString:@"/"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *img = [[UIImage alloc] initWithData:data];
        [editBtnPicture setBackgroundImage:img forState:UIControlStateNormal];

    }
    @catch (NSException * e) {
        NSLog(@"Exception: %@", e);
    }
    
    
    [activityIndicator stopAnimating];
    }
}

-(void)changePasswordUpdate{
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
    
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://millionairesorg.com/communication/updatepassword.php?userid=%@&password=%@",[prefs stringForKey:@"loggedin"],newpwd];
    NSData *mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    NSString *content = [[NSString alloc]  initWithBytes:[mydata bytes]
                                                  length:[mydata length] encoding: NSUTF8StringEncoding];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Communication"
                                                    message:@"Password updated successfully."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
     [activityIndicator stopAnimating];
    }
}

-(void)updatePassword{
    OldPassword=[[NSString alloc]init];
    newpwd=[[NSString alloc]init];
    OldPassword=txtOldPassword.text;
    newpwd=txtnewPassword.text;
    if ([OldPassword isEqualToString: (passwordTextField.text)]
        && ![newpwd isEqualToString:@"" ]){
        [self changePasswordUpdate];
    } else if([newpwd isEqualToString:@""])
             {
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Communication"
                                                                 message:@"New Password Can't be empty"
                                                                delegate:self
                                                       cancelButtonTitle:@"OK"
                                                       otherButtonTitles:nil];
                 [alert show];
                 
             }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Communication"
                                                        message:@"Your old password doesn't match"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    [alertView close];
}

-(void)cancelNumberPad{
    [phoneTextField resignFirstResponder];
    phoneTextField.text = @"";
}

-(void)doneWithNumberPad{
    [phoneTextField resignFirstResponder];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    NSString *urlString = @"http://millionairesorg.com/communication/mobile_uploaduserinfo.php";
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
    [activityIndicator stopAnimating];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Communication"
                                                    message:@"User details updated successfully."
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    }
    return true;
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
-(UIView *)changePassAlert{
    
    
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300,150)];
    [demoView setBackgroundColor:[UIColor whiteColor]];
    demoView.layer.cornerRadius=5;
    [demoView.layer setMasksToBounds:YES];
    [demoView.layer setBorderWidth:1.0];
    demoView.layer.borderColor=[[UIColor whiteColor]CGColor];
    
    txtOldPassword=[[UITextField alloc] initWithFrame:CGRectMake(0,0, 300,48)];
    txtOldPassword.placeholder=@"Old Password";
    txtOldPassword.borderStyle =UITextBorderStyleRoundedRect;
    [demoView addSubview:txtOldPassword];
    
    txtnewPassword=[[UITextField alloc] initWithFrame:CGRectMake(0,50, 300,48)];
    txtnewPassword.placeholder=@"New Password";
    txtnewPassword.borderStyle =UITextBorderStyleRoundedRect;
    [demoView addSubview:txtnewPassword];

    
    upDateBtn=[[UIButton alloc] initWithFrame:CGRectMake(0,100,150,50)];
    [upDateBtn setTitle:@"Update" forState:UIControlStateNormal];
    [upDateBtn addTarget:self
                     action:@selector(updatePassword)
           forControlEvents:UIControlEventTouchUpInside];
    [upDateBtn setBackgroundColor:[UIColor blackColor]];
        [demoView addSubview:upDateBtn];
    
    cancelBtn=[[UIButton alloc] initWithFrame:CGRectMake(150,100,150,50)];
    [cancelBtn setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelBtn addTarget:self
                     action:@selector(closeAlert:)
           forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setBackgroundColor:[UIColor blackColor]];
    [demoView addSubview:cancelBtn];
    return demoView;
    
}

-(void)closeAlert:(id)sender{
    [alertView close];
}


-(IBAction)UpdatePassword{
    alertView = [[CustomIOS7AlertView alloc] init];
    
    // Add some custom content to the alert view
    [alertView setContainerView:[self changePassAlert]];
    
    // Modify the parameters
    
    [alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView_, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, [alertView_ tag]);
        [alertView_ close];
    }];
    
    [alertView setUseMotionEffects:true];
    
    // And launch the dialog
    [alertView show];
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
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        [editBtnPicture setBackgroundImage:image forState:UIControlStateNormal];
        
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        // Code here to support video if enabled
    }
    //[self performSelector:@selector(pushView) withObject:nil afterDelay:0.2];
}



@end
