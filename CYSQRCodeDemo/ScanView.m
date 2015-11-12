//
//  ScanView.m
//  CYSQRCodeDemo
//
//  Created by YS_Chan on 15/11/11.
//  Copyright © 2015年 YS_Chan. All rights reserved.
//

#import "ScanView.h"

#define SCANVIEW_BACKGROUND_COLOR [UIColor clearColor]
#define VIEW_WIDTH self.frame.size.width
#define VIEW_HEIGHT self.frame.size.height
//边框颜色
#define SCANVIEW_FRAME_COLOR [UIColor colorWithRed:0.5195 green:0.9831 blue:0.8329 alpha:1.0]
//边框线宽度
#define SCANVIEW_FRAME_LINEWIDTH 5.0f
//边框水平线长度
#define SCANVIEW_FRAME_HORIZONTAL_LENGHT 30.0f
//边框垂直线长度
#define SCANVIEW_FRAME_VERTICAL_LENGHT 30.0f

//扫描线宽度
#define SCANLINE_LINEWIDTH 3.0f
//扫描线颜色
#define SCANLINE_COLOR [UIColor colorWithRed:0.6599 green:1.0 blue:0.7095 alpha:0.5]
//扫描线X轴坐标
#define SCANLINE_X 20.f
//扫描线Y轴坐标
#define SCANLINE_Y 20.f
//扫描线透明度
#define SCANLINE_ALPHA 0.8f


@interface ScanView()
@property (strong ,nonatomic) UIView *qrCodeline1;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation ScanView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = SCANVIEW_BACKGROUND_COLOR;
        self.qrCodeline1 = [[UIView alloc]initWithFrame:CGRectMake(SCANLINE_X, SCANLINE_Y, VIEW_WIDTH - SCANLINE_X * 2, SCANLINE_LINEWIDTH)];
        self.qrCodeline1.backgroundColor = SCANLINE_COLOR;
        self.qrCodeline1.alpha = 0.0f;
        [self addSubview:self.qrCodeline1];
        [self createTimer];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
//    [self defaultFrame];
    [self fourCornerFrame];
}

#pragma mark - 方框框
- (void)defaultFrame{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, VIEW_WIDTH, 0);
    CGPathAddLineToPoint(path, NULL, VIEW_WIDTH, VIEW_HEIGHT);
    CGPathAddLineToPoint(path, NULL, 0, VIEW_HEIGHT);
    CGPathAddLineToPoint(path, NULL, 0, 0);

    
    
    CGContextAddPath(ctx, path);
    [SCANVIEW_FRAME_COLOR set];
    CGContextSetLineWidth(ctx, SCANVIEW_FRAME_LINEWIDTH);
    CGContextStrokePath(ctx);
    CGPathRelease(path);
}

#pragma mark - 四角直角框
- (void)fourCornerFrame{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, 0, SCANVIEW_FRAME_VERTICAL_LENGHT);
    CGPathAddLineToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL, SCANVIEW_FRAME_HORIZONTAL_LENGHT, 0);
    
    CGPathMoveToPoint(path, NULL, VIEW_WIDTH - SCANVIEW_FRAME_HORIZONTAL_LENGHT, 0);
    CGPathAddLineToPoint(path, NULL, VIEW_WIDTH, 0);
    CGPathAddLineToPoint(path, NULL, VIEW_WIDTH, SCANVIEW_FRAME_VERTICAL_LENGHT);
    
    CGPathMoveToPoint(path, NULL, VIEW_WIDTH - SCANVIEW_FRAME_HORIZONTAL_LENGHT, VIEW_HEIGHT);
    CGPathAddLineToPoint(path, NULL, VIEW_WIDTH, VIEW_HEIGHT);
    CGPathAddLineToPoint(path, NULL, VIEW_WIDTH, VIEW_HEIGHT-SCANVIEW_FRAME_VERTICAL_LENGHT);
    
    CGPathMoveToPoint(path, NULL, 0, VIEW_HEIGHT-SCANVIEW_FRAME_VERTICAL_LENGHT);
    CGPathAddLineToPoint(path, NULL, 0, VIEW_HEIGHT);
    CGPathAddLineToPoint(path, NULL, SCANVIEW_FRAME_HORIZONTAL_LENGHT, VIEW_HEIGHT);
    
    CGContextAddPath(ctx, path);
    [SCANVIEW_FRAME_COLOR set];
    CGContextSetLineWidth(ctx, SCANVIEW_FRAME_LINEWIDTH);
    CGContextStrokePath(ctx);
    CGPathRelease(path);
}

#pragma mark - NSTimer
- (void)createTimer{
    _timer=[NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(moveUpAndDownLine) userInfo:nil repeats:YES];
}

- (void)stopAnimation{
    if ([_timer isValid] == YES) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)moveUpAndDownLine{
    [UIView animateWithDuration:2.5 delay:0.0 options:UIViewAnimationOptionAutoreverse|UIViewAnimationOptionRepeat|UIViewAnimationOptionCurveEaseOut animations:^{
        self.qrCodeline1.frame = CGRectMake(SCANLINE_X, VIEW_HEIGHT - SCANLINE_Y, VIEW_WIDTH - SCANLINE_X * 2, SCANLINE_LINEWIDTH);
        self.qrCodeline1.alpha = SCANLINE_ALPHA;
    } completion:^(BOOL finished) {}];
}




@end
