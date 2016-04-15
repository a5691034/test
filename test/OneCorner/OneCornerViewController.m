//
//  OneCornerViewController.m
//  test
//
//  Created by Apple on 15/10/9.
//  Copyright (c) 2015年 williams. All rights reserved.
//

#import "OneCornerViewController.h"

@interface OneCornerViewController ()

@end

@implementation OneCornerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"一只角的View";
    
    UIButton *view2 = [[UIButton alloc] initWithFrame:CGRectMake(120, 100, 80, 80)];
    view2.backgroundColor = [UIColor redColor];
    [self.view addSubview:view2];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:view2.bounds byRoundingCorners: UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = view2.bounds;
    maskLayer.path = maskPath.CGPath;
    view2.layer.mask = maskLayer;
    
    [view2 addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnAction {
    NSLog(@"123");
}

@end
