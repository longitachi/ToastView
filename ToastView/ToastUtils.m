//
//  ToastUtils.m
//  vsfa
//
//  Created by long on 15/7/29.
//  Copyright (c) 2015年 long. All rights reserved.
//

#import "ToastUtils.h"

@implementation ToastUtils

#pragma mark - 显示提示视图
+ (void)showAtTop:(NSString *)message
{
    [self show:message atTop:YES showTime:DefaultShowTime];
}

+ (void)show:(NSString *)message
{
    [self show:message atTop:NO showTime:DefaultShowTime];
}

+ (void)showLongAtTop:(NSString *)message
{
    [self show:message atTop:YES showTime:DefaultShowTime*2];
}

+ (void)showLong:(NSString *)message
{
    [self show:message atTop:NO showTime:DefaultShowTime*2];
}

static NSMutableArray *arrToasts = nil;
static ToastUtils *shareToast = nil;
static dispatch_once_t onceToken;

+ (void)show:(NSString *)message atTop:(BOOL)atTop showTime:(float)showTime
{
    if (![[NSThread currentThread] isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self show:message atTop:atTop showTime:showTime];
        });
        return;
    }
    
    dispatch_once(&onceToken, ^{
        shareToast = [[self alloc] init];
        arrToasts = [NSMutableArray array];
    });
    
    UILabel *toastLabel = [self getToastLabel];
    
    CGRect frame = [self getFrameWithMessage:message atTop:atTop];
    
    toastLabel.text = message;
    toastLabel.frame = frame;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((showTime-1) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [shareToast setOpacityAnimationForToastLabel:toastLabel WithDuration:1];
    });
    
    CGFloat margin = 5;
    //刷新数组内labelframe
    
    NSInteger arrCount = arrToasts.count;
    
    [arrToasts enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UILabel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ((NSInteger)idx <= arrCount - DefaultMaxShowCount) {
            [obj removeFromSuperview];
            return;
        }
        CGRect newF = obj.frame;
        newF.origin.y += atTop?(frame.size.height+margin):-(frame.size.height+margin);
        obj.frame = newF;
    }];
    
    [arrToasts addObject:toastLabel];
}

+ (UILabel *)getToastLabel
{
    UILabel *toastLabel = [[UILabel alloc] init];
    toastLabel.backgroundColor = DefaultBgColor;
    toastLabel.textColor = DefaultTextColor;
    toastLabel.font = [UIFont systemFontOfSize:DefaultFont-1];
    toastLabel.layer.masksToBounds = YES;
    toastLabel.layer.cornerRadius = 3.0f;
    toastLabel.textAlignment = NSTextAlignmentCenter;
    toastLabel.numberOfLines = 0;
    toastLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [[UIApplication sharedApplication].keyWindow addSubview:toastLabel];
    return toastLabel;
}

+ (CGRect)getFrameWithMessage:(NSString *)message atTop:(BOOL)atTop
{
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    
    CGFloat width = [self stringText:message font:DefaultFont isHeightFixed:YES fixedValue:DefaultHeight];
    CGFloat height = DefaultHeight;
    if (width > screenWidth - 20) {
        width = screenWidth - 20;
        height = [self stringText:message font:DefaultFont isHeightFixed:NO fixedValue:width];
    }
    
    return CGRectMake((screenWidth-width)/2, atTop?screenHeight*0.15:screenHeight*0.85, width, height);
}

- (void)setOpacityAnimationForToastLabel:(UILabel *)toastLabel WithDuration:(CFTimeInterval)duration
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @(1);
    animation.toValue = @(0);
    animation.duration = duration;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.delegate = shareToast;
    [toastLabel.layer addAnimation:animation forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [arrToasts.firstObject removeFromSuperview];
    [arrToasts removeObjectAtIndex:0];
}

//根据字符串长度获取对应的宽度或者高度
+ (CGFloat)stringText:(NSString *)text font:(CGFloat)font isHeightFixed:(BOOL)isHeightFixed fixedValue:(CGFloat)fixedValue
{
    CGSize size;
    if (isHeightFixed) {
        size = CGSizeMake(MAXFLOAT, fixedValue);
    } else {
        size = CGSizeMake(fixedValue, MAXFLOAT);
    }
    
    //返回计算出的size
    CGSize resultSize = [text boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:font]} context:nil].size;
    
    if (isHeightFixed) {
        return resultSize.width;
    } else {
        return resultSize.height;
    }
}

@end
