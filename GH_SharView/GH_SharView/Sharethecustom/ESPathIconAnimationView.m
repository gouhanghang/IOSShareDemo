//
//  ViewController.m
//  GH_SharView
//
//  Created by 苟应航 on 2018/3/27.
//  Copyright © 2018年 GouHang. All rights reserved.
//

#import "ESPathIconAnimationView.h"
#import "ESPathIcon.h"
#import "THelper.h"
#import <AVFoundation/AVFoundation.h>
#define bigIcon_R 176
#define nearbyIcon_R 40
#define farIcon_R 20
#define xGap 5

@implementation ESPathIconAnimationView

{
    SystemSoundID soundID;
    
    ShopType _shopType;
    
    UILabel *_bigIcon;
    BOOL _isDoubleClickIcon;//解决同时点击多个icon的BUG
    
    NSMutableArray *_pathIcons;
    BOOL _isOpenIcon;
    
    CAKeyframeAnimation *animationOpen;
    CAKeyframeAnimation *animationClose;
}

- (id)initWithFrame:(CGRect)frame withShowType:(ShopType)shopType
{
    self = [super initWithFrame:frame];
    if (self) {
        _shopType = shopType;
        _isOpenIcon = YES;
        //注册一个系统声音
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"get_notification" ofType:@"wav"];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &soundID);
        //播放系统声音提示用户
        AudioServicesPlaySystemSound(soundID);
        //震动
//        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews{
    //
    _bigIcon = [UILabel new];
    _bigIcon.frame = CGRectMake(self.width-40-20, 25, 40, 40);
    [self addSubview:_bigIcon];
    NSMutableArray *imgName;
        imgName = [NSMutableArray arrayWithObjects:@"popMenu_dingtalk",@"popMenu_qq",@"popMenu_weibo",@"popMenu_weixin_friend",@"popMenu_weixin",nil];
    __weak ESPathIconAnimationView *this = self;
    long int count = imgName.count - 1;
    _pathIcons = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        __block ESPathIcon *pathIcon = [[ESPathIcon alloc] initWithImageName:imgName[i] withLabelTitle:@""];
        float offx = [THelper cos:(90/count)*i];
        float offy = [THelper sin:(90/count)*i];
            pathIcon.endPoint = CGPointMake(_bigIcon.center.x - bigIcon_R*offx, _bigIcon.center.y + bigIcon_R*offy);
            //动画中间 较远点
            pathIcon.farPoint = CGPointMake(pathIcon.endPoint.x - farIcon_R*offx, pathIcon.endPoint.y + farIcon_R*offy);
            //动画中间较近点
            pathIcon.nearbyPoint = CGPointMake(pathIcon.endPoint.x + nearbyIcon_R*offx, pathIcon.endPoint.y - nearbyIcon_R*offy);
     //作为动画其实位置
