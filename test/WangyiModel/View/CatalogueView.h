//
//  CatalogueView.h
//  jinrishangji
//
//  Created by Apple on 16/1/14.
//  Copyright © 2016年 williams. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftSelectScroll.h"

@protocol CatalogueViewDelegate <NSObject>

//代理事件负责内外数据传递
//array => (传出去) 修改以后
//callback => (传进来) 已经选中的行业数组
-(void)editArray:(NSMutableArray *)array result:(void(^)(NSMutableArray *))callback;

//点击触发事件
- (void)didSelectedIndex:(NSIndexPath *)indexPath title:(NSString *)title code:(NSString *)code;
@end

@interface CatalogueView : UIView

@property (nonatomic,strong) id<CatalogueViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *selectedArray;//选中的数据数组

@property (nonatomic, assign) BOOL isShowSymbol;//符号显示 右侧选项的加减号 -/+

@property (nonatomic, copy) void(^beginSearch)();//开始输入
@property (nonatomic, copy) void(^endSearch)();//结束输入

- (void)removeItemAtIndex:(NSInteger)index;
@end
