//
//  LineView.m
//  XSHCar
//
//  Created by jonz on 14-7-14.
//  Copyright (c) 2014年 john. All rights reserved.
//

#import "LineView.h"
#import "CommonHeader.h"

@interface LineView ()
{
    NSMutableArray *pointArrays;
    
    UILabel *lblTitle;
    
    UIScrollView *scrollview;
    float start_X;
    float x_width;
}
@property(retain,nonatomic)NSMutableArray *pointArrays;
@property(retain,nonatomic)UILabel *lblTitle;
@end
@implementation LineView
@synthesize pointArrays,lblTitle;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        start_X = 50.0;
        x_width = 60.0;
        // Initialization code
        //titleHeight20.0
        
        if (scrollview == nil) {
            scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(start_X, 0 , self.bounds.size.width - start_X - 10.0,self.bounds.size.height - 20)];
            scrollview.backgroundColor = [UIColor whiteColor];
            scrollview.showsHorizontalScrollIndicator = NO;
            scrollview.showsVerticalScrollIndicator = NO;
            //scrollview.clipsToBounds = NO;
        }
        [self addSubview:scrollview];
  
    }
    return self;
}
-(void)drawXCoors:(NSMutableArray*)Points title:(NSString*)titles flag:(int)flag
{
    self.pointArrays = Points;
    CGFloat fenshu =self.pointArrays.count;
    while (self.subviews.count >0)
    {
        UIView *view = [self.subviews lastObject];
        [view removeFromSuperview];
        if (false == [view isKindOfClass:[UIScrollView class]])
        {
            view = nil;
        }
    }
    while (scrollview.subviews.count >0)
    {
        UIView *view = [scrollview.subviews lastObject];
        [view removeFromSuperview];
        view = nil;
    }
    while (scrollview.layer.sublayers.count>0)
    {
        CALayer *layer = [scrollview.layer.sublayers lastObject];
        [layer removeFromSuperlayer];
        layer = nil;
    }
    [self addSubview:scrollview];
    [self setNeedsDisplay];
    if (flag == 0)
    {
        scrollview.contentSize = CGSizeMake(x_width * [self.pointArrays count] + start_X, scrollview.frame.size.height);
    }
    else
    {
        if (flag ==  1)
        {
            fenshu = 12;
        }
        else if (flag == 2)
        {
            fenshu = 10;
        }
        scrollview.contentSize = self.bounds.size;
    }
//
    CGFloat height = self.frame.size.height-42;
    //x轴
    [self addLine:0 tox:scrollview.contentSize.width-15 y:height toY:height atView:scrollview];
    //y轴
    //CGFloat XStart = 50.0;
    CGFloat YCorValue = self.frame.size.height - 35.0;
    
    [self addLine:start_X tox:start_X y:YCorValue toY: -8 atView:self];
    
    if (lblTitle == nil)
    {
        lblTitle = [[UILabel alloc]initWithFrame:CGRectMake(30, self.frame.size.height - 20, SCREEN_WIDTH - 30, 20)];
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.textColor = [UIColor lightGrayColor];
        lblTitle.font = [UIFont systemFontOfSize:14.0];
    }
    lblTitle.text =titles;
    [self addSubview:lblTitle];
    

    //添加x视图
    //CGFloat eachW = widht/fenshu;
    CGFloat YMaxValue =1;
    for (int i = 0; i<self.pointArrays.count; i++)
    {
        CGFloat xXXX = start_X + x_width * (i);
        CGFloat endY = YCorValue;
        [self addLine:xXXX tox:xXXX y:YCorValue toY:height atView:scrollview];
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(xXXX,endY,x_width,21)];
        lbl.center = CGPointMake(xXXX, lbl.center.y);
        lbl.textAlignment =NSTextAlignmentCenter;
        [scrollview addSubview:lbl];
        lbl.font = [UIFont systemFontOfSize:8];
        lbl.tag = 200+i;
        NSString *day= [self.pointArrays objectAtIndex:i];
        NSArray *days = [day componentsSeparatedByString:@":"];
        
        if (days.count == 2)
        {
            lbl.text = [NSString stringWithFormat:@"%@",[days objectAtIndex:0]];
            CGFloat iValue = [[days objectAtIndex:1] floatValue];
            YMaxValue = (YMaxValue > iValue)? YMaxValue :iValue;
        }
        else
        {
            lbl.text = [NSString stringWithFormat:@"%d",i];
        }
        
    }
    //y视图
