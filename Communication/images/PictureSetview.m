//
//  PictureSetview.m
//  Communication
//
//  Created by mansoor shaikh on 23/03/15.
//  Copyright (c) 2015 MobiWebCode. All rights reserved.
//

#import "PictureSetview.h"
#import "UIColor+Expanded.h"
#import <QuartzCore/QuartzCore.h>

@implementation PictureSetview
@synthesize appDelegate,demoView;


- (id)init
{
    self = [super init];
    appDelegate=[[UIApplication sharedApplication] delegate];
    if (self) {
        [self setContainerView:[self createDemoView_Camera]];
    }
    return self;
}


- (UIView *)createDemoView_Camera
{
    
    demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300,150)];
    [demoView setBackgroundColor:[UIColor whiteColor]];
    demoView.layer.cornerRadius=5;
    [demoView.layer setMasksToBounds:YES];
    [demoView.layer setBorderWidth:1.0];
    demoView.layer.borderColor=[[UIColor whiteColor]CGColor];
    
    
    UIButton *topButton=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 300, 50)];
    [topButton setTitle:@"Select Picture" forState:UIControlStateNormal];
    [topButton setBackgroundImage:[UIImage imageNamed:@"navBar.png"] forState:UIControlStateNormal];
    topButton.layer.cornerRadius=15;
    [topButton setFont:[UIFont boldSystemFontOfSize:20]];
    [demoView addSubview:topButton];
    
   
    
    UIButton *cancel=[[UIButton alloc] initWithFrame:CGRectMake(265,10,30,30)];
    [cancel setBackgroundImage:[UIImage imageNamed:@"cancel.png"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(closeAlert:)
     forControlEvents:UIControlEventTouchUpInside];
    [demoView addSubview:cancel];
    [demoView bringSubviewToFront:cancel];

    
    return demoView;
}

-(void)closeAlert:(id)sender{
    [self close];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
