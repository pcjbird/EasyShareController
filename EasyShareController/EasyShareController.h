//
//  EasyShareController.h
//  EasyShareController
//
//  Created by pcjbird on 2017/12/29.
//  Copyright © 2017年 Zero Status. All rights reserved.
//
//  框架名称:EasyShareController
//  框架功能:一款让社交分享变得简单的视图控制器。
//  修改记录:
//     pcjbird    2017-12-30  Version:1.0.0 Build:201712300001
//                            1.首次发布SDK版本

#import <UIKit/UIKit.h>
#import <EasyShareController/EasyShareSocialItem.h>

/*
 * @brief 一款让社交分享变得简单的视图控制器。
 */
@interface EasyShareController : UIViewController

/*
 * @brief 蒙板颜色
 */
@property (nonatomic, strong) UIColor *maskColor;
/*
 * @brief 蒙板点击是否允许关闭当前视图控制器，默认 YES
 */
@property (nonatomic, assign) BOOL maskTapDismissEnable;
/*
 * @brief sheet背景色
 */
@property (nonatomic, strong) UIColor *sheetBackColor;
/*
 * @brief 标题 默认为nil
 */
@property (nonatomic, strong) NSString* shareTitle;
/*
 * @brief 是否将标题显示为网页提供者样式  默认 NO
 */
@property (nonatomic, assign) BOOL  showTitleAsWebProvider;
/*
 * @brief 取消按钮标题 默认为Cancel
 */
@property (nonatomic, strong) NSString* cancelTitle;
/*
 * @brief 头部自定义View, 默认系统会根据标题参数情况创建默认头部View
 */
@property (nonatomic,strong) UIView *headerView;
/*
 * @brief 尾部自定义View, 默认为nil
 */
@property (nonatomic,strong) UIView *footerView;

+ (instancetype)shareControllerWithArray:(NSArray<EasyShareSocialItem*>*)array firstRowCount:(NSInteger)count;

@end
