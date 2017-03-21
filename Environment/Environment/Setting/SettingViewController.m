//
//  SettingViewController.m
//  Environment
//
//  Created by 奥莉 on 2017/3/13.
//  Copyright © 2017年 远方科技. All rights reserved.
//

#import "SettingViewController.h"
#define labelWidth (ScreenWidth-30) / 3

@interface SettingViewController ()

@property (nonatomic, strong) NSArray *eArray;//设备命名数组
@property (nonatomic, strong) NSArray *fArray;//符号数组
@property (nonatomic, strong) NSArray *cArray;//测量命名数组
@property (nonatomic, strong) NSArray *fArray1;//符号数组1
@property (nonatomic, strong) NSArray *fArray2;//符号数组2
@property (nonatomic, strong) NSArray *tArray;//时间数组
@property (nonatomic, strong) UIScrollView *rootScrollView;
@property (nonatomic, strong) NSArray *dataArray;//获取参数数值数组

@property (nonatomic, strong) NSArray *dArray;// 保存之后返回的数组

//创建textfield
@property (nonatomic,strong) UITextField *startFanTf;
@property (nonatomic,strong) UITextField *startFanPoorTf;
@property (nonatomic,strong) UITextField *humidityTf;
@property (nonatomic,strong) UITextField *humidityPoorTf;
@property (nonatomic,strong) UITextField *temperatureTf;
@property (nonatomic,strong) UITextField *temperaturePoorTf;
@property (nonatomic,strong) UITextField *dhumidityTf;
@property (nonatomic,strong) UITextField *dhumidityPoorTf;
@property (nonatomic,strong) UITextField *pumpingTf;
@property (nonatomic,strong) UITextField *pumpingPoorTf;
@property (nonatomic,strong) UITextField *o2contentTf;
@property (nonatomic,strong) UITextField *tceilingTf;
@property (nonatomic,strong) UITextField *hceilingTf;
@property (nonatomic,strong) UITextField *levelTf;
@property (nonatomic,strong) UITextField *floodingTf;

@property (nonatomic,strong) UITextField *bfTimeH;
@property (nonatomic,strong) UITextField *bfTimeM;

@property (nonatomic,strong) UITextField *fanStarTimeH1;
@property (nonatomic,strong) UITextField *fanStarTimeM1;
@property (nonatomic,strong) UITextField *fanEndTimeH1;
@property (nonatomic,strong) UITextField *fanEndTimeM1;

@property (nonatomic,strong) UITextField *fanStarTimeH2;
@property (nonatomic,strong) UITextField *fanStarTimeM2;
@property (nonatomic,strong) UITextField *fanEndTimeH2;
@property (nonatomic,strong) UITextField *fanEndTimeM2;

@property (nonatomic,strong) UITextField *ventilationTime;
@end

@implementation SettingViewController
/*
UITextBorderStyleLine,
UITextBorderStyleBezel,
UITextBorderStyleRoundedRect
*/



#pragma mark - 创建label创建textField
-(UILabel *)createLableFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font textColor:(UIColor *)Textcolor{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = Textcolor;
    label.font = font;
    label.text = title;
    return label;
}

-(UITextField *)creatTextFieldFrame:(CGRect)frame{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = UITextBorderStyleLine;
    return textField;
}

#pragma mark - 刷新
-(void)viewWillAppear:(BOOL)animated{
    //刷新数据
    [self resquest];
}


