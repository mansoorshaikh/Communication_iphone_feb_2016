
/*

 Copyright (c) 2013 Joan Lluch <joan.lluch@sweetwilliamsl.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is furnished
 to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 
 Original code:
 Copyright (c) 2011, Philip Kluz (Philip.Kluz@zuui.org)
 
*/
#import "ActivityViewController.h"
#import "RearViewController.h"
#import "FeedViewController.h"
#import "UIColor+Expanded.h"
#import "SWRevealViewController.h"
#import "HomeViewController.h"
#import "FeedViewController.h"
#import "CameraDetailViewController.h"
#import "CalendarViewController.h"
#import "MediaViewController.h"
#import "CreateViewController.h"
#import "SettingsViewController.h"
#import "LoginViewController.h"
#import "UIImage+FontAwesome.h"
#import "NSString+FontAwesome.h"

@interface RearViewController()

@end

@implementation RearViewController

@synthesize rearTableView = _rearTableView;
@synthesize appDelegate,usernameLabel,displayUserName,userImageView,imageBtn;

#pragma mark - View lifecycle


- (void)viewDidLoad
{
	[super viewDidLoad];
    appDelegate=[[UIApplication sharedApplication] delegate];
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"menutablebg.png"]];
	self.rearTableView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"menutablebg.png"]];
    self.navigationController.navigationBarHidden=YES;
    [imageBtn.layer setFrame:CGRectMake(10,13,60,60)];
    [imageBtn setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:imageBtn];
    
    userImageView=[[AsyncImageView alloc] initWithFrame:CGRectMake(10, 15, 60, 60)];
    [userImageView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:userImageView];

    [self getHomePageDetails];
}

-(void)getHomePageDetails{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *urlString = [[NSString alloc]initWithFormat:@"http://millionairesorg.com/communication/HomepageDetail.php?userid=%@",[prefs objectForKey:@"loggedin"]];
    NSData *mydata = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:mydata options:0 error:&error];
    
    NSDictionary *homepage=[[json objectForKey:@"homepagedetails"] objectForKey:@"homepage"];
   
    usernameLabel.textAlignment = NSTextAlignmentCenter;
    //[usernameLabel setText:[NSString stringWithFormat:@"%@",[homepage objectForKey:@"username"]]];
    usernameLabel.text=@"Danny";
    usernameLabel.font =[UIFont systemFontOfSize:14];
    
    NSURL *url = [NSURL URLWithString:[[homepage objectForKey:@"userimage"] stringByReplacingOccurrencesOfString:@"\/" withString:@"/"]];
      // [userImageView loadImageFromURL:url];
    userImageView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"feed2.png"]];

}


