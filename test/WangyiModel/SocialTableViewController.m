//
//  SocialTableViewController.m
//  jinrishangji
//
//  Created by Apple on 16/4/13.
//  Copyright © 2016年 williams. All rights reserved.
//

#import "SocialTableViewController.h"

#define AllDataSaveFileName @"cacheAllData.plist"

@interface SocialTableViewController ()
{
    NSMutableArray *_dataArray;
    
    NSInteger _currentPage;
}

@end

@implementation SocialTableViewController
- (void)setCurrentFtype:(NSString *)currentFtype {
    _currentFtype = currentFtype;
    
    [self.tableView.header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [[NSMutableArray alloc] init];
    _currentFtype = @"";
    
    CGRect frame = self.view.bounds;
    
    self.tableView = [[UITableView alloc] initWithFrame:frame];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.backgroundColor = UIColorFromRGBA(0xf1f2f3, 1);
    //设置分隔线的样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //自动行高
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    //行高估计
    self.tableView.estimatedRowHeight = 180.0;
    
    //        [_tableView registerNib:[UINib nibWithNibName:@"PublicTableViewCell" bundle:nil] forCellReuseIdentifier:@"BusinessCircleCell"];
    
    
    __weak __typeof(self) weakSelf = self;
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf.tableView.header endRefreshing];
//        [weakSelf loadNewData];
        // 模拟延迟加载数据，因此2秒后才调用（真实开发中，可以移除这段gcd代码）
        //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //
        //            });
    }];
    
    self.tableView.footer =  [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [weakSelf.tableView.footer endRefreshing];
//        [weakSelf loadMoreData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - receive Data
- (void)getDataType:(NSString *)type page:(NSString *)page {
    
    NSDictionary *dic = @{@"ftoken":__kDeviceIdentifier,
                          @"ftype":type,//I 求购  O 出售
                          @"page":page,
                          @"busItemType":[_currentItemType isEqualToString:@"ALL"]?@"":_currentItemType,
                          @"limit":@"20"};
    
    [HTTPRequest HttpRequsetPostURL:__kGETITEMOFFERDATA parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"获取发布信息列表数据--%@",responseObject);
        
        NSDictionary *responseDic = responseObject;
        NSArray *currentArray = responseDic[@"items"];//当前数据
        NSString *allCount = responseDic[@"total"];//总数
        
        if ([page isEqualToString:@"1"]) {
            
        } else {
            if (currentArray.count > 0) {
                for (NSDictionary *dic in currentArray) {
                    TableViewCellModel *model = [[TableViewCellModel alloc] init];
                    [model setValuesForKeysWithDictionary:dic];
                    [_dataArray addObject:model];
                }
                [self.tableView reloadData];
                //底部刷新结束
                [self.tableView.mj_footer endRefreshing];
            } else {
                _currentPage--;
                //底部刷新 无更多数据
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //        NSLog(@"test--error--%@",error);
        // 获取 本地缓存数据
        
        _currentPage--;
        //底部刷新 无更多数据
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
}

- (void)loadNewData {
    _currentPage = 1;
    
    NSDictionary *dic = @{@"ftoken":__kDeviceIdentifier,
                          @"ftype":_currentFtype,//I 求购  O 出售
                          @"page":@"1",
                          @"busItemType":[_currentItemType isEqualToString:@"ALL"]?@"":_currentItemType,
                          @"limit":@"20"};
    [HTTPRequest HttpRequsetPostURL:__kGETITEMOFFERDATA parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"获取列表第一页数据--%@",responseObject);
        
        NSDictionary *responseDic = responseObject;
        NSArray *currentArray = responseDic[@"items"];//当前数据
        NSString *allCount = responseDic[@"total"];//总数
        
        //当前数据存本地
        if ([_currentFtype isEqualToString:@""]) {
            //全部选项
            //缓存第一页 数据到本地
            
            //获取路径
            NSString *filePath = [__kLocalFilePath stringByAppendingPathComponent:AllDataSaveFileName];
            NSLog(@"商机缓存数据地址==>%@",filePath);
            //写入数据
            [currentArray writeToFile:filePath atomically:YES];
        }
        
        [_dataArray removeAllObjects];
        for (NSDictionary *dic in currentArray) {
            TableViewCellModel *model = [[TableViewCellModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [_dataArray addObject:model];
        }
        [self.tableView reloadData];
        
        //下拉刷新当前页面数据
        //        [ProgressHUD showSuccess:@"刷新成功"];
        //        [ProgressHUD dismiss];
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [ProgressHUD showError:__ErrorNetWork];
        
        //        NSLog(@"test--error--%@",error);
        // 获取 本地缓存数据
        if ([_currentItemType isEqualToString:@"ALL"]) {
            //获取路径
            NSString *filePath = [__kLocalFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"cacheAllData.plist"]];
            NSLog(@"商机获取数据地址==>%@",filePath);
            //写入数据
            NSArray *currentArray = [NSArray arrayWithContentsOfFile:filePath];
            for (NSDictionary *dic in currentArray) {
                TableViewCellModel *model = [[TableViewCellModel alloc] init];
                [model setValuesForKeysWithDictionary:dic];
                [_dataArray addObject:model];
            }
            [self.tableView reloadData];
        } else {
            [_dataArray removeAllObjects];
            [self.tableView reloadData];
        }
    }];
}

- (void)loadMoreData
{
    _currentPage++;
    [self getDataType:_currentFtype page:[NSString stringWithFormat:@"%d",_currentPage]];
    // 1.添加假数据
    //    for (int i = 0; i<5; i++) {
    //        [self.data addObject:MJRandomData];
    //    }
    //
    //    // 2.模拟2秒后刷新表格UI（真实开发中，可以移除这段gcd代码）
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(MJDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        // 刷新表格
    //        [self.tableView reloadData];
    //
    //        // 拿到当前的上拉刷新控件，结束刷新状态
    //
    //    });
}
*/
#pragma mark - Table view data source

#pragma mark - TableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 30;//_dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%@ --- %zd ",self.title,indexPath.row];
    
    return cell;
    
//    TableViewCellModel *model = _dataArray[indexPath.row];
//    
//    return [[TableViewCellManager manager]createTableView:tableView TableViewCellType:TableViewCellTypePayAttention WithModel:model];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    [ProgressHUD showSuccess:_dataArray[indexPath.row]];
//    TableViewCellModel *model = _dataArray[indexPath.row];
//    [[PayAttentionManager manager] clickAttentionCountToGoodsId:model.fioId result:^(BOOL success) {
//        
//    }];
//    
//    DetailViewController *dvc = [[DetailViewController alloc] init];
//    dvc.hidesBottomBarWhenPushed = YES;
//    dvc.isMe = NO;
//    dvc.model = model;
//    [self.navigationController pushViewController:dvc animated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
