//
//  MainController.h
//  XmlToolbar
//
//  Created by R. Tyler Ballance on 10/22/06.
//  Copyright 2006 bleep. LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "XmlToolbar.h"

@interface MainController : NSObject {
	IBOutlet NSWindow *mainWindow;
	
	XmlToolbar *toolbarLoader;
}

@end
