//
//  QueryViewController.m
//  Environment
//
//  Created by 奥莉 on 2017/3/13.
//  Copyright © 2017年 远方科技. All rights reserved.
//

#import "QueryViewController.h"
#import "QueryManager.h"
#import "EnvironmentModel.h"
#import "EnvironmentModelCell.h"

@interface QueryViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *dataArray;


@end

@implementation QueryViewController


#pragma mark - 刷新数据
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

-(UILabel *)createLableFrame:(CGRect)frame title:(NSString *)title font:(UIFont *)font {
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor blueColor];
    label.font = font;
    label.text = title;
    return label;
}



-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _dataArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"数据查询";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;// 去掉留白
    
    // 右按钮
    UIButton *delete = [UIButton buttonWithType:UIButtonTypeSystem];
    delete.frame = CGRectMake(0, 0, 40, 20);
    [delete addTarget:self action:@selector(deleteClick) forControlEvents:UIControlEventTouchUpInside];
    [delete setTitle:@"清除" forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:delete];
    
    
    // 设置滚动视图
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, ScreenWidth, ScreenHeight - 104)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //分割线样式
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //隐藏滚动条
    self.tableView.showsVerticalScrollIndicator = NO;
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"EnvironmentModelCell" bundle:nil ] forCellReuseIdentifier:@"modelCell"];
    [self.view addSubview:self.tableView];
    
    
    [[QueryManager shareInstance] getAllValues];
    self.dataArray = [QueryManager shareInstance].dataArray;
    
    // Do any additional setup after loading the view from its nib.
}


#pragma mark - 删除本地数据
-(void)deleteClick{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提醒" message:@"是否删除本地数据" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
        //删除本地数据
        [[QueryManager shareInstance] deleteAllData];
        [UserInfoManager cancelEID];
        
        dispatch_after(0.2, dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - tableView协议
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EnvironmentModelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"modelCell" forIndexPath:indexPath];
    EnvironmentModel *model = self.dataArray[indexPath.row];
    
    if (cell == nil) {
        cell = [[EnvironmentModelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"modelCell"];
    }
    
    //单元格点击样式
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setDataWithModel:model];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    NSArray *array = [[NSArray alloc]initWithObjects:@"序号",@"日期",@"时间",@"o2值1号%",@"o2值2号%",@"温度℃",@"湿度%",@"水位mm", nil];
    CGFloat labelWidth = ScreenWidth / 8;
    for (int i = 0; i < array.count; i ++) {
        UILabel *label = [self createLableFrame:CGRectMake(labelWidth * i, 0, labelWidth, 40) title:array[i] font:[UIFont systemFontOfSize:10]];
        [view addSubview:label];
    }
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
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
