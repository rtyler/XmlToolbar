//
//  XmlToolbar.m
//  XmlToolbar
//
//  Created by R. Tyler Ballance on 10/22/06.
//  Copyright 2006 bleep. LLC. All rights reserved.
//

#import "XmlToolbar.h"

@implementation XmlToolbar


#pragma "General Methods"
- (id)initializeForWindow:(NSWindow *)theWindow withXml:(NSString *)pathToXmlFile
{
	self = [super init];
	
	if (self != nil) 
	{
		NSError *error = nil;
		NSXMLDocument *xmlDocument = [[NSXMLDocument alloc] initWithContentsOfURL:[NSURL fileURLWithPath:pathToXmlFile]
																		  options:NSXMLDocumentTidyXML error:&error];
		// XXX: Define a DTD at some point to validate against
		//if (!([xmlDocument validateAndReturnError:&error]))
		//	NSLog(@"Failed to validate Xml with error: %@", error);
		
		toolbarItems = [[NSMutableDictionary alloc] init];
		toolbarOrderedIdentifiers = [[NSMutableArray alloc] init];
		toolbarItems = [self processToolbarTree:xmlDocument];
		
		toolbar = [[NSToolbar alloc] initWithIdentifier:[self processToolbarIdentifier:xmlDocument]];
		window = theWindow;
		
		[self setToolbarDelegate:self];
		[self processToolbarSettings:xmlDocument];
		
		[window setToolbar:toolbar];
		[window makeKeyAndOrderFront:nil];
	}
	
	return self;
}
#pragma mark -

#pragma mark "Internal Methods"
// XXX: This whole function sucks/is hackish.
- (void)processToolbarSettings:(NSXMLDocument *)xmlDocument
{
	NSError *error = nil;
	NSArray *nodes = [[xmlDocument rootElement] nodesForXPath:@"//autosavesconfiguration" error:&error];
		
	if ([nodes count] > 0)
		[toolbar setAutosavesConfiguration:TRUE];
	
	nodes = [[xmlDocument rootElement] nodesForXPath:@"//allowsusercustomization" error:&error];
	
	if ([nodes count] > 0)
		[toolbar setAllowsUserCustomization:TRUE];
	
	nodes = [[xmlDocument rootElement] nodesForXPath:@"//showsbaselineseparator" error:&error];
		
	if ([nodes count] > 0)
		[toolbar setShowsBaselineSeparator:TRUE];
	
	// Process <sizemode/>
	nodes = [[xmlDocument rootElement] nodesForXPath:@"//sizemode" error:&error];
	if ([nodes count] > 0)
	{	
		NSString *mode = [[nodes objectAtIndex:0] stringValue];
		
		/*
		 NSToolbarSizeModeDefault,
		 NSToolbarSizeModeRegular,
		 NSToolbarSizeModeSmall
		 */
		
		if (![mode compare:@"NSToolbarSizeModeRegular"])
			[toolbar setSizeMode:NSToolbarSizeModeRegular];
		else if (![mode compare:@"NSToolbarSizeModeSmall"])
			[toolbar setSizeMode:NSToolbarSizeModeSmall];
	}
	
	// Process <displaymode/>
	nodes = [[xmlDocument rootElement] nodesForXPath:@"//displaymode" error:&error];
	if ([nodes count] > 0)
	{
		NSString *mode = [[nodes objectAtIndex:0] stringValue];
		
		/*
		 NSToolbarDisplayModeDefault,
		 NSToolbarDisplayModeIconAndLabel,
		 NSToolbarDisplayModeIconOnly,
		 NSToolbarDisplayModeLabelOnly
		 */
		
		if (![mode compare:@"NSToolbarDisplayModeIconAndLabel"])
			[toolbar setDisplayMode:NSToolbarDisplayModeIconAndLabel];
		else if (![mode compare:@"NSToolbarDisplayModeIconOnly"])
			[toolbar setDisplayMode:NSToolbarDisplayModeIconOnly];
		else if (![mode compare:@"NSToolbarDisplayModeLabelOnly"])
			[toolbar setDisplayMode:NSToolbarDisplayModeLabelOnly];
	}
}

- (NSString *)processToolbarIdentifier:(NSXMLDocument *)xmlDocument
{
	NSError *error = nil;
	NSArray *identifierNodes = [[xmlDocument rootElement] nodesForXPath:@"//identifier" error:&error];
	return [[identifierNodes objectAtIndex:0] stringValue];
}

- (NSMutableDictionary *)processToolbarTree:(NSXMLDocument *)xmlDocument
{
	NSMutableDictionary *items = [[NSMutableDictionary alloc] init];
	NSError *error = nil;
	int i = 0;
	NSArray *nodes = [[xmlDocument rootElement] nodesForXPath:@"//toolbaritem" error:&error];
		
	for (i = 0; i < [nodes count]; ++i)
	{
		NSXMLElement *element = [nodes objectAtIndex:i];
		NSString *identifierAndLabel = [[[element elementsForName:@"label"] objectAtIndex:0] stringValue];
		XmlToolbarItem *item = [[XmlToolbarItem alloc] initWithItemIdentifier:identifierAndLabel];
		
		[item setLabel:identifierAndLabel];
		[item setPaletteLabel:[[[element elementsForName:@"palettelabel"] objectAtIndex:0] stringValue]];
		[item setToolTip:[[[element elementsForName:@"tooltip"] objectAtIndex:0] stringValue]];
		[item setImage:[NSImage imageNamed:[[[element elementsForName:@"image"] objectAtIndex:0] stringValue]]];
		[item setNotificationName:[NSString stringWithFormat:@"%@", 
			[[[element elementsForName:@"notification"] objectAtIndex:0] stringValue]]];
		[item setTarget:self];
		[item setAction:@selector(toolbarItemClicked:)];
		
		// Add to dictionary
		[toolbarOrderedIdentifiers addObject:[item itemIdentifier]];
		[items setObject:item forKey:identifierAndLabel];
	}
	
	return items;
}
#pragma mark -

#pragma mark "NSToolbar Related Methods"
- (void)toolbarItemClicked:(XmlToolbarItem *)item
{
	NSLog(@"Firing off \"%@\" notification", [item notificationName]);
	[[NSNotificationCenter defaultCenter] postNotificationName:[item notificationName] object:item];
}

- (XmlToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier 
			willBeInsertedIntoToolbar:(BOOL)flag 
{
	return [toolbarItems objectForKey:itemIdentifier];
}

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar 
{
	return toolbarOrderedIdentifiers;
}

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar 
{
	return toolbarOrderedIdentifiers;
}

- (int)count 
{ 
	return [toolbarItems count]; 
}

- (void)setToolbarDelegate:(id)delegate { [toolbar setDelegate:delegate]; }
- (void)setToolbarDisplayMode:(NSToolbarDisplayMode)displayMode { [toolbar setDisplayMode:displayMode]; }
- (void)setToolbarSizeMode:(NSToolbarSizeMode)sizeMode { [toolbar setSizeMode:sizeMode]; }
- (void)setToolbarAllowsUserCustomization:(BOOL)allowsCustomization { [toolbar setAllowsUserCustomization:allowsCustomization]; }
- (void)setToolbarAutosavesConfiguration:(BOOL)flag { [toolbar setAutosavesConfiguration:flag]; }
- (void)setToolbarShowsBaselineSeparator:(BOOL)flag { [toolbar setShowsBaselineSeparator:flag]; }
- (void)setToolbarVisible:(BOOL)shown { [toolbar setVisible:shown]; }
#pragma mark -

@end