#pragma maek - 获取数据
-(void)resquest{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    NSString *urlStr = [NSString stringWithFormat:@"%@?SID=%@&OP=R",GETVALUES_url,[UserInfoManager getUserID]];
    //    NSLog(@"urlstr  is %@",urlStr);
    NSString *str = [NSString stringWithFormat:@"%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n",@"26",@"风机启动值O2",@"风机回差值O2",@"风机启动值温度",@"风机回差值温度",@"风机启动值湿度",@"风机回差值湿度",@"除湿机启动值",@"除湿机回差值",@"水泵启动值",@"水泵回差值",@"O2含量下限",@"环境温度上限",@"环境湿度上限",@"电缆沟水位上限",@"浸水限位",@"自动布防“时”",@"自动布防“分”",@"定时一开“时”",@"定时一开“分”",@"定时一停“时”",@"定时一停“分”",@"定时二开“时”",@"定时二开“时”",@"定时二停“时”",@"定时二停“分”",@"通风时间"];
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
//                NSLog(@"%@",self.dataArray);
                
                // 赋值
                [self getValues];
                
                
                // 延迟1秒后消失
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
                
            }else{
                NSString *error = self.dataArray[2];
                
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

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"参数设置";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;// 去掉留白
    
    // 右按钮
    UIButton *save = [UIButton buttonWithType:UIButtonTypeSystem];
    save.frame = CGRectMake(0, 0, 40, 20);
    [save addTarget:self action:@selector(saveClick) forControlEvents:UIControlEventTouchUpInside];
    [save setTitle:@"保存" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:save];
    
    
    
    // 初始化设置
    self.dataArray = [NSArray array];
    self.dArray = [NSArray array];
    
    self.eArray = [[NSArray alloc] initWithObjects:@"风机启动-02",@"风机回差-02",@"风机启动-温度",@"风机回差-温度",@"风机启动-湿度",@"风机回差-湿度",@"除湿机启动",@"除湿机回差",@"抽水泵启动",@"抽水泵回差", nil];
    self.fArray = [[NSArray alloc] initWithObjects:@"%",@"℃",@"%",@"%",@"mm", nil];
    self.fArray1 = [[NSArray alloc] initWithObjects:@"%",@"%",@"mm", nil];
    self.fArray2 = [[NSArray alloc] initWithObjects:@"℃",@"mm", nil];
    self.cArray = [[NSArray alloc] initWithObjects:@"o2含量下限",@"温度上限",@"湿度上限",@"水位上限",@"浸水限制",@" ", nil];
    self.tArray = [[NSArray alloc] initWithObjects:@"定时布防时间",@"风机定时开启一",@"风机定时开启二", nil];
    
    self.rootScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 69, ScreenWidth, ScreenHeight - 69)];
    self.rootScrollView.contentSize = CGSizeMake(ScreenWidth, 650);
    [self.view addSubview:self.rootScrollView];
    
    
    // 创建头label
    CGFloat labelWidth1 = ScreenWidth;
    CGFloat labelX = (ScreenWidth - labelWidth1) / 2;
    UILabel *equipmentLabel = [self createLableFrame:CGRectMake(labelX, 10, labelWidth1, 30) title:@"设备启动与回差值设置" font:[UIFont systemFontOfSize:17] textColor:[UIColor blackColor]];
    equipmentLabel.textAlignment = NSTextAlignmentCenter;
    [self.rootScrollView addSubview:equipmentLabel];
    UILabel *measurementLabel = [self createLableFrame:CGRectMake(labelX, 240, labelWidth1, 30) title:@"测量项目上限设置" font:[UIFont systemFontOfSize:17] textColor:[UIColor blackColor]];
    measurementLabel.textAlignment = NSTextAlignmentCenter;
    [self.rootScrollView addSubview:measurementLabel];
    UILabel *timeLabel = [self createLableFrame:CGRectMake(labelX, 400, labelWidth1, 30) title:@"时间设置    开              始 —— 结              束" font:[UIFont systemFontOfSize:17] textColor:[UIColor blackColor]];
    timeLabel.textAlignment = NSTextAlignmentCenter;
    [self.rootScrollView addSubview:timeLabel];
    //通风时间
    UILabel *tlabel = [self createLableFrame:CGRectMake(5, 560, (ScreenWidth - 30 )/ 3, 30) title:@"通风时间" font:[UIFont systemFontOfSize:14] textColor:[UIColor blueColor]];
    UILabel *tlabel1 = [self createLableFrame:CGRectMake(ScreenWidth / 2 - 30, 560, 30, 30) title:@"min" font:[UIFont systemFontOfSize:14] textColor:[UIColor blueColor]];
    [self.rootScrollView addSubview:tlabel];
    [self.rootScrollView addSubview:tlabel1];
    
    //分割线
    UIView *linView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 41, ScreenWidth, 1)];
    linView1.backgroundColor = [UIColor blackColor];
    [self.rootScrollView addSubview:linView1];
    UIView *linView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 235, ScreenWidth, 1)];
    linView2.backgroundColor = [UIColor blackColor];
    [self.rootScrollView addSubview:linView2];
    UIView *linView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 271, ScreenWidth, 1)];
    linView3.backgroundColor = [UIColor blackColor];
    [self.rootScrollView addSubview:linView3];
    UIView *linView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 395, ScreenWidth, 1)];
    linView4.backgroundColor = [UIColor blackColor];
    [self.rootScrollView addSubview:linView4];
    UIView *linView5 = [[UIView alloc] initWithFrame:CGRectMake(0, 431, ScreenWidth, 1)];
    linView5.backgroundColor = [UIColor blackColor];
    [self.rootScrollView addSubview:linView5];
    UIView *linView6 = [[UIView alloc] initWithFrame:CGRectMake(0, 555, ScreenWidth, 1)];
    linView6.backgroundColor = [UIColor blackColor];
    [self.rootScrollView addSubview:linView6];
    
    //创建label
    [self creatEquipmentLabel];
    [self creatMeasureLabel];
    [self creatTimeLabel];
    [self creattextField];
    
    // 获取数据
    [self resquest];
    // Do any additional setup after loading the view from its nib.
}

