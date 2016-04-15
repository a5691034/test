//
//  MoreLineViewController.m
//  test
//
//  Created by Apple on 15/10/15.
//  Copyright (c) 2015年 williams. All rights reserved.
//

#import "MoreLineViewController.h"
#import "model.h"

@interface MoreLineViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
}
@end

@implementation MoreLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareData];
    [self uiConfig];
    
}

- (void)prepareData {
    NSArray *stringsToSort=[NSArray arrayWithObjects:
                            @"￥hhh, .$",@" ￥Chin ese ",@"开源中国 ",@"www.oschina.net",
                            @"开源技术",@"社区",@"开发者",@"传播",
                            @"2014",@"a1",@"100",@"中国",@"暑假作业",
                            @"键盘", @"鼠标",@"hello",@"world",@"b1",
                            nil];
    
    _dataArray = [[NSMutableArray alloc] init];
    
    for (NSString *name in stringsToSort) {
        model *m = [[model alloc] init];
        m.name = name;
        m.phone = [NSString stringWithFormat:@"%d", arc4random()%999999+100000];
        
        [_dataArray addObject:m];
    }
    
    _dataArray = [self sortWithArray:_dataArray];
    
    [self test];
}

- (void)uiConfig {
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellid = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellid];
    }
    cell.textLabel.text = [_dataArray[indexPath.row] name];
    cell.detailTextLabel.text = [_dataArray[indexPath.row] phone];
    return cell;
}

- (NSMutableArray *)sortWithArray:(NSArray *)arr {
    
    NSArray *sortedArray = [arr sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        //这里的代码可以参照上面compare:默认的排序方法，也可以把自定义的方法写在这里，给对象排序
        model *m1 = (model*)obj1;
        model *m2 = (model*)obj2;
        
        obj1 = [self chineseToEnglish:m1.name];
        obj2 = [self chineseToEnglish:m2.name];
//        NSLog(@"%@,%@", obj1, obj2);
        
        NSComparisonResult result = [obj1 compare:obj2];
        return result;
    }];
    NSLog(@"排序后:%@",sortedArray);
    return sortedArray;
}

- (void)test{
    NSString *hanziText = @"中国人";
    if ([hanziText length]) {
        NSMutableString *ms = [[NSMutableString alloc] initWithString:hanziText];
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
            NSLog(@"pinyin: %@", ms);
        }
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
            NSLog(@"pinyin: %@", ms);
        }
    }
}

- (NSString*)chineseToEnglish:(NSString *)chinese {
    if ([chinese length]) {
        NSMutableString *ms = [[NSMutableString alloc] initWithString:chinese];
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
            NSLog(@"pinyin: %@", ms);
        }
        if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
            NSLog(@"pinyin: %@", ms);
        }
        return ms;
    }
    return @"Error";
}

@end
