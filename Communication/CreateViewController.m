//
//  CreateViewController.m
//  CommunicationApp
//
//  Created by mansoor shaikh on 14/04/14.
//  Copyright (c) 2014 MobiWebCode. All rights reserved.
//

#import "CreateViewController.h"
#import <MessageUI/MessageUI.h>
#import "MainViewController.h"
@interface CreateViewController ()<MFMailComposeViewControllerDelegate>

@end

@implementation CreateViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
            }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden=YES;
    // Do any additional setup after loading the view from its nib.
    MFMailComposeViewController *mailVC = [[MFMailComposeViewController alloc] init];
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
    MainViewController *mainvc=[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
    [self.navigationController pushViewController:mainvc animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
