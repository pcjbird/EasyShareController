//
//  EasyShareController.m
//  EasyShareController
//
//  Created by pcjbird on 2017/12/29.
//  Copyright © 2017年 Zero Status. All rights reserved.
//

#import "EasyShareController.h"
#import "EasyShareSocialButton.h"

#define SocialItemOriginX 15.0 //icon起点X坐标
#define SocialItemOriginY 15.0 //icon起点Y坐标
#define SocialItemIconWidth 57.0 //正方形图标宽度
#define SocialItemIconAndTitleSpace 10.0 //图标和标题间的间隔
#define SocialItemTitleSize 10.0 //标签字体大小
#define SocialItemTitleColor [UIColor colorWithRed:52/255.0 green:52/255.0 blue:50/255.0 alpha:1.0] //标签字体颜色
#define SocialItemLastlySpace 15.0 //尾部间隔
#define SocialItemXHorizontalSpace 15.0 //横向间距
#define UIKitLocalizedString(key) [[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] localizedStringForKey:key value:@"" table:nil]

@interface EasyShareController ()<UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>

@property (nonatomic, assign) BOOL isPresenting;
@property (nonatomic, strong) NSArray<EasyShareSocialItem *>* items;
@property (nonatomic, assign) NSInteger firstRowCount;

@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *sheetView;
@property (nonatomic, strong) UIView *bodyView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, weak) UITapGestureRecognizer *singleTap;

@end

@implementation EasyShareController

#pragma mark - init

- (instancetype)init
{
    if (self = [super init]) {
        [self configureController];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self configureController];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self configureController];
    }
    return self;
}

- (instancetype)initWithArray:(NSArray<EasyShareSocialItem*>*)array firstRowCount:(NSInteger)count
{
    if (self = [super init]) {
        [self configureController];
        if ([array isKindOfClass:[NSArray<EasyShareSocialItem*> class]]) {
            _items = [array copy];
            _firstRowCount = (count == 0) ? [_items count] : MIN([_items count], count);
        }
    }
    return self;
}

+ (instancetype)shareControllerWithArray:(NSArray<EasyShareSocialItem*>*)array firstRowCount:(NSInteger)count
{
    return [[EasyShareController alloc] initWithArray:array firstRowCount:count];
}

#pragma mark - configure

- (void)configureController
{
    _isPresenting = YES;
    self.providesPresentationContextTransitionStyle = YES;
    self.definesPresentationContext = YES;
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
    
    _maskColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.6];
    _maskTapDismissEnable = YES;
    _sheetBackColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:0.9];
    
    _items = [NSArray array];
    _firstRowCount = 0;
    _shareTitle = nil;
    _showTitleAsWebProvider = NO;
    _showTitleAlignmentLeft = NO;
    _cancelTitle = UIKitLocalizedString(@"Cancel");
    
    _headerView = nil;
    _footerView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    [self addMaskView];
    [self addSingleTapGesture];
    [self addSheetView];
    [self.view layoutIfNeeded];
}

- (void)addMaskView
{
    if (![_maskView isKindOfClass:[UIView class]])
    {
        UIView *maskView = [UIView new];
        maskView.backgroundColor = _maskColor;
        _maskView = maskView;
    }
    _maskView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view insertSubview:_maskView atIndex:0];
    _maskView.frame = [UIScreen mainScreen].bounds;
    _maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

-(void)setMaskColor:(UIColor *)maskColor
{
    _maskColor = maskColor;
    _maskView.backgroundColor = maskColor;
}

- (void)addSingleTapGesture
{
    self.view.userInteractionEnabled = YES;
    _maskView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    singleTap.enabled = _maskTapDismissEnable;
    
    [_maskView addGestureRecognizer:singleTap];
    _singleTap = singleTap;
}

-(void)setMaskTapDismissEnable:(BOOL)maskTapDismissEnable
{
    _maskTapDismissEnable = maskTapDismissEnable;
    _singleTap.enabled = maskTapDismissEnable;
}

