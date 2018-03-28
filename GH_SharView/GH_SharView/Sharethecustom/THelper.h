//
//  ViewController.m
//  GH_SharView
//
//  Created by 苟应航 on 2018/3/27.
//  Copyright © 2018年 GouHang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface THelper : NSObject


+ (UILabel *)labelWithFrame:(CGRect)frame
                       text:(NSString *)text
                  textColor:(UIColor *)color
              textAlignment:(NSTextAlignment)alignment
                       font:(UIFont *)font;

+ (UIButton *)buttonsetIamgeWithFrame:(CGRect)frame
                                nfile:(NSString *)nfileName
                                sfile:(NSString *)sfileName
                                  tag:(NSInteger)buttonTag
                               action:(SEL)action;

+ (NSMutableArray *)exchangeArrayItem:(NSMutableArray *)array;


+ (float)huDuFromdu:(float)du;
+ (float)sin:(float)du;
+ (float)cos:(float)du;

@end
