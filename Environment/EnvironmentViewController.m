//
//  EnvironmentViewController.m
//  Environment
//
//  Created by 奥莉 on 2017/3/22.
//  Copyright © 2017年 远方科技. All rights reserved.
//

#import "EnvironmentViewController.h"

@interface EnvironmentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *nameArray;
@property (nonatomic, strong) NSArray *iconArray;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation EnvironmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"环境监测";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;// 去掉留白
    
    //初始化数据
    self.nameArray = [[NSArray alloc] initWithObjects:@"监控状态",@"手动自动",@"参数查询",@"参数设置",@"电源设置", nil];
    self.iconArray = [[NSArray alloc] initWithObjects:@"jk",@"sd",@"cx",@"cs",@"dy", nil];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.nameArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *reuseIdentifier = @"reuse";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    cell.imageView.image = [UIImage imageNamed:self.iconArray[indexPath.row]];
    cell.textLabel.text = self.nameArray[indexPath.row];
    
    return cell;
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