-(void)addSheetView
{
    if (![_sheetView isKindOfClass:[UIView class]])
    {
        CGFloat height = 0.0f;
        //header
        if(_headerView)
        {
            height += CGRectGetHeight(_headerView.frame);
        }
        else if([self.shareTitle isKindOfClass:[NSString class]] && [self.shareTitle length] > 0)
        {
            height += 30.0f;
        }
        //footer
        if(_footerView)
        {
            height += CGRectGetHeight(_footerView.frame);
        }
        height += 8.0f;
        //cancel button
        height += 50.0f;
        //iPhoneX iPhoneXR iPhone XS iPhone XS Max
        if(CGRectGetHeight([UIScreen mainScreen].bounds) == 812.0f || CGRectGetHeight([UIScreen mainScreen].bounds) == 896.0f)
        {
            height += 34.0f;
        }
        //social items
        height += [self bodyHeight];
        
        _sheetView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds) - height, CGRectGetWidth([UIScreen mainScreen].bounds), height)];
        _sheetView.backgroundColor = _sheetBackColor;
        _sheetView.userInteractionEnabled = YES;
        [self.view addSubview:_sheetView];
        [self addHeaderView];
        [self addBodyView];
        [self addFooterView];
        [self addCancelButton];
    }
}

-(void)addHeaderView
{
    if(![_headerView isKindOfClass:[UIView class]] && [self.shareTitle isKindOfClass:[NSString class]] && [self.shareTitle length] > 0)
    {
        UIView* headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 30.0f)];
        headerView.backgroundColor = [UIColor clearColor];
        
        CGFloat fontSize = self.showTitleAsWebProvider ? 11.0f : 15.0f;
        CGFloat top = self.showTitleAsWebProvider ? 9.0f : 17.0f;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16.0f, top, headerView.frame.size.width-32.0f, fontSize)];
        label.textAlignment = _showTitleAlignmentLeft ? NSTextAlignmentJustified : NSTextAlignmentCenter;
        label.textColor = self.showTitleAsWebProvider ? [UIColor colorWithRed:99/255.0 green:98/255.0 blue:98/255.0 alpha:1.0] : [UIColor colorWithRed:51/255.0 green:68/255.0 blue:79/255.0 alpha:1.0];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:fontSize];
        label.adjustsFontSizeToFitWidth = YES;
        label.text = self.shareTitle;
        [headerView addSubview:label];
        _headerView = headerView;
        [self.sheetView addSubview:_headerView];
    }
    else if([_headerView isKindOfClass:[UIView class]])
    {
        _headerView.frame = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight(_headerView.frame));
        [self.sheetView addSubview:_headerView];
    }
}