//        pathIcon.center = _bigIcon.center;
        pathIcon.center =CGPointMake(-10, -10);
        [_pathIcons addObject:pathIcon];
        //动画起始点
        pathIcon.startPoint = _bigIcon.center;
        
        //按钮的点击事件。
        pathIcon.block = ^(id result){
            if (_isDoubleClickIcon) {//解决同时点击多个icon的BUG
                return;
            }//不重置_isDoubleClickIcon是因为动画完后，视图已近销毁
            _isDoubleClickIcon = YES;
            //
            [UIView animateWithDuration:0.2 animations:^{
                _bigIcon.transform = CGAffineTransformMakeScale(0.2, 0.2);
                _bigIcon.alpha = 0.3;
            } completion:^(BOOL finished) {
                _bigIcon.hidden = YES;
            }];
            //
            for (ESPathIcon *pathIcons in _pathIcons) {
                if (pathIcons == result) {
                    [UIView animateWithDuration:0.2 animations:^{
                        pathIcons.transform = CGAffineTransformMakeScale(1.8, 1.8);
                        pathIcons.alpha = 0.3;
                    } completion:^(BOOL finished) {
                        pathIcons.hidden = YES;
                    }];
                }else{
                    [UIView animateWithDuration:0.2 animations:^{
                        pathIcons.transform = CGAffineTransformMakeScale(0.2, 0.2);
                        pathIcons.alpha = 0.3;
                    } completion:^(BOOL finished) {
                        pathIcons.hidden = YES;
                    }];
                }
            }
            NSString *indexString = [NSString stringWithFormat:@"%d",i+10];
            [this performSelector:@selector(afteDelayRespodsToSelectorDelegate:) withObject:indexString afterDelay:0.3];
        };
        [self insertSubview:pathIcon belowSubview:_bigIcon];
    }
    [self addAnimationToIcon];
}
//延迟 等动画结束后 在调用其它方法（如：push）
- (void)afteDelayRespodsToSelectorDelegate:(NSString *)index{
    if ([self.delegate respondsToSelector:@selector(selectedIconIndex:withType:)]) {
        [self.delegate selectedIconIndex:[index intValue] withType:_shopType];
    }

}
//运行动画
- (void)addAnimationToIcon{
    //_bigIcon animation
    _bigIcon.userInteractionEnabled = NO;
    
    if (_isOpenIcon) {
//        [ESHelper exchangeArrayItem:_pathIcons];
    }else{//交换icon，使的收起时按（后——>先）顺序收起
        [THelper exchangeArrayItem:_pathIcons];
    }
    //_pathIcon animation
    for (int i = 0; i < _pathIcons.count; i++) {
        ESPathIcon *pathIcon = _pathIcons[i];
        if (_isOpenIcon) {
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path,NULL,pathIcon.startPoint.x,pathIcon.startPoint.y);
            CGPathAddLineToPoint(path, NULL, pathIcon.farPoint.x, pathIcon.farPoint.y);
            CGPathAddLineToPoint(path, NULL, pathIcon.nearbyPoint.x, pathIcon.nearbyPoint.y);
            CGPathAddLineToPoint(path, NULL, pathIcon.endPoint.x, pathIcon.endPoint.y);
            
            //创建 实例
            animationOpen = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            animationOpen.delegate = self;
            //设置path属性
            animationOpen.path = path;
            CGPathRelease(path);
            [animationOpen setDuration:animation_Time];
            animationOpen.fillMode = kCAFillModeForwards;
            animationOpen.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            pathIcon.animation = animationOpen;
            [self performSelector:@selector(afterDelayAddAnimation:) withObject:pathIcon afterDelay:i*animation_Time_Gap];
        }else{
            CGMutablePathRef path = CGPathCreateMutable();
            CGPathMoveToPoint(path, NULL, pathIcon.endPoint.x, pathIcon.endPoint.y);
            CGPathAddLineToPoint(path, NULL, pathIcon.nearbyPoint.x, pathIcon.nearbyPoint.y);
            CGPathAddLineToPoint(path, NULL, pathIcon.farPoint.x, pathIcon.farPoint.y);
            CGPathAddLineToPoint(path,NULL,pathIcon.startPoint.x,pathIcon.startPoint.y);
            
            //创建 实例
            animationClose = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            animationClose.delegate = self;
            //设置path属性
            animationClose.path = path;
            CGPathRelease(path);
            [animationClose setDuration:animation_Time];
            animationClose.fillMode = kCAFillModeForwards;
            animationClose.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
            pathIcon.animation = animationClose;
            [self performSelector:@selector(afterDelayAddAnimation:) withObject:pathIcon afterDelay:i*animation_Time_Gap];
            
        }
    }
    //延迟 等动画结束后在设置_isOpenIcon
    [self performSelector:@selector(setIsOpen) withObject:nil afterDelay:animation_Time + animation_Time_Gap*(_pathIcons.count - 1)];
}

- (void)setIsOpen{
    _isOpenIcon = !_isOpenIcon;
    _bigIcon.userInteractionEnabled = YES;
}
//一次先——>后顺序展开icon
- (void)afterDelayAddAnimation:(ESPathIcon *)pathIcon{
    if (_isOpenIcon) {
        [pathIcon.layer addAnimation:pathIcon.animation forKey:NULL];
        pathIcon.center = pathIcon.endPoint;//出现动画后的样式。
    }else{
        [pathIcon.layer addAnimation:pathIcon.animation forKey:NULL];
//        作为动画结束位置
//        pathIcon.center = pathIcon.startPoint;
        pathIcon.center = CGPointMake(-10, -10);
        
    }
    
}

@end
