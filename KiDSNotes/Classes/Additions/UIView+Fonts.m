//
//  UIView+UIView_TUFFonts.m
//  KiDSNotes
//
//  Created by deus4 on 26/10/15.
//  Copyright © 2015 deus4. All rights reserved.
//

#import "UIView+Fonts.h"

static NSString *kLightFontName = @"Roboto-Light";
static NSString *kRegularFontName = @"Roboto-Regular";
static NSString *kBlackFontName = @"Roboto-Black";
static NSString *kFuturaMedFontName = @"FuturaTOTMed";
static NSString *kFuturaLightFontName = @"FuturaTOTLig";
static NSString *kRobotoLightItalicFontName = @"Roboto-LightItalic";
static NSString *kRobotoBoldFontName = @"Roboto-Bold";
static NSString *kRobotoMediumFontName = @"Roboto-Medium";
static NSString *kRobotoItalicFontName = @"Roboto-Italic";
static NSString *kKidsProGradeFiveFontName = @"PFKidsPro-GradeFive";
static NSString *kKidsProGradeOneFontname = @"PFKidsPro-GradeOne";
static NSString *kSFBoldFontName = @"SFUIText-Bold";
static NSString *kSFRegularFontName = @"SFUIText-Regular";
static NSString *kSFLightFontName = @"SFUIText-Light";
static NSString *kCalibriFontName = @"Calibri";
static NSString *kCalibriBoldFontName = @"Calibri-Bold";

@implementation UIView (Fonts)

- (void)setCustomFont:(NSString *)fontName
{
    if ([self respondsToSelector:@selector(font)]
        && [self respondsToSelector:@selector(setFont:)])
    {
        UIFont *font = (UIFont *) [self performSelector:@selector(font)];
        
        UIFont *setterFont = [UIFont fontWithName:fontName
                                             size:font.pointSize];
        
        [self performSelector:@selector(setFont:) withObject:setterFont];
    }
}
- (void)setCalibriFont  {
    [self setCustomFont:kCalibriFontName];
}
- (void)setCalibriBoldFont  {
    [self setCustomFont:kCalibriBoldFontName];
}
- (void)setSFLightFont  {
    [self setCustomFont:kSFLightFontName];
}
- (void)setSFBoldFont   {
    [self setCustomFont:kSFBoldFontName];
}
- (void)setSFRegularFont    {
    [self setCustomFont:kSFRegularFontName];
}
- (void)setKidsProGradeFiveFont
{
    [self setCustomFont:kKidsProGradeFiveFontName];
}
- (void)setKidsProGradeOneFont
{
    [self setCustomFont:kKidsProGradeOneFontname];
}
- (void)setLightFont
{
    [self setCustomFont:kLightFontName];
}

- (void)setRegularFont
{
    [self setCustomFont:kRegularFontName];
}

- (void)setBlackFont
{
    [self setCustomFont:kBlackFontName];
}

- (void)setFuturaMedFont
{
    [self setCustomFont:kFuturaMedFontName];
}

- (void)setFuturaLightFont
{
    [self setCustomFont:kFuturaLightFontName];
}

- (void)setRobotoLightItalicFont
{
    [self setCustomFont:kRobotoLightItalicFontName];
}

- (void)setRobotoBoldFont
{
    [self setCustomFont:kRobotoBoldFontName];
}

- (void)setRobotoMediumFont
{
    [self setCustomFont:kRobotoMediumFontName];
}

- (void)setRobotoItalicFont
{
    [self setCustomFont:kRobotoItalicFontName];
}

+ (UIFont *)kidsProGradeFiveFontWithSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:kKidsProGradeFiveFontName size:fontSize];
}
+ (UIFont *)kidsProGradeOneFontWithSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:kKidsProGradeOneFontname size:fontSize];
}
+ (UIFont *)lightFontWithSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:kLightFontName size:fontSize];
}

+ (UIFont *)regularFontWithSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:kRegularFontName size:fontSize];
}

+ (UIFont *)blackFontWithSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:kBlackFontName size:fontSize];
}

+ (UIFont *)futuraMedWithSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:kFuturaMedFontName size:fontSize];
}

+ (UIFont *)futuraLightWithSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:kFuturaLightFontName size:fontSize];
}

+ (UIFont *)robotoLightItalicWithSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:kRobotoLightItalicFontName size:fontSize];
}

+ (UIFont *)robotBoldWithSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:kRobotoBoldFontName size:fontSize];
}

+ (UIFont *)robotoMediumWithSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:kRobotoMediumFontName size:fontSize];
}

+ (UIFont *)robotoItalicWithSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:kRobotoItalicFontName size:fontSize];
}
+ (UIFont *)sfRegularWithSize:(CGFloat)fontSize {
    return [UIFont fontWithName:kSFRegularFontName size:fontSize];
}
+ (UIFont *)sfBoldWithSize:(CGFloat)fontSize    {
    return [UIFont fontWithName:kSFBoldFontName size:fontSize];
}
+ (UIFont *)sfLightWithSize:(CGFloat)fontSize   {
    return [UIFont fontWithName:kSFLightFontName size:fontSize];
}
+ (UIFont *)calibriWithSize:(CGFloat)fontSize   {
    return [UIFont fontWithName:kCalibriFontName size:fontSize];
}
+ (UIFont *)calibriBoldWithSize:(CGFloat)fontSize   {
    return [UIFont fontWithName:kCalibriBoldFontName size:fontSize];
}
@end
