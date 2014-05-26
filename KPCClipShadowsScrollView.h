//
//  KPCScrollView.h
//  iObserve
//
//  Created by onekiloparsec on 24/5/14.
//  Copyright (c) 2014 onekiloparsec. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/**
 *  KPCClipShadowsScrollView is a simple scroll view subclass that allows to draw on its top and its bottom
 *  small shadow rectangles to provide a subtle and discrete fade effect, for a smoother visual transition.
 *
 *  The top shadow is shown only when the scroll view content scrolls above the top of its clip view. That is, 
 *  when the content is smaller than the scroll height, or when the upper most pixel of the content is visible,
 *  no shadow are drawn.
 *
 *  The same apply for the bottom shadow, if any.
 * 
 *  The clips view will set its property copiesOnScroll to NO by default. If set to YES, you may see UI artefacts.
 */
@interface KPCClipShadowsScrollView : NSScrollView

/**
 *  The height of the top shadow rectangle. Default to 10 points.
 */
@property(nonatomic, assign) CGFloat topShadowHeight;

/**
 *  The height of the bottom shadow rectangle. Default to 10 points.
 */
@property(nonatomic, assign) CGFloat bottomShadowHeight;

/**
 *  The duration of a fade in/fade out animations, in seconds, for the top shadow to appear/disappear.
 *  If <= 0, no animation will occurs. Default is 0.15 seconds;
 */
@property(nonatomic, assign) NSTimeInterval topShadowAnimationDuration;

/**
 *  The duration of a fade in/fade out animations, in seconds, for the bottom shadow to appear/disappear.
 *  If <= 0, no animation will occurs. Default is 0.15 seconds;
 */
@property(nonatomic, assign) NSTimeInterval bottomShadowAnimationDuration;

/**
 *  Remove top and bottom shadows.
 */
- (void)clearShadows;

/**
 *  This method creates a small rectangular layer, and set its topmost color to the provided color.
 *  The layer will be filled with a linear vertical gradient changing from the input color,
 *  to its equivalent color but with an alpha set to 0.0;
 *
 *  @param color The input topmost color of the top shadow. Must not be nil.
 */
- (void)setTopColor:(NSColor *)color;

/**
 *  This method creates a small rectangular layer at the top of the scroll view, and set its colors.
 *  The layer will be filled with a linear vertical gradient.
 *
 *  @param upColor The upper color of the shadow. Must not be nil.
 *  @param lowColor The lower color of the shadow. Must not be nil.
 */
- (void)setTopGradientUpperColor:(NSColor *)upColor lowerColor:(NSColor *)lowColor;

/**
 *  This method creates a small rectangular layer, and set its bottomost color to the provided color.
 *  The layer will be filled with a linear vertical gradient changing from the input color,
 *  to its equivalent color but with an alpha set to 0.0;
 *
 *  @param color The input bottommost color of the bottom shadow. Must not be nil.
 */
- (void)setBottomColor:(NSColor *)color;

/**
 *  This method creates a small rectangular layer at the bottom of the scroll view, and set its colors.
 *  The layer will be filled with a linear vertical gradient.
 *
 *  @param lowColor The lower color of the shadow. Must not be nil.
 *  @param upColor The upper color of the shadow. Must not be nil.
 */
- (void)setBottomGradientLowerColor:(NSColor *)lowColor upperColor:(NSColor *)upColor;

@end
