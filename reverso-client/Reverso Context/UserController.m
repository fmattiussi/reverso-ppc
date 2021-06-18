//
//  UserController.m
//  Reverso Context
//
//  Created by Francesco Mattiussi on 16/06/21.
//  Copyright 2021 __MyCompanyName__. All rights reserved.
//

#import "UserController.h"


@implementation UserController

@synthesize favoritesTableView, favoritesArray, favoritesDataObject, favoritesTableViewData;
@synthesize historyTableView, historyArray, historyDataObject, historyTableViewData;

@synthesize sourceLanguage, targetLanguage, useDefaultLanguage;

@synthesize service, sourceLanguageId, targetLanguageId;

@synthesize switchTabView;

- (id)init
{
    self = [super init];
    if (self) {
    
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
    
    }
    return self;
}

- (NSString *)locale:(int)index {
	switch(index) {
		case 0:
			return @"en";
			break;
			
		case 1:
			return @"fr";
			break;
			
		case 2:
			return @"it";
			break;
			
		default:
			return @"en";
			break;
	}
}

- (void)windowControllerDidLoadNib:(NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
	
	service = 1;
	
	[[self favoritesTableView] setDelegate:self];
	[[self favoritesTableView] setDataSource:self];
	[[self favoritesTableView] setTarget:self];
	
	[[self historyTableView] setDelegate:self];
	[[self historyTableView] setDataSource:self];
	[[self historyTableView] setTarget:self];
	
	[[self switchTabView] setDelegate:self];
	
	sourceLanguageId = [self locale:[sourceLanguage indexOfSelectedItem]];
	targetLanguageId = [self locale:[targetLanguage indexOfSelectedItem]];
}

// TableView's delegates and functions

- (int)numberOfRowsInTableView:(NSTableView *)pTableViewObj {

	if (pTableViewObj == favoritesTableView) {
		
		return [self.favoritesTableViewData count];
		
	} else if (pTableViewObj == historyTableView) {
		
		return [self.historyTableViewData count];
		
	}
}

- (id) tableView:(NSTableView *)pTableViewObj objectValueForTableColumn:(NSTableColumn *)pTableColumn row:(int)pRowIndex {
   
	if (pTableViewObj == favoritesTableView) {
		FavoriteDataObject *dataObject = (FavoriteDataObject *)[self.favoritesTableViewData objectAtIndex:pRowIndex];
		
		if ([[pTableColumn identifier] isEqualToString:@"favorite"]) {
			return [dataObject targetText];
		}
		
	} else if (pTableViewObj == historyTableView) {
		HistoryDataObject *dataObject = (HistoryDataObject *)[self.historyTableViewData objectAtIndex:pRowIndex];
		
		if ([[pTableColumn identifier] isEqualToString:@"history"]) {
			return [dataObject targetLanguage];
		}
	}

	NSLog(@"error in managing identifiers");
	return NULL;
   
}

- (void)tableView:(NSTableView *)pTableViewObj setObjectValue:(id)pObject forTableColumn:(NSTableColumn *)pTableColumn row:(int)pRowIndex {
   
	if (pTableViewObj == favoritesTableView) {
		FavoriteDataObject *dataObject = (FavoriteDataObject *)[self.favoritesTableViewData objectAtIndex:pRowIndex];
		
		if ([[pTableColumn identifier] isEqualToString:@"favorite"]) {
			return [dataObject setTargetText:(NSString *)pObject];
		}
		
	} else if (pTableViewObj == historyTableView) {
		HistoryDataObject *dataObject = (HistoryDataObject *)[self.historyTableViewData objectAtIndex:pRowIndex];
		
		if ([[pTableColumn identifier] isEqualToString:@"history"]) {
			return [dataObject setSourceText:(NSString *)pObject];
		}
	}

	NSLog(@"error in managing identifiers");
	return NULL;
   
}

// Language Change Events

- (IBAction)sourceLanguageSelected:(id)sender {

	sourceLanguageId = [self locale:[sender indexOfSelectedItem]];
	NSLog(@"%@", sourceLanguageId);
}

- (IBAction)targetLanguageSelected:(id)sender {

	targetLanguageId = [self locale:[sender indexOfSelectedItem]];
	NSLog(@"%@", targetLanguageId);
	
}

// Data Building Functions

