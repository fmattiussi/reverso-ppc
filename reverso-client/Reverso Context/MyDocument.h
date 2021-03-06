//
//  MyDocument.h
//  Reverso Context
//
//  Created by Francesco Mattiussi on 21/05/21.
//  Copyright __MyCompanyName__ 2021 . All rights reserved.
//


#import <Cocoa/Cocoa.h>
#import "TableViewDataObject.h"
#import "TranslationDataObject.h"
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
	IBOutlet NSTableView *translationsTableView;
	IBOutlet NSProgressIndicator *spinner;
	
	// Parsing Things
	NSString *currentElement, *source_example, *target_example, *translation;
	NSMutableString *elementValue;
	
	// Results Arrays
	NSMutableArray *sourceExampleArray, *targetExampleArray;
	NSMutableArray *tableViewData;
	NSMutableArray *translationsTableViewData;
	NSMutableArray *translations;
	
	// Drawer Things
	IBOutlet NSDrawer *drawer;
	IBOutlet NSView *drawerView;
	IBOutlet NSTextView *sourceText;
	IBOutlet NSTextView *targetText;
	
	// TabView
	IBOutlet NSTabView *servicesTabView;
	NSInteger service;
	
	// Windows
	IBOutlet NSWindow *preferences;
}

// Menu Actions
- (IBAction)openPreferences:(id)sender;

// Windows
@property (assign) IBOutlet NSWindow *preferences;

// TabView
@property (assign) IBOutlet NSTabView *servicesTabView;
@property (assign) NSInteger service;

// Drawer

@property (assign) IBOutlet NSDrawer *drawer;
@property (assign) IBOutlet NSView *drawerView;
@property (assign) IBOutlet NSTextView *sourceText;
@property (assign) IBOutlet NSTextView *targetText;
- (IBAction)toggleDrawer:(id)sender;
- (IBAction)saveToPasteboard:(id)sender;

// Interface Builder's properties
@property (assign) IBOutlet NSTextField *searchField;
@property (assign) IBOutlet NSPopUpButton *sourceLanguage;
@property (assign) IBOutlet NSPopUpButton *targetLanguage;
@property (assign) IBOutlet NSTableView *resultsTableView;
@property (assign) IBOutlet NSTableView *translationsTableView;
@property (assign) IBOutlet NSProgressIndicator *spinner;

// Interface Builder's actions
- (IBAction)search:(id)pId;
- (IBAction)sourceLanguageSelected:(id)sender;
- (IBAction)targetLanguageSelected:(id)sender;
- (IBAction)rowSelected:(id)sender;

@property (nonatomic, retain) NSMutableData* responseData;
@property (assign) NSInteger* sourceLanguageId;
@property (assign) NSInteger* targetLanguageId;

@property (assign) NSString* currentElement;
@property (assign) NSString* source_example;
@property (assign) NSString* target_example;
@property (assign) NSString* translation;
@property (assign) NSMutableString* elementValue;

@property (assign) NSMutableArray* sourceExampleArray;
@property (assign) NSMutableArray* targetExampleArray;
@property (assign) NSMutableArray* tableViewData;

@property (assign) NSMutableArray *translationsTableViewData;
@property (assign) NSMutableArray *translations;

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
