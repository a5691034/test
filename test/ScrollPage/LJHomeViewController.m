//
//  LJHomeViewController.m
//  特特特卖界面骨架
//
//  Created by 李学林 on 16/3/22.
//  Copyright © 2016年 upliver. All rights reserved.
//

#import "LJHomeViewController.h"
#import "LJSocialTableViewController.h"

@interface LJHomeViewController ()<UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *titleScrollView;
@property (strong, nonatomic) UIScrollView *contentScrollView;

@end

@implementation LJHomeViewController
- (UIScrollView *)titleScrollView {
    if (!_titleScrollView) {
        _titleScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, AppWidth, 30)];
        
        _titleScrollView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:_titleScrollView];
    }
    return _titleScrollView;
}

- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64+30, AppWidth, AppHeight - 30 - 64)];
        
        _contentScrollView.delegate = self;
        
        _contentScrollView.pagingEnabled = YES;
        self.contentScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 0);
        //        _contentScrollView.alwaysBounceVertical = NO;
        //        _contentScrollView.alwaysBounceHorizontal = NO;
        _contentScrollView.showsVerticalScrollIndicator = NO;
        _contentScrollView.showsHorizontalScrollIndicator = NO;//横向滚动位置显示轴
        
        [self.view addSubview:_contentScrollView];
    }
    return _contentScrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGBA(0xf2f2f2, 1);
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self addChildVc];
    
    [self setupTitle];
    
    // 默认选中第一个控制器
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
}
/**
 *  添加自控制器
 */
- (void)addChildVc{
    
    LJSocialTableViewController *social0 = [[LJSocialTableViewController alloc] init];
    social0.title = @"社会";
    [self addChildViewController:social0];
    
    LJSocialTableViewController *social1 = [[LJSocialTableViewController alloc] init];
    social1.title = @"军事";
    [self addChildViewController:social1];
    
    LJSocialTableViewController *social2 = [[LJSocialTableViewController alloc] init];
    social2.title = @"娱乐";
    [self addChildViewController:social2];
    
    LJSocialTableViewController *social3 = [[LJSocialTableViewController alloc] init];
    social3.title = @"高效";
    [self addChildViewController:social3];
    
    LJSocialTableViewController *social4 = [[LJSocialTableViewController alloc] init];
    social4.title = @"生活";
    [self addChildViewController:social4];
    
    LJSocialTableViewController *social5 = [[LJSocialTableViewController alloc] init];
    social5.title = @"美食";
    [self addChildViewController:social5];
    
    LJSocialTableViewController *social6 = [[LJSocialTableViewController alloc] init];
    social6.title = @"热门";
    [self addChildViewController:social6];
}

- (void)setupTitle
{
    for (NSInteger i = 0 ; i < 7; i ++) {
        
        UILabel *label = [[UILabel alloc] init];
        label.text = self.childViewControllers[i].title;
        
        if (i == 0) {
            label.transform = CGAffineTransformMakeScale(1 + 0.3 ,1 + 0.3);
            label.textColor = [UIColor redColor];
        }
        
        CGFloat labelW = 100;
        CGFloat labelH = self.titleScrollView.bounds.size.height;
        CGFloat labelY = 0;
        CGFloat labelX = i * labelW;
        label.frame = CGRectMake(labelX, labelY, labelW, labelH);
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.userInteractionEnabled = YES;
        label.tag = i;
        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelClick:)]];
        
        [self.titleScrollView addSubview:label];
        
        self.titleScrollView.contentSize = CGSizeMake(7 * labelW, 0);
        self.contentScrollView.contentSize = CGSizeMake(7 * [UIScreen mainScreen].bounds.size.width, 0);
        
        self.titleScrollView.showsHorizontalScrollIndicator = NO;
    }
}

- (void)titleLabelClick:(UITapGestureRecognizer *)tap
{
    NSInteger index = tap.view.tag;
    CGPoint offset = self.contentScrollView.contentOffset;
    offset.x = index * self.contentScrollView.frame.size.width;
    
    [self.contentScrollView setContentOffset:offset animated:YES];
}


#pragma mark -scrollVeiwDelegate
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
    UILabel *label = self.titleScrollView.subviews[index];
    CGPoint titleContentOffset = CGPointMake(label.center.x - width * 0.5, 0);
    // 设置左边的距离不会太靠右
    if (titleContentOffset.x < 0)titleContentOffset.x = 0;
    
    CGFloat maxTitleContentOffsetX = self.titleScrollView.contentSize.width - width;
    // 设置右边的距离不会太靠左
    if (titleContentOffset.x > maxTitleContentOffsetX) titleContentOffset.x = maxTitleContentOffsetX;
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
    
    NSLog(@"scal=->%f",scal);
    
    NSInteger leftLabelIndex = scal;
    NSInteger rightLabelIndex = scal + 1;
    
    
    CGFloat leftScal = scal - leftLabelIndex;
    CGFloat rightScal = rightLabelIndex - scal;
    if (rightLabelIndex == self.titleScrollView.subviews.count - 1) {
        return;
    }
    
    // 拿出对应的label
    UILabel *leftLabel = self.titleScrollView.subviews[leftLabelIndex];
    UILabel *rightLabel = self.titleScrollView.subviews[rightLabelIndex];
    
    NSLog(@"%@=->%@",leftLabel.text,rightLabel.text);

    [leftLabel setTextColor:[UIColor colorWithRed:1 - leftScal green:0 blue:0 alpha:1]];
    [rightLabel setTextColor:[UIColor colorWithRed:1 - rightScal green:0 blue:0 alpha:1]];
    
    leftLabel.transform = CGAffineTransformMakeScale(1 + (1 - leftScal) * 0.3,1 + (1 - leftScal)* 0.3);
    rightLabel.transform = CGAffineTransformMakeScale(1 + (1 - rightScal)* 0.3,1 + (1-rightScal)* 0.3);
    
//    if (leftLabelIndex-1 > 0) {
//        UILabel *label_left = self.titleScrollView.subviews[leftLabelIndex-1];
//        [label_left setTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
//        NSLog(@"");
//    }
//    
//    if (rightLabelIndex+1 <self.titleScrollView.subviews.count - 1) {
//        UILabel *label_right = self.titleScrollView.subviews[rightLabelIndex+1];
//        [label_right setTintColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:1]];
//    }
//    
}

@end
