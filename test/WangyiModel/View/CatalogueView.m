//
//  CatalogueView.m
//  jinrishangji
//
//  Created by Apple on 16/1/14.
//  Copyright © 2016年 williams. All rights reserved.
//

#import "CatalogueView.h"

@interface CatalogueView ()<LeftSelectScrollDelegate,UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIView *_TopView;
    LeftSelectScroll *leftScrollView;
    
    NSMutableArray *leftDataSource;//右边资源
    
    //当点击的时候 不去调用滑动调节
    BOOL isScrollSetSelect;
    
    UITableView *tableViewList;
    
    NSInteger _currentSection;//当前一级分目录
    NSDictionary *_allData;
    NSArray *_leftData;
    NSDictionary *_rightData;
    
//    UITextField *_searchTF;
}
@property (strong,nonatomic) NSMutableArray  *searchList;

@property (nonatomic, strong) UITableView *searchResultTable;
@property (nonatomic, strong) NSArray *searchResultArray;
@property (nonatomic, strong) UIView *searchResultView;

@end
@implementation CatalogueView
- (UIView *)searchResultView {
    if (!_searchResultView) {
        CGRect frame = self.bounds;
        frame.origin.y = CGRectGetMaxY(_TopView.frame);
//        frame.size.width = 200;
        
        _searchResultView = [[UIView alloc] initWithFrame:frame];
        _searchResultView.backgroundColor = [UIColor lightGrayColor];
        
        _searchResultTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height-100) style:UITableViewStylePlain];
        _searchResultTable.delegate = self;
        _searchResultTable.dataSource = self;
        _searchResultTable.tag = 111;
        [_searchResultView addSubview:_searchResultTable];
        _searchResultTable.tableFooterView = [[UIView alloc] init];
        
    }
    return _searchResultView;
}

- (void)setSearchResultArray:(NSArray *)searchResultArray {
    _searchResultArray = searchResultArray;
    if (searchResultArray.count > 0) {
        //存在数据
//        for (NSDictionary *dic in searchResultArray) {
//            
//            
//        }
        
    }
    [_searchResultTable reloadData];
    

    
    
}



- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createTopView];
        
        [self prepareData];
        
        [self initObjects];
        
        [self creatLeftScrollView];
        
        [self createTableView];
    }
    return self;
}

- (void)createTopView {
    _TopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
    _TopView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    [self addSubview:_TopView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 44)];
    label.text = @"行业分类";
    label.textAlignment = NSTextAlignmentCenter;
    [_TopView addSubview:label];
    
    CGFloat width = 130;
    UITextField *searchTF = [[UITextField alloc] initWithFrame:CGRectMake(kScreenWidth-20-width, 8, width, 28)];
    searchTF.placeholder = @"搜索行业";
    searchTF.backgroundColor = [UIColor whiteColor];
    searchTF.returnKeyType = UIReturnKeyDone;
//    searchTF.enablesReturnKeyAutomatically = YES;
    searchTF.keyboardType = UIKeyboardTypeDefault;
    searchTF.autocorrectionType = UITextAutocorrectionTypeNo;//自动纠错关闭
    searchTF.autocapitalizationType = UITextAutocapitalizationTypeNone;//关闭首字符大写
    searchTF.delegate = self;
    [_TopView addSubview:searchTF];
    [searchTF addTarget:self  action:@selector(valueChanged:)  forControlEvents:UIControlEventAllEditingEvents];
//    _searchTF = searchTF;
    
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    leftView.image = [UIImage imageNamed:@"btn_search"];
    leftView.contentMode = UIViewContentModeScaleAspectFit;
    searchTF.leftView = leftView;
    searchTF.leftViewMode = UITextFieldViewModeAlways;
}

- (void)prepareData {
    _searchList = [[NSMutableArray alloc] init];
    
//    NSString *path = __kLocalFilePath;
//    //获取路径
//    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",IV]];
//    NSLog(@"%@",filePath);
//    
//    _allData = [NSDictionary dictionaryWithContentsOfFile:filePath];
//    
//    NSLog(@"行业数据=>%@",_allData);
    
    _leftData = [_allData[@"TOP"] allKeys];
//    _rightData = _allData;
    
//    _selectedArray = [[NSMutableArray alloc] init];
    //数据传入
//    [_delegate editArray:nil result:^(NSMutableArray *array) {
//        _selectedArray = array;
//    }];
}

