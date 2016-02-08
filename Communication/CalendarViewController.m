//
//  CalendarViewController.m
//  CommunicationApp
//
//  Created by mansoor shaikh on 14/04/14.
//  Copyright (c) 2014 MobiWebCode. All rights reserved.
//

#import "CalendarViewController.h"
#import "SWRevealViewController.h"
#import "UIColor+Expanded.h"
#import "CalenderVO.h"
#import "AppDelegate.h"
#import "Reachability.h"
@interface CalendarViewController ()

@end

@implementation CalendarViewController
@synthesize appDelegate,tblview,activityIndicator,tableViewMain,activityDetailsArray,selectedDate,eventDate,avo;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)addEvent{
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [activityIndicator stopAnimating];
    appDelegate=[[UIApplication sharedApplication] delegate];

    [self getDateCalendarEvents];
    VRGCalendarView *calendar = [[VRGCalendarView alloc] init];
    calendar.delegate=self;
    calendar.frame=CGRectMake(0, 0, self.view.bounds.size.width-50, (self.view.bounds.size.height*40)/100);
    [self.view addSubview:calendar];
    
   // [self setFontFamily:@"Gotham Narrow" forView:self.view andSubViews:YES];
        appDelegate.selectedMenuItem=@"CALENDAR";
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFrame:CGRectMake(30, 0, 110, 35)];
    [titleLabel setText:@"CALENDAR"];
    
    titleLabel.font =[UIFont systemFontOfSize:18];
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
    tableViewMain.layer.cornerRadius=5;
    tableViewMain.frame=CGRectMake(0,(self.view.bounds.size.height*40)/100,self.view.bounds.size.width,450);
    [tableViewMain removeFromSuperview];
    [self.view addSubview:tableViewMain];
        [self getCalendarEvents];
    
}

-(void)calendarView:(VRGCalendarView *)calendarView switchedToMonth:(int)month targetHeight:(float)targetHeight animated:(BOOL)animated {
    NSMutableArray *eventArray=[[NSMutableArray alloc]init];

    for(int count=0;count<appDelegate.dateEventArray.count;count++)
    {
        NSString *eventdate=[appDelegate.dateEventArray objectAtIndex:count];
    if([[[eventdate componentsSeparatedByString:@"/"] objectAtIndex:0] intValue]==month)
    {
        [eventArray addObject:[NSNumber numberWithInt:[[[eventdate componentsSeparatedByString:@"/"] objectAtIndex:1] intValue]]];
    }
    }
    NSArray *dates =(NSArray* )eventArray;
    [calendarView markDates:dates];
}

-(void)calendarView:(VRGCalendarView *)calendarView dateSelected:(NSDate *)date {
    NSDate *newDate1 = [date dateByAddingTimeInterval:60*60*24*1];
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"MM/dd/yyyy";
    NSLog(@"%@",[dateFormatter stringFromDate:date]);
    selectedDate=[[NSString alloc] initWithString:[dateFormatter stringFromDate:date]];
    [self getCalendarEvents];
}


- (void) threadStartAnimating:(id)data {
    [activityIndicator startAnimating];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
}

