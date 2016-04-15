//
//  TagSelectViewController.m
//  jinrishangji
//
//  Created by Apple on 16/1/11.
//  Copyright © 2016年 williams. All rights reserved.
//

#import "TagSelectViewController.h"
#import "CatalogueView.h"

@interface TagSelectViewController () <CatalogueViewDelegate>
{
    BOOL _isEdit;
    NSMutableArray *_btnArray;
    NSMutableArray *_selectedTagArray;
}
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) CatalogueView *catalogueView;
@end

@implementation TagSelectViewController

- (instancetype)initWithArray:(NSArray *)array
{
    self = [super init];
    if (self) {
        _selectedTagArray = [[NSMutableArray alloc] initWithArray:array];
        _btnArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGRect frame = self.view.bounds;
        frame.size.height -= 64;
        _scrollView = [[UIScrollView alloc] initWithFrame:frame];
//        _scrollView.contentSize = CGSizeMake(AppWidth, AppHeight-63);
    }
    return _scrollView;
}

- (CatalogueView *)catalogueView {
    if (!_catalogueView) {
        CGFloat y = 150+64;
        _catalogueView = [[CatalogueView alloc] initWithFrame:CGRectMake(0, y, AppWidth, AppHeight-y)];
        _catalogueView.delegate = self;
        _catalogueView.selectedArray = _selectedTagArray;
        _catalogueView.isShowSymbol = YES;
        [self.view addSubview:_catalogueView];
        
        __weak __typeof(self) weakSelf = self;
        [_catalogueView setBeginSearch:^{
            [UIView animateWithDuration:0.3f animations:^{
                weakSelf.catalogueView.frame = CGRectMake(0, 64, AppWidth, AppHeight-y);
                
            }];
        }];
        
        [_catalogueView setEndSearch:^{
            [UIView animateWithDuration:0.3f animations:^{
                weakSelf.catalogueView.frame = CGRectMake(0, y, AppWidth, AppHeight-y);
                
            }];
        }];
    }
    return _catalogueView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self viewConfig];//视图控制器配置
    
    [self prepareData];//数据配置
    
    [self uiConfig];//UI控件配置
}

