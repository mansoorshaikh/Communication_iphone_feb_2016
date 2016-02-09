//
//  ActivityViewController.m
//  CommunicationApp
//
//  Created by mansoor shaikh on 14/04/14.
//  Copyright (c) 2014 MobiWebCode. All rights reserved.
//

#import "ActivityViewController.h"
#import "SWRevealViewController.h"
#import "ActivityVO.h"
#import "AsyncImageView.h"
#import "MediaViewController.h"
#import "CalendarViewController.h"
#import "FeedViewController.h"
#import "Reachability.h"
@interface ActivityViewController ()

@end

@implementation ActivityViewController
@synthesize appDelegate,activityDetailsArray,activityIndicator,tableViewMain;
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

-(void)getActivityList{
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
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://millionairesorg.com/communication/ActivityDetail.php?userid=%@",[prefs objectForKey:@"loggedin"]];
    NSData *mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    NSString *content = [[NSString alloc]  initWithBytes:[mydata bytes]
                                                  length:[mydata length] encoding: NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:mydata options:0 error:&error];
        if ([json objectForKey:@"activitydetail"]  == nil)
        {
    if(![content isEqualToString:@"no"]){
    NSArray *activityArray=[[json objectForKey:@"activitydetail"] objectForKey:@"activity"];
    for (int count=0; count<[activityArray count]; count++) {
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
    }
    [tableViewMain reloadData];
        }
    [activityIndicator stopAnimating];
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
    ActivityVO *avo=[[ActivityVO alloc]init];
    activityDetailsArray=[[NSMutableArray alloc] init];
    
    [activityIndicator stopAnimating];
    // Do any additional setup after loading the view from its nib.
    [self setFontFamily:@"Gotham Narrow" forView:self.view andSubViews:YES];
    appDelegate=[[UIApplication sharedApplication] delegate];
    appDelegate.selectedMenuItem=@"ACTIVITY";
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFrame:CGRectMake(30, 0, 110, 35)];
    [titleLabel setText:@"ACTIVITY"];
    
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
                                                                         style:UIBarButtonItemStylePlain target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    
        
    //[self getActivityList];

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma marl - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
   // [activityDetailsArray count];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //ActivityVO *avo=[[ActivityVO alloc]init];
    //avo=[activityDetailsArray objectAtIndex:indexPath.row];
    UILabel *actvitiytype,*firstinfo,*datelbl;
    
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor=[UIColor whiteColor];
       /*
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
        
        */
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
    
    tableView.backgroundColor=[UIColor clearColor];
    dispatch_async(dispatch_get_main_queue(), ^{
        //Your main thread code goes in here
        NSLog(@"Im on the main thread");
        
        
        UILabel *messageLabel = (id)[cell.contentView viewWithTag:2];
        UILabel *timeLabel = (id)[cell.contentView viewWithTag:3];
        
        
        
        messageLabel.text=@"Test message for communication app";
        
        timeLabel.text=@"10 feb 2016";
        
    });
    
    return cell;
    [activityIndicator stopAnimating];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*ActivityVO *avo=[[ActivityVO alloc]init];
    avo=[activityDetailsArray objectAtIndex:indexPath.row];

    if([avo.activitytype isEqualToString:@"media"])
    {
        MediaViewController *mediavc=[[MediaViewController alloc] initWithNibName:@"MediaViewController" bundle:nil];
        mediavc.avo=[[ActivityVO alloc]init];
        mediavc.avo=avo;
        [self.navigationController pushViewController:mediavc animated:YES];
        
        
    }else if ([avo.activitytype isEqualToString:@"feed"]){
        FeedViewController *feedvc=[[FeedViewController alloc] initWithNibName:@"FeedViewController" bundle:nil];
        feedvc.avo=[[ActivityVO alloc]init];
        feedvc.avo=avo;
    [self.navigationController pushViewController:feedvc animated:YES];
        
    }else if ([avo.activitytype isEqualToString:@"event"]){
        CalendarViewController *calvc=[[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
        calvc.avo=[[ActivityVO alloc]init];
        calvc.avo=avo;
        [self.navigationController pushViewController:calvc animated:YES];
        
        
    }
    */
    
}



@end