//字符串处理
-(NSString *)deleteStr:(NSString *)str{
    NSString *strUrl = [str stringByReplacingOccurrencesOfString:@"." withString:@""];
    return strUrl;
}

#pragma mark - 保存按钮
-(void)saveClick{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    NSString *urlStr = [NSString stringWithFormat:@"%@?SID=%@&OP=W",GETVALUES_url,[UserInfoManager getUserID]];
    //    NSLog(@"urlstr  is %@",urlStr);
    NSString *str = [NSString stringWithFormat:@"%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n",@"26",@"风机启动值O2",[self deleteStr:_startFanTf.text],@"风机回差值O2",[self deleteStr:_startFanPoorTf.text],@"风机启动值温度",[self deleteStr:_temperatureTf.text],@"风机回差值温度",[self deleteStr:_temperaturePoorTf.text],@"风机启动值湿度",[self deleteStr:_humidityTf.text],@"风机回差值湿度",[self deleteStr:_humidityPoorTf.text],@"除湿机启动值",[self deleteStr:_dhumidityTf.text],@"除湿机回差值",[self deleteStr:_dhumidityPoorTf.text],@"水泵启动值",_pumpingTf.text,@"水泵回差值",_pumpingPoorTf.text,@"O2含量下限",[self deleteStr:_o2contentTf.text],@"环境温度上限",[self deleteStr:_tceilingTf.text],@"环境湿度上限",[self deleteStr:_hceilingTf.text],@"电缆沟水位上限",_levelTf.text,@"浸水限位",_floodingTf.text,@"自动布防“时”",_bfTimeH.text,@"自动布防“分”",_bfTimeM.text,@"定时一开“时”",_fanStarTimeH1.text,@"定时一开“分”",_fanStarTimeM1.text,@"定时一停“时”",_fanEndTimeH1.text,@"定时一停“分”",_fanEndTimeM1.text,@"定时二开“时”",_fanStarTimeH2.text,@"定时二开“时”",_fanStarTimeM2.text,@"定时二停“时”",_fanEndTimeH2.text,@"定时二停“分”",_fanEndTimeM2.text,@"通风时间",_ventilationTime.text];
//        NSLog(@"str is %@",str);
    
    
    if (_startFanTf.text.length != 0 && _startFanPoorTf.text.length != 0 && _temperatureTf.text.length != 0&& _temperaturePoorTf.text != 0 && _humidityTf.text.length != 0 && _humidityPoorTf.text.length != 0 && _dhumidityTf.text.length != 0 && _pumpingTf.text.length != 0 && _pumpingPoorTf.text.length != 0 && _o2contentTf.text.length != 0 && _tceilingTf.text.length != 0 && _hceilingTf.text.length != 0 &&  _levelTf.text.length != 0 && _floodingTf.text.length != 0 && _bfTimeH.text.length != 0 && _bfTimeM.text.length != 0 && _fanStarTimeH1.text.length != 0 && _fanStarTimeM1.text.length != 0 && _fanEndTimeH1.text.length != 0 && _fanEndTimeM1.text.length != 0 && _fanStarTimeH2.text.length != 0 && _fanStarTimeM2.text.length != 0 && _fanEndTimeH2.text.length != 0 && _fanEndTimeM2.text.length != 0 && _ventilationTime.text.length != 0) {
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
    }else{
        [SVProgressHUD showErrorWithStatus:@"数据不能为空"];
        // 延迟1秒后消失
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
    }
    
    

}



