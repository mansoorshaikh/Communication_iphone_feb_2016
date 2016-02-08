//
//  AppDelegate.h
//  Communication
//
//  Created by mansoor shaikh on 21/04/14.
//  Copyright (c) 2014 MobiWebCode. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SWRevealViewController;
@class LoginViewController;
@class HomeViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    HomeViewController *HomeViewController;
}
@property (nonatomic, retain)IBOutlet HomeViewController *homeViewController;
@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain) LoginViewController *lvc;
@property(nonatomic,retain) NSString *selectedMenuItem;
@property (strong, nonatomic) SWRevealViewController *viewController;
@property(nonatomic,retain) NSMutableArray *dateEventArray;
@property(nonatomic,retain) NSString *deviceToken;

@end
