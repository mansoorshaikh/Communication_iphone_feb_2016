//
//  HomeViewController.m
//  CommunicationApp
//
//  Created by mansoor shaikh on 13/04/14.
//  Copyright (c) 2014 MobiWebCode. All rights reserved.
//

#import "HomeViewController.h"
#import "SWRevealViewController.h"
#import "AsyncImageView.h"
#import "ActivityVO.h"
#import "ActivityViewController.h"
#import "SettingsViewController.h"
#import "FeedViewController.h"
#import "CalendarViewController.h"
#import "MediaViewController.h"
#import "Reachability.h"
@interface HomeViewController ()

@end

@implementation HomeViewController
@synthesize appDelegate,activityIndicator;
@synthesize btnNewMsg,btnNewSurveys,imageViewNewEvent,tableViewMain,btnNewMsgnumber,btnNewServeyNumber,btnDate,btnNoNewEvent,lblNewMsg,lblNewSurveys,string,dateLabel,activityDetailsArray,settingVCUserName,deviceToken;




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

-(void)getActivityList{
    
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://millionairesorg.com/communication/ActivityDetail.php?userid=%@",[prefs objectForKey:@"loggedin"]];
    NSData *mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    NSString *content = [[NSString alloc]  initWithBytes:[mydata bytes]
                                                  length:[mydata length] encoding: NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:mydata options:0 error:&error];
    if(![content isEqualToString:@""]){
        @try {

    NSArray *activityArray=[[json objectForKey:@"activitydetail"] objectForKey:@"activity"];
    for (int count=0; count<[activityArray count]; count++) {
         @try {
        NSDictionary *activityData=[activityArray objectAtIndex:count];
        ActivityVO *avo=[[ActivityVO alloc] init];
        avo.activitytype=[[NSString alloc] init];
        avo.firstinformation=[[NSString alloc] init];
        avo.secondinformation=[[NSString alloc] init];
        avo.date=[[NSString alloc] init];
        if ([activityData objectForKey:@"activitytype"] != [NSNull null])
            avo.activitytype=[activityData objectForKey:@"activitytype"];
            avo.firstinformation=[activityData objectForKey:@"firstinformation"];
            avo.secondinformation=[activityData objectForKey:@"secondinformation"];
            avo.date=[activityData objectForKey:@"date"];
            [activityDetailsArray addObject:avo];
         }
             @catch (NSException * e) {
                 NSLog(@"Exception: %@", e);
                 NSDictionary *activityData=[[json objectForKey:@"activitydetail"] objectForKey:@"activity"];
                 ActivityVO *avo=[[ActivityVO alloc] init];
                 avo.activitytype=[[NSString alloc] init];
                 avo.firstinformation=[[NSString alloc] init];
                 avo.secondinformation=[[NSString alloc] init];
                 avo.date=[[NSString alloc] init];
                 if ([activityData objectForKey:@"activitytype"] != [NSNull null])
                     avo.activitytype=[activityData objectForKey:@"activitytype"];
                 avo.firstinformation=[activityData objectForKey:@"firstinformation"];
                 avo.secondinformation=[activityData objectForKey:@"secondinformation"];
                 avo.date=[activityData objectForKey:@"date"];
                 [activityDetailsArray addObject:avo];
             }

    }
        }             @catch (NSException * e) {
        }
    }
    [tableViewMain reloadData];
    [activityIndicator stopAnimating];
}

-(void)getHomePageDetails{
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
     NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://millionairesorg.com/communication/HomepageDetail.php?userid=%@",[prefs objectForKey:@"loggedin"]];
    NSData *mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:mydata options:0 error:&error];
    if (![[json valueForKey:@"homepagedetails"] isKindOfClass:[NSNull null]])
    {

    NSDictionary *homepage=[[json objectForKey:@"homepagedetails"] objectForKey:@"homepage"];
    
    [btnNewMsgnumber setTitle:[NSString stringWithFormat:@"%@ \n New Messages",[homepage objectForKey:@"messages"]] forState:UIControlStateNormal];
    [btnNewServeyNumber setTitle:[NSString stringWithFormat:@"%@ \n New Surveys",[homepage objectForKey:@"survey"]] forState:UIControlStateNormal];
    [btnNoNewEvent setTitle:[NSString stringWithFormat:@"        %@ \n New Events",[homepage objectForKey:@"events"]] forState:UIControlStateNormal];
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFrame:CGRectMake(30, 0, 110, 35)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setText:[NSString stringWithFormat:@"Hi %@",[homepage objectForKey:@"username"]]];
    
    titleLabel.font =[UIFont systemFontOfSize:18];
    self.navigationItem.titleView = titleLabel;
    }
    [activityIndicator stopAnimating];
}