#pragma marl - UITableView Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    NSInteger row = indexPath.row;
	
	if (nil == cell)
	{
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.textLabel.textColor=[UIColor whiteColor];
	}
    
    UIImageView *menuItemImageView=[[UIImageView alloc] initWithFrame:CGRectMake(5, 20, 15, 15)];
    UILabel *pictureLbl=[[UILabel alloc]initWithFrame:CGRectMake(10,10,35,35)];
    pictureLbl.text = @"";
    pictureLbl.textColor=[UIColor grayColor];

    UILabel *menuItemTextLabel=[[UILabel alloc] initWithFrame:CGRectMake(60, 5, 250, 45)];
    menuItemTextLabel.font = [UIFont systemFontOfSize:16];
    menuItemTextLabel.textColor=[UIColor colorWithHexString:@"808083"];
    cell.backgroundColor=[UIColor clearColor];
	if (row == 0)
	{
        //menuItemImageView.image=[UIImage imageNamed:@"homeicon.png"];
        pictureLbl.font = [UIFont fontWithName:@"FontAwesome" size:30];
        pictureLbl.text = @"\uf015";

		menuItemTextLabel.text = @"HOME";
        if([appDelegate.selectedMenuItem isEqualToString:@"Home"]){
            cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"tablecellselected.png"]];
        }
    }
	else if (row == 1)
	{
		//menuItemImageView.image=[UIImage imageNamed:@"feed.png"];
        pictureLbl.font = [UIFont fontWithName:@"FontAwesome" size:30];
        pictureLbl.text = @"\uf0eb";

		menuItemTextLabel.text = @"FEED";
        if([appDelegate.selectedMenuItem isEqualToString:@"FEED"]){
            cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"tablecellselected.png"]];
        }
	}
	else if (row == 2)
	{
       // menuItemImageView.image=[UIImage imageNamed:@"camera.png"];
        pictureLbl.font = [UIFont fontWithName:@"FontAwesome" size:30];
        pictureLbl.text = @"\uf083";

		menuItemTextLabel.text = @"CAMERA";
        if([appDelegate.selectedMenuItem isEqualToString:@"CAMERA"]){
            cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"tablecellselected.png"]];
        }
	}
	else if (row == 3)
	{
		//menuItemImageView.image=[UIImage imageNamed:@"camera.png"];
        pictureLbl.font = [UIFont fontWithName:@"FontAwesome" size:30];
        pictureLbl.text = @"\uf073";

		menuItemTextLabel.text = @"CALENDAR";
        if([appDelegate.selectedMenuItem isEqualToString:@"CALENDAR"]){
            cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"tablecellselected.png"]];
        }
	}
	else if (row == 4)
	{
		//menuItemImageView.image=[UIImage imageNamed:@"media.png"];
        pictureLbl.font = [UIFont fontWithName:@"FontAwesome" size:30];
        pictureLbl.text = @"\uf26c";

		menuItemTextLabel.text = @"MEDIA";
        if([appDelegate.selectedMenuItem isEqualToString:@"MEDIA"]){
            cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"tablecellselected.png"]];
        }
	}
    else if (row == 5)
	{
		//menuItemImageView.image=[UIImage imageNamed:@"activity.png"];
        pictureLbl.font = [UIFont fontWithName:@"FontAwesome" size:30];
        pictureLbl.text = @"\uf0a1";

		menuItemTextLabel.text = @"ACTIVITY";
        if([appDelegate.selectedMenuItem isEqualToString:@"ACTIVITY"]){
            cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"tablecellselected.png"]];
        }
	}
    else if (row == 6)
	{
		//menuItemImageView.image=[UIImage imageNamed:@"create.png"];
        pictureLbl.font = [UIFont fontWithName:@"FontAwesome" size:30];
        pictureLbl.text = @"\uf0f6";

		menuItemTextLabel.text = @"CREATE";
        if([appDelegate.selectedMenuItem isEqualToString:@"CREATE"]){
            cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"tablecellselected.png"]];
        }
	}else if (row == 7)
	{
		//menuItemImageView.image=[UIImage imageNamed:@"settings.png"];
        pictureLbl.font = [UIFont fontWithName:@"FontAwesome" size:30];
        pictureLbl.text = @"\uf013";

		menuItemTextLabel.text = @"SETTINGS";
        if([appDelegate.selectedMenuItem isEqualToString:@"SETTINGS"]){
            cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"tablecellselected.png"]];
        }
    }else if (row == 8)
        {
            //menuItemImageView.image=[UIImage imageNamed:@"settings.png"];
            pictureLbl.font = [UIFont fontWithName:@"FontAwesome" size:30];
            pictureLbl.text = @"\uf011";

            menuItemTextLabel.text = @"LOGOUT";
            if([appDelegate.selectedMenuItem isEqualToString:@"LOGOUT"]){
                cell.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"tablecellselected.png"]];
        }
        }
	[cell.contentView addSubview:menuItemImageView];
    [cell.contentView addSubview:menuItemTextLabel];
    [cell.contentView addSubview:pictureLbl];

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// Grab a handle to the reveal controller, as if you'd do with a navigtion controller via self.navigationController.
    SWRevealViewController *revealController = self.revealViewController;
    // We know the frontViewController is a NavigationController
    UINavigationController *frontNavigationController = (id)revealController.frontViewController;  // <-- we know it is a NavigationController
    NSInteger row = indexPath.row;
    
	// Here you'd implement some of your own logic... I simply take for granted that the first row (=0) corresponds to the "FrontViewController".
	if (row == 0)
	{
        if ( ![frontNavigationController.topViewController isKindOfClass:[HomeViewController class]] )
        {
			HomeViewController *HVC = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:HVC
                                                            ];
			[revealController pushFrontViewController:navigationController animated:YES];
        }
		// Seems the user attempts to 'switch' to exactly the same controller he came from!
		else
		{
			[revealController revealToggle:self];
		}
	}else if(row==1){
        if ( ![frontNavigationController.topViewController isKindOfClass:[FeedViewController class]] )
        {
			FeedViewController *fvc = [[FeedViewController alloc] initWithNibName:@"FeedViewController" bundle:nil];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:fvc
                                                            ];
			[revealController pushFrontViewController:navigationController animated:YES];
        }
		// Seems the user attempts to 'switch' to exactly the same controller he came from!
		else
		{
			[revealController revealToggle:self];
		}
    }else if(row==2){
        if ( ![frontNavigationController.topViewController isKindOfClass:[CameraDetailViewController class]] )
        {
			CameraDetailViewController *cvc = [[CameraDetailViewController alloc] initWithNibName:@"CameraDetailViewController" bundle:nil];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:cvc
                                                            ];
			[revealController pushFrontViewController:navigationController animated:YES];
        }
		// Seems the user attempts to 'switch' to exactly the same controller he came from!
		else
		{
			[revealController revealToggle:self];
		}
    }else if(row==3){
        if ( ![frontNavigationController.topViewController isKindOfClass:[CalendarViewController class]] )
        {
			CalendarViewController *cvc = [[CalendarViewController alloc] initWithNibName:@"CalendarViewController" bundle:nil];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:cvc
                                                            ];
			[revealController pushFrontViewController:navigationController animated:YES];
        }
		// Seems the user attempts to 'switch' to exactly the same controller he came from!
		else
		{
			[revealController revealToggle:self];
		}
    }else if(row==4){
        if ( ![frontNavigationController.topViewController isKindOfClass:[MediaViewController class]] )
        {
			MediaViewController *mvc = [[MediaViewController alloc] initWithNibName:@"MediaViewController" bundle:nil];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mvc
                                                            ];
			[revealController pushFrontViewController:navigationController animated:YES];
        }
		// Seems the user attempts to 'switch' to exactly the same controller he came from!
		else
		{
			[revealController revealToggle:self];
		}
    }
    else if(row==5){
        if ( ![frontNavigationController.topViewController isKindOfClass:[ActivityViewController class]] )
        {
			ActivityViewController *mvc = [[ActivityViewController alloc] initWithNibName:@"ActivityViewController" bundle:nil];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mvc
                                                            ];
			[revealController pushFrontViewController:navigationController animated:YES];
        }
		// Seems the user attempts to 'switch' to exactly the same controller he came from!
		else
		{
			[revealController revealToggle:self];
		}
    }else if(row==6){
        if ( ![frontNavigationController.topViewController isKindOfClass:[CreateViewController class]] )
        {
			CreateViewController *cvc = [[CreateViewController alloc] initWithNibName:@"CreateViewController" bundle:nil];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:cvc
                                                            ];
			[revealController pushFrontViewController:navigationController animated:YES];
        }
		else
		{
			[revealController revealToggle:self];
		}
    }else if(row==7){
        if ( ![frontNavigationController.topViewController isKindOfClass:[SettingsViewController class]] )
        {
			SettingsViewController *svc = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
			UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:svc
                                                            ];
			[revealController pushFrontViewController:navigationController animated:YES];
        }
    }
        else if(row==8){
        
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs removeObjectForKey:@"loggedin"];
        [prefs synchronize];
            UIWindow* window = [[UIApplication sharedApplication] keyWindow];

            LoginViewController *lvc=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
            
            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:lvc];
            navController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
            window.rootViewController=navController;
            [window makeKeyAndVisible];

        }else
		{
			[revealController revealToggle:self];
		}
    }



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog( @"%@: REAR", NSStringFromSelector(_cmd));
    [_rearTableView reloadData];
}
//
//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    NSLog( @"%@: REAR", NSStringFromSelector(_cmd));
//}
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    [super viewDidAppear:animated];
//    NSLog( @"%@: REAR", NSStringFromSelector(_cmd));
//}
//
//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    NSLog( @"%@: REAR", NSStringFromSelector(_cmd));
//}

@end