#pragma mark - 创建设备启动与回差设置
-(void)creatEquipmentLabel{
    for (int i = 0; i < (self.eArray.count / 2); i ++) {
        UILabel *label1 = [self createLableFrame:CGRectMake(5, (30 + 10) * (i + 1), labelWidth, 30) title:self.eArray[2 * i] font:[UIFont systemFontOfSize:14] textColor:[UIColor blueColor]];
        UILabel *label2 = [self createLableFrame:CGRectMake(ScreenWidth/2 + 5, (30 + 10) * (i + 1), labelWidth, 30) title:self.eArray[2 * i + 1] font:[UIFont systemFontOfSize:14] textColor:[UIColor blueColor]];
        [self.rootScrollView addSubview:label1];
        [self.rootScrollView addSubview:label2];
    }
    for (int i = 0; i < self.fArray.count; i ++) {
        UILabel *label = [self createLableFrame:CGRectMake(ScreenWidth / 2 - 30 , (30 + 10) * (i + 1), 30, 30) title:self.fArray[i] font:[UIFont systemFontOfSize:14] textColor:[UIColor blueColor]];
        [self.rootScrollView addSubview:label];
    }
}
#pragma mark - 创建测量项目上限值设置
-(void)creatMeasureLabel{
    for (int i = 0; i < ((self.cArray.count + 1 )/ 2); i ++) {
        UILabel *label1 = [self createLableFrame:CGRectMake(5, (30 + 10) * (i + 1) + 240, labelWidth, 30) title:self.cArray[2 * i] font:[UIFont systemFontOfSize:14] textColor:[UIColor blueColor]];
        UILabel *label2 = [self createLableFrame:CGRectMake(ScreenWidth/2 + 5, (30 + 10) * (i + 1) + 240, labelWidth, 30) title:self.cArray[2 * i + 1] font:[UIFont systemFontOfSize:14] textColor:[UIColor blueColor]];
        [self.rootScrollView addSubview:label1];
        [self.rootScrollView addSubview:label2];
    }
    for (int i = 0; i < 3; i ++) {
        UILabel *label = [self createLableFrame:CGRectMake(ScreenWidth / 2 - 30, (30 + 10) * (i + 1) + 240, 30, 30) title:self.fArray1[i] font:[UIFont systemFontOfSize:14] textColor:[UIColor blueColor]];
        [self.rootScrollView addSubview:label];
    }
    for (int i = 0; i < 2; i ++) {
      UILabel *label = [self createLableFrame:CGRectMake(ScreenWidth - 30, (30 + 10) * (i + 1) + 240, 30, 30) title:self.fArray2[i] font:[UIFont systemFontOfSize:14] textColor:[UIColor blueColor]];
        [self.rootScrollView addSubview:label];
    }
}

#pragma mark - 时间设置
-(void)creatTimeLabel{
    for (int i = 0; i < 3; i ++) {
        UILabel *label = [self createLableFrame:CGRectMake(5, (30 + 10) * (i + 1) + 400, labelWidth, 30) title:self.tArray[i] font:[UIFont systemFontOfSize:14] textColor:[UIColor blackColor]];
        [self.rootScrollView addSubview:label];
    }
}

