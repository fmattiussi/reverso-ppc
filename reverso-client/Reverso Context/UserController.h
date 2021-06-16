//
//  UserController.h
//  Reverso Context
//
//  Created by Francesco Mattiussi on 16/06/21.
//  Copyright 2021 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FavoriteDataObject.h"
#import "HistoryDataObject.h"

@interface UserController : NSWindowController {

	// TableViews
	IBOutlet NSTableView *favoritesTableView;
	IBOutlet NSTableView *historyTableView;
	
	// Language Selectors
	IBOutlet NSPopUpButton *sourceLanguage;
	IBOutlet NSPopUpButton *targetLanguage;
	IBOutlet NSButton *useDefaultLanguage;
	
	// TabView
	IBOutlet NSTabView *tabView;
	
	// Globals
	NSInteger service;
	
	// Favorites
	NSMutableArray *favoritesArray;
	FavoriteDataObject *favoritesDataObject;
	
	// History
	NSMutableArray *historyArray;
	HistoryDataObject *historyDataObject;
}

@property (assign) IBOutlet NSTableView *favoritesTableView;
@property (assign) IBOutlet NSTableView *historyTableView;

@property (assign) IBOutlet NSPopUpButton *sourceLanguage;
@property (assign) IBOutlet NSPopUpButton *targetLanguage;
@property (assign) IBOutlet NSButton *useDefaultLanguage;

@property (assign) NSTabView *tabView;

@property (assign) NSInteger service;

@property (assign) NSMutableArray *favoritesArray;
@property (assign) FavoriteDataObject *favoritesDataObject;

@property (assign) NSMutableArray *historyArray;
@property (assign) HistoryDataObject *historyDataObject;

@end
