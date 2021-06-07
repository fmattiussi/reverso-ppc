//
//  PreferencesController.m
//  Reverso Context
//
//  Created by Francesco Mattiussi on 23/05/21.
//  Copyright 2021 __MyCompanyName__. All rights reserved.
//

#import "PreferencesController.h"


@implementation PreferencesController

@synthesize mainView, serverView, accountView, mainWindow, toolbar;

@synthesize addressField, portField, serverUsername, serverPassword, authRadio;

- (void)saveServerInfo {
	[[NSUserDefaults standardUserDefaults] setObject:[addressField stringValue] forKey:@"serverAddress"];
	[[NSUserDefaults standardUserDefaults] setObject:[portField stringValue] forKey:@"serverPort"];
	
	if ([authRadio state] == 1) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"authCheck"];
		[[NSUserDefaults standardUserDefaults] setObject:[serverUsername stringValue] forKey:@"serverUsername"];
		[[NSUserDefaults standardUserDefaults] setObject:[serverPassword stringValue] forKey:@"serverPassword"];
	} else {
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"authCheck"];
	}
	
	NSLog(@"successfully updated userdefaults, retrievingan example");
	NSString *example = [[NSUserDefaults standardUserDefaults] stringForKey:@"serverAddress"];
	NSLog(@"%@", example);
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)windowShouldClose:(id)window {
	[self saveServerInfo];
	return YES;
}

- (IBAction)toggleAuth:(id)pId {
	if (authRadio.state == 1) {
		[serverUsername setEnabled:YES];
		[serverPassword setEnabled:YES];
	} else {
		[serverUsername setEnabled:NO];
		[serverPassword setEnabled:NO];
	}
}

- (void)awakeFromNib
{
	NSLog(@"window did load");
	[[mainWindow contentView] replaceSubview:mainView with:serverView];
	
	// retrieving data
	NSString *serverAddress = [[NSUserDefaults standardUserDefaults] stringForKey:@"serverAddress"];
	NSString *serverPort = [[NSUserDefaults standardUserDefaults] stringForKey:@"serverPort"];
	
	BOOL authCheck = [[NSUserDefaults standardUserDefaults] boolForKey:@"authCheck"];
	NSString *authUsername = [[NSUserDefaults standardUserDefaults] stringForKey:@"serverUsername"];
	NSString *authPassword = [[NSUserDefaults standardUserDefaults] stringForKey:@"serverPassword"];
	
	// populating the elements
	[addressField setStringValue:serverAddress];
	[portField setStringValue:serverPort];
	
	if (authCheck == YES) {
		authRadio.state = 1;
		[serverUsername setStringValue:authUsername];
		[serverPassword setStringValue:authPassword];
		[serverUsername setEnabled:YES];
		[serverPassword setEnabled:YES];
	} else {
		authRadio.state = 0;
		[serverUsername setEnabled:NO];
		[serverPassword setEnabled:NO];
	}
}

- (IBAction)serverPanel:(id)pId {
	NSLog(@"serverPanel");
	[[mainWindow contentView] replaceSubview:accountView with:serverView];
}


- (IBAction)accountPanel:(id)pId {
	NSLog(@"accountPanel");
	[[mainWindow contentView] replaceSubview:serverView with:accountView];
}

@end
