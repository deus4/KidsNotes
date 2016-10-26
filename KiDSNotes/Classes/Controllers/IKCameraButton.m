//
//  IKCameraButton.m
//  KiDSNotes
//
//  Created by deus4 on 29/01/16.
//  Copyright © 2016 deus4. All rights reserved.
//

#import "IKCameraButton.h"

@implementation IKCameraButton


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIColor* fillColor = [UIColor colorWithRed: 0.24 green: 0.55 blue: 0.801 alpha: 0.9];
    UIColor* fillColor2 = [UIColor colorWithRed: 1 green: 1 blue: 1 alpha: 1];
    
    //// Page-1
    {
        //// Feed
        {
            //// camera-+-Oval-23
            {
                //// Group 5
                {
                    //// Oval-23 Drawing
                    UIBezierPath* oval23Path = [UIBezierPath bezierPathWithOvalInRect: CGRectMake(0, 0, 60, 60)];
                    [fillColor setFill];
                    [oval23Path fill];
                    
                    
                    //// camera
                    {
                        //// Shape Drawing
                        UIBezierPath* shapePath = [UIBezierPath bezierPath];
                        [shapePath moveToPoint: CGPointMake(47.86, 43.39)];
                        [shapePath addLineToPoint: CGPointMake(11.02, 43.39)];
                        [shapePath addCurveToPoint: CGPointMake(9.11, 41.52) controlPoint1: CGPointMake(9.97, 43.39) controlPoint2: CGPointMake(9.11, 42.55)];
                        [shapePath addLineToPoint: CGPointMake(9.11, 17.58)];
                        [shapePath addCurveToPoint: CGPointMake(11.02, 15.71) controlPoint1: CGPointMake(9.11, 16.55) controlPoint2: CGPointMake(9.97, 15.71)];
                        [shapePath addLineToPoint: CGPointMake(21.04, 15.71)];
                        [shapePath addCurveToPoint: CGPointMake(22.25, 15.17) controlPoint1: CGPointMake(21.41, 15.71) controlPoint2: CGPointMake(22, 15.44)];
                        [shapePath addLineToPoint: CGPointMake(23.36, 13.93)];
                        [shapePath addCurveToPoint: CGPointMake(25.79, 12.84) controlPoint1: CGPointMake(23.91, 13.31) controlPoint2: CGPointMake(24.96, 12.84)];
                        [shapePath addLineToPoint: CGPointMake(32.98, 12.84)];
                        [shapePath addCurveToPoint: CGPointMake(35.42, 13.93) controlPoint1: CGPointMake(33.82, 12.84) controlPoint2: CGPointMake(34.86, 13.31)];
                        [shapePath addLineToPoint: CGPointMake(36.53, 15.17)];
                        [shapePath addCurveToPoint: CGPointMake(37.73, 15.71) controlPoint1: CGPointMake(36.77, 15.44) controlPoint2: CGPointMake(37.37, 15.71)];
                        [shapePath addLineToPoint: CGPointMake(47.86, 15.71)];
                        [shapePath addCurveToPoint: CGPointMake(49.77, 17.58) controlPoint1: CGPointMake(48.91, 15.71) controlPoint2: CGPointMake(49.77, 16.55)];
                        [shapePath addLineToPoint: CGPointMake(49.77, 41.52)];
                        [shapePath addCurveToPoint: CGPointMake(47.86, 43.39) controlPoint1: CGPointMake(49.77, 42.55) controlPoint2: CGPointMake(48.91, 43.39)];
                        [shapePath addLineToPoint: CGPointMake(47.86, 43.39)];
                        [shapePath closePath];
                        [shapePath moveToPoint: CGPointMake(11.02, 17.3)];
                        [shapePath addCurveToPoint: CGPointMake(10.74, 17.58) controlPoint1: CGPointMake(10.87, 17.3) controlPoint2: CGPointMake(10.74, 17.43)];
                        [shapePath addLineToPoint: CGPointMake(10.74, 41.52)];
                        [shapePath addCurveToPoint: CGPointMake(11.02, 41.79) controlPoint1: CGPointMake(10.74, 41.67) controlPoint2: CGPointMake(10.87, 41.79)];
                        [shapePath addLineToPoint: CGPointMake(47.86, 41.79)];
                        [shapePath addCurveToPoint: CGPointMake(48.14, 41.52) controlPoint1: CGPointMake(48.01, 41.79) controlPoint2: CGPointMake(48.14, 41.67)];
                        [shapePath addLineToPoint: CGPointMake(48.14, 17.58)];
                        [shapePath addCurveToPoint: CGPointMake(47.86, 17.3) controlPoint1: CGPointMake(48.14, 17.43) controlPoint2: CGPointMake(48.01, 17.3)];
                        [shapePath addLineToPoint: CGPointMake(37.73, 17.3)];
                        [shapePath addCurveToPoint: CGPointMake(35.3, 16.22) controlPoint1: CGPointMake(36.9, 17.3) controlPoint2: CGPointMake(35.85, 16.84)];
                        [shapePath addLineToPoint: CGPointMake(34.19, 14.98)];
                        [shapePath addCurveToPoint: CGPointMake(32.98, 14.44) controlPoint1: CGPointMake(33.95, 14.71) controlPoint2: CGPointMake(33.35, 14.44)];
                        [shapePath addLineToPoint: CGPointMake(25.79, 14.44)];
                        [shapePath addCurveToPoint: CGPointMake(24.59, 14.98) controlPoint1: CGPointMake(25.43, 14.44) controlPoint2: CGPointMake(24.83, 14.71)];
                        [shapePath addLineToPoint: CGPointMake(23.47, 16.22)];
                        [shapePath addCurveToPoint: CGPointMake(21.04, 17.3) controlPoint1: CGPointMake(22.92, 16.84) controlPoint2: CGPointMake(21.88, 17.3)];
                        [shapePath addLineToPoint: CGPointMake(11.02, 17.3)];
                        [shapePath addLineToPoint: CGPointMake(11.02, 17.3)];
                        [shapePath closePath];
                        shapePath.miterLimit = 4;
                        
                        shapePath.usesEvenOddFillRule = YES;
                        
                        [fillColor2 setFill];
                        [shapePath fill];
                        
                        
                        //// Shape 2 Drawing
                        UIBezierPath* shape2Path = [UIBezierPath bezierPath];
                        [shape2Path moveToPoint: CGPointMake(29.44, 39.16)];
                        [shape2Path addCurveToPoint: CGPointMake(19.97, 29.89) controlPoint1: CGPointMake(24.22, 39.16) controlPoint2: CGPointMake(19.97, 35)];
                        [shape2Path addCurveToPoint: CGPointMake(29.44, 20.62) controlPoint1: CGPointMake(19.97, 24.78) controlPoint2: CGPointMake(24.22, 20.62)];
                        [shape2Path addCurveToPoint: CGPointMake(38.91, 29.89) controlPoint1: CGPointMake(34.66, 20.62) controlPoint2: CGPointMake(38.91, 24.78)];
                        [shape2Path addCurveToPoint: CGPointMake(29.44, 39.16) controlPoint1: CGPointMake(38.91, 35) controlPoint2: CGPointMake(34.66, 39.16)];
                        [shape2Path addLineToPoint: CGPointMake(29.44, 39.16)];
                        [shape2Path closePath];
                        [shape2Path moveToPoint: CGPointMake(29.44, 22.22)];
                        [shape2Path addCurveToPoint: CGPointMake(21.6, 29.89) controlPoint1: CGPointMake(25.12, 22.22) controlPoint2: CGPointMake(21.6, 25.66)];
                        [shape2Path addCurveToPoint: CGPointMake(29.44, 37.56) controlPoint1: CGPointMake(21.6, 34.12) controlPoint2: CGPointMake(25.12, 37.56)];
                        [shape2Path addCurveToPoint: CGPointMake(37.28, 29.89) controlPoint1: CGPointMake(33.76, 37.56) controlPoint2: CGPointMake(37.28, 34.12)];
                        [shape2Path addCurveToPoint: CGPointMake(29.44, 22.22) controlPoint1: CGPointMake(37.28, 25.66) controlPoint2: CGPointMake(33.76, 22.22)];
                        [shape2Path addLineToPoint: CGPointMake(29.44, 22.22)];
                        [shape2Path closePath];
                        shape2Path.miterLimit = 4;
                        
                        shape2Path.usesEvenOddFillRule = YES;
                        
                        [fillColor2 setFill];
                        [shape2Path fill];
                        
                        
                        //// Shape 3 Drawing
                        UIBezierPath* shape3Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(42.38, 29.3, 7.05, 1.6) cornerRadius: 0.8];
                        [fillColor2 setFill];
                        [shape3Path fill];
                        
                        
                        //// Shape 4 Drawing
                        UIBezierPath* shape4Path = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(9.45, 29.3, 7.4, 1.6) cornerRadius: 0.8];
                        [fillColor2 setFill];
                        [shape4Path fill];
                        
                        //// Shape 5 Drawing
                        UIBezierPath* shape5Path = [UIBezierPath bezierPath];
                        [shape5Path moveToPoint: CGPointMake(29.44, 34.88)];
                        [shape5Path addCurveToPoint: CGPointMake(24.35, 29.89) controlPoint1: CGPointMake(26.63, 34.88) controlPoint2: CGPointMake(24.35, 32.64)];
                        [shape5Path addCurveToPoint: CGPointMake(29.44, 24.9) controlPoint1: CGPointMake(24.35, 27.14) controlPoint2: CGPointMake(26.63, 24.9)];
                        [shape5Path addCurveToPoint: CGPointMake(34.53, 29.89) controlPoint1: CGPointMake(32.25, 24.9) controlPoint2: CGPointMake(34.53, 27.14)];
                        [shape5Path addCurveToPoint: CGPointMake(29.44, 34.88) controlPoint1: CGPointMake(34.53, 32.64) controlPoint2: CGPointMake(32.25, 34.88)];
                        [shape5Path addLineToPoint: CGPointMake(29.44, 34.88)];
                        [shape5Path closePath];
                        [shape5Path moveToPoint: CGPointMake(29.44, 26.5)];
                        [shape5Path addCurveToPoint: CGPointMake(25.98, 29.89) controlPoint1: CGPointMake(27.53, 26.5) controlPoint2: CGPointMake(25.98, 28.02)];
                        [shape5Path addCurveToPoint: CGPointMake(29.44, 33.28) controlPoint1: CGPointMake(25.98, 31.76) controlPoint2: CGPointMake(27.53, 33.28)];
                        [shape5Path addCurveToPoint: CGPointMake(32.9, 29.89) controlPoint1: CGPointMake(31.35, 33.28) controlPoint2: CGPointMake(32.9, 31.76)];
                        [shape5Path addCurveToPoint: CGPointMake(29.44, 26.5) controlPoint1: CGPointMake(32.9, 28.02) controlPoint2: CGPointMake(31.35, 26.5)];
                        [shape5Path addLineToPoint: CGPointMake(29.44, 26.5)];
                        [shape5Path closePath];
                        shape5Path.miterLimit = 4;
                        
                        shape5Path.usesEvenOddFillRule = YES;
                        
                        [fillColor2 setFill];
                        [shape5Path fill];

                    }
                }
            }
        }
    }
}


@end
