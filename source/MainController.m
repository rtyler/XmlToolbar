//
//  MainController.m
//  XmlToolbar
//
//  Created by R. Tyler Ballance on 10/22/06.
//

#import "MainController.h"


@implementation MainController

- (void)awakeFromNib
{
	NSString *xmlFile = [[NSBundle mainBundle] pathForResource:@"Toolbar" ofType:@"xml"];
	toolbarLoader = [[XmlToolbar alloc] initializeForWindow:mainWindow withXml:xmlFile];
}

@end
