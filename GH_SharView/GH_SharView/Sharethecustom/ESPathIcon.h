//
//  ViewController.m
//  GH_SharView
//
//  Created by 苟应航 on 2018/3/27.
//  Copyright © 2018年 GouHang. All rights reserved.
//


#import <UIKit/UIKit.h>

typedef void (^CliciIconBlock) (id result);

@interface ESPathIcon : UIView

{
    CGPoint _startPoint;
    CGPoint _nearbyPoint;
    CGPoint _farPoint;
    CGPoint _endPoint;
    CAKeyframeAnimation *_animation;
}
@property (nonatomic,assign)CGPoint startPoint;
@property (nonatomic,assign)CGPoint nearbyPoint;
@property (nonatomic,assign)CGPoint farPoint;
@property (nonatomic,assign)CGPoint endPoint;
@property (nonatomic,strong)CAKeyframeAnimation *animation;
@property (nonatomic,copy)CliciIconBlock block;

- (id)initWithImageName:(NSString *)imageName withLabelTitle:(NSString *)title;

@end
