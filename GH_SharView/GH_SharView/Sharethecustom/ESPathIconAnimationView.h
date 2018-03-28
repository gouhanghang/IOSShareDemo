//
//  ViewController.m
//  GH_SharView
//
//  Created by 苟应航 on 2018/3/27.
//  Copyright © 2018年 GouHang. All rights reserved.
//


#import <UIKit/UIKit.h>

#define animation_Time 0.6
#define animation_Time_Gap 0.1

typedef enum {
    BUSINESS = 0,
    SHOP,
    BUILDING,
    WORKSHOP
} ShopType;

@class ESPathIconAnimationView;

@protocol ESPathIconAnimationViewDelegate <NSObject>

- (void)selectedIconIndex:(int)index withType:(ShopType)shopType;

@end

@interface ESPathIconAnimationView : UIView


@property (nonatomic,weak)id<ESPathIconAnimationViewDelegate> delegate;

@property (nonatomic,assign)BOOL isOpenIcon;


- (id)initWithFrame:(CGRect)frame withShowType:(ShopType)type;

- (void)addAnimationToIcon;

@end
