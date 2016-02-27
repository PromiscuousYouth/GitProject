//
//  ViewController.m
//  HuanChat_Test
//
//  Created by 花落丶微凉 on 16/2/24.
//  Copyright © 2016年 花落丶微凉. All rights reserved.
//

#import "ViewController.h"
#import "EMSDK.h"
//#import "ChatDemoHelper.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "EMClient.h"
#import "FriendsTableViewController.h"

@interface ViewController ()//<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;



@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.title = NSLocalizedString(<#key#>, <#comment#>)
    
//    _usernameTextField.delegate = self;
//    _passwordTextField.delegate = self;
    
    self.title = @"环信SDK学习";
    
    
}
//注册账号
- (IBAction)regiserButton:(UIButton *)sender
{
    //隐藏键盘
    [self.view endEditing:YES];
    
    [self registerUserWith:_usernameTextField.text
                       psw:_passwordTextField.text];
    
}



//登录
- (IBAction)loginButton:(UIButton *)sender
{
    [self.view endEditing:YES];
    
    [self loginWithUser:_usernameTextField.text
                    paw:_passwordTextField.text];
    
}


//- (IBAction)addFriend:(UIBarButtonItem *)sender
//{
//    
//    
//    EMError *error = [[EMClient sharedClient].contactManager addContact:[NSString stringWithFormat:@"%@",_usernameTextField.text] message:@"天王盖地虎,2333"];
//    
//    if (!error)
//    {
//        NSLog(@"添加成功");
//    }
//}

//注册
-(void)registerUserWith:(NSString *)userName psw:(NSString *)passWord
{
    if (userName.length == 0 || passWord.length == 0)
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"用户名或者密码不能为空" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancelAction = [UIAlertAction  actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancelAction];
        
        //弹出视图
        [self presentViewController:alert animated:YES completion:nil];
        
        return ;
    }
    EMError *error = [[EMClient sharedClient]registerWithUsername:userName
                                                        password:passWord];
    
    if (error == nil)
    {
        NSLog(@"注册成功");
    }

}
//登录
-(void)loginWithUser:(NSString *)userName paw:(NSString *)passWord
{
    if (userName.length == 0 ||passWord.length == 0)
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"警告" message:@"用户名或者密码不能为空" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction * cancelAction = [UIAlertAction  actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        
        [alert addAction:cancelAction];
        
        //弹出视图
        [self presentViewController:alert animated:YES completion:nil];
        
        return ;

    }
    EMError *error = [[EMClient sharedClient] loginWithUsername:userName
                                                       password:passWord];
    if (!error)
    {
        NSLog(@"登陆成功");

        
        //设置自动登录
        [[EMClient sharedClient].options setIsAutoLogin:YES];
     
        [self pushFriendList];
    }
    
}

//跳转
-(void)pushFriendList
{
    FriendsTableViewController * friendListVC = [[FriendsTableViewController alloc]init];
    
//    [self.navigationController pushViewController:friendListVC animated:YES];
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = friendListVC ;
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
