//
//  XmlToolbarItem.h
//  XmlToolbar
//
//  Created by R. Tyler Ballance on 10/22/06.
//  Copyright 2006 bleep. LLC. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface XmlToolbarItem : NSToolbarItem {
	NSString *notificationName;
}

- (void)setNotificationName:(NSString *)theNotification;
- (NSString *)notificationName;

@end
