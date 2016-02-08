//
//  FeedViewController.m
//  CommunicationApp
//
//  Created by mansoor shaikh on 14/04/14.
//  Copyright (c) 2014 MobiWebCode. All rights reserved.
//

#import "FeedViewController.h"
#import "SWRevealViewController.h"
#import "FeedDetailsViewController.h"
#import "FeedSurveyViewController.h"
#import "FeedTypeVO.h"
#import "AsyncImageView.h"
#import "FeedVO.h"
#import "ActivityVO.h"
#import "Feedlist.h"
#import <QuartzCore/QuartzCore.h>
#import "FeedDetailsViewController.h"
#import "Reachability.h"
@interface FeedViewController ()

@end

@implementation FeedViewController
@synthesize appDelegate,feedArray,activityIndicator,tableView,activityDetailsArray,feedButtonArray,feedtypeString,feedTypeArray,avo,selectFeed;

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

- (void) threadStartAnimating:(id)data {
    [activityIndicator startAnimating];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];

}

-(void)getFeedType{
    Reachability *myNetwork = [Reachability reachabilityWithHostname:@"google.com"];
    NetworkStatus myStatus = [myNetwork currentReachabilityStatus];
    if(myStatus == NotReachable)
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Communication" message:@"No internet connection available!!!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [activityIndicator stopAnimating];
    }else{

    feedTypeArray=[[NSMutableArray alloc] init];
    feedButtonArray=[[NSMutableArray alloc] init];
    selectFeed=[[NSString alloc]init];
        [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        NSString *urlString = [[NSString alloc]initWithFormat:@"http://millionairesorg.com/communication/feedtypes.php?userid=%@",[prefs objectForKey:@"loggedin"]];
        NSData *mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
        
        NSString *content = [[NSString alloc]  initWithBytes:[mydata bytes]
                                                      length:[mydata length] encoding: NSUTF8StringEncoding];
      
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:mydata options:0 error:&error];
     if ([json objectForKey:@"feeddetail"] != [NSNull null])
     {
         NSArray *feeddetails=[[json objectForKey:@"feeddetail"] objectForKey:@"feed"];
        for (int count=0; count<[feeddetails count]; count++) {
            NSDictionary *feedData=[feeddetails objectAtIndex:count];
            FeedTypeVO *fvo=[[FeedTypeVO alloc] init];
            fvo.feedid=[[NSString alloc] init];
            fvo.feedtype=[[NSString alloc] init];
            if ([feedData objectForKey:@"feedid"] != [NSNull null])
                fvo.feedid=[feedData objectForKey:@"feedid"];
            fvo.feedtype=[feedData objectForKey:@"feedtype"];
            [feedTypeArray addObject:fvo];
        
        }
    int counter = 0,heightcounter=1;
    int yValue=0,xValue=0;
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    for (int count = 0; count < feedTypeArray.count; count++) {
        UIButton *feedTypeBtn=[[UIButton alloc] initWithFrame:CGRectMake(xValue,yValue,screenWidth/4,40)];
        FeedTypeVO *feedTypelist=[feedTypeArray objectAtIndex:count];
        [feedTypeBtn setTitle:feedTypelist.feedtype forState:UIControlStateNormal];
        [feedTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [feedTypeBtn addTarget:self action:@selector(clickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [feedTypeBtn setBackgroundColor:[UIColor whiteColor]];
        [[feedTypeBtn layer] setBorderWidth:0.5f];
        [[feedTypeBtn layer] setBorderColor:[UIColor blackColor].CGColor];
        [self.view addSubview:feedTypeBtn];
        [feedButtonArray addObject:feedTypeBtn];
        xValue=xValue+screenWidth/4;
        counter++;
        if(counter==4)
        {
            xValue=0;
            yValue=yValue+40;
            heightcounter++;
        }
    }
    
    tableView.frame=CGRectMake(0, 40*heightcounter, self.view.bounds.size.width, self.view.bounds.size.height);
    
    [activityIndicator stopAnimating];
    [self getFeedList];
    }
    }
    [activityIndicator stopAnimating];

}

-(void)clickButtonAction:(UIButton*)feedTypeBtn{
    for(int i=0;  i<feedButtonArray.count; i++){
        UIButton *feedBtn=[feedButtonArray objectAtIndex:i];
        [feedBtn setBackgroundColor:[UIColor whiteColor]];
    }
    [feedTypeBtn setBackgroundColor:[UIColor lightGrayColor]];
    feedtypeString=[feedTypeBtn titleForState:UIControlStateNormal];
    [self getFeedList];
}


-(void)getFeedList{
    [NSThread detachNewThreadSelector:@selector(threadStartAnimating:) toTarget:self withObject:nil];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if([feedtypeString isEqualToString:@""]){
        FeedTypeVO *ftvo=[feedTypeArray objectAtIndex:0];
        feedtypeString=ftvo.feedtype;
    }
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://millionairesorg.com/communication/feedlist.php?feedtype=%@&userid=%@",feedtypeString,[prefs objectForKey:@"loggedin"]];
    NSData *mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    NSString *content = [[NSString alloc]  initWithBytes:[mydata bytes]
                                                  length:[mydata length] encoding: NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:mydata options:0 error:&error];
    activityDetailsArray=[[NSMutableArray alloc] init];
    if (![[json objectForKey:@"feeddetails"] isEqual:[NSNull null]])
    {

    if(![content isEqualToString:@"no"]){
    NSArray *activityArray=[[json objectForKey:@"feeddetails"] objectForKey:@"feed"];
   @try {
        for (int count=0; count<[activityArray count]; count++) {
        

        NSDictionary *activityData=[activityArray objectAtIndex:count];
        Feedlist *fdlvo=[[Feedlist alloc] init];
        fdlvo.feedid=[[NSString alloc] init];
        fdlvo.feedtype=[[NSString alloc] init];
        fdlvo.time=[[NSString alloc] init];
        fdlvo.feedtext=[[NSString alloc] init];
        fdlvo.feedformat=[[NSString alloc] init];
        fdlvo.feeddescription=[[NSString alloc] init];
        fdlvo.feedimage=[[NSString alloc] init];
        fdlvo.feedname=[[NSString alloc] init];
    
        
        if ([activityData objectForKey:@"feedtext"] != [NSNull null])
            fdlvo.feedimage=[activityData objectForKey:@"feedimage"];
        fdlvo.feedname=[activityData objectForKey:@"feedname"];
         fdlvo.feedid=[activityData objectForKey:@"feedid"];
        fdlvo.feeddescription=[activityData objectForKey:@"feeddescription"];
        fdlvo.time=[activityData objectForKey:@"time"];
        fdlvo.feedtext=[activityData objectForKey:@"feedtext"];

        fdlvo.feedformat=[activityData objectForKey:@"feedformat"];
        [activityDetailsArray addObject:fdlvo];
        }
   }
        @catch (NSException * e) {
            NSLog(@"Exception: %@", e);
            NSDictionary *activityData=[[json objectForKey:@"feeddetails"] objectForKey:@"feed"];
            Feedlist *fdlvo=[[Feedlist alloc] init];
            fdlvo.feedid=[[NSString alloc] init];
            fdlvo.feedtype=[[NSString alloc] init];
            fdlvo.time=[[NSString alloc] init];
            fdlvo.feedtext=[[NSString alloc] init];
            fdlvo.feedformat=[[NSString alloc] init];
            fdlvo.feeddescription=[[NSString alloc] init];
            fdlvo.feedimage=[[NSString alloc] init];
            fdlvo.feedname=[[NSString alloc] init];
            
            
            if ([activityData objectForKey:@"feedtext"] != [NSNull null])
                fdlvo.feedimage=[activityData objectForKey:@"feedimage"];
            fdlvo.feedname=[activityData objectForKey:@"feedname"];
            fdlvo.feedid=[activityData objectForKey:@"feedid"];
            fdlvo.feeddescription=[activityData objectForKey:@"feeddescription"];
            fdlvo.time=[activityData objectForKey:@"time"];
            fdlvo.feedtext=[activityData objectForKey:@"feedtext"];
            
            fdlvo.feedformat=[activityData objectForKey:@"feedformat"];
            [activityDetailsArray addObject:fdlvo];

        }
    
    }
    if (avo != nil)
    {
        for(int count=0;count<activityDetailsArray.count;count++)
        {
            Feedlist *fvo=[activityDetailsArray objectAtIndex:count];
            if([fvo.feedid isEqualToString:avo.secondinformation])
                
            {
                if(![fvo.feedformat isEqualToString:@"Normal"])
                {
                    avo=nil;
                    SWRevealViewController *revealController = self.revealViewController;

                    FeedSurveyViewController *feedsurvey=[[FeedSurveyViewController alloc] initWithNibName:@"FeedSurveyViewController" bundle:nil];
                    feedsurvey.selectFeedlist=[[Feedlist alloc]init];
                    feedsurvey.selectFeedlist=fvo;
                    
                UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:feedsurvey];
                    [revealController pushFrontViewController:navigationController animated:YES];
                    

                    break;
                }else{
                    SWRevealViewController *revealController = self.revealViewController;

                    FeedDetailsViewController *feeddetails=[[FeedDetailsViewController alloc] initWithNibName:@"FeedDetailsViewController" bundle:nil];
                    feeddetails.selectFeedlist=[[Feedlist alloc]init];
                    feeddetails.selectFeedlist=fvo;
                    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:feeddetails];
                    [revealController pushFrontViewController:navigationController animated:YES];
                    break;
                }

            }
        }
        
    }
    [tableView reloadData];

    
    }

    [activityIndicator stopAnimating];
}




