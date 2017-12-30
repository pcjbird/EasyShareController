//
//  EasyShareSocialItem.m
//  EasyShareController
//
//  Created by pcjbird on 2017/12/30.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import "EasyShareSocialItem.h"

@interface EasyShareSocialItem()

@property(nonatomic, strong) id  icon;
@property(nonatomic, strong) id  highlightIcon;
@property(nonatomic, strong) NSString* title;
@property(nonatomic, copy) void(^shareAction)(EasyShareSocialItem* item);

@end


@implementation EasyShareSocialItem

-(instancetype) initWithIcon:(id)icon highlightIcon:(id)highlightIcon title:(NSString*)title action:(void(^)(EasyShareSocialItem* item))shareAction
{
    if(self = [super init])
    {
        _icon = icon;
        _highlightIcon = highlightIcon;
        _title = title;
        _shareAction = shareAction;
    }
    return self;
}

+(instancetype) itemWithIcon:(id)icon highlightIcon:(id)highlightIcon title:(NSString*)title action:(void(^)(EasyShareSocialItem* item))shareAction
{
    return [[EasyShareSocialItem alloc] initWithIcon:icon highlightIcon:highlightIcon title:title action:shareAction];
}

@end
