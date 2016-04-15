//
//  DatePickerSecondViewController.m
//  test
//
//  Created by Apple on 16/4/15.
//  Copyright © 2016年 williams. All rights reserved.
//

#import "DatePickerSecondViewController.h"
#import "FyCalendarView.h"

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

@interface DatePickerSecondViewController ()
@property (strong, nonatomic) FyCalendarView *calendarView;
@property (nonatomic, strong) NSDate *date;
@end

@implementation DatePickerSecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.date = [NSDate date];
    [self setupCalendarView];
}

- (void)setupCalendarView {
    self.calendarView = [[FyCalendarView alloc] initWithFrame:CGRectMake(10, 64, self.view.frame.size.width - 20, self.view.frame.size.width - 20)];
    //日期状态
    //    self.calendarView.allDaysArr = [NSArray arrayWithObjects: @"5", @"8", @"9", @"17",  @"30", nil];
    //    self.calendarView.partDaysArr = [NSArray arrayWithObjects:@"1", @"2", @"26", @"12",@"15", @"19",nil];
    [self.view addSubview:self.calendarView];
    //    self.calendarView.isShowOnlyMonthDays = NO;
    self.calendarView.date = [NSDate date];
    self.calendarView.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year){
        NSLog(@"%li-%li-%li", (long)year,(long)month,(long)day);
    };
    WS(weakSelf)
    self.calendarView.nextMonthBlock = ^(){
        [weakSelf setupNextMonth];
    };
    self.calendarView.lastMonthBlock = ^(){
        [weakSelf setupLastMonth];
    };
}

- (void)setupNextMonth {
    [self.calendarView removeFromSuperview];
    self.calendarView = [[FyCalendarView alloc] initWithFrame:CGRectMake(10, 64, self.view.frame.size.width - 20, self.view.frame.size.width - 20)];
    [self.view addSubview:self.calendarView];
    //    self.calendarView.allDaysArr = [NSArray arrayWithObjects:  @"17",  @"21", @"25",  @"30", nil];
    //    self.calendarView.partDaysArr = [NSArray arrayWithObjects:@"1", @"2", @"26", @"19",nil];
    self.date = [self.calendarView nextMonth:self.date];
    [self.calendarView createCalendarViewWith:self.date];
    self.calendarView.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year){
        NSLog(@"%li-%li-%li", (long)year,(long)month,(long)day);
    };
    WS(weakSelf)
    self.calendarView.nextMonthBlock = ^(){
        [weakSelf setupNextMonth];
    };
    self.calendarView.lastMonthBlock = ^(){
        [weakSelf setupLastMonth];
    };
}

- (void)setupLastMonth {
    [self.calendarView removeFromSuperview];
    self.calendarView = [[FyCalendarView alloc] initWithFrame:CGRectMake(10, 64, self.view.frame.size.width - 20, self.view.frame.size.width - 20)];
    [self.view addSubview:self.calendarView];
    //    self.calendarView.allDaysArr = [NSArray arrayWithObjects: @"5", @"6", @"8", @"9", @"11", @"16", @"17", @"21", @"25",  @"30", nil];
    //    self.calendarView.partDaysArr = [NSArray arrayWithObjects:@"1", @"2", @"26", @"29", @"12",@"15", @"18", @"19",nil];
    self.date = [self.calendarView lastMonth:self.date];
    [self.calendarView createCalendarViewWith:self.date];
    self.calendarView.calendarBlock =  ^(NSInteger day, NSInteger month, NSInteger year){
        NSLog(@"%li-%li-%li", (long)year,(long)month,(long)day);
    };
    WS(weakSelf)
    self.calendarView.lastMonthBlock = ^(){
        [weakSelf setupLastMonth];
    };
    self.calendarView.nextMonthBlock = ^(){
        [weakSelf setupNextMonth];
    };
}

@end
