//
//  RootBusinessCircleViewController.m
//  jinrishangji
//
//  Created by Apple on 16/1/11.
//  Copyright (c) 2016年 williams. All rights reserved.
//

#import "RootBusinessCircleViewController.h"
#import "ZLCustomeSegmentControlView.h"
#import "TagSelectViewController.h"
//#import "TableViewCellManager.h"
#import "SearchBCViewController.h"
//#import "PayAttentionManager.h"

#import "SocialTableViewController.h"

#define AllDataSaveFileName @"cacheAllData.plist"
#define FtypeAll @""
#define FtypeBuy @"I"
#define FtypeSell @"O"

@interface RootBusinessCircleViewController () <UIScrollViewDelegate>
{
    NSMutableArray *_pilotTitleArray;
    NSMutableArray *_dataArray;
    
    NSString *_currentFtype;//当前获取数据类型/求购/出售/全部
    NSString *_currentItemType;//当前行业ID, 全部为@"ALL"/
    NSInteger _currentPage;
    
    BOOL _isEditPilotScroll;
}
@property (strong, nonatomic) UIScrollView *titleScrollView;
//@property (nonatomic, strong) UIScrollView *pilotScrollView;
@property (nonatomic, strong) UIButton *addPilotBtn;
//@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIScrollView *contentScrollView;
        
@end

@implementation RootBusinessCircleViewController
- (UIScrollView *)titleScrollView {
    if (!_titleScrollView) {
        _titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, AppWidth-40, 30)];
//        _titleScrollView.delegate = self;
        
        _titleScrollView.backgroundColor = [UIColor whiteColor];//UIColorFromRGBA(0xf2f2f2, 1);
        
        [self.view addSubview:_titleScrollView];
    }
    return _titleScrollView;
}

- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        
        _contentScrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+30, AppWidth, AppHeight-30-64)];
        
        _contentScrollView.delegate = self;
        
        _contentScrollView.pagingEnabled = YES;
        self.contentScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 0);
//        _contentScrollView.alwaysBounceVertical = NO;
//        _contentScrollView.alwaysBounceHorizontal = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;//横向滚动位置显示轴
        
    }
    return _contentScrollView;
}

/**
 *  添加自控制器
 */
- (void)addChildVc:(NSArray *)array{
    
    NSLog(@"addChildVc=->%@",array);
    
    for (UIViewController *VC in self.childViewControllers) {
        [VC removeFromParentViewController];
    }
//    [self removeFromParentViewController];
//    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (NSDictionary *dic in array) {
        
        SocialTableViewController *social = [[SocialTableViewController alloc] init];
//        social.currentFtype = FtypeAll;
        social.title = dic[@"title"];
        social.currentItemType = dic[@"code"];
        [self addChildViewController:social];
        
    }
    
}

- (void)setupTitle
{
    NSUInteger subVCNo = self.childViewControllers.count;
    
    UILabel *lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];;
    for (NSInteger i = 0 ; i < subVCNo; i ++) {
        
        UILabel *label = [[UILabel alloc] init];
        NSString *labelString = self.childViewControllers[i].title;
        label.text = labelString;
        
        if (i == 0) {
            label.transform = CGAffineTransformMakeScale(1 + 0.3 ,1 + 0.3);
            label.textColor = [UIColor redColor];
        }
        
        int count = [self convertToInt:labelString];
        CGFloat labelW = count<6?100:count*12;//100;
        CGFloat labelH = self.titleScrollView.bounds.size.height;
        CGFloat labelY = 0;
        CGFloat labelX = CGRectGetMaxX(lastLabel.frame);//i * (labelW+20);
        
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.userInteractionEnabled = YES;
        label.tag = 100+i;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelClick:)]];
        
//        label.adjustsFontSizeToFitWidth = YES;
        
        [self.titleScrollView addSubview:label];
        lastLabel = label;
        
//        self.titleScrollView.contentSize = CGSizeMake(subVCNo * (labelW+20), 0);
        self.titleScrollView.contentSize = CGSizeMake(CGRectGetMaxX(label.frame), 0);
        self.contentScrollView.contentSize = CGSizeMake(subVCNo * [UIScreen mainScreen].bounds.size.width, 0);
        self.titleScrollView.showsHorizontalScrollIndicator = NO;
    }
    
    
}

- (void)titleLabelClick:(UITapGestureRecognizer *)tap
{
    NSInteger index = tap.view.tag-100;
    CGPoint offset = self.contentScrollView.contentOffset;
    offset.x = index * self.contentScrollView.frame.size.width;
    
    [self.contentScrollView setContentOffset:offset animated:YES];
}


