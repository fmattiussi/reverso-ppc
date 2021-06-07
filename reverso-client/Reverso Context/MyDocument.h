//
//  MyDocument.h
//  Reverso Context
//
//  Created by Francesco Mattiussi on 21/05/21.
//  Copyright __MyCompanyName__ 2021 . All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "TableViewDataObject.h"
#import "PreferencesController.h"

@interface MyDocument : NSDocument
{

	NSMutableData* responseData;
	NSInteger *sourceLanguageId;
	NSInteger *targetLanguageId;
	
	// Interface Builder Things
	IBOutlet NSSearchField *searchField;
	IBOutlet NSPopUpButton *sourceLanguage;
	IBOutlet NSPopUpButton *targetLanguage;
	IBOutlet NSTableView *resultsTableView;
	IBOutlet NSProgressIndicator *spinner;
	
	// Parsing Things
	NSString *currentElement, *source_example, *target_example;
	NSMutableString *elementValue;
	
	// Results Arrays
	NSMutableArray *sourceExampleArray, *targetExampleArray;
	NSMutableArray *tableViewData;
	
	// Drawer Things
	IBOutlet NSDrawer *drawer;
	IBOutlet NSView *drawerView;
	
	// TabView
	IBOutlet NSTabView *tabView;
	NSString *service;
	
	// Windows
	IBOutlet NSWindow *preferences;
}

// Menu Actions
- (IBAction)openPreferences:(id)sender;

// Windows
@property (assign) IBOutlet NSWindow *preferences;

// TabView
@property (assign) IBOutlet NSTabView *tabView;
@property (assign) NSString *service;
- (IBAction)tabChanged:(id)sender;

// Drawer

@property (assign) IBOutlet NSDrawer *drawer;
@property (assign) IBOutlet NSView *drawerView;
- (IBAction)toggleDrawer:(id)sender;

// Interface Builder's properties
@property (assign) IBOutlet NSTextField *searchField;
@property (assign) IBOutlet NSPopUpButton *sourceLanguage;
@property (assign) IBOutlet NSPopUpButton *targetLanguage;
@property (assign) IBOutlet NSTableView *resultsTableView;
@property (assign) IBOutlet NSProgressIndicator *spinner;

// Interface Builder's actions
- (IBAction)search:(id)pId;
- (IBAction)sourceLanguageSelected:(id)sender;
- (IBAction)targetLanguageSelected:(id)sender;

@property (nonatomic, retain) NSMutableData* responseData;
@property (assign) NSInteger* sourceLanguageId;
@property (assign) NSInteger* targetLanguageId;

@property (assign) NSString* currentElement;
@property (assign) NSString* source_example;
@property (assign) NSString* target_example;
@property (assign) NSMutableString* elementValue;

@property (assign) NSMutableArray* sourceExampleArray;
@property (assign) NSMutableArray* targetExampleArray;
@property (assign) NSMutableArray* tableViewData;

- (NSString *)locale:(int)index;
- (void)find;
// TableView's delegate functions

- (int)numberOfRowsInTableView:(NSTableView *)pTableViewObj;

- (id) tableView:(NSTableView *)pTableViewObj 
                objectValueForTableColumn:(NSTableColumn *)pTableColumn 
                                      row:(int)pRowIndex;

- (void)tableView:(NSTableView *)pTableViewObj 
                           setObjectValue:(id)pObject 
                           forTableColumn:(NSTableColumn *)pTableColumn
                                      row:(int)pRowIndex;

@end
