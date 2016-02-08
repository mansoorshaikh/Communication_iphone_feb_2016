//
//  PlayMediaViewController.m
//  CommunicationApp
//
//  Created by mansoor shaikh on 14/04/14.
//  Copyright (c) 2014 MobiWebCode. All rights reserved.
//

#import "PlayMediaViewController.h"

@interface PlayMediaViewController ()

@end

@implementation PlayMediaViewController

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
    
    MPMoviePlayerController *moviePlayer =  [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:@"sample.mp4"]];
    moviePlayer.fullscreen=YES;
    [self.view addSubview:moviePlayer.view ];
    [self.view bringSubviewToFront:moviePlayer.view];
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerDidExitFullscreenNotification
                                                  object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
