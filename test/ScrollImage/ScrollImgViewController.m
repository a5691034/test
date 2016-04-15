//
//  ScrollImgViewController.m
//  test
//
//  Created by Apple on 15/11/2.
//  Copyright (c) 2015年 williams. All rights reserved.
//

#import "ScrollImgViewController.h"

#define Width self.view.bounds.size.width //图片滚动显示的宽
#define Height 220  //图片滚动显示的高

@interface ScrollImgViewController () <UIScrollViewDelegate>

    
@property (nonatomic, strong)NSArray *dataArray;
@property (nonatomic, strong) UIScrollView *imgScrollView;
@property (nonatomic, strong) UILabel *pageLabel;

@end

@implementation ScrollImgViewController
- (UIScrollView *)imgScrollView {
    if (!_imgScrollView) {
        _imgScrollView = [[UIScrollView alloc] init];
        
        [_imgScrollView setContentSize:CGSizeMake(Width*_dataArray.count,Height)];
        [_imgScrollView setBounces:NO];
        [_imgScrollView setShowsHorizontalScrollIndicator:NO];
        [_imgScrollView setBackgroundColor:[UIColor scrollViewTexturedBackgroundColor]];
        [_imgScrollView setUserInteractionEnabled:YES];
        _imgScrollView.delegate = self;
        
        [_imgScrollView setPagingEnabled:YES];//当此属性设置为YES时，才能自动分页
    }
    return _imgScrollView;
}

- (UILabel *)pageLabel {
    if (!_pageLabel) {
        _pageLabel = [[UILabel alloc] init];
        [_pageLabel setBackgroundColor:[UIColor redColor]];
        [_pageLabel setTextColor:[UIColor whiteColor]];
        [_pageLabel setAlpha:0.5f];
        [_pageLabel setTextAlignment:NSTextAlignmentCenter];
        
//        if ([[[self.dataDic objectForKey:@"list"] objectAtIndex:0] count] != 0) {
//            [_pageLabel setText:[NSString stringWithFormat:@"%d/%lu",pageNum,(unsigned long)[[[self.dataDic objectForKey:@"list"] objectAtIndex:0] count]]];
//        }else{
//            [_pageLabel setText:[NSString stringWithFormat:@"%d/%lu",0,(unsigned long)[[[self.dataDic objectForKey:@"list"] objectAtIndex:0] count]]];
//        }
    }
    return _pageLabel;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    for (int i=0; i<dataArray.count; i++) {
        UIImageView *imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:dataArray[i]]];
        imgv.frame = CGRectMake(i*Width, 0, Width, Height);
        [self.imgScrollView addSubview:imgv];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"图片滚动";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self prepareData];
    
    [self uiConfig];
}

- (void)prepareData {
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    for (int i = 1; i<6; i++) {
        [arr addObject:[NSString stringWithFormat:@"pic%d.jpg",i]];
    }
    
    self.dataArray = arr;
}

- (void)uiConfig {
    
    [self.view addSubview:self.imgScrollView];
    [self.view addSubview:self.pageLabel];
    
    self.imgScrollView.frame = CGRectMake(0, 64, Width, Height);
    self.pageLabel.frame = CGRectMake(0, 64, Width, 44);
    
    [self setPageNumber];
    
}
//设置页码显示内容
-  (void)setPageNumber {
    int pageNumber = _imgScrollView.contentOffset.x / Width + 1;
    
    self.pageLabel.text = [NSString stringWithFormat:@"%d/%d",pageNumber,(int)self.dataArray.count];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView; {
    NSLog(@"跳转");
    [self setPageNumber];
}


@end
