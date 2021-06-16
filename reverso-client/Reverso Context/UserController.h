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
	
	IBOutlet NSMutableArray *favoritesTableViewData;
	IBOutlet NSMutableArray *historyTableViewData;
	
	// Language Selectors
	IBOutlet NSPopUpButton *sourceLanguage;
	IBOutlet NSPopUpButton *targetLanguage;
	IBOutlet NSButton *useDefaultLanguage;
	
	// TabView
	IBOutlet NSTabView *switchTabView;
	
	// Globals
	NSInteger service;
	
	// Favorites
	NSMutableArray *favoritesArray;
	FavoriteDataObject *favoritesDataObject;
	
	// History
	NSMutableArray *historyArray;
	HistoryDataObject *historyDataObject;
	
	// URLRequest
	NSMutableData* responseData;
	
	NSInteger* sourceLanguageId;
	NSInteger* targetLanguageId;
	
	// XMLParser
	NSString* currentElement;
	NSMutableString *elementValue;
	NSString *favorite;
	NSString *history;
}

@property (assign) IBOutlet NSTableView *favoritesTableView;
@property (assign) IBOutlet NSTableView *historyTableView;

@property (assign) IBOutlet NSPopUpButton *sourceLanguage;
@property (assign) IBOutlet NSPopUpButton *targetLanguage;
@property (assign) IBOutlet NSButton *useDefaultLanguage;

@property (assign) NSTabView *switchTabView;

@property (assign) NSInteger service;

@property (assign) NSMutableArray *favoritesArray;
@property (assign) FavoriteDataObject *favoritesDataObject;

@property (assign) NSMutableArray *historyArray;
@property (assign) HistoryDataObject *historyDataObject;

@property (nonatomic, retain) NSMutableData* responseData;
@property (assign) NSInteger* sourceLanguageId;
@property (assign) NSInteger* targetLanguageId;

@property (assign) NSString* currentElement;
@property (assign) NSMutableString* elementValue;
@property (assign) NSString* favorite;
@property (assign) NSString* history;

@property (assign) IBOutlet NSMutableArray *favoritesTableViewData;
@property (assign) IBOutlet NSMutableArray *historyTableViewData;

// Utility Functions

- (void)loadPanel;
- (NSString *)locale:(int)index;

- (void)buildHistory:(NSMutableArray *)tableViewData array:(NSMutableArray *)baseArray;
- (void)buildFavorites:(NSMutableArray *)tableViewData array:(NSMutableArray *)baseArray;

// TableView Delagtes

- (int)numberOfRowsInTableView:(NSTableView *)pTableViewObj;

- (id) tableView:(NSTableView *)pTableViewObj objectValueForTableColumn:(NSTableColumn *)pTableColumn row:(int)pRowIndex;

- (void)tableView:(NSTableView *)pTableViewObj setObjectValue:(id)pObject forTableColumn:(NSTableColumn *)pTableColumnrow:(int)pRowIndex;
									  
@end
