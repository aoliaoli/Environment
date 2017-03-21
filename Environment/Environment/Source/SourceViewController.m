//
//  SourceViewController.m
//  Environment
//
//  Created by 奥莉 on 2017/3/13.
//  Copyright © 2017年 远方科技. All rights reserved.
//

#import "SourceViewController.h"

@interface SourceViewController ()
@property (weak, nonatomic) IBOutlet UIButton *powerStartButton;
@property (weak, nonatomic) IBOutlet UIButton *powerStopButton;
@property (weak, nonatomic) IBOutlet UIImageView *powerImage;

@property (weak, nonatomic) IBOutlet UITextField *dateTf;
@property (weak, nonatomic) IBOutlet UITextField *starHTf;
@property (weak, nonatomic) IBOutlet UITextField *starMTf;
@property (weak, nonatomic) IBOutlet UITextField *stopHTf;
@property (weak, nonatomic) IBOutlet UITextField *stopMTf;
@property (weak, nonatomic) IBOutlet UITextField *chargingTimeTf;
@property (weak, nonatomic) IBOutlet UITextField *voltageTf;
@property (weak, nonatomic) IBOutlet UITextField *startvoltageTf;
@property (weak, nonatomic) IBOutlet UITextField *voltageLowerTf;

@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,strong) NSArray *dArray;
@property (nonatomic,strong) NSArray *pArray;


@end

@implementation SourceViewController

#pragma mark - 刷新
-(void)viewWillAppear:(BOOL)animated{
    //刷新数据
    [self resquest];
}



#pragma mark - 获取接口数据
-(void)resquest{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    NSString *urlStr = [NSString stringWithFormat:@"%@?SID=%@&OP=R",GETVALUES_url,[UserInfoManager getUserID]];
    //    NSLog(@"urlstr  is %@",urlStr);
    NSString *str = [NSString stringWithFormat:@"%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n",@"12",@"手动充电启动",@"手动充电停止",@"充电指示",@"充电日期",@"充电启动时",@"充电启动分",@"充电停止时",@"充电停止分",@"充电时间",@"蓄电池电压值",@"充电启动电压值",@"电压下限"];
    //        NSLog(@"str is %@",str);
    
    // 进度条
    [SVProgressHUD showWithStatus:@"正在获取数据..."];
    [NetWorkRequestManager requestWithType:POST urlString:urlStr dic:nil str:str successful:^(NSData *data) {
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //保存到数组
        self.dataArray = [result componentsSeparatedByString:@"\r\n"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.dataArray[0] isEqual:@"OK"]) {
                [SVProgressHUD showSuccessWithStatus:@"获取成功"];
                NSLog(@"%@",self.dataArray);
                
                // 赋值
                [self getValues];
                
                
                // 延迟1秒后消失
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
                
            }else{
                NSString *error = self.dataArray[2];
                
                [SVProgressHUD showErrorWithStatus:error];
                // 延迟1秒后消失
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            }
            
        });
        
    } errorMessage:^(NSError *error) {
        NSLog(@"error is %@",error);
    }];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"电源设置";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataArray = [NSArray array];
    self.dArray = [NSArray array];
    self.pArray = [NSArray array];
    
    
    // 右按钮
    UIButton *save = [UIButton buttonWithType:UIButtonTypeSystem];
    save.frame = CGRectMake(0, 0, 40, 20);
    [save addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    [save setTitle:@"保存" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:save];
    
    //获取数据
    [self resquest];
    // Do any additional setup after loading the view from its nib.
}






//字符串处理
-(NSString *)turnIntBystring:(NSString *)str{
    int intString = [str intValue];
    int a = intString % 10;
    int b = intString / 10;
    float c = b + 0.1 * a;
    NSString *string = [NSString stringWithFormat:@"%.1f",c];
    return string;
}

#pragma mark - 赋值
-(void)getValues{
    if ([self.dataArray[2] isEqual:@"0"]) {
        _powerStartButton.selected = NO;
    }else{
        _powerStartButton.selected = YES;
    }
    if ([self.dataArray[3] isEqual:@"0"]) {
        _powerStopButton.selected = NO;
    }else{
        _powerStopButton.selected = YES;
    }
    if ([self.dataArray[4] isEqual:@"0"]) {
        _powerImage.image = [UIImage imageNamed:@"红圈"];
    }else{
       _powerImage.image = [UIImage imageNamed:@"绿圈"];
    }
    _dateTf.text = self.dataArray[5];
    _starHTf.text = self.dataArray[6];
    _starMTf.text = self.dataArray[7];
    _stopHTf.text = self.dataArray[8];
    _stopMTf.text = self.dataArray[9];
    _chargingTimeTf.text = self.dataArray[10];
    _voltageTf.text = [NSString stringWithFormat:@"%@",[self turnIntBystring:self.dataArray[11]]];
    _startvoltageTf.text = [NSString stringWithFormat:@"%@",[self turnIntBystring:self.dataArray[12]]];
    _voltageLowerTf.text = [NSString stringWithFormat:@"%@",[self turnIntBystring:self.dataArray[13]]];
}

