//
//  ScratchCardView.m
//  RGBTool
//
//  Created by admin on 21/08/2017.
//  Copyright © 2017 yang. All rights reserved.
//


#import "XScratchView.h"

@interface XScratchView ()

/**  */
@property (nonatomic, strong) UIImageView *surfaceImageView;
/**  */
@property (nonatomic, strong) CALayer *imageLayer;
/**  */
@property (nonatomic, strong) CAShapeLayer *shapeLayer;
/** 手指的涂抹路径 */
@property (nonatomic, assign) CGMutablePathRef path;

@end

@implementation XScratchView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.surfaceImageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self addSubview:self.surfaceImageView];
        
        self.imageLayer = [CALayer layer];
        self.imageLayer.frame = self.bounds;
        [self.layer addSublayer:self.imageLayer];
        
        self.shapeLayer = [CAShapeLayer layer];
        self.shapeLayer.frame = self.bounds;
        self.shapeLayer.lineCap = kCALineCapRound;
        self.shapeLayer.lineJoin = kCALineJoinRound;
        self.shapeLayer.lineWidth = 20;
        self.shapeLayer.strokeColor = [UIColor whiteColor].CGColor;
        self.shapeLayer.fillColor = nil;//此处必须设为nil，否则后边添加addLine的时候会自动填充

        self.imageLayer.mask = self.shapeLayer;
        self.path = CGPathCreateMutable();
    }
    return self;
}
#pragma mark --- Touch Events
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGPathMoveToPoint(self.path, nil, point.x, point.y);
    self.shapeLayer.path = self.path;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesMoved:touches withEvent:event];
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGPathAddLineToPoint(self.path, nil, point.x, point.y);
    self.shapeLayer.path = self.path;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
}

#pragma mark --- Public Methods
- (void)recover{
    CGPathRelease(self.path);
    self.path = CGPathCreateMutable();
    self.shapeLayer.path = nil;
}



-(UIImage*)didMosaicImage
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.layer renderInContext:context];
    UIImage *mImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return mImg;
}

#pragma mark --- 重写属性的set方法

- (void)setMosaicImage:(UIImage *)mosaicImage{
    _mosaicImage = mosaicImage;
    self.imageLayer.contents = (id)mosaicImage.CGImage;//把照片放在Layer层
}

- (void)setSurfaceImage:(UIImage *)surfaceImage{
    _surfaceImage = surfaceImage; //
    self.surfaceImageView.image = surfaceImage;///把产生的马赛克照片放在上层
}


- (void)dealloc{
    if (self.path) {
        CGPathRelease(self.path);
    }
}


@end
