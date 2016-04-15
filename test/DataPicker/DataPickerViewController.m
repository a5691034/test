//
//  DataPickerViewController.m
//  test
//
//  Created by Apple on 15/10/6.
//  Copyright © 2015年 williams. All rights reserved.
//

#import "DataPickerViewController.h"
#import "ZHPickView.h"

@interface DataPickerViewController () <ZHPickViewDelegate>
{
    UIButton *_btn;
}

@property(nonatomic,strong)ZHPickView *pickview;

@end

@implementation DataPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"日期选择器";
    
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setTitle:@"时间选择器" forState:UIControlStateNormal];
    [self.view addSubview:_btn];
    _btn.backgroundColor = [UIColor redColor];
    _btn.frame = CGRectMake((self.view.frame.size.width - 250)/2, 100, 250, 50);
    [_btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnAction {
    
    
    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:9000000];
    _pickview=[[ZHPickView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];
    _pickview.delegate = self;
    
    [_pickview show];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [_pickview remove];
}

#pragma mark ZhpickVIewDelegate

-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString{
    
    NSString *string = [resultString substringToIndex:10];
    
    [_btn setTitle:string forState:UIControlStateNormal];

    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

@end
