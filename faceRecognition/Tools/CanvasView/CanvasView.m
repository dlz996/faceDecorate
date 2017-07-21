//
//  CanvasView.m
//  Created by sluin on 16/3/1.
//  Copyright (c) 2016年 SunLin. All rights reserved.
//

#import "CanvasView.h"

@implementation CanvasView
{
    CGContextRef context ;
}

- (void)drawRect:(CGRect)rect
{
    [self drawPointWithPoints:self.arrPersons];
}

-(void)drawPointWithPoints:(NSArray *)arrPersons
{
    if (context) {
        CGContextClearRect(context, self.bounds) ;
    }
    context = UIGraphicsGetCurrentContext();
    
    for (NSDictionary *dicPerson in arrPersons) {
        if ([dicPerson objectForKey:POINTS_KEY]) {
            NSArray * ary = [dicPerson objectForKey:POINTS_KEY];
            for (int i=0; i<ary.count; i++) {
                if (i == 3 || i == 0) {
                    NSString * strPoints = ary[i];
                    CGPoint p = CGPointFromString(strPoints);
                    UIImage *image = [UIImage imageNamed:@"glasses"];
                    CGContextDrawImage(context, CGRectMake(p.x - 25 , p.y - 25 , 80 , 50), image.CGImage);//使用这个使图片上下颠倒了，参考
                }
            }
        }
    }
//    CGContextSetLineWidth(context, 2);
    CGContextStrokePath(context);
}

@end
