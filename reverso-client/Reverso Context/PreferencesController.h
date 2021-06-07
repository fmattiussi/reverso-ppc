//
//  PreferencesController.h
//  Reverso Context
//
//  Created by Francesco Mattiussi on 23/05/21.
//  Copyright 2021 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface PreferencesController : NSWindowController {
	IBOutlet NSWindow *mainWindow;
	IBOutlet NSView *mainView;
	IBOutlet NSToolbar *toolbar;
	
	IBOutlet NSView *serverView;
	IBOutlet NSView *accountView;
	
	// Server View
	
	IBOutlet NSTextField *addressField;
	IBOutlet NSTextField *portField;
	
	IBOutlet NSTextField *serverUsername;
	IBOutlet NSTextField *serverPassword;
	
	IBOutlet NSButton *authRadio;
	IBOutlet NSTextField *accountUsername;
	IBOutlet NSTextField *accountPassword;
}

@property (assign) IBOutlet NSWindow *mainWindow;
@property (assign) IBOutlet NSView *mainView;
@property (assign) IBOutlet NSToolbar *toolbar;
	
@property (assign) IBOutlet NSView *serverView;
@property (assign) IBOutlet NSView *accountView;

- (IBAction)serverPanel:(id)pId;
- (IBAction)accountPanel:(id)pId;

- (void)saveServerInfo;

- (IBAction)toggleAuth:(id)pId;
// to move

@property (assign) NSTextField *addressField;
@property (assign) NSTextField *portField;

@property (assign) IBOutlet NSTextField *serverUsername;
@property (assign) IBOutlet NSTextField *serverPassword;
	
@property (assign) IBOutlet NSButton *authRadio;
@property (assign) IBOutlet NSTextField *accountUsername;
@property (assign) IBOutlet NSTextField *accountPassword;

- (IBAction)updateInformations:(id)pId;
- (IBAction)closeDrawer:(id)pId;

- (IBAction)open:(id)sender;

@end
