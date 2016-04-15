//
//  CustomCameraViewController.m
//  test
//
//  Created by Apple on 15/11/20.
//  Copyright (c) 2015年 williams. All rights reserved.
//

#import "CustomCameraViewController.h"
#import "LLSimpleCamera.h"

#define AppWidth ([UIScreen mainScreen].bounds.size.width)
#define AppHeight ([UIScreen mainScreen].bounds.size.height)

@interface CustomCameraViewController ()
{
    NSInteger _pictureNumber;
}

@property (strong, nonatomic) LLSimpleCamera *camera;
@property (nonatomic, strong) UIButton *takePhotoBtn;
@property (nonatomic, strong) UIButton *leaveBtn;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) UILabel *pictureNumberLabel;

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UILabel *measurementLabel;
@end
@implementation CustomCameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createCamera];
}

- (void)createCamera {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    self.camera = [[LLSimpleCamera alloc] initWithQuality:AVCaptureSessionPresetHigh
                                                 position:CameraPositionBack
                                             videoEnabled:YES];
    
    // attach to a view controller
    [self.camera attachToViewController:self withFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height)];
    
    // read: http://stackoverflow.com/questions/5427656/ios-uiimagepickercontroller-result-image-orientation-after-upload
    // you probably will want to set this to YES, if you are going view the image outside iOS.
    self.camera.fixOrientationAfterCapture = NO;
    
    // take the required actions on a device change
//    __weak typeof(self) weakSelf = self;
//    [self.camera setOnDeviceChange:^(LLSimpleCamera *camera, AVCaptureDevice * device) {
//        
//        NSLog(@"Device changed.");
//        
//        // device changed, check if flash is available
//        if([camera isFlashAvailable]) {
//            weakSelf.flashButton.hidden = NO;
//            
//            if(camera.flash == CameraFlashOff) {
//                weakSelf.flashButton.selected = NO;
//            }
//            else {
//                weakSelf.flashButton.selected = YES;
//            }
//        }
//        else {
//            weakSelf.flashButton.hidden = YES;
//        }
//    }];
    
//    [self.camera setOnError:^(LLSimpleCamera *camera, NSError *error) {
//        NSLog(@"Camera error: %@", error);
//        
//        if([error.domain isEqualToString:LLSimpleCameraErrorDomain]) {
//            if(error.code == LLSimpleCameraErrorCodeCameraPermission ||
//               error.code == LLSimpleCameraErrorCodeMicrophonePermission) {
//                
//                if(weakSelf.errorLabel) {
//                    [weakSelf.errorLabel removeFromSuperview];
//                }
//                
//                UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
//                label.text = @"We need permission for the camera.\nPlease go to your settings.";
//                label.numberOfLines = 2;
//                label.lineBreakMode = NSLineBreakByWordWrapping;
//                label.backgroundColor = [UIColor clearColor];
//                label.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:13.0f];
//                label.textColor = [UIColor whiteColor];
//                label.textAlignment = NSTextAlignmentCenter;
//                [label sizeToFit];
//                label.center = CGPointMake(screenRect.size.width / 2.0f, screenRect.size.height / 2.0f);
//                weakSelf.errorLabel = label;
//                [weakSelf.view addSubview:weakSelf.errorLabel];
//            }
//        }
//    }];
    
    self.takePhotoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    [self.takePhotoBtn setTitle:@"拍照" forState:UIControlStateNormal];
    self.takePhotoBtn.layer.borderWidth = 1;
    [self.takePhotoBtn addTarget:self action:@selector(takePhotoBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.takePhotoBtn];
    
    self.leaveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 88, 44)];
    [self.leaveBtn setTitle:@"退出" forState:UIControlStateNormal];
    self.leaveBtn.layer.borderWidth = 1;
    [self.leaveBtn addTarget:self action:@selector(takeOutAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.leaveBtn];
    
    self.nextBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 88, 44)];
    [self.nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    self.nextBtn.layer.borderWidth = 1;
    [self.nextBtn addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.nextBtn];
    
    self.pictureNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    self.pictureNumberLabel.center = CGPointMake(self.nextBtn.frame.size.width, 0);
    self.pictureNumberLabel.backgroundColor = [UIColor redColor];
    self.pictureNumberLabel.textColor = [UIColor whiteColor];
    self.pictureNumberLabel.hidden = YES;
    self.pictureNumberLabel.layer.cornerRadius = 10;
    self.pictureNumberLabel.clipsToBounds = YES;
    self.pictureNumberLabel.textAlignment = NSTextAlignmentCenter;
    [self.nextBtn addSubview:self.pictureNumberLabel];
    
    self.boxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 355)];
    self.boxView.layer.borderWidth = 1;
    self.boxView.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:self.boxView];
    
    self.measurementLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
    self.measurementLabel.text = @"320*355";
    self.measurementLabel.textAlignment = NSTextAlignmentRight;
    self.measurementLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.measurementLabel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // start the camera
    [self.camera start];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    // stop the camera
    [self.camera stop];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.camera.view.frame = self.view.bounds;
    
    self.takePhotoBtn.center = CGPointMake(AppWidth/2, AppHeight - 60);
    self.leaveBtn.center = CGPointMake(44, 44);
    self.nextBtn.center = CGPointMake(AppWidth - 60, AppHeight - 44);
    self.boxView.center = CGPointMake(self.view.center.x, self.view.center.y-20);
    self.measurementLabel.center = CGPointMake(self.view.center.x, 450);
}

- (void)takePhotoBtnAction {
    NSLog(@"拍照了~~");
    
    [self.camera capture:^(LLSimpleCamera *camera, UIImage *image, NSDictionary *metadata, NSError *error) {
        if(!error) {
            
            // we should stop the camera, since we don't need it anymore. We will open a new vc.
            // this very important, otherwise you may experience memory crashes
            [camera start];
            
            _pictureNumber ++;
            
            self.pictureNumberLabel.hidden = NO;
            self.pictureNumberLabel.text = [NSString stringWithFormat:@"%d",_pictureNumber];
            self.pictureNumberLabel.bounds = CGRectMake(0, 0, 10+10*self.pictureNumberLabel.text.length, 20);
            
            // show the image
//            ImageViewController *imageVC = [[ImageViewController alloc] initWithImage:image];
//            [self presentViewController:imageVC animated:NO completion:nil];
            
        }
        else {
            NSLog(@"An error has occured: %@", error);
        }
    } exactSeenImage:YES];
    
}

- (void)takeOutAction {
    NSLog(@"退出");
    
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)nextBtnAction {
    NSLog(@"下一步");
}

- (void)dealloc {
    self.camera = nil;
}

@end
