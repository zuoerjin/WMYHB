//
//  YHChatListViewController.m
//  WMYHB
//
//  Created by wangjian on 2017/9/12.
//  Copyright © 2017年 wangjian. All rights reserved.
//

#import "YHChatListViewController.h"

@interface YHChatListViewController ()

@end

@implementation YHChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"1221";
    
//    EMError *error = [[EMClient sharedClient] registerWithUsername:@"8001" password:@"111111"];

    [[EMClient sharedClient] loginWithUsername:@"8001"
                                      password:@"111111"
                                    completion:^(NSString *aUsername, EMError *aError) {
                                        if (!aError) {
                                            NSLog(@"登录成功");
                                        } else {
                                            NSLog(@"登录失败");
                                        }
                                    }];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)test:(id)sender {
    
    EaseMessageViewController *chatController = [[EaseMessageViewController alloc] initWithConversationChatter:@"8002" conversationType:EMConversationTypeChat];

    [self.navigationController pushViewController:chatController animated:YES];
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
