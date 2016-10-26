//
//  UIView+UIView_TUFFonts.h
//  KiDSNotes
//
//  Created by deus4 on 26/10/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Fonts)

- (void)setCustomFont:(NSString *)fontName;

- (void)setKidsProGradeFiveFont;
- (void)setKidsProGradeOneFont;
- (void)setLightFont;
- (void)setRegularFont;
- (void)setBlackFont;
- (void)setFuturaMedFont;
- (void)setFuturaLightFont;
- (void)setRobotoLightItalicFont;
- (void)setRobotoBoldFont;
- (void)setRobotoMediumFont;
- (void)setRobotoItalicFont;
- (void)setSFRegularFont;
- (void)setSFBoldFont;
- (void)setSFLightFont;
- (void)setCalibriFont;
- (void)setCalibriBoldFont;

+ (UIFont *)kidsProGradeFiveFontWithSize:(CGFloat)fontSize;
+ (UIFont *)kidsProGradeOneFontWithSize:(CGFloat)fontSize;
+ (UIFont *)lightFontWithSize:(CGFloat)fontSize;
+ (UIFont *)regularFontWithSize:(CGFloat)fontSize;
+ (UIFont *)blackFontWithSize:(CGFloat)fontSize;
+ (UIFont *)futuraMedWithSize:(CGFloat)fontSize;
+ (UIFont *)futuraLightWithSize:(CGFloat)fontSize;
+ (UIFont *)robotoLightItalicWithSize:(CGFloat)fontSize;
+ (UIFont *)robotBoldWithSize:(CGFloat)fontSize;
+ (UIFont *)robotoMediumWithSize:(CGFloat)fontSize;
+ (UIFont *)robotoItalicWithSize:(CGFloat)fontSize;
+ (UIFont *)sfRegularWithSize:(CGFloat)fontSize;
+ (UIFont *)sfBoldWithSize:(CGFloat)fontSize;
+ (UIFont *)sfLightWithSize:(CGFloat)fontSize;
+ (UIFont *)calibriWithSize:(CGFloat)fontSize;
+ (UIFont *)calibriBoldWithSize:(CGFloat)fontSize;

@end