#pragma mark - 创建textField
-(void)creattextField{
    _startFanTf = [self creatTextFieldFrame:CGRectMake(labelWidth - 20, 45, 55, 20)];
    [self.rootScrollView addSubview:_startFanTf];
    _startFanPoorTf = [self creatTextFieldFrame:CGRectMake(ScreenWidth/2 + 5 - 20 + labelWidth, 45, 55, 20)];
    [self.rootScrollView addSubview:_startFanPoorTf];
    _temperatureTf = [self creatTextFieldFrame:CGRectMake(labelWidth - 20, 85, 55, 20)];
    [self.rootScrollView addSubview:_temperatureTf];
    _temperaturePoorTf = [self creatTextFieldFrame:CGRectMake(ScreenWidth/2 + 5 - 20 + labelWidth, 85, 55, 20)];
    [self.rootScrollView addSubview:_temperaturePoorTf];
    _humidityTf = [self creatTextFieldFrame:CGRectMake(labelWidth - 20, 125, 55, 20)];
    [self.rootScrollView addSubview:_humidityTf];
    _humidityPoorTf = [self creatTextFieldFrame:CGRectMake(ScreenWidth/2 + 5 - 20 + labelWidth, 125, 55, 20)];
    [self.rootScrollView addSubview:_humidityPoorTf];
    _dhumidityTf = [self creatTextFieldFrame:CGRectMake(labelWidth - 20, 165, 55, 20)];
    [self.rootScrollView addSubview:_dhumidityTf];
    _dhumidityPoorTf = [self creatTextFieldFrame:CGRectMake(ScreenWidth/2 + 5 - 20 + labelWidth, 165, 55, 20)];
    [self.rootScrollView addSubview:_dhumidityPoorTf];
    _pumpingTf = [self creatTextFieldFrame:CGRectMake(labelWidth - 20, 205, 55, 20)];
    [self.rootScrollView addSubview:_pumpingTf];
    _pumpingPoorTf = [self creatTextFieldFrame:CGRectMake(ScreenWidth/2 + 5 - 20 + labelWidth, 205, 55, 20)];
    [self.rootScrollView addSubview:_pumpingPoorTf];
    
    
    _o2contentTf = [self creatTextFieldFrame:CGRectMake(labelWidth - 20, 285, 55, 20)];
    [self.rootScrollView addSubview:_o2contentTf];
    _hceilingTf = [self creatTextFieldFrame:CGRectMake(labelWidth - 20, 325, 55, 20)];
    [self.rootScrollView addSubview:_hceilingTf];
    _floodingTf = [self creatTextFieldFrame:CGRectMake(labelWidth - 20, 365, 55, 20)];
    [self.rootScrollView addSubview:_floodingTf];
    _tceilingTf = [self creatTextFieldFrame:CGRectMake(ScreenWidth/2 + 5 - 20 + labelWidth, 285, 55, 20)];
    [self.rootScrollView addSubview:_tceilingTf];
    _levelTf = [self creatTextFieldFrame:CGRectMake(ScreenWidth/2 + 5 - 20 + labelWidth, 325, 55, 20)];
    [self.rootScrollView addSubview:_levelTf];
    
    
    
    _bfTimeH = [self creatTextFieldFrame:CGRectMake(labelWidth - 10, 445, 40, 20)];
    [self.rootScrollView addSubview:_bfTimeH];
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth + 40, 440, 20, 30)];
    label1.text = @":";
    [self.rootScrollView addSubview:label1];
    _bfTimeM = [self creatTextFieldFrame:CGRectMake(labelWidth + 55, 445, 40, 20)];
    [self.rootScrollView addSubview:_bfTimeM];
    
    
    _fanStarTimeH1 = [self creatTextFieldFrame:CGRectMake(labelWidth - 10, 485, 40, 20)];
    [self.rootScrollView addSubview:_fanStarTimeH1];
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth + 40, 480, 20, 30)];
    lable2.text = @":";
    [self.rootScrollView addSubview:lable2];
    _fanStarTimeM1 = [self creatTextFieldFrame:CGRectMake(labelWidth + 55, 485, 40, 20)];
    [self.rootScrollView addSubview:_fanStarTimeM1];
    
    
    _fanStarTimeH2 = [self creatTextFieldFrame:CGRectMake(labelWidth - 10, 525, 40, 20)];
    [self.rootScrollView addSubview:_fanStarTimeH2];
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth + 40, 520, 20, 30)];
    label3.text = @":";
    [self.rootScrollView addSubview:label3];
    _fanStarTimeM2 = [self creatTextFieldFrame:CGRectMake(labelWidth + 55, 525, 40, 20)];
    [self.rootScrollView addSubview:_fanStarTimeM2];
    
    UIView *view1 = [[UIView alloc] initWithFrame:CGRectMake(labelWidth + 96, 495, 40, 1)];
    view1.backgroundColor = [UIColor blackColor];
    [self.rootScrollView addSubview:view1];
    _fanEndTimeH1 = [self creatTextFieldFrame:CGRectMake(labelWidth + 137, 485, 40, 20)];
    [self.rootScrollView addSubview:_fanEndTimeH1];
    UILabel *label4 = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth + 187, 480, 20, 30)];
    label4.text = @":";
    [self.rootScrollView addSubview:label4];
    _fanEndTimeM1 = [self creatTextFieldFrame:CGRectMake(labelWidth + 202, 485, 40, 20)];
    [self.rootScrollView addSubview:_fanEndTimeM1];
    
    UIView *view2 = [[UIView alloc] initWithFrame:CGRectMake(labelWidth + 96, 535, 40, 1)];
    view2.backgroundColor = [UIColor blackColor];
    [self.rootScrollView addSubview:view2];
    _fanEndTimeH2 = [self creatTextFieldFrame:CGRectMake(labelWidth + 137, 525, 40, 20)];
    [self.rootScrollView addSubview:_fanEndTimeH2];
    UILabel *label5 = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth + 187, 520, 20, 30)];
    label5.text = @":";
    [self.rootScrollView addSubview:label5];
    _fanEndTimeM2 = [self creatTextFieldFrame:CGRectMake(labelWidth + 202, 525, 40, 20)];
    [self.rootScrollView addSubview:_fanEndTimeM2];
    
    _ventilationTime = [self creatTextFieldFrame:CGRectMake(labelWidth - 30, 565, 60, 20)];
    [self.rootScrollView addSubview:_ventilationTime];
    
    
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
    _startFanTf.text = [NSString stringWithFormat:@"%@",[self turnIntBystring:self.dataArray[2]]];
    _startFanPoorTf.text = [NSString stringWithFormat:@"%@",[self turnIntBystring:self.dataArray[3]]];
    _temperatureTf.text = [NSString stringWithFormat:@"%@",[self turnIntBystring:self.dataArray[4]]];
    _temperaturePoorTf.text = [NSString stringWithFormat:@"%@",[self turnIntBystring:self.dataArray[5]]];
    _humidityTf.text = [NSString stringWithFormat:@"%@",[self turnIntBystring:self.dataArray[6]]];
    _humidityPoorTf.text = [NSString stringWithFormat:@"%@",[self turnIntBystring:self.dataArray[7]]];
    _dhumidityTf.text = [NSString stringWithFormat:@"%@",[self turnIntBystring:self.dataArray[8]]];
    _dhumidityPoorTf.text = [NSString stringWithFormat:@"%@",[self turnIntBystring:self.dataArray[9]]];
    _pumpingTf.text = self.dataArray[10];
    _pumpingPoorTf.text = self.dataArray[11];
    
    _o2contentTf.text = [NSString stringWithFormat:@"%@",[self turnIntBystring:self.dataArray[12]]];
    _tceilingTf.text = [NSString stringWithFormat:@"%@",[self turnIntBystring:self.dataArray[13]]];
    _hceilingTf.text = [NSString stringWithFormat:@"%@",[self turnIntBystring:self.dataArray[14]]];
    _levelTf.text = self.dataArray[15];
    _floodingTf.text = self.dataArray[16];
    
    
    _bfTimeH.text = self.dataArray[17];
    _bfTimeM.text = self.dataArray[18];
    
    _fanStarTimeH1.text = self.dataArray[19];
    _fanStarTimeM1.text = self.dataArray[20];
    _fanEndTimeH1.text = self.dataArray[21];
    _fanEndTimeM1.text = self.dataArray[22];
    
    _fanStarTimeH2.text = self.dataArray[23];
    _fanStarTimeM2.text = self.dataArray[24];
    _fanEndTimeH2.text = self.dataArray[25];
    _fanEndTimeM2.text = self.dataArray[26];
    
    _ventilationTime.text = self.dataArray[27];
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