//视图控制器配置
- (void)viewConfig {
    self.navigationItem.title = @"我关注的行业";
    self.view.backgroundColor = UIColorFromRGBA(0xf1f2f3, 1);
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    editBtn.frame = CGRectMake(0, 0, 60, 25);
    editBtn.backgroundColor = [UIColor whiteColor];
    [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [editBtn setTitle:@"确认" forState:UIControlStateSelected];
    [editBtn setTitleColor:UIColorFromRGBA(0xcc3031, 1) forState:UIControlStateNormal];
    editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    editBtn.layer.cornerRadius = 5;
    [editBtn addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
}

//数据配置
- (void)prepareData {
    //获取路径
//    NSString *filePath = [__kLocalFilePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist",IV]];
//    NSLog(@"%@",filePath);
//    
//    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
//    
//    NSLog(@"数据=>%@",dic);
}

//UI控件配置
- (void)uiConfig {
    [self.view addSubview:self.scrollView];
    [self layoutBtns];
}

//布局
- (void)layoutBtns {
    //删除所有按钮
    [self removeAllBtn];
    
    CGFloat leftW = 10;//边距
    CGFloat spaceW = 10;//左右间距
    CGFloat spaceH = 8;//上下间距
    int lineCount = 4;//一行个数
    CGFloat btnW = (AppWidth - leftW*2 - spaceW * (lineCount-1))/4;
    CGFloat btnH = btnW/2;
    
    UIButton *lastBtn;
    for (int i=0; i<_selectedTagArray.count; i++) {
        UIButton *btn = [self createBtn:i];
        [btn setTitle:_selectedTagArray[i][@"title"] forState:UIControlStateNormal];
        //区分编辑状态
        [btn setTitleColor:_isEdit?UIColorFromRGBA(0xcc3031, 1):UIColorFromRGBA(0x333333, 1) forState:UIControlStateNormal];
        
        CGFloat line = i/lineCount;//行数
        CGFloat count = i%lineCount;//一行中的位置
        CGFloat x = leftW + (btnW+spaceW)*count;
        CGFloat y = leftW + (btnH+spaceH)*line;
        btn.frame = CGRectMake(x, y, btnW, btnH);
        [_scrollView addSubview:btn];
//        if (i==11) {
//            
//        }
        
        
        if (_isEdit) {
            if (i>0) {
                
                //添加事件
                [btn addTarget:self action:@selector(everyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                //添加一个叉
                UIImageView *imgv = [btn viewWithTag:333];
                imgv.center = CGPointMake(btnW-5, 5);
                imgv.hidden = NO;
            }
            
            
        } else {
            //移除事件
            [btn removeTarget:self action:@selector(everyBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            //删除叉
            UIImageView *imgv = [btn viewWithTag:333];
            imgv.hidden = YES;
        }
        
        lastBtn = btn;
    }
    
    CGFloat maxH = CGRectGetMaxY(lastBtn.frame)+leftW;
//    if (maxH>AppHeight-63) {
        _scrollView.contentSize = CGSizeMake(AppWidth, maxH);
//    } else {
//        _scrollView.contentSize = CGSizeMake(AppWidth, AppHeight-63);
//    }
}

//获取一个空的按钮  懒加载
- (UIButton *)createBtn:(NSInteger)index {
    if (index<_btnArray.count) {
        
    } else {
        UIButton *btn = [[UIButton alloc] init];
        btn.layer.cornerRadius = 5;//圆角
        [btn setBackgroundColor:[UIColor whiteColor]];
        [btn setTitleColor:UIColorFromRGBA(0x333333, 1) forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
//        btn.layer.borderColor = UIColorFromRGBA(0xc8c9ca, 1).CGColor;
//        btn.layer.borderWidth = 1;
        btn.tag = index+100;
        
        //添加红叉
        UIImage *img = [UIImage imageNamed:@"btn_delete_image"];
        UIImageView *imgv = [[UIImageView alloc] initWithImage:img];
        imgv.layer.cornerRadius = 10;
        imgv.tag = 333;
        [btn addSubview:imgv];
        
        //将按钮存入数组
        [_btnArray addObject:btn];
    }
    
    return _btnArray[index];
}

//删除所有按钮
- (void)removeAllBtn {
    for (int i=0; i<_btnArray.count; i++) {
        UIButton *btn = [self createBtn:i];
        [btn removeFromSuperview];
    }
}

//删除一个按钮
- (void)removeBtn:(NSInteger)index {
    UIButton *btn = [self createBtn:index];
    [btn removeFromSuperview];
    
    [_selectedTagArray removeObjectAtIndex:index];
    [self layoutBtns];
    
    //触发行业分类里面的删除
    [_catalogueView removeItemAtIndex:index];
}

#pragma mark - Private Method
//按钮点击删除事件
- (void)everyBtnAction:(UIButton *)btn {
    NSInteger index = btn.tag - 100;//按钮序号
    
    [self removeBtn:index];
    
}

//编辑按钮点击事件
- (void)editBtnAction:(UIButton*)btn {
    btn.selected = !btn.selected;
    _isEdit = btn.selected;
    [self layoutBtns];
    
    CGRect frame = self.view.bounds;
    
    if (!btn.selected) {
        //结束编辑
        [ProgressHUD showSuccess:@"修改成功"];
        
        NSMutableString *itemsType = [[NSMutableString alloc] init];
        for (NSDictionary *dic in _selectedTagArray) {
            [itemsType appendFormat:@"%@,",dic[@"code"]];
        }
        NSString *itemsTypeString=[itemsType substringToIndex:[itemsType length]-1];
        NSLog(@"itemsTypeitemsType=>%@",itemsTypeString);
        NSLog(@"%@",_selectedTagArray);
        
        self.catalogueView.hidden = YES;
        [self.view endEditing:YES];//关闭所有键盘

        _callback(_selectedTagArray);
        
//        [[LoginUser user] editUserItemType:itemsTypeString competion:^(BOOL success, NSString *msg) {
//            self.catalogueView.hidden = YES;
//            [self.view endEditing:YES];//关闭所有键盘
//            if (success) {
//                _callback(_selectedTagArray);
//                
//            } else {
//                [ProgressHUD showError:msg];
//            }
//        }];
        
        
//        frame.size.height -= 64;
    } else {
        //开始编辑
        self.catalogueView.hidden = NO;
        
        frame.size.height = CGRectGetMinY(self.catalogueView.frame);
    }
    self.scrollView.frame = frame;
}

#pragma mark - CatalogueDelegate
-(void)editArray:(NSMutableArray *)array result:(void(^)(NSMutableArray *))callback; {
    //点击事件 结果数组传出
    if (array) {
        _selectedTagArray = array;
    }
    
    //已选tag数据传入
    if (callback) {
        callback(_selectedTagArray);
    }
    
    [self layoutBtns];
}
- (void)didSelectedIndex:(NSIndexPath *)indexPath title:(NSString *)title code:(NSString *)code; {
    NSLog(@"%@_%@",title, code);
}

@end