-(void)initObjects{
    
    
    
    
    #pragma mark - 左侧数据
    leftDataSource = [[NSMutableArray alloc]initWithObjects:@"套餐1",@"套餐2",@"套餐3",@"套餐4",@"套餐5",@"套餐6",@"套餐7",@"套餐8",@"套餐9",@"套餐10",@"套餐11",@"套餐12", nil];
//    leftDataSource = [[NSMutableArray alloc] initWithArray:_leftData];
}

-(void)createTableView{
    tableViewList = [[UITableView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(leftScrollView.frame), _TopView.frame.size.height, kScreenWidth*0.75, self.frame.size.height-44)];
    tableViewList.delegate = self;
    tableViewList.dataSource = self;
    tableViewList.tag = 21;//标识tableView
    [self addSubview:tableViewList];
    tableViewList.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    tableViewList.scrollEnabled = YES;
}
-(void)creatLeftScrollView{
    
    leftScrollView = [[LeftSelectScroll alloc]initWithFrame:CGRectMake(0, _TopView.frame.size.height, kScreenWidth*0.25, self.frame.size.height-44)];
    
    leftScrollView.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    
    [leftScrollView setLeftSelectArray:leftDataSource];
    
    leftScrollView.leftSelectDelegate = self;
    
    leftScrollView.delegate = self;
    
    [self addSubview:leftScrollView];
}

#pragma mark 点击左侧切换右侧的代理方法
-(void)clickLeftSelectScrollButton:(NSInteger)indexPath{
    
    isScrollSetSelect = NO;
    
    _currentSection = indexPath;
    
    [tableViewList scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath] atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 21) {
        if (isScrollSetSelect == YES) {
            [leftScrollView setSelectButtonWithIndexPathSection:section];
        }
        return [self viewForHeaderView:section];
    }else{
        return nil;
    }
}

//实际需要会修改
- (UIView*)viewForHeaderView:(NSInteger)parama{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 32)];
    label.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
    if (leftDataSource.count != 0) {
        label.text = leftDataSource[parama];
        //        [NSString stringWithFormat:@"第%ld组",(long)parama];
    }
    return label;
}

//获取当前右侧数组数据
- (NSDictionary *)getLeftData:(NSInteger)section {
//    NSString *key = [_leftData objectAtIndex:section];
//    key = _allData[@"TOP"][key];
//    NSDictionary *currentDic = _allData[key];
    
    NSMutableDictionary *currentDic = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i<leftDataSource.count; i++) {
        [currentDic setObject:[NSString stringWithFormat:@"this is %d",i] forKey:leftDataSource[i]];
    }
    
    return currentDic;
}

#pragma mark UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag == 111) {
        return 1;
    }
    return  leftDataSource.count ;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 111) {
        return _searchResultArray.count;
    }
    
    NSDictionary *currentDic = [self getLeftData:section];
    
    return [currentDic allKeys].count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == 111) {
        return 0;
    }
    
    
    return 25;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 111) {
        return 44;
    }
    
    
    return 64;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 111) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultTableViewCell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ResultTableViewCell"];
        }
        NSDictionary *currentDic = _searchResultArray[indexPath.row];
        NSLog(@"currentDic=->%@",currentDic);
        NSString *key = [currentDic allKeys][0];
        if (_isShowSymbol) {
            //如果 key 存在于 已选数组中
            NSDictionary *object = @{@"title":key,@"code":currentDic[key]};
            if ([_selectedArray indexOfObject:object] != NSNotFound) {
                //存在 显示  -
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_minussign"]];
                
            } else {
                //不存在 显示 +
                cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_plussign"]];
            }
        }

//        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = key;
        cell.detailTextLabel.text = currentDic[key];
        return cell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCellIdentF"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableViewCellIdentF"];
        
    }
