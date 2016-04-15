
//
//  LJSocialTableViewController.m
//  特特特卖界面骨架
//
//  Created by 李学林 on 16/3/22.
//  Copyright © 2016年 upliver. All rights reserved.
//

#import "LJSocialTableViewController.h"
#import "MJRefresh.h"

@interface LJSocialTableViewController ()

@end


static NSString *ID = @"socialCell";

@implementation LJSocialTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:ID];
    
    __weak __typeof(self) weakself = self;
    
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"header_123123123");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself.tableView.header endRefreshing];
        });
    }];
    
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"footer_123123123");
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakself.tableView.footer endRefreshing];
        });
    }];
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 50;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ --- %zd ",self.title,indexPath.row];
    
    return cell;
}


@end