- (void) threadStartAnimating:(id)data {
    [activityIndicator startAnimating];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    activityDetailsArray=[[NSMutableArray alloc] init];
      appDelegate=[[UIApplication sharedApplication] delegate];
    
   
    [activityIndicator stopAnimating];
    [self setFontFamily:@"Open Sans" forView:self.view andSubViews:YES];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navBar.png"]];
    self.navigationController.navigationBar.translucent = NO;
  
    SWRevealViewController *revealController = [self revealViewController];
    appDelegate.selectedMenuItem=@"Home";

    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
 
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"reveal-icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;

    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if(height>=480 && height<568){
        //iphone 4
        
        btnNewMsg.layer.frame=CGRectMake(0,0,170,120);
        [btnNewMsg removeFromSuperview];
        [self.view addSubview:btnNewMsg];
        
        btnNewMsgnumber.layer.frame=CGRectMake(20,15,140,60);
        [btnNewMsgnumber removeFromSuperview];
        [self.view addSubview:btnNewMsgnumber];
        
        btnNewSurveys.layer.frame=CGRectMake(170,0,170,120);
        [btnNewSurveys removeFromSuperview];
        [self.view addSubview:btnNewSurveys];
        
        btnNewServeyNumber.layer.frame=CGRectMake(190,15,140,60);
        [btnNewServeyNumber removeFromSuperview];
        [self.view addSubview:btnNewServeyNumber];
        
        lblNewMsg.layer.frame=CGRectMake(10,70,100,30);
         [lblNewMsg removeFromSuperview];
         [self.view addSubview:lblNewMsg];
        [self.view bringSubviewToFront:lblNewMsg];
        
         lblNewSurveys.layer.frame=CGRectMake(180,70,100,30);
         [lblNewSurveys removeFromSuperview];
         [self.view addSubview:lblNewSurveys];
         [self.view bringSubviewToFront:lblNewSurveys];
        
        imageViewNewEvent.frame=CGRectMake(0,120,320,120);
        imageViewNewEvent.image=[UIImage imageNamed:@"home_calendorbg.png"];
        [imageViewNewEvent removeFromSuperview];
        [self.view addSubview:imageViewNewEvent];
        
        btnDate.layer.frame=CGRectMake(20,140,140,75);
        [btnDate removeFromSuperview];
        [self.view addSubview:btnDate];
        
        btnNoNewEvent.layer.frame=CGRectMake(170,140,140,75);
        [btnNoNewEvent removeFromSuperview];
        [self.view addSubview:btnNoNewEvent];
        
        
        tableViewMain.layer.cornerRadius=5;
        tableViewMain.frame=CGRectMake(0,260,480,500);
        [tableViewMain removeFromSuperview];
        [self.view addSubview:tableViewMain];
        
                
    }else if(height>=568 && height<600){
        //iphone 5
        
        btnNewMsg.layer.frame=CGRectMake(0,0,170,130);
        [btnNewMsg removeFromSuperview];
        [self.view addSubview:btnNewMsg];
        
        btnNewMsgnumber.layer.frame=CGRectMake(20,15,140,60);
        [btnNewMsgnumber removeFromSuperview];
        [self.view addSubview:btnNewMsgnumber];
        
        btnNewSurveys.layer.frame=CGRectMake(170,0,170,130);
        [btnNewSurveys removeFromSuperview];
        [self.view addSubview:btnNewSurveys];
        
        btnNewServeyNumber.layer.frame=CGRectMake(180,15,140,60);
        [btnNewServeyNumber removeFromSuperview];
        [self.view addSubview:btnNewServeyNumber];
        
        lblNewMsg.layer.frame=CGRectMake(30,70,100,30);
        [btnNewServeyNumber removeFromSuperview];
        [self.view addSubview:btnNewServeyNumber];
        [self.view bringSubviewToFront:lblNewMsg];
        
        lblNewSurveys.layer.frame=CGRectMake(190,70,100,30);
        [btnNewServeyNumber removeFromSuperview];
        [self.view addSubview:btnNewServeyNumber];
        [self.view bringSubviewToFront:lblNewSurveys];


        
        imageViewNewEvent.frame=CGRectMake(0,130,320,130);
        imageViewNewEvent.image=[UIImage imageNamed:@"home_calendorbg.png"];
        [imageViewNewEvent removeFromSuperview];
        [self.view addSubview:imageViewNewEvent];
        
        btnDate.layer.frame=CGRectMake(15,160,140,75);
        [btnDate removeFromSuperview];
        [self.view addSubview:btnDate];
        
        dateLabel.layer.frame=CGRectMake(20,150,140,75);
        [dateLabel removeFromSuperview];
        [self.view addSubview:dateLabel];
        [self.view bringSubviewToFront:lblNewMsg];
        
        btnNoNewEvent.layer.frame=CGRectMake(170,150,140,75);
        [btnNoNewEvent removeFromSuperview];
        [self.view addSubview:btnNoNewEvent];
        
        
        tableViewMain.layer.cornerRadius=5;
        tableViewMain.frame=CGRectMake(0,270,self.view.bounds.size.width,460);
        [tableViewMain removeFromSuperview];
        [self.view addSubview:tableViewMain];
        
    }else{
        
        btnNewMsg.layer.frame=CGRectMake(0,0,170,130);
        [btnNewMsg removeFromSuperview];
        [self.view addSubview:btnNewMsg];
        
        btnNewMsgnumber.layer.frame=CGRectMake(20,15,140,60);
        [btnNewMsgnumber removeFromSuperview];
        [self.view addSubview:btnNewMsgnumber];
        
        btnNewSurveys.layer.frame=CGRectMake(170,0,170,130);
        [btnNewSurveys removeFromSuperview];
        [self.view addSubview:btnNewSurveys];
        
        btnNewServeyNumber.layer.frame=CGRectMake(190,15,140,60);
        [btnNewServeyNumber removeFromSuperview];
        [self.view addSubview:btnNewServeyNumber];
        
        lblNewMsg.layer.frame=CGRectMake(10,100,100,30);
        [lblNewMsg removeFromSuperview];
        [self.view addSubview:lblNewMsg];
        [self.view bringSubviewToFront:lblNewMsg];
        
        lblNewSurveys.layer.frame=CGRectMake(180,100,100,30);
        [lblNewSurveys removeFromSuperview];
        [self.view addSubview:lblNewSurveys];
        [self.view bringSubviewToFront:lblNewSurveys];
        
        
        imageViewNewEvent.frame=CGRectMake(0,130,320,130);
        imageViewNewEvent.image=[UIImage imageNamed:@"home_calendorbg.png"];
        [imageViewNewEvent removeFromSuperview];
        [self.view addSubview:imageViewNewEvent];
        
        btnDate.layer.frame=CGRectMake(20,150,140,75);
        [btnDate removeFromSuperview];
        [self.view addSubview:btnDate];
        
        btnNoNewEvent.layer.frame=CGRectMake(170,150,140,75);
        [btnNoNewEvent removeFromSuperview];
        [self.view addSubview:btnNoNewEvent];
        
        
        tableViewMain.layer.cornerRadius=5;
        tableViewMain.frame=CGRectMake(0,270,480,500);
        [tableViewMain removeFromSuperview];
        [self.view addSubview:tableViewMain];
        
    }
    Reachability *myNetwork = [Reachability reachabilityWithHostname:@"google.com"];
    NetworkStatus myStatus = [myNetwork currentReachabilityStatus];
    if(myStatus == NotReachable)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Communication" message:@"No internet connection available!!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [activityIndicator stopAnimating];
    }else{
    [self getActivityList];
    [self getHomePageDetails];
    }
    [activityIndicator stopAnimating];
}

