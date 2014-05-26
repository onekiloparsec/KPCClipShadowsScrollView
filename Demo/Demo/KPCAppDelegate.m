//
//  KPCAppDelegate.m
//  Demo
//
//  Created by onekiloparsec on 25/5/14.
//  Copyright (c) 2014 onekiloparsec. All rights reserved.
//

#import "KPCAppDelegate.h"

@implementation KPCAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	self.principalColorWell.target = self;
	self.principalColorWell.action = @selector(refreshScrollViewShadows);

	self.secondaryColorWell.target = self;
	self.secondaryColorWell.action = @selector(refreshScrollViewShadows);

	[self refreshScrollViewShadows];
}

- (IBAction)toggleShadows:(id)sender
{
	[self refreshScrollViewShadows];
}

- (IBAction)toggleShadowsAsGradients:(id)sender
{
	[self refreshScrollViewShadows];
}

- (void)refreshScrollViewShadows
{
	BOOL useShadows = ([self.toggleShadowsCheckButton state] == NSOnState);
	BOOL useShadowGradients = ([self.toggleShadowsAsGradientsCheckButton state] == NSOnState);

	[self.toggleShadowsAsGradientsCheckButton setHidden:!useShadows];
	[self.principalColorWell setHidden:!useShadows];
	[self.secondaryColorWell setHidden:!useShadowGradients];

	if (useShadows && useShadowGradients) {
		[self.scrollView setTopGradientUpperColor:self.principalColorWell.color lowerColor:self.secondaryColorWell.color];
		[self.scrollView setBottomGradientLowerColor:self.principalColorWell.color upperColor:self.secondaryColorWell.color];
	}
	else if (useShadows && !useShadowGradients) {
		[self.scrollView setTopColor:self.principalColorWell.color];
		[self.scrollView setBottomColor:self.principalColorWell.color];
	}
	else if (!useShadows) {
		[self.scrollView setTopColor:nil];
		[self.scrollView setBottomColor:nil];
	}
}

#pragma mark - NSTableViewDataSource

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
	return 20.0;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	return [NSString stringWithFormat:@"Row %ld", (long)row];
}

#pragma mark - NSTableViewDelegate

- (NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
	NSTableCellView *cellView = [tableView makeViewWithIdentifier:[tableColumn identifier] owner:self];
	[cellView.textField setStringValue:[NSString stringWithFormat:@"Row %ld", (long)row]];
	return cellView;
}

@end