-(void)getCalendarEvents{
    Reachability *myNetwork = [Reachability reachabilityWithHostname:@"google.com"];
    NetworkStatus myStatus = [myNetwork currentReachabilityStatus];
    if(myStatus == NotReachable)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Communication" message:@"No internet connection available!!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [activityIndicator stopAnimating];
    }else{

    activityDetailsArray=[[NSMutableArray alloc] init];
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];

    NSString *urlString = [[NSString alloc]initWithFormat:@"http://millionairesorg.com/communication/calendarevents.php?currentdate=%@&userid=%@",selectedDate,[prefs objectForKey:@"loggedin"]];
    NSData *mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    NSString *content = [[NSString alloc]  initWithBytes:[mydata bytes]
                                                  length:[mydata length] encoding: NSUTF8StringEncoding];
    if(![content isEqualToString:@"no"]){
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:mydata options:0 error:&error];
        if (! json==nil)
        {

    NSArray *calendarArray=[[json objectForKey:@"calendareventdetail"] objectForKey:@"calendarevent"];
    for (int count=0; count<[calendarArray count]; count++) {
        @try {
            // Try something
            NSDictionary *activityData=[calendarArray objectAtIndex:count];
            CalenderVO *cvo=[[CalenderVO alloc] init];
            cvo.calendareventid=[[NSString alloc] init];
            cvo.calendareventdate=[[NSString alloc] init];
            cvo.calendareventtime=[[NSString alloc] init];
            cvo.calendareventtext=[[NSString alloc] init];
            
            
            cvo.calendareventid=[activityData objectForKey:@"calendareventid"];
            cvo.calendareventdate=[activityData objectForKey:@"calendareventdate"];
            cvo.calendareventtime=[activityData objectForKey:@"calendareventtime"];
            cvo.calendareventtext=[activityData objectForKey:@"calendareventtext"];
            [activityDetailsArray addObject:cvo];

        }
        @catch (NSException * e) {
            NSLog(@"Exception: %@", e);
            NSDictionary *activityData=[[json objectForKey:@"calendareventdetail"] objectForKey:@"calendarevent"];
            CalenderVO *cvo=[[CalenderVO alloc] init];
            cvo.calendareventid=[[NSString alloc] init];
            cvo.calendareventdate=[[NSString alloc] init];
            cvo.calendareventtime=[[NSString alloc] init];
            cvo.calendareventtext=[[NSString alloc] init];
            
            
            cvo.calendareventid=[activityData objectForKey:@"calendareventid"];
            cvo.calendareventdate=[activityData objectForKey:@"calendareventdate"];
            cvo.calendareventtime=[activityData objectForKey:@"calendareventtime"];
            cvo.calendareventtext=[activityData objectForKey:@"calendareventtext"];
            [activityDetailsArray addObject:cvo];
            break;
        }
    }
    }
    
    [tableViewMain reloadData];
    }
    [activityIndicator stopAnimating];
    }
}

-(void)getDateCalendarEvents{
    activityDetailsArray=[[NSMutableArray alloc] init];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://millionairesorg.com/communication/calendareventdatelist.php?userid=%@",[prefs objectForKey:@"loggedin"]];
    NSData *mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    NSString *content = [[NSString alloc]  initWithBytes:[mydata bytes]
                                                  length:[mydata length] encoding: NSUTF8StringEncoding];
    appDelegate.dateEventArray=[[NSMutableArray alloc]init];
                                          
    if(![content isEqualToString:@""]){
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:mydata options:0 error:&error];
        if (! json==nil)
        {

        NSArray *calendarArray=[[json objectForKey:@"calendardatedetails"] objectForKey:@"calendardate"];
        for (int count=0; count<[calendarArray count]; count++) {
            NSDictionary *activityData=[calendarArray objectAtIndex:count];
            [appDelegate.dateEventArray  addObject:[activityData objectForKey:@"calendareventdate"]];
        }
        }
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma marl - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [activityDetailsArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSInteger row = indexPath.row;
	CalenderVO *cvo=[activityDetailsArray objectAtIndex:indexPath.row];
    UILabel *timeLabel,*messageLabel;

	if (nil == cell)
	{
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor=[UIColor whiteColor];

        timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 5, 200, 20)];
        timeLabel.tag=2;
        messageLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 25, 180, 25)];
        messageLabel.tag=3;
        
        timeLabel.font = [UIFont fontWithName:@"Gotham Narrow" size:12];
        timeLabel.textColor=[UIColor blackColor];
        messageLabel.font = [UIFont fontWithName:@"Gotham Narrow" size:12];
        messageLabel.textColor=[UIColor blackColor];
        
        
        [cell.contentView addSubview:messageLabel];
        [cell.contentView addSubview:timeLabel];

	}
    
    tableView.backgroundColor=[UIColor clearColor];
    dispatch_async(dispatch_get_main_queue(), ^{
        //Your main thread code goes in here
        NSLog(@"Im on the main thread");
        
        
               UILabel *messageLabel = (id)[cell.contentView viewWithTag:2];
        UILabel *timeLabel = (id)[cell.contentView viewWithTag:3];
        
        
        
        
        messageLabel.text=cvo.calendareventtext;
        
        timeLabel.text=cvo.calendareventtime;
        
    });
    return cell;
}

- (void)nextButtonPressed {
	NSLog(@"Next...");
}

- (void)prevButtonPressed {
	NSLog(@"Prev...");
}


@end
