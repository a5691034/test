//
//  ScrollHiddenViewController.m
//  test
//
//  Created by Apple on 15/12/24.
//  Copyright (c) 2015年 williams. All rights reserved.
//

#import "ScrollHiddenViewController.h"
#define LQXWidth self.view.bounds.size.width
#define LQXHeight self.view.bounds.size.height
#define LQXData [NSString stringWithFormat:@"随机数据---%d", arc4random_uniform(1000000)]

@interface ScrollHiddenViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;
@property (nonatomic, assign) BOOL hidden;
@property (nonatomic, assign) BOOL scrollUporDown;

@end

@implementation ScrollHiddenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.frame = CGRectMake(0, LQXHeight - 40, LQXWidth, 40);
    UIView *statusBarView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, LQXWidth, 20)];
    
    statusBarView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"首页--标题栏.png"]];
    
    [self.view addSubview:statusBarView];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, LQXWidth, LQXHeight - 20) style:0];
    self.tableView.bounces = YES
    ;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 44;
    self.tableView.userInteractionEnabled = YES;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = YES;
    self.dataArray = [NSMutableArray array];
    for (int i = 0; i< 100; i++) {
        [self.dataArray addObject:LQXData];
    }
    [self.view addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.dataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *str = @"reuse";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:str];
    }
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.tableView]) {
        static float newy = 0;
        static float oldy = 0;
        newy = scrollView.contentOffset.y ;
        if (newy != oldy ) {
            if (newy > oldy) {
                self.scrollUporDown = YES;
            }else if(newy < oldy){
                self.scrollUporDown = NO;
            }
            oldy = newy;
        }
        if (_scrollUporDown == YES) {
            self.hidden = YES;
            [UIView animateWithDuration:0.5 animations:^{
                
                self.navigationController.navigationBarHidden = YES;
//                self.navigationController.navigationBar.frame = CGRectMake(0, -40, LQXWidth, 40);
//                self.tabBarController.tabBar.frame = CGRectMake(0 , LQXHeight + 40, LQXWidth, 40);
            }];
            
        }
        else if (_scrollUporDown == NO) {
            if (self.hidden == YES) {
                [UIView animateWithDuration:0.5 animations:^{
                    self.navigationController.navigationBarHidden = NO;
//                    self.navigationController.navigationBar.frame = CGRectMake(0, 20, LQXWidth, 40);
                    
//                    self.tabBarController.tabBar.frame = CGRectMake(0 , LQXHeight , LQXWidth, 40);
                }];
                
                
                self.hidden = NO;
            }
        }
        
    }
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
