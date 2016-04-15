//
//  CalculatorView.h
//  test
//
//  Created by Apple on 15/11/3.
//  Copyright (c) 2015年 williams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorView : UIView

@property (nonatomic, strong) NSString *promptTitle;
@property (nonatomic, strong) void(^callback)(NSString *result, NSString *currency);

@end
