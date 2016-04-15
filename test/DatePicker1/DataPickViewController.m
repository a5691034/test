//
//  DataPickViewController.m
//  test
//
//  Created by Apple on 15/10/12.
//  Copyright (c) 2015年 williams. All rights reserved.
//

#import "DataPickViewController.h"


@interface DataPickViewController () <THDatePickerDelegate>

@property (nonatomic, strong) UIButton *dateButton;
@property (nonatomic, strong) THDatePickerViewController *datePicker;

@property (nonatomic, retain) NSDate *curDate;
@property (nonatomic, retain) NSDateFormatter *formatter;
@end

@implementation DataPickViewController
- (UIButton *)dateButton {
     if (!_dateButton) {
          _dateButton = [UIButton buttonWithType:UIButtonTypeCustom];
          _dateButton.backgroundColor = [UIColor redColor];
          
          [_dateButton addTarget:self action:@selector(touchedBtn:) forControlEvents:UIControlEventTouchUpInside];
     }
     return _dateButton;
}

- (void)viewDidLoad {
     [super viewDidLoad];
     
     [self.view addSubview:self.dateButton];
     self.dateButton.frame = CGRectMake((self.view.frame.size.width - 200)/2, 100, 200, 100);
     
     self.curDate = [NSDate date];
     self.formatter = [[NSDateFormatter alloc] init];
     [_formatter setDateFormat:@"yyyy/MM/dd"];
     [self refreshTitle];
}

-(void)refreshTitle{
     if(self.curDate) {
          [self.dateButton setTitle:[_formatter stringFromDate:_curDate] forState:UIControlStateNormal];
     }
     else {
          [self.dateButton setTitle:@"No date selected" forState:UIControlStateNormal];
     }
}

- (void)touchedBtn:(UIButton *)btn {
     if(!self.datePicker)
          self.datePicker = [THDatePickerViewController datePicker];
     self.datePicker.date = self.curDate;
     self.datePicker.delegate = self;
     [self.datePicker setAllowClearDate:NO];
     [self.datePicker setAutoCloseOnSelectDate:YES];
     [self.datePicker setSelectedBackgroundColor:[UIColor colorWithRed:125/255.0 green:208/255.0 blue:0/255.0 alpha:1.0]];
     [self.datePicker setCurrentDateColor:[UIColor colorWithRed:242/255.0 green:121/255.0 blue:53/255.0 alpha:1.0]];
     
     
     [self.datePicker setDateHasItemsCallback:^BOOL(NSDate *date) {
          int tmp = (arc4random() % 30)+1;
          if(tmp % 5 == 0)
               return YES;
          return NO;
     }];
     //[self.datePicker slideUpInView:self.view withModalColor:[UIColor lightGrayColor]];
     
     //    [self presentSemiViewController:self.datePicker withOptions:@{
     //                                                                  KNSemiModalOptionKeys.pushParentBack    : @(NO),
     //                                                                  KNSemiModalOptionKeys.animationDuration : @(1.0),
     //                                                                  KNSemiModalOptionKeys.shadowOpacity     : @(0.3),
     //                                                                  }];
     
     self.datePicker.view.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
     self.datePicker.modalPresentationStyle = UIModalPresentationOverFullScreen;
     [self presentViewController:self.datePicker animated:NO completion:^{
          self.datePicker.view.superview.backgroundColor = [UIColor clearColor];
     }];
     
}

-(void)datePickerDonePressed:(THDatePickerViewController *)datePicker{
     self.curDate = datePicker.date;
     [self refreshTitle];
     //[self.datePicker slideDownAndOut];
     //    [self dismissSemiModalView];
     [self dismissViewControllerAnimated:NO completion:nil];
}

-(void)datePickerCancelPressed:(THDatePickerViewController *)datePicker{
     //[self.datePicker slideDownAndOut];
     //    [self dismissSemiModalView];
     [self dismissViewControllerAnimated:NO completion:nil];
}

@end