#pragma mark - 获取当前右侧数据
    NSDictionary *currentDic = [self getLeftData:indexPath.section];
    NSArray *array = [currentDic allKeys];
    NSString *key = array[indexPath.row];
    
    if (_isShowSymbol) {
        //如果 key 存在于 已选数组中
        NSDictionary *object = @{@"title":key,@"code":currentDic[key]};
        if ([_selectedArray indexOfObject:object] != NSNotFound) {
            //存在 显示  -
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_minussign"]];
            
        } else {
            //不存在 显示 +
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_plussign"]];
            
        }
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.text = key;//[NSString stringWithFormat:@"菜品%d",indexPath.row + 1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    /*
    if (tableView.tag == 111) {
        NSDictionary *currentDic = _searchResultArray[indexPath.row];
        NSString *key = [currentDic allKeys][0];
        
        [self endEditing:YES];
        
        
#pragma mark - 点击事件
        if ([self.delegate respondsToSelector:@selector(didSelectedIndex:title:code:)]) {
            [_delegate didSelectedIndex:indexPath title:key code:currentDic[key]];
        }

        if ([self.delegate respondsToSelector:@selector(editArray:result:)]) {
            //如果 key 存在于 已选数组中
            NSDictionary *object = @{@"title":key,@"code":currentDic[key]};
            if ([_selectedArray indexOfObject:object] != NSNotFound) {
                //存在
                [_selectedArray removeObject:object];
            } else {
                //不存在
                [_selectedArray addObject:object];
            }
            
            [_delegate editArray:_selectedArray result:nil];
            [tableViewList reloadData];
        }
        
        return;
    }
    
    
    
    NSString *key = [_leftData objectAtIndex:indexPath.section];
    key = _allData[@"TOP"][key];
    NSDictionary *currentDic = _allData[key];//当前section的row数据数组
    NSArray *currentArray = [currentDic allKeys];//key数组
    NSString *rowKey = currentArray[indexPath.row];
    
//    [ProgressHUD showSuccess:rowKey];
    
#pragma mark - 点击事件
    if ([self.delegate respondsToSelector:@selector(didSelectedIndex:title:code:)]) {
        [_delegate didSelectedIndex:indexPath title:rowKey code:currentDic[rowKey]];
    }
//    [self.CatalogueViewDelegate editArray:(传出去)修改以后 result:^(NSMutableArray *array) {
    //已经选中的行业数组
//        (传进来)
//        将数组中元素进行标记
//    }]
    if ([self.delegate respondsToSelector:@selector(editArray:result:)]) {
        //如果 key 存在于 已选数组中
        NSDictionary *object = @{@"title":rowKey,@"code":currentDic[rowKey]};
        if ([_selectedArray indexOfObject:object] != NSNotFound) {
            //存在
            [_selectedArray removeObject:object];
        } else {
            //不存在
            [_selectedArray addObject:object];
        }
        
        [_delegate editArray:_selectedArray result:nil];
        
        //刷新当前行
        [tableViewList reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    */
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    isScrollSetSelect = YES ;
}

#pragma mark - TextField Delegate
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    NSLog(@"输入内容=-> %@",textField.text);
//    return YES;
//}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    NSLog(@"开始输入");
    _beginSearch();
    [self addSubview:self.searchResultView];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"结束输入");
    textField.text = @"";
    _endSearch();
    [self.searchResultView removeFromSuperview];
    self.searchResultView = nil;
}

- (void)valueChanged:(UITextField *)textField {
    NSLog(@"输入内容=->%@",textField.text);
    /*
    //通过关键字, 到网络上搜索结果
//    NSLog(@"分类搜索结果 %@",localSearchController.searchBar.text);
//    NSLog(@"updateSearchResultsForSearchController");
    NSString *searchString = textField.text;//[localSearchController.searchBar text];
    NSLog(@"searchString----:%@",searchString);
    NSMutableArray *tempData = [[NSMutableArray alloc] init];
    
    if (![searchString isEqualToString:@""]) {
        NSString *path = __kLocalFilePath;
        //获取路径
        NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",IV]];
        NSLog(@"%@",filePath);
        
        NSDictionary *allData = [NSDictionary dictionaryWithContentsOfFile:filePath];
        
        NSLog(@"行业数据=>%@",allData);
        
        NSArray *leftData = [allData[@"TOP"] allObjects];
        NSLog(@"leftData----:%@",leftData);
        for (NSString *ID in leftData) {
            for (NSString *Key in [[allData objectForKey:ID] allKeys]) {
                [tempData  addObject:Key];
                
            }
        }
        NSPredicate *preicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[c] %@", searchString];
        if (self.searchList!= nil) {
            [self.searchList removeAllObjects];
        }
        //过滤数据
        tempData= [NSMutableArray arrayWithArray:[tempData filteredArrayUsingPredicate:preicate]];
        NSLog(@"%@",tempData);
        
        for (NSString *ID in leftData) {
            for (NSString *Key in [[allData objectForKey:ID] allKeys]) {
                if([tempData containsObject:Key])
                {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:[[allData objectForKey:ID] objectForKey:Key] forKey:Key];
                    [self.searchList addObject:dic];
                }
            }
        }
        
        NSLog(@"searchList---:%@",self.searchList);
        //刷新表格
        self.searchResultArray = self.searchList;
    } else {
        if (self.searchList!= nil) {
            [self.searchList removeAllObjects];
        }
        self.searchResultArray = self.searchList;
    }
     */
}

#pragma mark - Private Method
- (void)removeItemAtIndex:(NSInteger)index; {
    
    [tableViewList reloadData];
    
}

@end
