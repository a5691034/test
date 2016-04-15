//
//  CalculatorView.m
//  test
//
//  Created by Apple on 15/11/3.
//  Copyright (c) 2015年 williams. All rights reserved.
//

#import "CalculatorView.h"

#define LeftDistanceWide 10 //左边距
#define BottomDistanceHeight 10 //底边距
#define KeyBoardHeight 250 //计算器高度
#define KeyBoardWidth (AppWidth-2*LeftDistanceWide) //计算器宽度
#define CurrencyHeight 190 //货币高度

#define AppWidth ([UIScreen mainScreen].bounds.size.width)
#define AppHeight ([UIScreen mainScreen].bounds.size.height)

@interface CalculatorView () <UITextFieldDelegate>
{
    CGFloat btnWidth;
    CGFloat btnHeight;
    
    NSArray *mainKeyArray;
    NSArray *choseCurrencyArrya;
    
    UILabel *_titleLabel;
}
@property (nonatomic, strong) UITextField *inputTF;
@property (nonatomic, strong) UIButton *currencyBtn;
@property (nonatomic, strong) UIButton *deletBtn;
@property (nonatomic, strong) UIButton *okBtn;
@property (nonatomic, strong) UIView *mainKeyBoard;

@property (nonatomic, strong) UIView *choseCurrencyView;

@end
@implementation CalculatorView
- (UITextField *)inputTF {
    if (!_inputTF) {
        _inputTF = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 3*btnWidth, btnHeight)];
        
        _inputTF.backgroundColor = [UIColor redColor];
        _inputTF.layer.borderWidth = 1;
        _inputTF.layer.borderColor = [UIColor whiteColor].CGColor;
        
        _inputTF.delegate = self;
        _inputTF.leftViewMode = UITextFieldViewModeAlways;
        _inputTF.adjustsFontSizeToFitWidth = YES;
        
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1.5*btnWidth, btnHeight)];
        leftLabel.text = _promptTitle;
        leftLabel.textAlignment = NSTextAlignmentCenter;
        _inputTF.leftView = leftLabel;
        
        _titleLabel = leftLabel;
    }
    return _inputTF;
}

