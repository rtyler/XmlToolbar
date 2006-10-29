//
//  MainController.m
//  XmlToolbar
//
//  Created by R. Tyler Ballance on 10/22/06.
//  Copyright 2006 bleep. LLC. All rights reserved.
//

#import "MainController.h"


@implementation MainController

- (void)awakeFromNib
{
	NSString *xmlFile = [[NSBundle mainBundle] pathForResource:@"Toolbar" ofType:@"xml"];
	toolbarLoader = [[XmlToolbar alloc] initializeForWindow:mainWindow withXml:xmlFile];
}

@end