-(IBAction)activityEvent{
     SWRevealViewController *revealController = self.revealViewController;
    ActivityViewController *mvc = [[ActivityViewController alloc] initWithNibName:@"ActivityViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mvc];
    [revealController pushFrontViewController:navigationController animated:YES];
}

-(IBAction)feedSurveys{
    SWRevealViewController *revealController = self.revealViewController;
     FeedViewController *fvc = [[FeedViewController alloc] initWithNibName:@"FeedViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:fvc];
    [revealController pushFrontViewController:navigationController animated:YES];
}

-(IBAction)calendarEvents{
    SWRevealViewController *revealController = self.revealViewController;
    CalendarViewController *cvc = [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:cvc];
    [revealController pushFrontViewController:navigationController animated:YES];
}
-(void)viewDidAppear:(BOOL)animatedß
{
    NSDate* date = [NSDate date];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd MMMM"];
    NSString* str = [formatter stringFromDate:date];
    [btnDate setTitle:str forState:UIControlStateNormal];
   
    if([[NSUserDefaults standardUserDefaults]  objectForKey:@"udid"]== nil){
    [self pushNotificationPost];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)pushNotificationPost{
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    
    NSString *post =[NSString stringWithFormat:@"udid=%@",appDelegate.deviceToken];
    
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://millionairesorg.com/communication/registeriphoneudid.php?%@",post];
    
    NSLog(@"register url %@",urlString);
    
    NSData *mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:urlString]];
    
    NSString *content = [[NSString alloc]  initWithBytes:[mydata bytes]
                                                  length:[mydata length] encoding: NSUTF8StringEncoding];
    NSLog(@"content = %@",content);
    [activityIndicator stopAnimating];
    NSString *valueToSave = @"yes";
    [[NSUserDefaults standardUserDefaults]
     setObject:valueToSave forKey:@"udid"];

}
#pragma marl - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [activityDetailsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	 
    static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    ActivityVO *avo=[activityDetailsArray objectAtIndex:indexPath.row];
    UILabel *actvitiytype,*firstinfo,*datelbl;
	if (nil == cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor=[UIColor whiteColor];
       
        if([avo.activitytype isEqualToString:@"media"])
        {
            actvitiytype=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 20)];
            actvitiytype.tag=1;
            actvitiytype.text=@"Admin has addes new media";
            [cell.contentView addSubview:actvitiytype];

        }else if ([avo.activitytype isEqualToString:@"feed"]){
            actvitiytype=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 20)];
            actvitiytype.tag=1;
            actvitiytype.text=@"Admin has addes new feed";
            [cell.contentView addSubview:actvitiytype];
 
        }else if ([avo.activitytype isEqualToString:@"event"]){
            actvitiytype=[[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 20)];
            actvitiytype.tag=1;
            actvitiytype.text=@"Admin has addes new event";
            [cell.contentView addSubview:actvitiytype];
            
        }
        
        
        firstinfo=[[UILabel alloc] initWithFrame:CGRectMake(10, 25, 180, 25)];
        firstinfo.tag=2;
        datelbl=[[UILabel alloc] initWithFrame:CGRectMake(235, 5, 100, 45)];
        datelbl.tag=3;
        actvitiytype.font = [UIFont fontWithName:@"Gotham Narrow" size:14];
        actvitiytype.textColor=[UIColor blackColor];
        firstinfo.font = [UIFont fontWithName:@"Gotham Narrow" size:12];
        firstinfo.textColor=[UIColor blackColor];
        datelbl.font = [UIFont fontWithName:@"Gotham Narrow" size:12];
        datelbl.textColor=[UIColor blackColor];

        [cell.contentView addSubview:firstinfo];
        [cell.contentView addSubview:datelbl];
	}
    tableView.backgroundColor=[UIColor clearColor];
    dispatch_async(dispatch_get_main_queue(), ^{
        //Your main thread code goes in here
        NSLog(@"Im on the main thread");

    
    UILabel *messageLabel = (id)[cell.contentView viewWithTag:2];
    UILabel *timeLabel = (id)[cell.contentView viewWithTag:3];
  
        
    
    messageLabel.text=avo.firstinformation;
    
    timeLabel.text=avo.date;
    
   });
    
    return cell;
    [activityIndicator stopAnimating];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ActivityVO *avo=[activityDetailsArray objectAtIndex:indexPath.row];
   
    if([avo.activitytype isEqualToString:@"media"])
    {
        MediaViewController *mediavc=[[MediaViewController alloc] initWithNibName:@"MediaViewController" bundle:nil];
        mediavc.avo=[[ActivityVO alloc]init];
        mediavc.avo=[activityDetailsArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:mediavc animated:YES];

        
    }else if ([avo.activitytype isEqualToString:@"feed"]){
        FeedViewController *feedvc=[[FeedViewController alloc] initWithNibName:@"FeedViewController" bundle:nil];
        feedvc.avo=[[ActivityVO alloc]init];
        feedvc.avo=[activityDetailsArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:feedvc animated:YES];

    }else if ([avo.activitytype isEqualToString:@"event"]){
        CalendarViewController *calvc=[[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
        calvc.avo=[[ActivityVO alloc]init];
        calvc.avo=[activityDetailsArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:calvc animated:YES];

        
    }
    
    
}

@end
