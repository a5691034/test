//
//  CutPicViewController.m
//  test
//
//  Created by Apple on 15/10/30.
//  Copyright (c) 2015年 williams. All rights reserved.
//

#import "CutPicViewController.h"
#import "DHSmartScreenshot.h"

@interface CutPicViewController ()
{
    UIScrollView *_scrollView;
}
@end

@implementation CutPicViewController

- (instancetype)initWithArr:(NSArray *)arr
{
    self = [super init];
    if (self) {
        
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"屏幕截图";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self prepareData];
    [self uiConfig];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(cutPicture)];
    
//    [self cutPicture];
}

- (void)prepareData {
    
}

- (void)uiConfig {
//    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
//    _tableView.dataSource = self;
//    _tableView.delegate = self;
//    [self.view addSubview:_tableView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 900);
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    view1.backgroundColor = [UIColor redColor];
    [_scrollView addSubview:view1];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 400, 100, 300)];
    view.backgroundColor = [UIColor redColor];
    [_scrollView addSubview:view];
    
    
    
    
}
#pragma mark --屏幕截图
- (void)cutPicture {
    UIImage *image = [self captureScrollView:_scrollView];
    
    //由于界面
//    self.showImageView.image = image;
//    NSLog(@"capture image.size%@",NSStringFromCGSize(image.size));
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil,nil);
    
    //保存到本地
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/image.png"];
    NSLog(@"path:\n%@",path);
    [UIImagePNGRepresentation(image) writeToFile:path atomically:YES];
}

- (UIImage *)captureScrollView:(UIScrollView *)scrollView{
    UIImage* image = nil;
    UIGraphicsBeginImageContext(scrollView.contentSize);
    {
        CGPoint savedContentOffset = scrollView.contentOffset;
        CGRect savedFrame = scrollView.frame;
        scrollView.contentOffset = CGPointZero;
        scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height);
        [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
        image = UIGraphicsGetImageFromCurrentImageContext();
        scrollView.contentOffset = savedContentOffset;
        scrollView.frame = savedFrame;
    }
    UIGraphicsEndImageContext();
    if (image != nil) {
        return image;
    }
    return nil;
}


@end
