//
//  CameraViewController.m
//  test
//
//  Created by Apple on 15/9/30.
//  Copyright (c) 2015年 williams. All rights reserved.
//

#import "CameraViewController.h"
#import "CustomCameraViewController.h"

@interface CameraViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, strong) UIImageView *myImageView;
@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor redColor];
    
    [self uiConfig];
}

- (void)uiConfig {
    //
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(takePictureAction)];
    
    
    //相机获取图像显示
    _myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    [self.view addSubview:_myImageView];
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    self.myImageView.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)takePictureAction {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:@"相机实例,nil时不显示"
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:@"确定"
                                  otherButtonTitles:@"系统相机", @"自定义相机",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        //确定
        NSLog(@"000");
    }else if (buttonIndex == 1) {
        //系统相机
        NSLog(@"系统相机");
        
        
        self.picker = [[UIImagePickerController alloc] init];
        //设置输入类型为照相机
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //设置代理
        self.picker.delegate = self;
        
        _myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
        [self.view addSubview:_myImageView];
        
        
        
        [self presentViewController:self.picker animated:YES completion:nil];
    }else if(buttonIndex == 2) {
        //自定义相机
        NSLog(@"自定义相机");
        
        
        [self presentViewController:[CustomCameraViewController new] animated:YES completion:^{
            
        }];
        
    }else if(buttonIndex == 3) {
        //取消
        NSLog(@"33");
    }
    
}

@end
