//
//  MoreResultViewController.m
//  jinrishangji
//
//  Created by Apple on 16/3/16.
//  Copyright © 2016年 williams. All rights reserved.
//

#import "MoreResultViewController.h"

@interface MoreResultViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *_dataArray;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MoreResultViewController
- (UITableView *)tableView {
    if (!_tableView) {
        CGRect frame = self.view.bounds;
        frame.origin.y = 64;
        frame.size.height = AppHeight - frame.origin.y;
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 44.0;
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated {
//    [self loadDataWithPage:1];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewConfig];//视图控制器配置
    
    [self prepareData];//数据配置
    
    [self uiConfig];//UI控件配置
}

- (void)viewConfig{
    self.navigationItem.title = _isOffer?@"产品搜索结果":@"用户搜索结果";
    self.view.backgroundColor = UIColorFromRGBA(0xf2f2f2, 1);
}

- (void)prepareData{
    _dataArray = [[NSMutableArray alloc] init];
}

- (void)uiConfig{
    
}
/*
#pragma mark - Private Method
- (void)loadDataWithPage:(int )page {
    NSDictionary *dic = @{@"ftoken":__kDeviceIdentifier,
                          @"target":_isOffer?@"ITEM":@"USER",
                          @"keyword":_searchKey,
                          @"page":[NSString stringWithFormat:@"%d",page],
                          @"limit":@"20"};
    
    [HTTPRequest HttpRequsetPostURL:__kQUERY parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Search_responseObject=->%@",responseObject);
        
        [_dataArray removeAllObjects];
        
        NSDictionary *responseDic = responseObject;
        if (_isOffer) {
            NSDictionary *offerItemsDic = responseDic;//offer搜索结果
            
            //offer 搜索结果
            int offerTotal = [offerItemsDic[@"total"] intValue];
            //        if (userTotal > 0) {
            NSMutableArray *offerModelArray = [[NSMutableArray alloc] init];
            NSArray *offerArray = offerItemsDic[@"items"];
            for (NSDictionary *dic in offerArray) {
                TableViewCellModel *model = [[TableViewCellModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [offerModelArray addObject:model];
            }
            [_dataArray addObjectsFromArray:offerModelArray];
            
        } else {
            NSDictionary *userItemsDic = responseDic;//用户搜索结果
            
            //用户搜索结果
            int userTotal = [userItemsDic[@"total"] intValue];
            //        if (userTotal > 0) {
            NSMutableArray *userArray = [NSMutableArray arrayWithArray:userItemsDic[@"items"]];
            
            [_dataArray addObjectsFromArray:userArray];
            
        }
        [self.tableView reloadData];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    if (_isOffer) {
        //offer 搜索结果
        TableViewCellModel *model = _dataArray[indexPath.row];
        cell = [[TableViewCellManager manager]createTableView:tableView TableViewCellType:TableViewCellTypeMe WithModel:model];
        
    } else {
        //用户搜索结果
        static NSString *cellid = @"searchViewUserCell";
        cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
        }
        NSDictionary *userInfo = _dataArray[indexPath.row];
        cell.textLabel.text = [userInfo[@"fuserAlias"] isKindOfClass:[NSNull class]]?@"":userInfo[@"fuserAlias"];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *object = _dataArray[indexPath.row];
    BOOL isOnline = [[NSUserDefaults standardUserDefaults] boolForKey:__kNETWORKSTATUS];
    if (isOnline) {
        OtherUserDetailViewController *oudvc = [[OtherUserDetailViewController alloc] init];
        oudvc.fuserId = object[@"fuserId"];
        oudvc.userInfoData = object;
        oudvc.isFollow = [object[@"ffollow"] isEqualToString:@"Y"];
        
        UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:oudvc];
        [self presentViewController:navi animated:YES completion:^{
            
        }];
        
    } else {
        [ProgressHUD showError:__ErrorNetWork];
    }
    
}
*/
@end