-(void) addBodyView
{
    if (![_bodyView isKindOfClass:[UIView class]])
    {
        CGFloat top = 0;
        if([_headerView isKindOfClass:[UIView class]])
        {
            top += CGRectGetHeight(_headerView.frame);
        }
        _bodyView = [[UIView alloc] initWithFrame:CGRectMake(0, top, CGRectGetWidth([UIScreen mainScreen].bounds), [self bodyHeight])];
        _bodyView.backgroundColor = [UIColor clearColor];
        _bodyView.userInteractionEnabled = YES;
        
        NSInteger rows = [self bodyRows];
        if(rows > 0)
        {
            {
                UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), [self bodyRowHeight])];
                scrollView.backgroundColor = [UIColor clearColor];
                scrollView.showsVerticalScrollIndicator = NO;
                scrollView.showsHorizontalScrollIndicator = NO;
                scrollView.contentSize = CGSizeMake(SocialItemOriginX + _firstRowCount * (SocialItemIconWidth + SocialItemXHorizontalSpace), [self bodyRowHeight]);
                [_bodyView addSubview:scrollView];
                for (NSInteger i = 0; i < _firstRowCount; i++) {
                    EasyShareSocialItem * item = [_items objectAtIndex:i];
                    CGRect frame = CGRectMake(SocialItemOriginX + i*(SocialItemIconWidth + SocialItemXHorizontalSpace), SocialItemOriginY, SocialItemIconWidth, SocialItemIconWidth+SocialItemIconAndTitleSpace+SocialItemTitleSize);
                    UIView * view = [self createSocialItemView:item frame:frame];
                    if([view isKindOfClass:[UIView class]])
                    {
                        [scrollView addSubview:view];
                    }
                }
            }
            
            if(rows > 1)
            {
                UIView * line = [[UIView alloc] initWithFrame:CGRectMake(10, [self bodyRowHeight]+0.25f, CGRectGetWidth([UIScreen mainScreen].bounds) - 20, 0.5f)];
                line.backgroundColor = [UIColor colorWithRed:208/255.0 green:208/255.0 blue:208/255.0 alpha:1.0];
                [_bodyView addSubview:line];
                line.translatesAutoresizingMaskIntoConstraints = NO;
                line.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
                
                UIScrollView * scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, [self bodyRowHeight] + 1, CGRectGetWidth([UIScreen mainScreen].bounds), [self bodyRowHeight])];
                scrollView.backgroundColor = [UIColor clearColor];
                scrollView.showsVerticalScrollIndicator = NO;
                scrollView.showsHorizontalScrollIndicator = NO;
                scrollView.contentSize = CGSizeMake(SocialItemOriginX + ([_items count] - _firstRowCount) * (SocialItemIconWidth + SocialItemXHorizontalSpace), [self bodyRowHeight]);
                [_bodyView addSubview:scrollView];
                NSInteger totalCount = [_items count];
                for (NSInteger i = _firstRowCount; i < totalCount; i++) {
                    EasyShareSocialItem * item = [_items objectAtIndex:i];
                    CGRect frame = CGRectMake(SocialItemOriginX + (i-_firstRowCount)*(SocialItemIconWidth + SocialItemXHorizontalSpace), SocialItemOriginY, SocialItemIconWidth, SocialItemIconWidth+SocialItemIconAndTitleSpace+SocialItemTitleSize);
                    UIView * view = [self createSocialItemView:item frame:frame];
                    if([view isKindOfClass:[UIView class]])
                    {
                        [scrollView addSubview:view];
                    }
                }
            }
        }
        [self.sheetView addSubview:_bodyView];
    }
}

-(UIView*) createSocialItemView:(EasyShareSocialItem *)item frame:(CGRect) frame
{
    if([item isKindOfClass:[EasyShareSocialItem class]])
    {
        UIImage * icon = nil;
        if([item.icon isKindOfClass:[UIImage class]])
        {
            icon = item.icon;
        }
        else if([item.icon isKindOfClass:[NSString class]])
        {
            icon =  [UIImage imageNamed:item.icon];
        }
        
        UIImage * highlightIcon = nil;
        if([item.highlightIcon isKindOfClass:[UIImage class]])
        {
            highlightIcon = item.highlightIcon;
        }
        else if([item.highlightIcon isKindOfClass:[NSString class]])
        {
            highlightIcon =  [UIImage imageNamed:item.highlightIcon];
        }

        CGFloat imageWidth = icon ? icon.size.width : SocialItemIconWidth;
        CGFloat imageHeight = icon ? icon.size.height : SocialItemIconWidth;
        
        UIView *view = [[UIView alloc] initWithFrame:frame];
        view.backgroundColor = [UIColor clearColor];
        
        EasyShareSocialButton *button = [EasyShareSocialButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((CGRectGetWidth(view.frame) - imageWidth)/2, 0, imageWidth, imageHeight);
        button.titleLabel.font = [UIFont systemFontOfSize:SocialItemTitleSize];
        [button setTitle:@"" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
        if (icon)
        {
            [button setImage:icon forState:UIControlStateNormal];
        }
        if (highlightIcon)
        {
            [button setImage:highlightIcon forState:UIControlStateHighlighted];
        }
        __weak typeof(self) weakSelf = self;
        __weak typeof (item) weakItem = item;
        button.clickBlock = ^(UIButton *button) {
            [weakSelf dismissViewControllerAnimated:YES completion:^{
                if(item.shareAction)item.shareAction(weakItem);
            }];
        };
        [view addSubview:button];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.origin.y +button.frame.size.height+ SocialItemLastlySpace, view.frame.size.width, SocialItemTitleSize)];
        label.textColor = SocialItemTitleColor;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:SocialItemTitleSize];
        label.text = item.title;
        [view addSubview:label];
        
        return view;
    }
    
    return nil;
}

