//
//  HomeViewController.m
//  Environment
//
//  Created by 奥莉 on 2017/3/13.
//  Copyright © 2017年 远方科技. All rights reserved.
//

#import "HomeViewController.h"
#import "homeModelCell.h"
#import "QueryManager.h"

@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic,strong) UITableView *tableView1;//警报状态滚动视图

@property (nonatomic,strong) UILabel *label1;//警报label
@property (nonatomic,strong) UILabel *label2;//环境label

@property (nonatomic,strong) NSArray *eArray;//保存环境测量值和设备运行状态的数据
@property (nonatomic,strong) NSArray *jArray;//保存警报状态的数据
@property (nonatomic,strong) NSArray *nArray;//保存警报名字数组

//环境测量值的label
@property (weak, nonatomic) IBOutlet UILabel *e1Label;
@property (weak, nonatomic) IBOutlet UILabel *e2Label;
@property (weak, nonatomic) IBOutlet UILabel *e3Label;
@property (weak, nonatomic) IBOutlet UILabel *e4Label;
@property (weak, nonatomic) IBOutlet UILabel *e5Label;
//状态按钮
@property (weak, nonatomic) IBOutlet UIImageView *bfimage;
@property (weak, nonatomic) IBOutlet UIImageView *hjiameg;
@property (weak, nonatomic) IBOutlet UIImageView *fjimage;
@property (weak, nonatomic) IBOutlet UIImageView *csimage;
@property (weak, nonatomic) IBOutlet UIImageView *csjimage;



@end

@implementation HomeViewController


#pragma mark - 创建label

-(UILabel *)createLableFrame:(CGRect)frame title:(NSString *)title backgroundColor:(UIColor *)color textColor:(UIColor *)Textcolor{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = color;
    label.textColor = Textcolor;
    label.font = [UIFont systemFontOfSize:17];
    label.text = title;
    return label;
}


#pragma mark - 刷新
-(void)viewWillAppear:(BOOL)animated{
    //刷新数据
    [self getValues];
    [self getValues2];
}


#pragma mark - 获取当前时间
// 获取当前时间
- (NSString *)currentDateStr:(NSString *)str{
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    // [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss SS"];
    [dateFormatter setDateFormat:str];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    return dateString;
}

