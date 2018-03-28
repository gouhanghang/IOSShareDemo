//
//  ViewController.m
//  GH_SharView
//
//  Created by 苟应航 on 2018/3/27.
//  Copyright © 2018年 GouHang. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()<ESPathIconAnimationViewDelegate>
{
    UIView *_bgView;
    UITapGestureRecognizer *_tap;
    ESPathIconAnimationView *_pathIconBusicessView;
    ESPathIconAnimationView *_pathIconShopView;
    ESPathIconAnimationView *_pathIconBuildView;
    ESPathIconAnimationView *_pathIconWorkShopView;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *sharebtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [sharebtn setImage:[UIImage imageNamed:@"shareicon"] forState:UIControlStateNormal];
    [sharebtn addTarget:self action:@selector(actionshare) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sharebtn];
    [sharebtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(20);
        make.width.height.mas_equalTo(50);
    }];
}
-(void)actionshare{
    if (_bgView != nil) {
        return;
    }
    if (_bgView == nil) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
        _bgView.backgroundColor =[UIColor clearColor]; //RGBA(0, 0, 0, 0.7);
         [self.view addSubview:_bgView];
        
        UIImageView *shareimage=[UIImageView new];
        shareimage.image=[UIImage imageNamed:@"bgimages"];
        [_bgView addSubview:shareimage];
        [shareimage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_bgView.mas_top);
            make.width.height.mas_equalTo(250);
            make.right.mas_equalTo(_bgView.mas_right);
        }];
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenBgView:)];
        _tap.enabled = NO;//先禁用掉，防止多次点击，特别是动画还没结束
        [_bgView addGestureRecognizer:_tap];
        [self performSelector:@selector(setTapEnabled:) withObject:_tap afterDelay:animation_Time + animation_Time_Gap*3];
    }
    _bgView.hidden = NO;
    if (_pathIconShopView == nil) {
        _pathIconShopView = [[ESPathIconAnimationView alloc] initWithFrame:CGRectMake(0, 0, _bgView.width, _bgView.height) withShowType:SHOP];
        _pathIconShopView.delegate = self;
        [_bgView addSubview:_pathIconShopView];
    }else{
        _pathIconBusicessView.hidden = YES;
        _pathIconShopView.hidden = NO;
        _pathIconBuildView.hidden = YES;
        _pathIconWorkShopView.hidden = YES;
        [_pathIconShopView addAnimationToIcon];
    }
    
}

- (void)setTapEnabled:(UITapGestureRecognizer *)tap{
    tap.enabled = YES;
}

- (void)hiddenBgView:(UITapGestureRecognizer *)tap{
    tap.enabled = NO;//先禁用掉，防止多次点击，特别是动画还没结束
    float delayTime = animation_Time+animation_Time_Gap*3;
    [_pathIconShopView addAnimationToIcon];
    [self performSelector:@selector(afterDelayHiddenBgView:) withObject:tap afterDelay:delayTime];
}
- (void)afterDelayHiddenBgView:(UITapGestureRecognizer *)tap{
    for (int i = 0; i < _pathIconShopView.subviews.count; i++) {
        UIView *view = _pathIconShopView.subviews[i];
        if (view.superview) {
            [view removeFromSuperview];
            view = nil;
        }
    }
    _pathIconShopView.hidden = !_pathIconShopView.hidden;
    if (_pathIconShopView.superview) {
        [_pathIconShopView removeFromSuperview];
        _pathIconShopView = nil;
    }
    _bgView.hidden = !_bgView.hidden;
    if (_bgView.superview) {
        [_bgView removeGestureRecognizer:_tap];
        [_bgView removeFromSuperview];
        _bgView = nil;
    }
}
-(void)selectedIconIndex:(int)index withType:(ShopType)shopType{
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
