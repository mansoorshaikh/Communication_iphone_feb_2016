//
//  MediaViewController.m
//  CommunicationApp
//
//  Created by mansoor shaikh on 14/04/14.
//  Copyright (c) 2014 MobiWebCode. All rights reserved.
//

#import "MediaViewController.h"
#import "AppDelegate.h"
#import "SWRevealViewController.h"
#import "PlayMediaViewController.h"
#import "MediaVO.h"
#import "AsyncImageView.h"
#import <QuartzCore/QuartzCore.h>
#import "AVFoundation/AVFoundation.h"
#import "CustomIOS7AlertView.h"
#import "Reachability.h"
@interface MediaViewController ()

@end

@implementation MediaViewController
@synthesize appDelegate,mediaArray,activityIndicator,tblview,alertView,player,mvo,avo;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) threadStartAnimating:(id)data {
    [activityIndicator startAnimating];
    activityIndicator.center = CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0);
    [self.view addSubview: activityIndicator];
}

-(void)getMediaList{
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
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://millionairesorg.com/communication/medialist.php?userid=%@",[prefs objectForKey:@"loggedin"]];
    NSData *mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    NSString *content = [[NSString alloc]  initWithBytes:[mydata bytes]
                                                  length:[mydata length] encoding: NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:mydata options:0 error:&error];
    mediaArray=[[NSMutableArray alloc] init];
        if (! json==nil)
        {

    if(![content isEqualToString:@"no"]){
        NSArray *activityArray=[[json objectForKey:@"mediadetails"] objectForKey:@"media"];
        for (int count=0; count<[activityArray count]; count++) {
            @try {
            NSDictionary *activityData=[activityArray objectAtIndex:count];
            mvo=[[MediaVO alloc] init];
            mvo.mediaid=[[NSString alloc] init];
            mvo.medianame=[[NSString alloc] init];
            mvo.mediadate=[[NSString alloc] init];
            mvo.mediapath=[[NSString alloc] init];
            mvo.mediapicture=[[NSString alloc] init];
            mvo.youtubevideo=[[NSString alloc] init];
            
            
            mvo.mediaid=[activityData objectForKey:@"mediaid"];
            mvo.medianame=[activityData objectForKey:@"medianame"];
            mvo.mediadate=[activityData objectForKey:@"mediadate"];
            mvo.mediapath=[activityData objectForKey:@"mediapath"];
             mvo.mediapicture=[activityData objectForKey:@"mediapicture"];
             mvo.youtubevideo=[activityData objectForKey:@"youtubevideo"];
            [mediaArray addObject:mvo];
                
            }
            @catch (NSException * e) {
                NSLog(@"Exception: %@", e);
                NSDictionary *activityData=[[json objectForKey:@"calendareventdetail"] objectForKey:@"calendarevent"];
                mvo=[[MediaVO alloc] init];
                mvo.mediaid=[[NSString alloc] init];
                mvo.medianame=[[NSString alloc] init];
                mvo.mediadate=[[NSString alloc] init];
                mvo.mediapath=[[NSString alloc] init];
                mvo.mediapicture=[[NSString alloc] init];
                mvo.youtubevideo=[[NSString alloc] init];
                
                
                mvo.mediaid=[activityData objectForKey:@"mediaid"];
                mvo.medianame=[activityData objectForKey:@"medianame"];
                mvo.mediadate=[activityData objectForKey:@"mediadate"];
                mvo.mediapath=[activityData objectForKey:@"mediapath"];
                mvo.mediapicture=[activityData objectForKey:@"mediapicture"];
                mvo.youtubevideo=[activityData objectForKey:@"youtubevideo"];
                [mediaArray addObject:mvo];
                
            }

        }
    }
    if (avo != nil)
    {
        for(int count=0;count<mediaArray.count;count++)
        {
            MediaVO *mvo=[mediaArray objectAtIndex:count];
            if([mvo.medianame isEqualToString:avo.firstinformation])
                
            {
                UIButton *transperentBtn=[[UIButton alloc] init];
                transperentBtn.tag=count;
                [self videoAlertDialog:transperentBtn];
                
            }
        }
        
    }
    
        [tblview reloadData];
        
        }

    [activityIndicator stopAnimating];
    }
}

-(void)playVideo{
    [player play];
}

-(void)exitVideo{
    [alertView close];
    [player pause];
    
}

