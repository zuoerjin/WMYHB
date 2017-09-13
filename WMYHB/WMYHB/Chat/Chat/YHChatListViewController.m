//
//  YHChatListViewController.m
//  WMYHB
//
//  Created by wangjian on 2017/9/12.
//  Copyright © 2017年 wangjian. All rights reserved.
//

#import "YHChatListViewController.h"
#import "DemoCallManager.h"

@interface YHChatListViewController ()
{
    __weak IBOutlet UIButton *btn1;
    __weak IBOutlet UIButton *btn2;
    __weak IBOutlet UIButton *btn3;
    
    __weak IBOutlet UIButton *btn4;
}

@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *psw;

@end

@implementation YHChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"TEST";
    
    btn1.selected = YES;
    btn2.selected = NO;
    btn3.selected = NO;
    btn4.selected = NO;

    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"Resolution"];
    
//    EMError *error = [[EMClient sharedClient] registerWithUsername:@"8001" password:@"111111"];

    
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)login:(id)sender {
    
    [self.username resignFirstResponder];
    [self.psw resignFirstResponder];
    
    [[EMClient sharedClient] loginWithUsername:self.username.text
                                      password:self.psw.text
                                    completion:^(NSString *aUsername, EMError *aError) {
                                        if (!aError) {
                                            
                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录成功" message:@"可点击下方进入聊天页面" delegate:nil
                                                                                  cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                                            
                                            [alert show];
                                            NSLog(@"登录成功");
                                        } else {
                                            
                                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"登录失败" message:aError.errorDescription delegate:nil
                                                                                  cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                                            
                                            [alert show];

                                            NSLog(@"登录失败");
                                        }
                                    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)test:(id)sender {
    
    [DemoCallManager sharedManager];
    
    NSString *name = @"";
    
    if ([self.username.text isEqualToString:@"8001"]) {
     
        name = @"8002";
    } else {
        
        name = @"8001";
    }

    EaseMessageViewController *chatController = [[EaseMessageViewController alloc] initWithConversationChatter:name conversationType:EMConversationTypeChat];

    [self.navigationController pushViewController:chatController animated:YES];
}
- (IBAction)a:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"Resolution"];

    btn1.selected = YES;
    btn2.selected = NO;
    btn3.selected = NO;
    btn4.selected = NO;

}
- (IBAction)b:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"Resolution"];

    btn1.selected = NO;
    btn2.selected = YES;
    btn3.selected = NO;
    btn4.selected = NO;

}
- (IBAction)c:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"3" forKey:@"Resolution"];

    btn1.selected = NO;
    btn2.selected = NO;
    btn3.selected = YES;
    btn4.selected = NO;

}
- (IBAction)d:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] setObject:@"4" forKey:@"Resolution"];

    btn1.selected = NO;
    btn2.selected = NO;
    btn3.selected = NO;
    btn4.selected = YES;

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