#pragma mark - 获取环境数据已经设备运行状态
-(void)getValues{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    NSString *urlStr = [NSString stringWithFormat:@"%@?SID=%@&OP=R",GETVALUES_url,[UserInfoManager getUserID]];
//    NSLog(@"urlstr  is %@",urlStr);
    NSString *str = [NSString stringWithFormat:@"%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n",@"10",@"O2变送器1号位本地",@"O2变送器2号位本地",@"环境温度值本地",@"环境湿度值本地",@"电缆沟水位值本地",@"布防状态",@"风机状态",@"SF6风机状态",@"除湿状态",@"水泵状态"];
//    NSLog(@"str is %@",str);
    // 进度条
    [SVProgressHUD showWithStatus:@"正在获取数据..."];
    [NetWorkRequestManager requestWithType:POST urlString:urlStr dic:nil str:str successful:^(NSData *data) {
        
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //保存到数组
        self.eArray = [result componentsSeparatedByString:@"\r\n"];
//        NSLog(@"%ld,%@",self.eArray.count,self.eArray);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.eArray[0] isEqual:@"OK"]) {
                //填写数据
                [SVProgressHUD showSuccessWithStatus:@"获取成功"];
                // 延迟1秒后消失
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });

                [self getData];
                
                [self saveValues];
                
            }else{
                NSString *error = self.eArray[2];
                
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

#pragma mark - 保存本地数据
-(void)saveValues{
    
    NSString *numb1o2 = [NSString stringWithFormat:@"%@",[self turnIntBystring:self.eArray[2]]];
    NSString *numb2o2 = [NSString stringWithFormat:@"%@",[self turnIntBystring:self.eArray[3]]];
    NSString *temperature = [NSString stringWithFormat:@"%@",[self turnIntBystring:self.eArray[4]]];
    NSString *humidity = [NSString stringWithFormat:@"%@",[self turnIntBystring:self.eArray[5]]];
    
    
    NSInteger i = [UserInfoManager getEID];
    NSLog(@"%ld",i);
    [UserInfoManager conserveEID:(i + 1)];
    
    NSString *eid = [NSString stringWithFormat:@"%ld",[UserInfoManager getEID]];
    EnvironmentModel *model = [[EnvironmentModel alloc] initWitheid:eid edate:[self currentDateStr:@"MM/dd"] etime:[self currentDateStr:@"hh:mm:ss"] numb1o2:numb1o2 numb2o2:numb2o2 temperature:temperature humidity:humidity lever:self.eArray[6]];
    [[QueryManager shareInstance] insertModel:model];
 
}

#pragma mark - 获取警报状态
-(void)getValues2{
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    NSString *urlStr = [NSString stringWithFormat:@"%@?SID=%@&OP=R",GETVALUES_url,[UserInfoManager getUserID]];
//    NSLog(@"urlstr  is %@",urlStr);
    NSString *str = [NSString stringWithFormat:@"%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n%@\r\n",@"17",@"SF61号报警",@"SF62号报警",@"SF63号报警",@"SF64号报警",@"O21号位超限",@"O22号位超限",@"温度超限",@"湿度超限",@"水位超限",@"浸水报警",@"门禁1号入侵报警",@"门禁2号入侵报警",@"烟雾1号报警",@"烟雾2号报警",@"烟雾3号报警",@"烟雾4号报警",@"断电报警"];
//    NSLog(@"str is %@",str);
    
    // 进度条
    [SVProgressHUD showWithStatus:@"正在获取数据..."];
    [NetWorkRequestManager requestWithType:POST urlString:urlStr dic:nil str:str successful:^(NSData *data) {
        NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //保存到数组
        self.jArray = [result componentsSeparatedByString:@"\r\n"];
//        NSLog(@"%ld,%@",self.jArray.count,self.jArray);
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([self.jArray[0] isEqual:@"OK"]) {
                [SVProgressHUD showSuccessWithStatus:@"获取成功"];
                // 延迟1秒后消失
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });

                [self.tableView1 reloadData];
            }else{
                NSString *error = self.jArray[2];
                
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
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"状态监测";
    // 设置警报label
    CGFloat labelWidth = (ScreenWidth - 80) / 2;
    self.label1 = [self createLableFrame:CGRectMake(20, 20, labelWidth, 30) title:@"警报状态指示" backgroundColor:[UIColor whiteColor] textColor:[UIColor colorWithRed:0.00 green:0.78 blue:0.63 alpha:1.00]];
    [self.view addSubview:self.label1];
    // 设置环境label
    self.label2 = [self createLableFrame:CGRectMake(60 + labelWidth, 20, labelWidth, 30) title:@"环境测量值" backgroundColor:[UIColor whiteColor] textColor:[UIColor colorWithRed:0.00 green:0.78 blue:0.63 alpha:1.00]];
    [self.view addSubview:self.label2];
    
    // 设置滚动视图
    self.tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, ScreenWidth / 2, ScreenHeight - 104)];
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    //分割线样式
    self.tableView1.separatorStyle = UITableViewCellSeparatorStyleNone;
    //隐藏滚动条
    self.tableView1.showsVerticalScrollIndicator = NO;
    //注册cell
    [self.tableView1 registerNib:[UINib nibWithNibName:@"homeModelCell" bundle:nil ] forCellReuseIdentifier:@"homecell"];
    [self.view addSubview:self.tableView1];
    
    // 获取数据
    [self getValues];
    [self getValues2];
    
    //初始化数组
    self.eArray = [NSArray array];
    self.jArray = [NSArray array];
    self.nArray = [[NSArray alloc] initWithObjects:@"1号SF6",@"2号SF6",@"3号SF6",@"4号SF6",@"1号 O2",@"2号 O2",@"温  度",@"湿  度",@"水  位",@"浸  水",@"门禁1号",@"门禁2号",@"烟雾1号",@"烟雾2号",@"烟雾3号",@"烟雾4号",@"电  源", nil];
    
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

-(void)getData {
    self.e1Label.text = [NSString stringWithFormat:@"1号O2含量 %@%%",[self turnIntBystring:self.eArray[2]]];
    self.e2Label.text = [NSString stringWithFormat:@"2号o2含量 %@%%",[self turnIntBystring:self.eArray[3]]];
    self.e3Label.text = [NSString stringWithFormat:@"环境温度 %@℃",[self turnIntBystring:self.eArray[4]]];
    self.e4Label.text = [NSString stringWithFormat:@"环境湿度 %@%%",[self turnIntBystring:self.eArray[5]]];
    self.e5Label.text = [NSString stringWithFormat:@"电缆沟水位 %@mm",self.eArray[6]];
    
    //判断状态值
    if ([self.eArray[7] isEqual:@"0"]) {
        [self.bfimage setImage:[UIImage imageNamed:@"红圈"]];
    }else{
        [self.bfimage setImage:[UIImage imageNamed:@"绿圈"]];
    }
    if ([self.eArray[8] isEqual:@"0"]) {
        [self.hjiameg setImage:[UIImage imageNamed:@"红圈"]];
    }else{
        [self.hjiameg setImage:[UIImage imageNamed:@"绿圈"]];
    }
    if ([self.eArray[9] isEqual:@"0"]) {
        [self.fjimage setImage:[UIImage imageNamed:@"红圈"]];
    }else{
        [self.fjimage setImage:[UIImage imageNamed:@"绿圈"]];
    }
    if ([self.eArray[10] isEqual:@"0"]) {
        [self.csimage setImage:[UIImage imageNamed:@"红圈"]];
    }else{
        [self.csimage setImage:[UIImage imageNamed:@"绿圈"]];
    }
    if ([self.eArray[11] isEqual:@"0"]) {
        [self.csjimage setImage:[UIImage imageNamed:@"红圈"]];
    }else{
        [self.csjimage setImage:[UIImage imageNamed:@"绿圈"]];
    }
}

#pragma mark - tableView协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.nArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    homeModelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"homecell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[homeModelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homecell"];
    }
    cell.nameLabel.text = self.nArray[indexPath.row];
    //单元格点击样式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.jArray.count < self.nArray.count) {
        return cell;
    }
    if ([self.jArray[indexPath.row + 2] isEqual:@"0"]) {
        cell.imageButton.image = [UIImage imageNamed:@"绿圈"];
    }else{
        cell.imageButton.image = [UIImage imageNamed:@"红圈"];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
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
