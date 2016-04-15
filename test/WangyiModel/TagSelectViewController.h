//
//  TagSelectViewController.h
//  jinrishangji
//
//  Created by Apple on 16/1/11.
//  Copyright © 2016年 williams. All rights reserved.
//

#import "ViewController.h"

@interface TagSelectViewController : ViewController

//@property (nonatomic, strong) NSMutableArray *originalArray;
@property (nonatomic, copy) void(^callback)(NSMutableArray *array);

- (instancetype)initWithArray:(NSArray *)array;

@end