- (UIButton *)addPilotBtn {
    if (!_addPilotBtn) {
        _addPilotBtn = [[UIButton alloc] initWithFrame:CGRectMake(AppWidth-40, 64, 40, 30)];
        [_addPilotBtn setBackgroundColor:UIColorFromRGBA(0xf5f6f7, 1)];
        [_addPilotBtn setTitle:@"+" forState:UIControlStateNormal];
        [_addPilotBtn setTitleColor:UIColorFromRGBA(0xc93336, 1) forState:UIControlStateNormal];
        [_addPilotBtn addTarget:self action:@selector(editPiloteAction) forControlEvents:UIControlEventTouchUpInside];
        
//        //shadowColor阴影颜色
//        _addPilotBtn.layer.shadowColor = [UIColor blackColor].CGColor;
//        //shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
//        _addPilotBtn.layer.shadowOffset = CGSizeMake(1,1);
//        //阴影透明度，默认0
//        _addPilotBtn.layer.shadowOpacity = 0.5;
//        //阴影半径，默认3
//        _addPilotBtn.layer.shadowRadius = 1;
    }
    return _addPilotBtn;
}

- (void)viewWillAppear:(BOOL)animated {
    
//    [self loadNewData];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self viewConfig];//视图控制器配置
    
    [self prepareData];//数据配置
    
    [self uiConfig];//UI控件配置 ==> 登陆成功以后再配置 notAction方法内
    
    [self notAction];
}

//视图控制器配置
- (void)viewConfig {
    self.navigationItem.title = @"登录中...";
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notAction) name:__kisAutoLogin object:nil];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginErrorAction) name:__kLoginError object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:__kUpdateCurrentPageData object:nil];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //左侧搜索按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchItemAction)];
    //右侧更多按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"•••" style:UIBarButtonItemStyleDone target:self action:@selector(moreItemAction)];
}

//数据配置
- (void)prepareData {
    _pilotTitleArray = [[NSMutableArray alloc] initWithArray:@[@{@"title":@"全部",@"code":@"ALL"},@{@"title":@"项目一",@"code":@"1001"},@{@"title":@"项目一二",@"code":@"1001"},@{@"title":@"项目一三",@"code":@"1001"},@{@"title":@"项目一四",@"code":@"1001"},@{@"title":@"项目一",@"code":@"1001"},@{@"title":@"项目一",@"code":@"1001"}]];
    
    _dataArray = [[NSMutableArray alloc] init];
    _currentItemType = @"ALL";
    _currentPage = 1;
    _currentFtype = FtypeAll;
}

//UI控件配置
- (void)uiConfig {
    
//    [self.view addSubview:self.titleScrollView];
    [self.view addSubview:self.addPilotBtn];
    [self.view addSubview:self.contentScrollView];
//    [self.view addSubview:self.tableView];
    [self addChildVc:_pilotTitleArray];
    
    [self setupTitle];
    // 默认选中第一个控制器
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];

//
//    [[LoginUser user] getuserItemTypeCompetion:^(BOOL success, NSString *msg, NSArray *items) {
//        
//        if (success) {
//            for (NSDictionary *dic in items) {
//                NSDictionary *newdic = @{@"title":dic[@"fitemTypeName"],
//                                         @"code":dic[@"fitemTypeId"]};
//                [_pilotTitleArray addObject:newdic];
//            }
//            NSLog(@"_pilotTitleArray=>>%@",_pilotTitleArray);
//        } else {
//            
//        }
//        [self addChildVc:_pilotTitleArray];
//        
//        [self setupTitle];
//        // 默认选中第一个控制器
//        [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
//    }];
}

#pragma mark - ScrollVeiwDelegate
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGFloat width = scrollView.frame.size.width;
    CGFloat height = scrollView.frame.size.height;
    CGFloat offsetX = scrollView.contentOffset.x;
    
    // 向contentScrollView上添加控制器的View
    NSInteger index = offsetX / width;
    
    // 取出要显示的控制器
    UITableViewController *willShowVc = self.childViewControllers[index];
    
    // 设置顶部的titleScrollVeiw滚动到中间
    UILabel *label = [self.titleScrollView viewWithTag:index+100];//self.titleScrollView.subviews[index];
    CGPoint titleContentOffset = CGPointMake(label.center.x - width * 0.5, 0);
    
    CGFloat maxTitleContentOffsetX = self.titleScrollView.contentSize.width - width + 40;
    // 设置右边的距离不会太靠左
    if (titleContentOffset.x > maxTitleContentOffsetX) titleContentOffset.x = maxTitleContentOffsetX;
    // 设置左边的距离不会太靠右
    if (titleContentOffset.x < 0) titleContentOffset.x = 0;
    
    [self.titleScrollView setContentOffset:titleContentOffset animated:YES];
    
    // 如果当前控制器已经显示过一次就不要再次显示出来 就直接返回;
    if ([willShowVc isViewLoaded]) {
        return;
    }
    willShowVc.view.frame = CGRectMake(width * index, 0, width, height);
    [scrollView addSubview:willShowVc.view];
    
    [willShowVc.tableView.header beginRefreshing];
}

