//
//  YJBackView.m
//  YuJia
//
//  Created by 万宇 on 2017/5/22.
//  Copyright © 2017年 wylt_ios_1. All rights reserved.
//

#import "YJBackView.h"

@implementation YJBackView

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    //    UIView *result = [super hitTest:point withEvent:event];//父类调用hit方法，然后对每个子类进行判断，点击是否在这个子类上，然后子类再进行同样判断，直到找到点击的对象
    //    for (UIView *view in self.subviews) {
    //        CGPoint subPoint = [view convertPoint:point fromView:self];
    //        //在整个self上进行坐标改变，变成以这个button的（0，0）为原点的坐标系，然后根据此基础，得出这个点得坐标
    //        if ([view pointInside:subPoint withEvent:event]) {
    //            return view;//如果这个点在under button的坐标系内
    //        }
    //
    //    }
    //
    //
    //        return result;
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        for (UIView *subView in self.subviews) {
            CGPoint subPoint = [subView convertPoint:point fromView:self];
            //在整个self上进行坐标改变，变成以这个button的（0，0）为原点的坐标系，然后根据此基础，得出这个点得坐标
            if (CGRectContainsPoint(subView.bounds, subPoint)) {
                view = subView;//如果这个点在under button的坐标系内
            }
        }
    }
    
    return view;
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

@end
