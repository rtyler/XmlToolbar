//
//  MainController.h
//  XmlToolbar
//
//  Created by R. Tyler Ballance on 10/22/06.
//

#import <Cocoa/Cocoa.h>

#import "XmlToolbar.h"

@interface MainController : NSObject {
	IBOutlet NSWindow *mainWindow;
	
	XmlToolbar *toolbarLoader;
}

@end
