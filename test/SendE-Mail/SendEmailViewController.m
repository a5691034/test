//
//  SendEmailViewController.m
//  test
//
//  Created by Apple on 15/11/24.
//  Copyright (c) 2015年 williams. All rights reserved.
//

#import "SendEmailViewController.h"
#import <MessageUI/MessageUI.h>

@interface SendEmailViewController () <MFMailComposeViewControllerDelegate>

@end

@implementation SendEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(showViewEnd)];
}

- (void)showViewEnd {
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass != nil)
    {
        if ([mailClass canSendMail])
        {
            [self displayComposerSheet];
        }
        else
        {
//            [self launchMailAppOnDevice];
            [self alertWithmsg:@"您的系统邮箱未登录,是否去登录"];
            
        }
    }
    else
    {
        [self alertWithmsg:@"111"];
    }
    

}

-(void)displayComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    //设置主题
    [picker setSubject:@"博客园-FlyElephant"];
    
    //设置收件人
    NSArray *toRecipients = [NSArray arrayWithObjects:@"FlyElephant@163.com",
                             nil];
    NSArray *ccRecipients = [NSArray arrayWithObjects:@"10000@qq.com",
                             @"10000@sina.com", nil];
    NSArray *bccRecipients = [NSArray arrayWithObjects:@"keso@sina.com",
                              nil];
    
    [picker setToRecipients:toRecipients];
    [picker setCcRecipients:ccRecipients];
    [picker setBccRecipients:bccRecipients];
    
    //设置附件为图片
    NSString *path = [[NSBundle mainBundle] pathForResource:@"man"
                                                     ofType:@"jpg"];
    NSData *myData = [NSData dataWithContentsOfFile:path];
    [picker addAttachmentData:myData mimeType:@"image/png"
                     fileName:@"man"];
    
    // 设置邮件发送内容
    NSString *emailBody = @"IOS中的个人博客地址:http://www.cnblogs.com/xiaofeixiang";
    [picker setMessageBody:emailBody isHTML:NO];
    
    //邮件发送的模态窗口
    [self presentModalViewController:picker animated:YES];
}


//　邮件发送完成调用的方法:
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled: //取消
            NSLog(@"MFMailComposeResultCancelled-取消");
            break;
        case MFMailComposeResultSaved: // 保存
            NSLog(@"MFMailComposeResultSaved-保存邮件");
            break;
        case MFMailComposeResultSent: // 发送
            NSLog(@"MFMailComposeResultSent-发送邮件");
            break;
        case MFMailComposeResultFailed: // 尝试保存或发送邮件失败
            NSLog(@"MFMailComposeResultFailed: %@...",[error localizedDescription]);
            break;
    }
    
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) alertWithmsg: (NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:@"取消", nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex; {
    if (buttonIndex==0) {
        //确定
        [[UIApplication sharedApplication]openURL:[NSURL   URLWithString:@"mailto://"]];
    } else {
        //取消
    }
}
@end
