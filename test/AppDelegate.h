//
//  AppDelegate.h
//  test
//
//  Created by Apple on 15/9/29.
//  Copyright (c) 2015年 williams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSlideViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,strong) UINavigationController * mainNavigationController;

@property (nonatomic,strong) LeftSlideViewController * LeftSlideVC;

@end