-(void)videoAlertDialog:(UIButton*)btn{
    alertView = [[CustomIOS7AlertView alloc] init];
    
    // Add some custom content to the alert view
    
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 340)];
    [demoView setBackgroundColor:[UIColor whiteColor]];
    demoView.layer.cornerRadius=15;

    MediaVO *mvo=[mediaArray objectAtIndex:btn.tag];
    player = [AVPlayer playerWithURL:[NSURL URLWithString:mvo.mediapath]]; //
    
    AVPlayerLayer *layer = [AVPlayerLayer layer];
    
    [layer setPlayer:player];
    [layer setFrame:CGRectMake(0, 0, 300, 300)];
    [layer setBackgroundColor:[UIColor redColor].CGColor];
    [layer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [player play];
    [demoView.layer addSublayer:layer];
    
    UIButton *exitBtn=[[UIButton alloc] initWithFrame:CGRectMake(0, 300, 300, 40)];
    [exitBtn setTitle:@"Exit" forState:UIControlStateNormal];
    [exitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [exitBtn setBackgroundColor:[UIColor blackColor]];
        [exitBtn addTarget:self action:@selector(exitVideo) forControlEvents:UIControlEventTouchUpInside];
    [demoView addSubview:exitBtn];
    
    [alertView setContainerView:demoView];
    
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

-(void)closeAlert:(id)sender{
    [alertView close];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [activityIndicator stopAnimating];
    appDelegate=[[UIApplication sharedApplication] delegate];
    appDelegate.selectedMenuItem=@"MEDIA";
    
    UILabel *titleLabel = [[UILabel alloc] init];
    [titleLabel setFrame:CGRectMake(30, 0, 110, 35)];
    [titleLabel setText:@"MEDIA"];
    
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

    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated{
    [self getMediaList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma marl - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d",[mediaArray count]/2);
    if([mediaArray count]%2==0)
        return [mediaArray count]/2;
    else
        return ([mediaArray count]/2)+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
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
    
    MediaVO *mediaVO=[mediaArray objectAtIndex:row-1];
	if (nil == cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor=[UIColor whiteColor];
	}
    
    AsyncImageView *mediaImage=[[AsyncImageView alloc] initWithFrame:CGRectMake(5, 0, 155, 150)];
    [mediaImage setBackgroundColor:[UIColor clearColor]];
    [mediaImage loadImageFromURL:[NSURL URLWithString:mediaVO.mediapicture]];
    
    UIButton *transperentBtn=[[UIButton alloc] initWithFrame:CGRectMake(5, 0, 155, 150)];
    transperentBtn.tag=row-1;
    [transperentBtn addTarget:self action:@selector(videoAlertDialog:) forControlEvents:UIControlEventTouchUpInside];
   
    UILabel *feedtextLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, 155, 155, 20)];
    feedtextLabel.font = [UIFont fontWithName:@"Gotham Narrow" size:12];
    feedtextLabel.textColor=[UIColor blackColor];
    feedtextLabel.text=mediaVO.medianame;
    
    UILabel *feedtimeLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, 175, 155, 15)];
    feedtimeLabel.font = [UIFont systemFontOfSize:8];
    feedtimeLabel.textColor=[UIColor blackColor];
    feedtimeLabel.text=mediaVO.mediadate;
    
    [cell.contentView addSubview:mediaImage];
     [cell.contentView addSubview:transperentBtn];
    [cell.contentView addSubview:feedtextLabel];
    [cell.contentView addSubview:feedtimeLabel];
    if([mediaArray count]>row){
    mediaVO=[mediaArray objectAtIndex:row];
    
    AsyncImageView *mediaImage2=[[AsyncImageView alloc] initWithFrame:CGRectMake(160, 0, 155, 150)];
    [mediaImage2 setBackgroundColor:[UIColor clearColor]];
    [mediaImage2 loadImageFromURL:[NSURL URLWithString:mediaVO.mediapicture]];
        UIButton *transperentBtn2=[[UIButton alloc] initWithFrame:CGRectMake(160, 0, 155, 150)];
        transperentBtn2.tag=row;
        [transperentBtn2 addTarget:self action:@selector(videoAlertDialog:) forControlEvents:UIControlEventTouchUpInside];


    UILabel *feedtextLabel2=[[UILabel alloc] initWithFrame:CGRectMake(210, 155, 155, 20)];
    feedtextLabel2.font = [UIFont fontWithName:@"Gotham Narrow" size:12];
    feedtextLabel2.textColor=[UIColor blackColor];
    feedtextLabel2.text=mediaVO.medianame;
    
    UILabel *feedtimeLabel2=[[UILabel alloc] initWithFrame:CGRectMake(210, 175, 155, 15)];
    feedtimeLabel2.textColor=[UIColor blackColor];
    feedtimeLabel2.font = [UIFont systemFontOfSize:8];
    feedtimeLabel2.text=mediaVO.mediadate;
    
    [cell.contentView addSubview:mediaImage2];
        [cell.contentView addSubview:transperentBtn2];
    [cell.contentView addSubview:feedtextLabel2];
    [cell.contentView addSubview:feedtimeLabel2];
    }

    return cell;
}


@end