- (void)viewDidLoad
{
    [super viewDidLoad];
    activityDetailsArray=[[NSMutableArray alloc] init];
    feedtypeString=[[NSString alloc] init];
    feedtypeString=@"";
    [self setFontFamily:@"Gotham Narrow" forView:self.view andSubViews:YES];
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFrame:CGRectMake(30, 0, 110, 35)];
    [titleLabel setText:@"FEEDS"];
  
    titleLabel.font =[UIFont systemFontOfSize:18];
    self.navigationItem.titleView = titleLabel;
    //segmentedControl.transform = CGAffineTransformMakeScale(0.75, 0.75);
    //segmentedControl = [[UISegmentedControl alloc] initWithItems:feedArray];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"navBar.png"]];
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"feedtablebg.png"]];
    appDelegate=[[UIApplication sharedApplication] delegate];
    appDelegate.selectedMenuItem=@"FEED";
    SWRevealViewController *revealController = [self revealViewController];

    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIBarButtonItem *revealButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"reveal-icon.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                         style:UIBarButtonItemStyleBordered target:revealController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = revealButtonItem;
    if(avo != nil)
    {
        feedtypeString=avo.firstinformation;
        [self getFeedList];
    }else{
        [self getFeedType];

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
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    Feedlist *fdlvo=[activityDetailsArray objectAtIndex:indexPath.row];
    AsyncImageView *userImageView;
    UILabel *messageLabel,*timeLabel,*usernameLabel;
    if (nil == cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.backgroundColor=[UIColor clearColor];
        cell.textLabel.textColor=[UIColor whiteColor];
        userImageView=[[AsyncImageView alloc] initWithFrame:CGRectMake(5, 5, 35, 35)];
        [userImageView setBackgroundColor:[UIColor clearColor]];

        userImageView.tag=1;
        userImageView.backgroundColor=[UIColor clearColor];
        usernameLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 5, 200, 20)];
        usernameLabel.tag=2;
        messageLabel=[[UILabel alloc] initWithFrame:CGRectMake(50, 25, 180, 25)];
        messageLabel.tag=3;
        timeLabel=[[UILabel alloc] initWithFrame:CGRectMake(235, 5, 100, 45)];
        timeLabel.tag=4;
        usernameLabel.font = [UIFont fontWithName:@"Gotham Narrow" size:12];
        usernameLabel.textColor=[UIColor blackColor];
        messageLabel.font = [UIFont fontWithName:@"Gotham Narrow" size:12];
        messageLabel.textColor=[UIColor blackColor];
        timeLabel.font = [UIFont fontWithName:@"Gotham Narrow" size:12];
        timeLabel.textColor=[UIColor blackColor];
        
        [cell.contentView addSubview:userImageView];
        [cell.contentView addSubview:usernameLabel];
        [cell.contentView addSubview:messageLabel];
        [cell.contentView addSubview:timeLabel];
    }
    tableView.backgroundColor=[UIColor clearColor];
    dispatch_async(dispatch_get_main_queue(), ^{
        //Your main thread code goes in here
        NSLog(@"Im on the main thread");
        
        
        AsyncImageView *userImageView= (id)[cell.contentView viewWithTag:1];
        UILabel *usernameLabel = (id)[cell.contentView viewWithTag:2];
        UILabel *messageLabel = (id)[cell.contentView viewWithTag:3];
        UILabel *timeLabel = (id)[cell.contentView viewWithTag:4];
        
        [userImageView loadImageFromURL:[NSURL URLWithString:fdlvo.feedimage]];
        
        usernameLabel.text=fdlvo.feedname;
        
        messageLabel.text=fdlvo.feeddescription;
        
        timeLabel.text=fdlvo.time;
        
    });
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Feedlist *feedlist=[activityDetailsArray objectAtIndex:indexPath.row];

    if(![feedlist.feedformat isEqualToString:@"Normal"])
    {
        FeedSurveyViewController *feedsurvey=[[FeedSurveyViewController alloc] initWithNibName:@"FeedSurveyViewController" bundle:nil];
        feedsurvey.selectFeedlist=[[Feedlist alloc]init];
        feedsurvey.selectFeedlist=[activityDetailsArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:feedsurvey animated:YES];

    }else{
        FeedDetailsViewController *feeddetails=[[FeedDetailsViewController alloc] initWithNibName:@"FeedDetailsViewController" bundle:nil];
        feeddetails.selectFeedlist=[[Feedlist alloc]init];
        feeddetails.selectFeedlist=[activityDetailsArray objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:feeddetails animated:YES];
    }
}




@end