- (IBAction)powerStart:(UIButton *)sender {
    if (sender.selected) {
        [self wPower:@"手动充电启动" andstr:@"1"];
    }else{
        [self wPower:@"手动充电启动" andstr:@"0"];
    }
}

- (IBAction)powerStop:(UIButton *)sender {
    if (sender.selected) {
        [self wPower:@"手动充电停止" andstr:@"1"];
    }else{
        [self wPower:@"手动充电停止" andstr:@"0"];
    }
}

#pragma mark - 充电手自动
-(void)wPower:(NSString *)power andstr:(NSString *)kStr{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    NSString *urlStr = [NSString stringWithFormat:@"%@?SID=%@&OP=W",GETVALUES_url,[UserInfoManager getUserID]];
    //    NSLog(@"urlstr  is %@",urlStr);
    NSString *str = [NSString stringWithFormat:@"%@\r\n%@\r\n%@\r\n",@"1",power,kStr];
    //        NSLog(@"str is %@",str);
    [SVProgressHUD showWithStatus:@"正在获取数据..."];
    [NetWorkRequestManager requestWithType:POST urlString:urlStr dic:nil str:str successful:^(NSData *data) {
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //保存到数组
        self.pArray = [result componentsSeparatedByString:@"\r\n"];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.pArray[0] isEqual:@"OK"]) {
                [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                //请求数据
                [self resquest];
                // 延迟1秒后消失
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
                
            }else{
                NSString *error = self.pArray[2];
                
                [SVProgressHUD showErrorWithStatus:error];
                // 延迟1秒后消失
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
            }
            
        });
        
    } errorMessage:^(NSError *error) {
        NSLog(@"error is %@",error);
    }];

}



#pragma mark - 保存按钮

//字符串处理
-(NSString *)deleteStr:(NSString *)str{
    NSString *strUrl = [str stringByReplacingOccurrencesOfString:@"." withString:@""];
    return strUrl;
}

-(void)saveClick{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    NSString *urlStr = [NSString stringWithFormat:@"%@?SID=%@&OP=W",GETVALUES_url,[UserInfoManager getUserID]];
    //    NSLog(@"urlstr  is %@",urlStr);
    NSString *str = [NSString stringWithFormat:@"%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n",@"9",@"充电日期",_dateTf.text,@"充电启动时",_starHTf.text,@"充电启动分",_starMTf.text,@"充电停止时",_stopHTf.text,@"充电停止分",_stopMTf.text,@"充电时间",[self deleteStr:_chargingTimeTf.text],@"蓄电池电压值",[self deleteStr:_voltageTf.text],@"充电启动电压值",[self deleteStr:_startvoltageTf.text],@"电压下限",[self deleteStr:_voltageLowerTf.text]];
    //        NSLog(@"str is %@",str);
    
    
    if (_dateTf.text.length != 0 && _starHTf.text.length != 0 && _starMTf.text.length != 0 && _stopHTf.text != 0 && _stopMTf.text.length != 0 && _chargingTimeTf.text.length != 0 && _voltageTf.text.length != 0 && _startvoltageTf.text.length != 0 && _voltageLowerTf.text.length != 0) {
        // 进度条
        [SVProgressHUD showWithStatus:@"正在获取数据..."];
        [NetWorkRequestManager requestWithType:POST urlString:urlStr dic:nil str:str successful:^(NSData *data) {
            NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            //保存到数组
            self.dArray = [result componentsSeparatedByString:@"\r\n"];
            dispatch_async(dispatch_get_main_queue(), ^{
                if ([self.dArray[0] isEqual:@"OK"]) {
                    [SVProgressHUD showSuccessWithStatus:@"保存成功"];
                    //请求数据
                    [self resquest];
                    // 延迟1秒后消失
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                    });
                    
                }else{
                    NSString *error = self.dArray[2];
                    
                    [SVProgressHUD showErrorWithStatus:error];
                    // 延迟1秒后消失
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [SVProgressHUD dismiss];
                    });
                }
                
            });
            
        } errorMessage:^(NSError *error) {
            NSLog(@"error is %@",error);
        }];
    }else{
        [SVProgressHUD showErrorWithStatus:@"数据不能为空"];
        // 延迟1秒后消失
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }
    
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
