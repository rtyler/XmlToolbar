//
//  ToolbarLoader.h
//  XmlToolbar
//
//  Created by R. Tyler Ballance on 10/22/06.
//  Copyright 2006 bleep. LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "XmlToolbarItem.h"

@interface XmlToolbar : NSObject {
	NSWindow *window;
	NSToolbar *toolbar;
	
	NSMutableDictionary *toolbarItems;
	NSMutableArray *toolbarOrderedIdentifiers;
}

- (id)initializeForWindow:(NSWindow *)window withXml:(NSString *)pathToXmlFile;

/* Toolbar related methods */
- (void)toolbarItemClicked:(XmlToolbarItem *)item;

- (void)setToolbarDelegate:(id)delegate;
- (void)setToolbarDisplayMode:(NSToolbarDisplayMode)displayMode;
- (void)setToolbarSizeMode:(NSToolbarSizeMode)sizeMode;
- (void)setToolbarAllowsUserCustomization:(BOOL)allowsCustomization;
- (void)setToolbarAutosavesConfiguration:(BOOL)flag;
- (void)setToolbarShowsBaselineSeparator:(BOOL)flag;
- (void)setToolbarVisible:(BOOL)shown;

@end
