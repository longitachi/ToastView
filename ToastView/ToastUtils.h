//
//  ToastUtils.h
//  vsfa
//
//  Created by long on 15/7/29.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DefaultMaxShowCount 5
#define DefaultShowTime     2
#define DefaultFont         18
#define DefaultHeight       30
#define DefaultBgColor      [UIColor darkGrayColor]
#define DefaultTextColor    [UIColor whiteColor]

#define ShowToastAtTop(format, ...) \
[ToastUtils showAtTop:[NSString stringWithFormat:format, ## __VA_ARGS__]]

#define ShowToast(format, ...) \
[ToastUtils show:[NSString stringWithFormat:format, ## __VA_ARGS__]]

#define ShowToastLongAtTop(format, ...) \
[ToastUtils showLongAtTop:[NSString stringWithFormat:format, ## __VA_ARGS__]]

#define ShowToastLong(format, ...) \
[ToastUtils showLong:[NSString stringWithFormat:format, ## __VA_ARGS__]]

@interface ToastUtils : NSObject

/*!
 @brief 显示提示视图, 默认显示在屏幕上方，防止被软键盘覆盖，DefaultShowTime秒后自动消失
 */
+ (void)showAtTop:(NSString *)message;

/*!
 @brief 显示提示视图, 默认显示在屏幕下方，DefaultShowTime秒后自动消失
 */
+ (void)show:(NSString *)message;

/*!
 @brief 显示提示视图，默认显示在屏幕上方，防止被软键盘覆盖，DefaultShowTime*2秒后自动消失
 */
+ (void)showLongAtTop:(NSString *)message;

/*!
 @brief 显示提示视图，默认显示在屏幕下方，DefaultShowTime*2秒后自动消失
 */
+ (void)showLong:(NSString *)message;

@end
