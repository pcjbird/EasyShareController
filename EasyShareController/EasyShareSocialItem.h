//
//  EasyShareSocialItem.h
//  EasyShareController
//
//  Created by pcjbird on 2017/12/30.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EasyShareSocialItem : NSObject

@property(nonatomic, strong, readonly) id  icon;
@property(nonatomic, strong, readonly) id  highlightIcon;
@property(nonatomic, strong, readonly) NSString* title;
@property(nonatomic, copy, readonly) void(^shareAction)(EasyShareSocialItem* item);

+(instancetype) itemWithIcon:(id)icon highlightIcon:(id)highlightIcon title:(NSString*)title action:(void(^)(EasyShareSocialItem* item))shareAction;

@end
