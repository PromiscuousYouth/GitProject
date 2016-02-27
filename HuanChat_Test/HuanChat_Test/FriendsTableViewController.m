//
//  FriendsTableViewController.m
//  HuanChat_Test
//
//  Created by 花落丶微凉 on 16/2/27.
//  Copyright © 2016年 花落丶微凉. All rights reserved.
//

#import "FriendsTableViewController.h"
#import "AppDelegate.h"
#import "EaseMessageViewController.h"

@interface FriendsTableViewController ()<EMContactManagerDelegate>
{
    NSMutableArray * friendListArray ;
}
@end

@implementation FriendsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//    self.title = @"通讯录";
    
    friendListArray = [[NSMutableArray alloc]init];

    
    UITabBarController * mainTabBar = [[UITabBarController alloc]init];
    
    UINavigationController * mainNav = [[UINavigationController alloc]initWithRootViewController:mainTabBar];
    
    mainTabBar.viewControllers = @[self];
    
    
    UITabBarItem * item1 = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemFeatured tag:1];
    
    mainTabBar.title = @"通讯录";
    
    

    self.tabBarItem = item1 ;
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    window.rootViewController = mainNav;
    
    //注册tableView
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
    
    
    //设置代理
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    
    //获得好友列表
    EMError * error = nil ;
    
    NSArray * userList = [[EMClient sharedClient].contactManager getContactsFromServerWithError:&error];
    if (!error)
    {
        NSLog(@"%@",userList);
        if (userList.count == 0)
        {
            userList = [[EMClient sharedClient].contactManager getBlackListFromDB];
        }
        [friendListArray setArray:userList];
        [self.tableView reloadData];
    }
    
}
-(void)didReceiveFriendInvitationFromUsername:(NSString *)aUsername
                                      message:(NSString *)aMessage
{
    NSLog(@"%@%@",aUsername,aMessage);
    
    //同意好友请求
    EMError *error = [[EMClient sharedClient].contactManager acceptInvitationForUsername:aUsername];
    if (!error) {
        NSLog(@"发送同意成功");
    
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return friendListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.textLabel.text = friendListArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *userName = friendListArray[indexPath.row];
    
    EaseMessageViewController *chatController = [[EaseMessageViewController alloc] initWithConversationChatter:userName conversationType:EMConversationTypeChat];
    
    chatController.title = [NSString stringWithFormat:@"正在与%@聊天中",friendListArray[indexPath.row]];
    
    [self.navigationController pushViewController:chatController animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