//    height =self.frame.size.height -50;
//    CGFloat hightcount = pointArrays.count == 0 ? 10 :pointArrays.count;
    
    CGFloat eachHeight = height/10;
    CGFloat eachI = YMaxValue /10;
    for (int k = 0 ;k<= 10 ;k++)
    {
        CGFloat y = height - k*eachHeight;
        
        [self addLine:40.0 tox:start_X y:y toY:y atView:self];
        
        UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(0,0,40,20)];
        lbl.center = CGPointMake(lbl.center.x,y);
        lbl.textAlignment =NSTextAlignmentCenter;
        [self addSubview:lbl];
        lbl.font = [UIFont systemFontOfSize:8];
        lbl.text = [NSString stringWithFormat:@"%.1f",k*eachI];
        lbl.tag = 100+k;
    }
    

    
    //画线
    CGPoint pt1 =CGPointZero,pt2 =CGPointZero;
    for (int k = 0 ;k< self.pointArrays.count ;k++) {
        CGFloat x = ((UILabel*)[self viewWithTag:(200+k)]).center.x;
        NSString *day= [self.pointArrays objectAtIndex:(k)];

        NSArray *days = [day componentsSeparatedByString:@":"];
        double y = 0;
        if (days.count == 2) {
            double iValue = [[days objectAtIndex:1] floatValue];
            y = height - iValue*(height/YMaxValue);
            if (k == 0) {
                pt1 = CGPointMake(x, y);
            }else if (k == 1){
                pt2 = CGPointMake(x, y);
            }else{
//                CGFloat pt1x= pt1.x;
                pt1 = pt2;
//                pt1x = pt1x!= x ? pt1x : pt1.x;
                pt2 = CGPointMake(x, y);
                NSLog(@"y===%f",y);
                if (y <= 3)
                {
                    NSLog(@"y===%f",y);
                    pt2 = CGPointMake(x, 4);
                }
            }
            if(k >0){
                [self makeLineLayer:scrollview.layer lineFromPointA:pt1 toPointB:pt2];
                [self Layer:scrollview.layer drawCircle:pt1];
                if (k == self.pointArrays.count -1) {
                    [self Layer:scrollview.layer drawCircle:pt2];
                }
            }
        }
        else{
            NSLog(@"error");
        }
    }
}
-(void)makeLineLayer:(CALayer *)layer lineFromPointA:(CGPoint)pointA toPointB:(CGPoint)pointB
{
    CAShapeLayer *line = [CAShapeLayer layer];
    UIBezierPath *linePath=[UIBezierPath bezierPath];
    [linePath moveToPoint:pointA];
    [linePath addLineToPoint:pointB];
    line.path=linePath.CGPath;
    line.fillColor = nil;
    line.opacity = 2.0;
    line.strokeColor = [UIColor redColor].CGColor;
    [layer addSublayer:line];
}
-(void)Layer:(CALayer *)layer drawCircle:(CGPoint)pt
{
    CGFloat radius = 3;

    UIBezierPath *linePath = [UIBezierPath bezierPathWithArcCenter:pt radius:radius startAngle:M_PI
                                                   endAngle:-M_PI 
                                                  clockwise:NO];
    CAShapeLayer *backgroundLayer = [CAShapeLayer layer];
    backgroundLayer.path = linePath.CGPath;
    backgroundLayer.strokeColor = [[UIColor lightGrayColor] CGColor];
    backgroundLayer.fillColor = [[UIColor redColor] CGColor];
    backgroundLayer.lineWidth = 2;
    [layer addSublayer:backgroundLayer];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 */
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}

-(void)addLine:(int)x tox:(int)toX y:(int)y toY:(int)toY atView:(UIView*)view
{
    //    NSLog(@"mefo %s",__func__);
    CAShapeLayer *lineShape =nil;
    lineShape = nil;
    CGMutablePathRef linePath = nil;
    linePath = CGPathCreateMutable();
    lineShape = [CAShapeLayer layer];
    lineShape.lineWidth = 0.5f;
    lineShape.lineCap = kCALineCapRound;;
    lineShape.strokeColor = [UIColor darkGrayColor].CGColor;
    
    CGPathMoveToPoint(linePath, NULL, x, y);
    CGPathAddLineToPoint(linePath, NULL, toX, toY);
    lineShape.path = linePath;
    CGPathRelease(linePath);
    [view.layer addSublayer:lineShape];
}

@end
