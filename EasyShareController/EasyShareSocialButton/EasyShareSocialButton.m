//
//  EasyShareSocialButton.m
//  EasyShareController
//
//  Created by pcjbird on 2017/12/30.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import "EasyShareSocialButton.h"

@implementation EasyShareSocialButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addTarget:self action:@selector(doAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)doAction:(UIButton *)button {
    if(self.clickBlock)self.clickBlock(button);
}

@end
