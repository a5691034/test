//
//  SearchBCViewController.m
//  jinrishangji
//
//  Created by Apple on 16/1/18.
//  Copyright © 2016年 williams. All rights reserved.
//

#import "SearchBCViewController.h"
#import "MoreResultViewController.h"

@interface SearchBCViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>
{
    NSMutableArray *_dataArray; //结果数组
    
    NSString *_searchKey;//搜索关键字
}
@property (nonatomic, strong) UITextField *searchTF;//搜索框
@property (nonatomic, strong) UIView *backgroundPromptView;//背景提示视图

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SearchBCViewController
- (UITextField *)searchTF {
    if (!_searchTF) {
        _searchTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 64+5, AppWidth-2*20, 35)];
        _searchTF.font = [UIFont systemFontOfSize:14];
        //        _searchTF.placeholder = @"搜索关键字、人、认证商家";
        _searchTF.backgroundColor = [UIColor whiteColor];
        _searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTF.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索关键字、人、认证商家" attributes:@{NSForegroundColorAttributeName: UIColorFromRGBA(0x999999, 1)}];
        //        [_searchTF setValue:UIColorFromRGBA(0x999999, 1) forKey:@"placeholderLabel.textColor"];
        
        _searchTF.layer.borderColor = UIColorFromRGBA(0xd2d2d2, 1).CGColor;
        _searchTF.layer.borderWidth = 1;
        _searchTF.autocapitalizationType = UITextAutocapitalizationTypeNone;//去除首字母大写
        
        _searchTF.delegate = self;
        
        UIImageView *leftV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_search"]];
        leftV.frame = CGRectMake(0, 0, 40, 20);
        leftV.contentMode = UIViewContentModeScaleAspectFit;
        _searchTF.leftView = leftV;
        _searchTF.leftViewMode = UITextFieldViewModeAlways;
        
        UIButton *searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 40)];
        [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [searchBtn setTitleColor:UIColorFromRGBA(0x999999, 1) forState:UIControlStateNormal];
        searchBtn.layer.borderColor = UIColorFromRGBA(0xd2d2d2, 1).CGColor;
        searchBtn.layer.borderWidth = 1;
        _searchTF.rightView = searchBtn;
        _searchTF.rightViewMode = UITextFieldViewModeAlways;
        [searchBtn addTarget:self action:@selector(searchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _searchTF;
}

- (UIView *)backgroundPromptView {
    if (!_backgroundPromptView) {
        _backgroundPromptView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_searchTF.frame), AppWidth, 300)];
        _backgroundPromptView.backgroundColor = [UIColor clearColor];
        
        CGFloat width = 50;
        CGFloat fontSize = 12;
        //关键字->图片
        UIImageView *keyIcon = [[UIImageView alloc] initWithFrame:CGRectMake(AppWidth/2-2*width, 60, width, width)];
        keyIcon.image = [UIImage imageNamed:@"character"];
        [_backgroundPromptView addSubview:keyIcon];
        //关键字->文字
        UILabel *keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(AppWidth/2-2*width, CGRectGetMaxY(keyIcon.frame), width, 30)];
        keyLabel.text = @"关键字";
        keyLabel.textColor = UIColorFromRGBA(0x999999, 1);
        keyLabel.font = [UIFont systemFontOfSize:fontSize];
        keyLabel.textAlignment = NSTextAlignmentCenter;
        [_backgroundPromptView addSubview:keyLabel];
        //人->图片
        UIImageView *userIcon = [[UIImageView alloc] initWithFrame:CGRectMake(AppWidth/2+width, 60, width, width)];
        userIcon.image = [UIImage imageNamed:@"person"];
        [_backgroundPromptView addSubview:userIcon];
        //人->关键字
        UILabel *userLabel = [[UILabel alloc] initWithFrame:CGRectMake(AppWidth/2+width, CGRectGetMaxY(userIcon.frame), width, 30)];
        userLabel.text = @"人";
        userLabel.textColor = UIColorFromRGBA(0x999999, 1);
        userLabel.font = [UIFont systemFontOfSize:fontSize];
        userLabel.textAlignment = NSTextAlignmentCenter;
        [_backgroundPromptView addSubview:userLabel];
        
    }
    return _backgroundPromptView;
}

- (UITableView *)tableView {
    if (!_tableView) {
        CGRect frame = self.view.bounds;
        frame.origin.y = CGRectGetMaxY(self.searchTF.frame)+5;
        frame.size.height = AppHeight - frame.origin.y;
        _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 44.0;
        
        [self.view addSubview:_tableView];
    }
    _tableView.hidden = NO;
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewConfig];//视图控制器配置
    
    [self prepareData];//数据配置
    
    [self uiConfig];//UI控件配置
}

