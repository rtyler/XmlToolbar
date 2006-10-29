//
//  XmlToolbarItem.m
//  XmlToolbar
//
//  Created by R. Tyler Ballance on 10/22/06.
//  Copyright 2006 bleep. LLC. All rights reserved.
//

#import "XmlToolbarItem.h"


@implementation XmlToolbarItem

- (void)setNotificationName:(NSString *)theNotification
{
	notificationName = [theNotification copy];
}

- (NSString *)notificationName
{
	return notificationName;
}

@end
