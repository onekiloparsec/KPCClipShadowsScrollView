//
//  KPCScrollView.m
//  iObserve
//
//  Created by onekiloparsec on 24/5/14.
//  Copyright (c) 2014 onekiloparsec. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "KPCClipShadowsScrollView.h"
#import <QuartzCore/QuartzCore.h>

@interface KPCClipShadowsScrollView	() {
	// Not set to CAGradientLayer for a more flexible future.
	CALayer *_topLayer;
	CALayer *_bottomLayer;
}
@end

@implementation KPCClipShadowsScrollView

- (id)init
{
	self = [super init];
	if (self) {
		[self _clipShadowScrollViewSetup];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	if (self) {
		[self _clipShadowScrollViewSetup];
	}
	return self;
}

- (id)initWithFrame:(NSRect)frameRect
{
	self = [super initWithFrame:frameRect];
	if (self) {
		[self _clipShadowScrollViewSetup];
	}
	return self;
}

- (void)_clipShadowScrollViewSetup
{
	[self setWantsLayer:YES];

	self.topShadowHeight = 10.0;
	self.bottomShadowHeight = 10.0;

	self.topShadowAnimationDuration = 0.15;
	self.bottomShadowAnimationDuration = 0.15;

	NSClipView *parentClipView = [self contentView];
	[parentClipView postsBoundsChangedNotifications];
	[parentClipView setCopiesOnScroll:NO];

	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(setNeedsDisplay)
												 name:NSViewBoundsDidChangeNotification
											   object:parentClipView];
}

- (void)setNeedsDisplay
{
	[self setNeedsDisplay:YES];
}

- (void)clearShadows
{
	[_topLayer removeFromSuperlayer];
	[_bottomLayer removeFromSuperlayer];
	[self setNeedsDisplay:YES];
}

- (void)setTopColor:(NSColor *)upColor
{
	if (upColor == nil) {
		[NSException raise:NSInvalidArgumentException format:@"The input color is nil"];
		return;
	}

	CGFloat red, green, blue, alpha;
	[upColor getRed:&red green:&green blue:&blue alpha:&alpha];
	NSColor *lowColor = [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:0.0];
	[self setTopGradientUpperColor:upColor lowerColor:lowColor];
}

- (void)setTopGradientUpperColor:(NSColor *)upColor lowerColor:(NSColor *)lowColor
{
	if (upColor == nil || lowColor == nil) {
		[NSException raise:NSInvalidArgumentException format:@"The input color is nil"];
		return;
	}

	if (_topLayer == nil) {
		_topLayer = [CAGradientLayer layer];
	}

	[(CAGradientLayer *)_topLayer setColors:@[(id)upColor.CGColor, (id)lowColor.CGColor]];
	[self setNeedsDisplay:YES];
}

- (void)setBottomColor:(NSColor *)lowColor
{
	if (lowColor == nil) {
		[NSException raise:NSInvalidArgumentException format:@"The input color is nil"];
		return;
	}

	CGFloat red, green, blue, alpha;
	[lowColor getRed:&red green:&green blue:&blue alpha:&alpha];
	NSColor *upColor = [NSColor colorWithCalibratedRed:red green:green blue:blue alpha:0.0];
	[self setBottomGradientLowerColor:lowColor upperColor:upColor];
}

- (void)setBottomGradientLowerColor:(NSColor *)lowColor upperColor:(NSColor *)upColor
{
	if (upColor == nil || lowColor == nil) {
		[NSException raise:NSInvalidArgumentException format:@"The input color is nil"];
		return;
	}

	if (_bottomLayer == nil) {
		_bottomLayer = [CAGradientLayer layer];
	}

	[(CAGradientLayer *)_bottomLayer setColors:@[(id)upColor.CGColor, (id)lowColor.CGColor]];
	[self setNeedsDisplay:YES];
}

- (void)handleShadowLayer:(CALayer *)shadowLayer
					 draw:(BOOL)draw
			   withHeight:(CGFloat)height
		animationDuration:(NSTimeInterval)duration
{
	CGFloat originY = 0.0;

	if (shadowLayer == _topLayer) {
		originY = ([self isFlipped]) ? NSMinY(self.bounds) : NSMaxY(self.bounds)-height;
	}
	else {
		originY = ([self isFlipped]) ? NSMaxY(self.bounds)-height : NSMinY(self.bounds);
	}

	if (draw && shadowLayer) {
		shadowLayer.frame = CGRectMake(NSMinX(self.bounds), originY, NSWidth(self.bounds), height);

		if ([[self.layer sublayers] containsObject:shadowLayer] == NO) {
			[self.layer addSublayer:shadowLayer];

			if (duration > 0.0) {
				CABasicAnimation *fadeIn = [CABasicAnimation animationWithKeyPath:@"opacity"];
				fadeIn.fromValue = [NSNumber numberWithFloat:0.0];
				fadeIn.toValue = [NSNumber numberWithFloat:1.0];
				fadeIn.duration = duration;
				fadeIn.fillMode = kCAFillModeForwards;
				[shadowLayer addAnimation:fadeIn forKey:@"fadeInAnimation"];
			}
		}
	}
	else {
		if (duration > 0.0 && shadowLayer) {
			[CATransaction begin]; {
				[CATransaction setCompletionBlock:^{
					[shadowLayer removeFromSuperlayer];
				}];
				CABasicAnimation *fadeOut = [CABasicAnimation animationWithKeyPath:@"opacity"];
				fadeOut.fromValue = [NSNumber numberWithFloat:1.0];
				fadeOut.toValue = [NSNumber numberWithFloat:0.0];
				fadeOut.duration = duration;
				[shadowLayer addAnimation:fadeOut forKey:@"fadeOutAnimation"];
			}
		}
		else {
			[shadowLayer removeFromSuperlayer];
		}
	}
}

- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];

	NSClipView *parentClipView = [self contentView];
	NSRect clipViewBounds = [parentClipView bounds];
	NSRect docViewBounds = [(NSView *)[self documentView] bounds];

	BOOL isTopOfDocumentViewClipped = (clipViewBounds.origin.y > 0.0);

	[self handleShadowLayer:_topLayer
					   draw:(isTopOfDocumentViewClipped && _topLayer)
				 withHeight:self.topShadowHeight
		  animationDuration:self.topShadowAnimationDuration];

	BOOL isBottomOfDocumentViewClipped = (clipViewBounds.origin.y + clipViewBounds.size.height < docViewBounds.size.height);

	[self handleShadowLayer:_bottomLayer
					   draw:(isBottomOfDocumentViewClipped && _bottomLayer)
				 withHeight:self.bottomShadowHeight
		  animationDuration:self.bottomShadowAnimationDuration];
}

@end
