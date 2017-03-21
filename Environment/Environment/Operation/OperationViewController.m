//
//  OperationViewController.m
//  Environment
//
//  Created by 奥莉 on 2017/3/13.
//  Copyright © 2017年 远方科技. All rights reserved.
//

#import "OperationViewController.h"

@interface OperationViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *hjImageView;//环境风机警报
@property (weak, nonatomic) IBOutlet UIImageView *sfImageView;//SF6风机警报
@property (weak, nonatomic) IBOutlet UIImageView *csImageView;//除湿警报
@property (weak, nonatomic) IBOutlet UIImageView *csbImageView;//抽水泵警报
@property (weak, nonatomic) IBOutlet UIImageView *bfImageView;//布防状态

@property (weak, nonatomic) IBOutlet UIButton *setButton;
@property (weak, nonatomic) IBOutlet UIButton *hjStartButton;
@property (weak, nonatomic) IBOutlet UIButton *hjEndButton;
@property (weak, nonatomic) IBOutlet UIButton *sfStartButton;
@property (weak, nonatomic) IBOutlet UIButton *sfEndButton;
@property (weak, nonatomic) IBOutlet UIButton *csStartButton;
@property (weak, nonatomic) IBOutlet UIButton *csEndButton;
@property (weak, nonatomic) IBOutlet UIButton *csbStartButton;
@property (weak, nonatomic) IBOutlet UIButton *csbEndButton;
@property (weak, nonatomic) IBOutlet UIButton *bfStartButton;
@property (weak, nonatomic) IBOutlet UIButton *bfEndButton;


@property (nonatomic,strong) NSString *setValue;//记录手动自动的数值

@property (nonatomic,strong) NSArray *zArray;//状态数组
@property (nonatomic,strong) NSArray *wArray;//写入数组


@end

@implementation OperationViewController

#pragma mark - 刷新
-(void)viewWillAppear:(BOOL)animated{
    //刷新数据
    [self getValues];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"手动自动";
    self.view.backgroundColor = [UIColor whiteColor];
    
    //初始化数组
    self.zArray = [NSArray array];
    self.wArray = [NSArray array];
    [self.setButton setTitle:@"手   动" forState:UIControlStateNormal];
    [self.setButton setTitle:@"自   动" forState:UIControlStateSelected];
    
    //请求数据
    [self getValues];
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - 写入数据
-(void)writeValues{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    NSString *urlStr = [NSString stringWithFormat:@"%@?SID=%@&OP=W",GETVALUES_url,[UserInfoManager getUserID]];
//    NSLog(@"urlstr  is %@",urlStr);
    NSString *str = [NSString stringWithFormat:@"%@\r\n%@\r\n%@\r\n",@"1",@"手自切换",self.setValue];
//    NSLog(@"str is %@",str);
    
    // 进度条
    [SVProgressHUD showWithStatus:@"正在获取数据..."];
    [NetWorkRequestManager requestWithType:POST urlString:urlStr dic:nil str:str successful:^(NSData *data) {
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //保存到数组
        self.wArray = [result componentsSeparatedByString:@"\r\n"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.wArray[0] isEqual:@"OK"]) {
                [SVProgressHUD showSuccessWithStatus:@"获取成功"];
                //请求数据
                [self getValues];
                // 延迟1秒后消失
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
                
            }else{
                NSString *error = self.zArray[2];
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:error preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    //返回重新登录
                    dispatch_after(0.2, dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
                }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
        });
        
    } errorMessage:^(NSError *error) {
        NSLog(@"error is %@",error);
    }];
}

#pragma mark - 获取接口数据
-(void)getValues{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    NSString *urlStr = [NSString stringWithFormat:@"%@?SID=%@&OP=R",GETVALUES_url,[UserInfoManager getUserID]];
//    NSLog(@"urlstr  is %@",urlStr);
    NSString *str = [NSString stringWithFormat:@"%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n",@"6",@"手自切换",@"风机状态",@"SF6风机状态",@"除湿状态",@"水泵状态",@"布防状态"];
//    NSLog(@"str is %@",str);
    
    // 进度条
    [SVProgressHUD showWithStatus:@"正在获取数据..."];
    [NetWorkRequestManager requestWithType:POST urlString:urlStr dic:nil str:str successful:^(NSData *data) {
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //保存到数组
        self.zArray = [result componentsSeparatedByString:@"\r\n"];
        NSLog(@"%ld,%@",self.zArray.count,self.zArray);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.zArray[0] isEqual:@"OK"]) {
                [SVProgressHUD showSuccessWithStatus:@"获取成功"];
                [self getData:self.zArray[2]];
                // 延迟1秒后消失
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
                
            }else{
                NSString *error = self.zArray[2];
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:error preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    //返回重新登录
                    dispatch_after(0.2, dispatch_get_main_queue(), ^{
                        [self dismissViewControllerAnimated:YES completion:nil];
                    });
                }];
                [alert addAction:ok];
                [self presentViewController:alert animated:YES completion:nil];
            }
            
        });
        
    } errorMessage:^(NSError *error) {
        NSLog(@"error is %@",error);
    }];
}

