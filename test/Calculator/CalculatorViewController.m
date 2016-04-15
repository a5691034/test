//
//  CalculatorViewController.m
//  test
//
//  Created by Apple on 15/11/3.
//  Copyright (c) 2015年 williams. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorView.h"

@interface CalculatorViewController ()

@property (nonatomic, strong) CalculatorView *cv;

@end

@implementation CalculatorViewController
- (CalculatorView *)cv {
    if (!_cv) {
        _cv = [[CalculatorView alloc] initWithFrame:self.view.bounds];
        _cv.backgroundColor = [UIColor blackColor];
        _cv.alpha = 0.5;
        
        //设置弹出输入框的属性
        _cv.promptTitle = @"设置标题";
        CalculatorViewController *cvc = self;
        [_cv setCallback:^(NSString *result, NSString *currency) {
            cvc.title = [NSString stringWithFormat:@"%@-%@",currency, result];
        }];
        
        [self.navigationController.view addSubview:self.cv];
        _cv.hidden = YES;
    }
    return _cv;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"计算器";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"计算器" style:UIBarButtonItemStyleDone target:self action:@selector(showCalculatorView)];
    
}



- (void)showCalculatorView {
    self.cv.hidden = NO;
    
}

@end
