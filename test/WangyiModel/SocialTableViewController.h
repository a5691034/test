//
//  SocialTableViewController.h
//  jinrishangji
//
//  Created by Apple on 16/4/13.
//  Copyright © 2016年 williams. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SocialTableViewController : UITableViewController

@property (nonatomic, strong) NSString *currentItemType;//当前行业ID, 全部为@"ALL"/
@property (nonatomic, strong) NSString *currentFtype;//当前获取数据类型/求购/出售/全部

@end