-(NSInteger) bodyRows
{
    NSInteger itemCount = [_items count];
    NSInteger firstRowCount = _firstRowCount;
    NSInteger rows = 0;
    if(itemCount > 0)
    {
        if((firstRowCount == 0) || (itemCount <= firstRowCount))
        {
            rows = 1;
        }
        else
        {
            rows = 2;
        }
    }
    return rows;
}

-(CGFloat) bodyHeight
{
    CGFloat height = 0.0f;
    NSInteger rows = [self bodyRows];
    
    if(rows == 0)
    {
        height += 10.0f;
    }
    else
    {
        height +=  [self bodyRowHeight] * rows;
        if(rows == 2) height += 1.0f;
    }
    return height;
}

-(CGFloat) bodyRowHeight
{
    return (SocialItemOriginY + SocialItemIconWidth + SocialItemIconAndTitleSpace + SocialItemTitleSize + SocialItemLastlySpace);
}

-(void) addFooterView
{
    if ([_footerView isKindOfClass:[UIView class]])
    {
        _footerView.frame = CGRectMake(0, CGRectGetMaxY(_bodyView.frame), CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight(_footerView.frame));
        [self.sheetView addSubview:_footerView];
    }
}

-(void) addCancelButton
{
    if (![_cancelButton isKindOfClass:[UIView class]])
    {
        CGFloat buttonHeight = 50.0f;
        CGFloat top = CGRectGetHeight(_sheetView.bounds);
        top -= buttonHeight;
        //iPhoneX iPhoneXR iPhone XS iPhone XS Max
        if(CGRectGetHeight([UIScreen mainScreen].bounds) == 812.0f || CGRectGetHeight([UIScreen mainScreen].bounds) == 896.0f)
        {
            top -= 34.0f;
        }
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(0, top, CGRectGetWidth([UIScreen mainScreen].bounds), buttonHeight);
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:16];
        [_cancelButton setTitle:_cancelTitle forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[self imageWithColor:[UIColor whiteColor] size:CGSizeMake(1.0, 1.0)] forState:UIControlStateNormal];
        [_cancelButton setBackgroundImage:[self imageWithColor:[UIColor colorWithRed:234/255.0 green:234/255.0 blue:234/255.0 alpha:1.0] size:CGSizeMake(1.0, 1.0)] forState:UIControlStateHighlighted];
        [_cancelButton addTarget:self action:@selector(cancleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.sheetView addSubview:_cancelButton];
    }
}


-(void)setHeaderView:(UIView *)headerView
{
    if([_headerView isKindOfClass:[UIView class]])
    {
        [_headerView removeFromSuperview];
    }
    _headerView = headerView;
}

-(void)setFooterView:(UIView *)footerView
{
    if([_footerView isKindOfClass:[UIView class]])
    {
        [_footerView removeFromSuperview];
    }
    _footerView = footerView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action

- (void)singleTap:(UITapGestureRecognizer *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)cancleButtonAction:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (_isPresenting) {
        [self presentAnimateTransition:transitionContext];
    }else {
        [self dismissAnimateTransition:transitionContext];
    }
}


- (void)presentAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    EasyShareController *shareController = (EasyShareController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    shareController.maskView.alpha = 0.0;
    shareController.sheetView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(shareController.sheetView.frame));
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:shareController.view];
    
    [UIView animateWithDuration:0.25 animations:^{
        shareController.maskView.alpha = 1.0;
        shareController.sheetView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
    
}

- (void)dismissAnimateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    EasyShareController *shareController = (EasyShareController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [UIView animateWithDuration:0.25 animations:^{
        shareController.maskView.alpha = 0.0;
        shareController.sheetView.transform = CGAffineTransformMakeTranslation(0, CGRectGetHeight(shareController.sheetView.frame));
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:YES];
    }];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    _isPresenting = YES;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    _isPresenting = NO;
    return self;
}

#pragma mark - 颜色生成图片方法
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context,
                                   
                                   color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
@end