/**
 *  手动拖拽scrollView的时候才会调用这个方法,通过点击上面的方法导致的scrollView滚动快停止的时候不会调用这个方法
 *
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat scal = self.contentScrollView.contentOffset.x / self.contentScrollView.frame.size.width;
    
//    NSLog(@"scal=->%f",scal);
    
    NSInteger leftLabelIndex = scal;
    NSInteger rightLabelIndex = scal + 1;
    
    
    CGFloat leftScal = scal - leftLabelIndex;
    CGFloat rightScal = rightLabelIndex - scal;
    if (self.titleScrollView.subviews.count < 1) {
        return;
    }
    if (rightLabelIndex == self.titleScrollView.subviews.count) {
        return;
    }
    
    // 拿出对应的label
    UILabel *leftLabel = [self.titleScrollView viewWithTag:leftLabelIndex+100];//self.titleScrollView.subviews[leftLabelIndex];
    UILabel *rightLabel = [self.titleScrollView viewWithTag:rightLabelIndex+100];//self.titleScrollView.subviews[rightLabelIndex];
    
    [leftLabel setTextColor:[UIColor colorWithRed:1 - leftScal green:0 blue:0 alpha:1]];
    [rightLabel setTextColor:[UIColor colorWithRed:1 - rightScal green:0 blue:0 alpha:1]];
    
    leftLabel.transform = CGAffineTransformMakeScale(1 + (1 - leftScal) * 0.3,1 + (1 - leftScal)* 0.3);
    rightLabel.transform = CGAffineTransformMakeScale(1 + (1 - rightScal)* 0.3,1 + (1-rightScal)* 0.3);
    
    
}

#pragma mark - Private Method
-(void)notAction
{
    self.navigationItem.title = @"商机";
    
//    [self uiConfig];//UI控件配置

    //更新页面数据
    _currentFtype = FtypeAll;
//    [self loadNewData];
}

- (void)loginErrorAction {
    self.navigationItem.title = @"商机(离线...)";
    
//    [self uiConfig];//UI控件配置

    //获取路径
//    NSString *filePath = [__kLocalFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"cacheAllData.plist"]];
//    NSLog(@"商机获取数据地址==>%@",filePath);
//    //写入数据
//    NSArray *currentArray = [NSArray arrayWithContentsOfFile:filePath];
//    for (NSDictionary *dic in currentArray) {
//        TableViewCellModel *model = [[TableViewCellModel alloc] init];
//        [model setValuesForKeysWithDictionary:dic];
//        [_dataArray addObject:model];
//    }
//    [_tableView reloadData];
}

- (void)scrollPilotChange:(NSInteger)index  {
    
}

- (void)searchItemAction {
    SearchBCViewController *sbcvc = [[SearchBCViewController alloc] init];
    sbcvc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:sbcvc animated:YES];
    
}

- (void)moreItemAction {
    CGFloat width = self.contentScrollView.frame.size.width;
    CGFloat offsetX = self.contentScrollView.contentOffset.x;
    
    // 向contentScrollView上添加控制器的View
    NSInteger index = offsetX / width;
    
    // 取出要显示的控制器
    __weak SocialTableViewController *willShowVc = self.childViewControllers[index];
    
    
    //初始化提示框；
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"全部" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
//        _currentFtype = FtypeAll;
        willShowVc.currentFtype = FtypeAll;
        
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"求购" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        _currentFtype = FtypeBuy;
        willShowVc.currentFtype = FtypeBuy;
        //        [self loadNewData];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"出售" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        _currentFtype = FtypeSell;
        willShowVc.currentFtype = FtypeSell;
        //        [self loadNewData];
    }]];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        //点击按钮的响应事件；
        
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alert addAction:cancel];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

- (void)editPiloteAction {
//    [ProgressHUD showSuccess:@"修改标签内容"];
    
    TagSelectViewController *tsvc = [[TagSelectViewController alloc] initWithArray:_pilotTitleArray];
    tsvc.hidesBottomBarWhenPushed = YES;
//    tsvc.originalArray = _pilotTitleArray;
    [tsvc setCallback:^(NSMutableArray *array) {
        NSLog(@"修改标签内容==>>%@",array);
        _pilotTitleArray = array;
        
        [_titleScrollView removeFromSuperview];
        _titleScrollView = nil;
        _currentItemType = @"ALL";
        
        [self addChildVc:_pilotTitleArray];
        
        [self setupTitle];
        
        CGPoint offset = self.contentScrollView.contentOffset;
        offset.x = 0;
        [self.contentScrollView setContentOffset:offset animated:YES];
        // 默认选中第一个控制器
        [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
        
//        [_pilotScrollView removeFromSuperview];
//        _pilotScrollView = nil;
//        [self.view insertSubview:self.pilotScrollView belowSubview:self.addPilotBtn];
//        _isEditPilotScroll = NO;
//        [self loadNewData];
    }];
//    _isEditPilotScroll = YES;
    [self.navigationController pushViewController:tsvc animated:YES];
    
}

#pragma mark - Tools Method
- (int)convertToInt:(NSString*)strtemp//判断中英混合的的字符串长度
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}

@end