- (UIButton *)currencyBtn {
    if (!_currencyBtn) {
        _currencyBtn = [[UIButton alloc] initWithFrame:CGRectMake(3*btnWidth, 0, btnWidth, btnHeight)];
        
        _currencyBtn.backgroundColor = [UIColor magentaColor];
        [_currencyBtn setTitle:@"USD" forState:UIControlStateNormal];
        [_currencyBtn setTitleColor:[UIColor colorWithRed:0.22f green:0.43f blue:0.65f alpha:1.00f] forState:UIControlStateNormal];
        _currencyBtn.layer.borderWidth = 1;
        _currencyBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        
        [_currencyBtn addTarget:self action:@selector(currencyBtnAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _currencyBtn;
}

- (UIButton *)deletBtn {
    if (!_deletBtn) {
        _deletBtn = [[UIButton alloc] initWithFrame:CGRectMake(3*btnWidth, btnHeight, btnWidth, 2*btnHeight)];
        
        _deletBtn.backgroundColor = [UIColor purpleColor];
        [_deletBtn setTitle:@"Del" forState:UIControlStateNormal];
        _deletBtn.layer.borderWidth = 1;
        _deletBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        
        [_deletBtn addTarget:self action:@selector(deletBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deletBtn;
}

- (UIButton *)okBtn {
    if (!_okBtn) {
        _okBtn = [[UIButton alloc] initWithFrame:CGRectMake(3*btnWidth, 3*btnHeight, btnWidth, 2*btnHeight)];
        
        _okBtn.backgroundColor = [UIColor colorWithRed:0.22f green:0.43f blue:0.65f alpha:1.00f];
        [_okBtn setTitle:@"OK" forState:UIControlStateNormal];
        _okBtn.layer.borderWidth = 1;
        _okBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        
        [_okBtn addTarget:self action:@selector(okBtnAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _okBtn;
}

- (UIView *)mainKeyBoard {
    if (!_mainKeyBoard) {
        _mainKeyBoard = [[UIView alloc] initWithFrame:CGRectMake(0, btnHeight, 3*btnWidth, 4*btnHeight)];
        
        _mainKeyBoard.backgroundColor = [UIColor blueColor];
        
        int count = 0;
        for (NSString *title in mainKeyArray) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(count%3*btnWidth, count/3*btnHeight, btnWidth, btnHeight)];
            [btn setTitle:title forState:UIControlStateNormal];
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [UIColor whiteColor].CGColor;
            btn.tag = count+100;
            [btn addTarget:self action:@selector(mainKeyBoardBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [_mainKeyBoard addSubview:btn];
            count++;
        }
    }
    return _mainKeyBoard;
}

- (UIView *)choseCurrencyView {
    if (!_choseCurrencyView) {
        _choseCurrencyView = [[UIView alloc] initWithFrame:CGRectMake(LeftDistanceWide, AppHeight-KeyBoardHeight-2*BottomDistanceHeight-CurrencyHeight, AppWidth-2*LeftDistanceWide, CurrencyHeight)];
        _choseCurrencyView.backgroundColor = [UIColor whiteColor];
        
        int number = 4;
        CGFloat width = (AppWidth-2*LeftDistanceWide) / number;;
        CGFloat height = CurrencyHeight / (choseCurrencyArrya.count%number?choseCurrencyArrya.count/number+1:choseCurrencyArrya.count/number);
        
        int count = 0;
        for (NSString *title in choseCurrencyArrya) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(count%4*width, count/4*height, width, height)];
            [btn setTitle:title forState:UIControlStateNormal];
            btn.backgroundColor = [UIColor redColor];
            
            btn.layer.borderWidth = 1;
            btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
            btn.tag = 200 + count;
            [btn addTarget:self action:@selector(currencyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            
            [_choseCurrencyView addSubview:btn];
            count++;
        }
        
        
        [self addSubview:_choseCurrencyView];
        _choseCurrencyView.hidden = YES;
    }
    return _choseCurrencyView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareData];
        [self uiConfig:frame];
    }
    return self;
}

- (void)prepareData {
    btnWidth = KeyBoardWidth / 4;
    btnHeight = KeyBoardHeight / 5;
    
    mainKeyArray = @[@"1",@"2",@"3",
                     @"4",@"5",@"6",
                     @"7",@"8",@"9",
                     @"0",@".",@"Close"];
    
    choseCurrencyArrya = @[@"TRYL",@"INR",@"JPY",@"CHF",
                           @"CAD",@"HKD",@"RUB",@"BRL",
                           @"USD",@"EUR",@"CNY",@"GBP"];
}

- (void)uiConfig:(CGRect)frame {
    UIView *backView = [[UIView alloc] initWithFrame:frame];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewCloseAction)];
    [backView addGestureRecognizer: tap];
    [self addSubview:backView];
    
    UIView *keyView = [[UIView alloc] initWithFrame:CGRectMake( LeftDistanceWide, frame.size.height-BottomDistanceHeight - KeyBoardHeight, frame.size.width - 2*LeftDistanceWide, KeyBoardHeight)];
    keyView.backgroundColor = [UIColor whiteColor];
    [self addSubview:keyView];
    
    [keyView addSubview:self.inputTF];
    [keyView addSubview:self.currencyBtn];
    [keyView addSubview:self.deletBtn];
    [keyView addSubview:self.okBtn];
    [keyView addSubview:self.mainKeyBoard];
}
- (void)setPromptTitle:(NSString *)promptTitle {
    _promptTitle = promptTitle;
    
    _titleLabel.text = promptTitle;
}
#pragma mark --Method
- (void)currencyBtnAction:(UIButton *)btn {
    NSString *title = choseCurrencyArrya[btn.tag - 200];
    [self.currencyBtn setTitle:title forState:UIControlStateNormal];
    
    self.choseCurrencyView.hidden = YES;
}

- (void)mainKeyBoardBtnAction:(UIButton *)btn {

    if (btn.tag-100 == 11) {
        //关闭键
        [self viewCloseAction];
    } else {
        //数字输入键
        NSLog(@"%@",btn.titleLabel.text);
        
        self.inputTF.text = [NSString stringWithFormat:@"%@%@", self.inputTF.text, btn.titleLabel.text];
    }
}

- (void)okBtnAction {
    NSLog(@"OK");
    
    _callback(self.inputTF.text, self.currencyBtn.titleLabel.text);
    
    [self viewCloseAction];
}

- (void)deletBtnAction {
    NSLog(@"DEL");
    
    if (self.inputTF.text.length > 0) {
        self.inputTF.text = [self.inputTF.text substringToIndex:self.inputTF.text.length-1];
    }
}

- (void)currencyBtnAction {
    NSLog(@"CURRENCy");
    
    self.choseCurrencyView.hidden = !self.choseCurrencyView.hidden;
}

- (void)viewCloseAction {
    self.hidden = YES;
    self.inputTF.text = nil;
    
    self.choseCurrencyView.hidden = YES;
}

#pragma mark --Delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

@end