- (void)buildFavorites:(NSMutableArray *)tableViewData array:(NSMutableArray *)baseArray {
	
	self.favoritesTableViewData = [[NSMutableArray alloc] init];
		
	int i;
	for (i = 0; i < [baseArray count] - 1; i++) {
		FavoriteDataObject *dataObject = [[FavoriteDataObject alloc] initWithFavorites:[baseArray objectAtIndex:i]];
		[self.favoritesTableViewData addObject:dataObject];
	}
	
}

- (void)buildHistory:(NSMutableArray *)tableViewData array:(NSMutableArray *)baseArray {
	
	self.historyTableViewData = [[NSMutableArray alloc] init];
		
	int i;
	for (i = 0; i < [baseArray count] - 1; i++) {
		HistoryDataObject *dataObject = [[HistoryDataObject alloc] initWithHistory:[baseArray objectAtIndex:i]];
		[self.historyTableViewData addObject:dataObject];
	}
	
}

// Parser Events

- (void) parserDidStartDocument:(NSXMLParser *)parser {
	
	if (service == 1) {
		favoritesArray = [[NSMutableArray alloc] init];
	} else if (service == 2) {
		historyArray = [[NSMutableArray alloc] init];
	}
}

- (void) parserDidEndDocument:(NSXMLParser *)parser {
	
	if (service == 1) {
		[self buildFavorites:self.favoritesTableViewData array:favoritesArray];
		[[self favoritesTableView] reloadData];
	} else if (service == 2) {
		[self buildHistory:self.historyTableViewData array:historyArray];
		[[self historyTableView] reloadData];
	}
	
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	if (service == 1) {
		if ([@"target_text" isEqualToString:elementName]) {
			favorite = [elementValue copy];
		} 
		
		if ([@"Favorite" isEqualToString:elementName]) {
			[favoritesArray addObject:favorite];
		}
	} else if (service == 2) {
		if ([@"source_text" isEqualToString:elementName]) {
			history = [elementValue copy];
		}
		
		if ([@"History" isEqualToString:elementName]) {
			[historyArray addObject:history];
		}
	}
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (!elementValue) elementValue = [NSMutableString stringWithCapacity:100];
	[elementValue appendString:string];
	NSLog(@"found characters");
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	currentElement = elementName;
	elementValue = nil;
	NSLog(@"didstartelement");
}

// URLRequest Events

- (void)connectionDidFinishLoading:(NSURLConnection*)connection {
	[connection release];
	
	// Parsing the XML response
	NSLog(@"caricamento terminato");
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData:responseData];
	[parser setDelegate:self];
	[parser parse];
	NSLog(@"parsing inviato");
	
	NSString* responseString = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
	NSLog(@"%@", responseString);
	[responseString release];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	responseData = [[NSMutableData alloc] init];
	NSLog(@"responso ricevuto");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	[responseData appendData:data];
	NSLog(@"dati ricevuti");
	NSLog(@"%@", data);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	NSLog(@"c'e stato un errore!");
}

// Loading Data Methods

- (void)loadPanel {
	NSString *serverAddress = [[NSUserDefaults standardUserDefaults] stringForKey:@"serverAddress"];
	NSString *serverPort = [[NSUserDefaults standardUserDefaults] stringForKey:@"serverPort"];
	
	NSString *accountUsername = [[NSUserDefaults standardUserDefaults] stringForKey:@"accountUsername"];
	NSString *accountPassword = [[NSUserDefaults standardUserDefaults] stringForKey:@"accountPassword"];
	
	NSString *service_str = [[NSString alloc] init];
	
	if ([self service] == 1) {
		service_str = @"favorites";
		NSLog(@"%@", service_str);
	} else if ([self service] == 2) {
		service_str = @"history";
		NSLog(@"%@", service_str);
	}
	
	NSString *componentsPath = [NSString stringWithFormat:@"http://%@:%@/?service=%@&inputlang=%@&outputlang=%@&number=10&email=%@&password=%@", serverAddress, serverPort, service_str, @"fr", @"it", accountUsername, accountPassword];
	
	componentsPath = [componentsPath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	NSLog(@"%@", componentsPath);
	NSURL *url = [NSURL URLWithString:componentsPath];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	NSLog(@"richiesta inviata");
	[request setHTTPMethod:@"GET"];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

// TabView Events

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)item {
	
	NSLog(@"assigned at %@", item.identifier);
	if ([item.identifier isEqualTo:@"1"]) {
		self.service = 1;
	} else if ([item.identifier isEqualTo:@"2"]) {
		self.service = 2;
	}
	
	[self loadPanel];
}

@end
