//
//  LeftSelectScroll.h
//  YiLeHelp
//
//  Created by ChenYi on 15/11/14.
//  Copyright © 2015年 JC. All rights reserved.
//
//尺寸定义
#define kScreenWidth [UIScreen mainScreen].bounds.size.width//屏幕的宽度
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height//屏幕的高度
#define kNav_H kScreenHeight > 668 ? 86 : 64//屏幕的高度
#define kTabbar_H kScreenHeight > 668 ? 59 : 49//屏幕的高度
//RGBA设置颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#import <UIKit/UIKit.h>

/*
@protocol LeftSelectScrollDataSource <NSObject>

- (NSInteger)numberOfRowsInSection;

- (UIButton*)viewForRowAtIndexPath:(NSInteger *)indexPath;

@end
*/
@protocol LeftSelectScrollDelegate <NSObject>

-(void)clickLeftSelectScrollButton:(NSInteger)indexPath;

@end

@interface LeftSelectScroll : UIScrollView

@property(nonatomic,strong)NSArray *leftSelectArray;

@property (nonatomic,strong)id<LeftSelectScrollDelegate>leftSelectDelegate;

-(void)setLeftSelectArray:(NSArray *)leftSelectArray;


-(void)setSelectButtonWithIndexPathSection:(NSInteger)indexPathSection;

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)




@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com