//
//  LeftSelectScroll.m
//  YiLeHelp
//
//  Created by ChenYi on 15/11/14.
//  Copyright © 2015年 JC. All rights reserved.
//

#import "LeftSelectScroll.h"

@implementation LeftSelectScroll
{
    UIButton *tempSelectButton;
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        tempSelectButton = [[UIButton alloc]init];
    }
    return self;
}

-(void)setLeftSelectArray:(NSArray *)leftSelectArray{
    _leftSelectArray = leftSelectArray;
//    NSArray *array = @[@"套餐",@"饮料",@"点心",@"小菜"];
//    _leftSelectArray = array;
    UIButton *lastBtn;
    for (int i = 0; i<_leftSelectArray.count; i++) {
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 53*i, kScreenWidth*0.25, 53)];
        [button setTitle:_leftSelectArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGBA(0xcc3031, 1) forState:UIControlStateSelected];
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        [button setBackgroundColor:[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f]];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, button.frame.size.height - 0.5, button.frame.size.width, 0.5)];
//        label.backgroundColor = MYCOLOR_LineColor;
        label.backgroundColor = [UIColor grayColor];
        [button addSubview:label];
        
        [self addSubview:button];
        
        [button addTarget:self action:@selector(clickLeftSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i+11;
        if (i == 0) {
            [button setSelected:YES];
            [button setBackgroundColor:[UIColor whiteColor]];
            tempSelectButton = button;
        }
        lastBtn = button;
    }
    if (CGRectGetMaxY(lastBtn.frame)>self.frame.size.height) {
        
    }
    
    self.contentSize = CGSizeMake(self.frame.size.width, CGRectGetMaxY(lastBtn.frame));
}

-(void)clickLeftSelectButton:(UIButton*)button{
    
    [tempSelectButton setSelected:NO];
    [tempSelectButton setBackgroundColor:[UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f]];
    
    [button setSelected:YES];
    [button setBackgroundColor:[UIColor whiteColor]];
    
    tempSelectButton = button;
    
    NSInteger tag = button.tag - 11;
    if (self.leftSelectDelegate && [self.leftSelectDelegate respondsToSelector:@selector(clickLeftSelectScrollButton:)]) {
        [self.leftSelectDelegate clickLeftSelectScrollButton:tag];
    }
}

-(void)setSelectButtonWithIndexPathSection:(NSInteger)indexPathSection{

    for (int i = 0; i< _leftSelectArray.count; i++) {
        NSInteger tag = i + 11 ;
        
        UIButton *btn = (UIButton*)[self viewWithTag:tag];
        if (btn.tag == indexPathSection + 11) {
            tempSelectButton = btn;
            [btn setSelected:YES];
            btn.backgroundColor = [UIColor whiteColor];
        }else{
            [btn setSelected:NO];
            btn.backgroundColor = [UIColor colorWithRed:0.95f green:0.95f blue:0.95f alpha:1.00f];
        }
    }
    
    CGFloat offsetY = self.contentOffset.y;
    CGFloat viewHeight = self.frame.size.height;
    CGFloat maxY = 53 * (indexPathSection+1);
    CGFloat minY = 53 * (indexPathSection);
    
    CGPoint offSet;
    if (maxY > offsetY + viewHeight) {
        offSet = CGPointMake(0, maxY-viewHeight);
    } else if (minY < offsetY) {
        offSet = CGPointMake(0, minY);
    } else {
        offSet = self.contentOffset;
    }
    //            NSLog(@"point--%f,%f",offSet.x, offSet.y);
    [UIView animateWithDuration:0.5 animations:^{
        self.contentOffset = offSet;
    } completion:^(BOOL finished) {
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com