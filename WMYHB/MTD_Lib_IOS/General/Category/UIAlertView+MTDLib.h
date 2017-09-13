//
//  UIAlertView+MTDLib.h
//  dwframework
//
//  Created by jojo on 7/6/14.
//  Copyright (c) 2014 dw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (MTDLib)

/*
 
 This method only work if you want a one or two button alert view.
 This should do for 90% of use cases, if you need more button use the standard constructor.
 
 For a one button alert provide nil for both the right button title and action
 
 This method will create and display the alert and automatically invoke the given block
 when the button is tapped.
 
 
 Example usage:
 
 [UIAlertView displayAlertWithTitle:@"Example Alert View With Blocks"
 message:@"What is the meaning of life?"
 leftButtonTitle:@"41"
 leftButtonAction:^{
 NSLog(@"Incorrect");
 }
 rightButtonTitle:@"42"
 rightButtonAction:^{
 [UIAlertView displayAlertWithTitle:@"Result"
 message:@"You chose wisely"
 leftButtonTitle:@"Ok"
 leftButtonAction:nil
 rightButtonTitle:nil
 rightButtonAction:nil];
 }];
 
 
 */

+ (void) displayAlertWithTitle:(NSString *)title
                       message:(NSString *)message
               leftButtonTitle:(NSString *)leftButtonTitle
              leftButtonAction:(void (^)(void))leftButtonAction
              rightButtonTitle:(NSString*)rightButtonTitle
             rightButtonAction:(void (^)(void))rightButtonAction;

@end
