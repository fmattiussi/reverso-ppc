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

@synthesize accountUsername, accountPassword;

- (void)saveServerInfo {
	[[NSUserDefaults standardUserDefaults] setObject:[addressField stringValue] forKey:@"serverAddress"];
	[[NSUserDefaults standardUserDefaults] setObject:[portField stringValue] forKey:@"serverPort"];
	
	[[NSUserDefaults standardUserDefaults] setObject:[accountUsername stringValue] forKey:@"accountUsername"];
	[[NSUserDefaults standardUserDefaults] setObject:[accountPassword stringValue] forKey:@"accountPassword"];
	
	if ([authRadio state] == 1) {
		[[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"authCheck"];
		[[NSUserDefaults standardUserDefaults] setObject:[serverUsername stringValue] forKey:@"serverUsername"];
		[[NSUserDefaults standardUserDefaults] setObject:[serverPassword stringValue] forKey:@"serverPassword"];
	} else {
		[[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"authCheck"];
	}
	
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
	
	NSString *reversoUsername = [[NSUserDefaults standardUserDefaults] stringForKey:@"accountUsername"];
	NSString *reversoPassword = [[NSUserDefaults standardUserDefaults] stringForKey:@"accountPassword"];
	
	// populating the elements
	
	if (reversoUsername != nil) {
		[addressField setStringValue:serverAddress];
		[portField setStringValue:serverPort];
	}
	
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
