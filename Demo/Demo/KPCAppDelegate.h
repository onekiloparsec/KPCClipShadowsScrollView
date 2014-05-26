//
//  KPCAppDelegate.h
//  Demo
//
//  Created by onekiloparsec on 25/5/14.
//  Copyright (c) 2014 onekiloparsec. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "KPCClipShadowsScrollView.h"

@interface KPCAppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet KPCClipShadowsScrollView *scrollView;
@property (assign) IBOutlet NSButton *toggleShadowsCheckButton;
@property (assign) IBOutlet NSButton *toggleShadowsAsGradientsCheckButton;
@property (assign) IBOutlet NSColorWell *principalColorWell;
@property (assign) IBOutlet NSColorWell *secondaryColorWell;

- (IBAction)toggleShadows:(id)sender;
- (IBAction)toggleShadowsAsGradients:(id)sender;

@end
