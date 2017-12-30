//
//  EasyShareSocialButton.h
//  EasyShareController
//
//  Created by pcjbird on 2017/12/30.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^EasyShareSocialButtonBlock)(UIButton * button);

@interface EasyShareSocialButton : UIButton

@property (nonatomic, copy) EasyShareSocialButtonBlock clickBlock;

@end
