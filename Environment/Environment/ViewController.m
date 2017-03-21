//
//  ViewController.m
//  Environment
//
//  Created by 奥莉 on 2017/3/10.
//  Copyright © 2017年 远方科技. All rights reserved.
//

#import "ViewController.h"
#import "IndexViewController.h"

@interface ViewController ()

@property (nonatomic,strong) NSMutableDictionary *dataDic;
@property (nonatomic, strong) NSString *sid;


@property (weak, nonatomic) IBOutlet UITextField *usernameTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordtf;



@end

@implementation ViewController

-(NSMutableDictionary *)dataDic{
    if (_dataDic == nil) {
        _dataDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    return _dataDic;
}


// 判断用户是否已经登
-(void)viewDidAppear:(BOOL)animated{
    if (![[UserInfoManager getUserName] isEqual:@" "]) {
        // 取消SID
        [UserInfoManager cancelUserID];
        self.usernameTf.text = [UserInfoManager getUserName];
        self.passwordtf.text = [UserInfoManager getUserPwd];
    }
}


// 登入
- (IBAction)land:(id)sender {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    
    if (_usernameTf.text.length == 0 || _passwordtf.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:@"用户名和密码不为空"];
        // 延迟1秒后消失
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [SVProgressHUD dismiss];
        });
        return;
    }
    
    // 进度条
    [SVProgressHUD showWithStatus:@"正在登陆..."];
    [NetWorkRequestManager requestWithType:POST urlString:LOGIN_url dic:@{@"GRM":_usernameTf.text,@"PASS":_passwordtf.text} str:nil successful:^(NSData *data) {
        NSString *result = [[NSString alloc] initWithData:data  encoding:NSUTF8StringEncoding];
        NSLog(@"dataDic is %@",result);
        NSArray *array1 = [result componentsSeparatedByString:@"\r\n"];

        //  判断返回的数据
        if ([array1[0] isEqual:@"OK"]) {
            //获取SID
            _sid = [array1[2] substringFromIndex:4];
            //获取用户数据，保存到本地
            [UserInfoManager conserveUserID:_sid];
            [UserInfoManager conserveUserName:_usernameTf.text];
            [UserInfoManager conserveUserPwd:_passwordtf.text];
            
            //跳转到主界面
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:@"登入成功"];
                // 延迟1秒后消失
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
                IndexViewController *indexVC = [[IndexViewController alloc] init];
                [self presentViewController:indexVC animated:YES completion:nil];

            });
        }else{
            NSString *error = array1[2];
            
            [SVProgressHUD showErrorWithStatus:error];
            // 延迟1秒后消失
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }
        
       
    } errorMessage:^(NSError *error) {
        NSLog(@"error is %@",error);
    }];
//
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