- (void)viewConfig{
    self.navigationItem.title = @"搜索";
    self.view.backgroundColor = UIColorFromRGBA(0xf2f2f2, 1);
}

- (void)prepareData{
    _dataArray = [[NSMutableArray alloc] init];
}

- (void)uiConfig{
    [self.view addSubview:self.searchTF];
    [self.view addSubview:self.backgroundPromptView];
}
/*
#pragma mark - TableView Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            static NSString *cellid = @"searchViewMoreCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
            }
            cell.textLabel.text = _dataArray[indexPath.section][indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            //用户搜索结果
            static NSString *cellid = @"searchViewUserCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
            }
            NSDictionary *userInfo = _dataArray[indexPath.section][indexPath.row];
            cell.textLabel.text = [userInfo[@"fuserAlias"] isKindOfClass:[NSNull class]]?@"":userInfo[@"fuserAlias"];
        }
        
    }
    
    if (indexPath.section == 1) {
        if (indexPath.row == 3) {
            static NSString *cellid = @"searchViewMoreCell";
            cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellid];
            }
            cell.textLabel.text = _dataArray[indexPath.section][indexPath.row];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
        //offer 搜索结果
        TableViewCellModel *model = _dataArray[indexPath.section][indexPath.row];
        
        cell = [[TableViewCellManager manager]createTableView:tableView TableViewCellType:TableViewCellTypeMe WithModel:model];
        }
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSArray *title = @[@"联系人", @"产品"];
    return title[section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id object = _dataArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        //用户
        if ([object isKindOfClass:[NSDictionary class]]) {
            
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
        
        //最后一个加载更多=->
        if ([object isKindOfClass:[NSString class]]) {
            MoreResultViewController *mrvc = [[MoreResultViewController alloc] init];
            mrvc.searchKey = _searchKey;
            mrvc.isOffer = NO;
            [self.navigationController pushViewController:mrvc animated:YES];
        }
    }
    if (indexPath.section == 1) {
        //offer
        if ([object isKindOfClass:[TableViewCellModel class]]) {
            TableViewCellModel *model = object;
            [[PayAttentionManager manager] clickAttentionCountToGoodsId:model.fioId result:^(BOOL success) {
                
            }];
            
            DetailViewController *dvc = [[DetailViewController alloc] init];
            dvc.hidesBottomBarWhenPushed = YES;
            dvc.isMe = NO;
            dvc.model = model;
            [self.navigationController pushViewController:dvc animated:YES];
        }
        
        //最后一个加载更多=->
        if ([object isKindOfClass:[NSString class]]) {
            MoreResultViewController *mrvc = [[MoreResultViewController alloc] init];
            mrvc.searchKey = _searchKey;
            mrvc.isOffer = YES;
            [self.navigationController pushViewController:mrvc animated:YES];
        }
        
    }
    
}


#pragma mark - Private Method
- (void)searchBtnAction:(UIButton *)btn {
    NSLog(@"搜索==>%@",_searchTF.text);
    
    _searchKey = _searchTF.text;
    
    if ([_searchKey isEqualToString:@""]) {
        [ProgressHUD showError:@"请输入搜索内容"];
        return;
    }
    
    //    __kQUERY
    NSDictionary *dic = @{@"ftoken":__kDeviceIdentifier,
                          @"target":@"ALL",
                          @"keyword":_searchKey,
                          @"page":@"1",
                          @"limit":@"3"};
    [ProgressHUD show];
    [HTTPRequest HttpRequsetPostURL:__kQUERY parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Search_responseObject=->%@",responseObject);
        
        NSDictionary *responseDic = responseObject;
        NSDictionary *userItemsDic = responseDic[@"userItems"];//用户搜索结果
        NSDictionary *offerItemsDic = responseDic[@"offerItems"];//offer搜索结果
        
        [_dataArray removeAllObjects];
        
        //用户搜索结果
        int userTotal = [userItemsDic[@"total"] intValue];
        //        if (userTotal > 0) {
        NSMutableArray *userArray = [NSMutableArray arrayWithArray:userItemsDic[@"items"]];
        //超过三条搜索结果
        if (userTotal > 3) {
            [userArray addObject:@"查看更多联系人"];
        }
        [_dataArray addObject:userArray];
        
        //        }
        
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
        //超过三条搜索结果
        if (offerTotal > 3) {
            [offerModelArray addObject:@"查看更多产品"];
        }
        [_dataArray addObject:offerModelArray];
        
        [self.tableView reloadData];
        [ProgressHUD dismiss];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [ProgressHUD showError:__ErrorNetWork];
    }];
    
}

#pragma mark - TextField Delegate


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //修改搜索 关键字
    _tableView.hidden = YES;
    return YES;
    
}
*/
@end
