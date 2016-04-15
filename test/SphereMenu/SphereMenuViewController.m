//
//  SphereMenuViewController.m
//  test
//
//  Created by Apple on 15/11/12.
//  Copyright (c) 2015年 williams. All rights reserved.
//

#import "SphereMenuViewController.h"
#import "SphereMenu.h"

@interface SphereMenuViewController () <SphereMenuDelegate>

@end

@implementation SphereMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:1 green:0.58 blue:0.27 alpha:1];
    
    UIImage *startImage = [UIImage imageNamed:@"start"];
    UIImage *image1 = [UIImage imageNamed:@"icon-twitter"];
    UIImage *image2 = [UIImage imageNamed:@"icon-email"];
    UIImage *image3 = [UIImage imageNamed:@"icon-facebook"];
    NSArray *images = @[image1, image2, image3];
    SphereMenu *sphereMenu = [[SphereMenu alloc] initWithStartPoint:CGPointMake(160, 320)
                                                         startImage:startImage
                                                      submenuImages:images];
    sphereMenu.delegate = self;
    [self.view addSubview:sphereMenu];
}

- (void)sphereDidSelected:(int)index
{
    NSLog(@"sphere %d selected", index);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