#pragma mark - 显示状态
-(void)getData:(NSString *)isTrue{
    
    //设置图片的状态
    if ([self.zArray[3] isEqual:@"0"]) {
        self.hjImageView.image = [UIImage imageNamed:@"红圈"];
    }else{
        self.hjImageView.image = [UIImage imageNamed:@"绿圈"];
    }
    if ([self.zArray[4] isEqual:@"0"]) {
        self.sfImageView.image = [UIImage imageNamed:@"红圈"];
    }else{
        self.sfImageView.image = [UIImage imageNamed:@"绿圈"];
    }
    if ([self.zArray[5] isEqual:@"0"]) {
        self.csImageView.image = [UIImage imageNamed:@"红圈"];
    }else{
        self.csImageView.image = [UIImage imageNamed:@"绿圈"];
    }
    if ([self.zArray[6] isEqual:@"0"]) {
        self.csbImageView.image = [UIImage imageNamed:@"红圈"];
    }else{
        self.csbImageView.image = [UIImage imageNamed:@"绿圈"];
    }
    if ([self.zArray[7] isEqual:@"0"]) {
        self.bfImageView.image = [UIImage imageNamed:@"红圈"];
    }else{
        self.bfImageView.image = [UIImage imageNamed:@"绿圈"];
    }
    
    if ([self.zArray[8] isEqual:@"0"]) {
        self.bfImageView.image = [UIImage imageNamed:@"绿圈"];
        self.bfStartButton.enabled = YES;
    }else{
        self.bfImageView.image = [UIImage imageNamed:@"红圈"];
        self.bfEndButton.enabled = NO;
    }
    
    //判断按钮状态
    if ([isTrue isEqual:@"0"]) {
        //自动状态下
        self.setButton.selected = NO;
        //设置按钮的状态
        self.hjEndButton.enabled = NO;
        self.hjStartButton.enabled = NO;
        self.sfEndButton.enabled = NO;
        self.sfStartButton.enabled = NO;
        self.csEndButton.enabled = NO;
        self.csStartButton.enabled = NO;
        self.csbEndButton.enabled = NO;
        self.csbStartButton.enabled = NO;
        
    }else{
        //手动状态
        self.setButton.selected = YES;
        //判断环境风机的状态
        if ([self.zArray[3] isEqual:@"0"]) {
            //停止状态
            self.hjEndButton.enabled = NO;
            self.hjStartButton.enabled = YES;
        }else{
            //启动状态
            self.hjEndButton.enabled = YES;
            self.hjStartButton.enabled = NO;
        }
        //判断SF6风机的状态
        if ([self.zArray[4] isEqual:@"0"]) {
            //停止状态
            self.sfEndButton.enabled = NO;
            self.sfStartButton.enabled = YES;
        }else{
            //启动状态
            self.sfEndButton.enabled = YES;
            self.sfStartButton.enabled = NO;
        }
        //判断除湿机的状态
        if ([self.zArray[5] isEqual:@"0"]) {
            //停止状态
            self.csEndButton.enabled = NO;
            self.csStartButton.enabled = YES;
        }else{
            //启动状态
            self.csEndButton.enabled = YES;
            self.csStartButton.enabled = NO;
        }
        //判断抽水泵的状态
        if ([self.zArray[6] isEqual:@"0"]) {
            //停止状态
            self.csbEndButton.enabled = NO;
            self.csbStartButton.enabled = YES;
        }else{
            //启动状态
            self.csbEndButton.enabled = YES;
            self.csbStartButton.enabled = NO;
        }
    }
}


#pragma mark - 手动自动按钮
- (IBAction)setButton:(UIButton *)sender {
    if (sender.selected) {
        self.setValue = @"0";
    }else{
        self.setValue = @"1";
    }
    //写入数据
    [self writeValues];
}



#pragma mark - 环境风机启动和停止
- (IBAction)hjStart:(id)sender {
}
- (IBAction)hjEnd:(id)sender {
}

#pragma mark - SF6风机启动和停止
- (IBAction)sfStart:(id)sender {
}
- (IBAction)sfEnd:(id)sender {
}

#pragma mark - 除湿机启动和停止
- (IBAction)csStart:(id)sender {
}
- (IBAction)csEnd:(id)sender {
}

#pragma mark - 抽水泵启动和停止
- (IBAction)csbStart:(id)sender {
}
- (IBAction)csbEnd:(id)sender {
}


#pragma mark - 布防启动和停止
- (IBAction)bfStart:(id)sender {
}
- (IBAction)bfEnd:(id)sender {
}










@end
