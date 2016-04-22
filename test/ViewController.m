//
//  ViewController.m
//  test
//
//  Created by Apple on 15/9/29.
//  Copyright (c) 2015年 williams. All rights reserved.
//

#import "ViewController.h"
#import "MJRefresh.h"
#import "AppDelegate.h"

#import <Photos/Photos.h>

#import "DataPickerViewController.h"
#import "CameraViewController.h"
#import "OneCornerViewController.h"
#import "PickImageViewController.h"
#import "DataPickViewController.h"
#import "DatePickerSecondViewController.h"
#import "LocationViewController.h"
#import "MoreLineViewController.h"
#import "CutPicViewController.h"
#import "ScrollImgViewController.h"
#import "CalculatorViewController.h"
#import "SphereMenuViewController.h"
#import "SendEmailViewController.h"
#import "ScrollHiddenViewController.h"
#import "RootBusinessCircleViewController.h"
#import "LJHomeViewController.h"
#import "ScrollShowViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_dataArray;
    UITableView *_tableView;
}


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self prepareData];
    [self uiConfig];
    
}

- (void)prepareData {
    _dataArray = [[NSMutableArray alloc] init];
    
    NSArray *titleArr = @[@"相机",@"日期选择(滚轮)",@"一只角的View",@"图片选择",@"日期选择器📅",@"日期选择器单选",@"地图定位", @"文字排序", @"屏幕截图", @"图片滚动", @"计算器", @"弹出式子菜单", @"发送邮件", @"滚动隐藏导航栏", @"页面滚动", @"模仿网易新闻",@"滚动-锁定"];
    for (int i = 0; i<20; i++) {
        if (i<titleArr.count) {
            [_dataArray addObject:titleArr[i]];
        }else {
            [_dataArray addObject:[NSString stringWithFormat:@"测试数据%d",i]];
        }
    }
}

- (void)uiConfig {
    CGRect frame = self.view.bounds;
    frame.origin.y = 64;
    frame.size.height -= 64;
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    _tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf loadMoreData];
    }];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"侧边栏" style:(UIBarButtonItemStylePlain) target:self action:@selector(openLeftVCAction)];
    
}
- (void)openLeftVCAction
{
    AppDelegate * tempAppDelegate = [[UIApplication sharedApplication]delegate];
    if (tempAppDelegate.LeftSlideVC.closed) {
        [tempAppDelegate.LeftSlideVC openLeftView];
    }
    else
    {
        [tempAppDelegate.LeftSlideVC closeLeftView];
    }
}


- (void)loadMoreData
{
    // 1.添加假数据
    for (int i = 0; i<5; i++) {
        [_dataArray addObject:[NSString stringWithFormat:@"测试数据%d",i]];
    }
    
    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [_tableView reloadData];
        
        // 拿到当前的上拉刷新控件，结束刷新状态
        [_tableView.footer endRefreshing];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    cell.textLabel.text = _dataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            NSLog(@"相机");
            
            [self.navigationController pushViewController:[CameraViewController new] animated:YES];
        }
            break;
        case 1:
        {
            NSLog(@"日期选择器");
            
            [self.navigationController pushViewController:[DataPickerViewController new] animated:YES];
        }
            break;
        case 2:
        {
            NSLog(@"独角");
            
            [self.navigationController pushViewController:[OneCornerViewController new] animated:YES];
        }
            break;
        case 3:
        {
            NSLog(@"图片选择器");
            
            [self.navigationController pushViewController:[PickImageViewController new] animated:YES];
        }
            break;
        case 4:
        {
            NSLog(@"日期");
            
            [self.navigationController pushViewController:[DataPickViewController new] animated:YES];
        }
            break;
        case 5:
        {
            NSLog(@"DatePickerSecondViewController");
            
            [self.navigationController pushViewController:[DatePickerSecondViewController new] animated:YES];
        }
            break;
        case 6:
        {
            NSLog(@"地图定位");
            
            [self.navigationController pushViewController:[LocationViewController new] animated:YES];
        }
            break;
        case 7:
        {
            NSLog(@"文字排序");
            
            [self.navigationController pushViewController:[MoreLineViewController new] animated:YES];
        }
            break;
        case 8:
        {
            NSLog(@"截屏");
            
            [self.navigationController pushViewController:[CutPicViewController new] animated:YES];
        }
            break;
        case 9:
        {
            NSLog(@"图片滚动");
            
            [self.navigationController pushViewController:[ScrollImgViewController new] animated:YES];
        }
            break;
        case 10:
        {
            NSLog(@"计算器按钮");
            
            [self.navigationController pushViewController:[CalculatorViewController new] animated:YES];
        }
            break;
        case 11:
        {
            NSLog(@"弹出式子菜单");
            
            [self.navigationController pushViewController:[SphereMenuViewController new] animated:YES];
        }
            break;
        case 12:
        {
            NSLog(@"发送邮件");
            [self.navigationController pushViewController:[SendEmailViewController new] animated:YES];
        }
            break;
        case 13:
        {
            NSLog(@"滚动隐藏导航栏");
            [self.navigationController pushViewController:[ScrollHiddenViewController new] animated:YES];
        }
            break;
        case 14:
        {
            NSLog(@"页面滚动");
            [self.navigationController pushViewController:[LJHomeViewController new] animated:YES];
        }
            break;
        case 15:
        {
            NSLog(@"模仿网易新闻");
            [self.navigationController pushViewController:[RootBusinessCircleViewController new] animated:YES];
        }
            break;
        case 16:
        {
            NSLog(@"滚动-锁定");

            [self.navigationController pushViewController:[ScrollShowViewController new] animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    AppDelegate * tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tempAppDelegate.LeftSlideVC setPanEnabled:YES];
}


@end
