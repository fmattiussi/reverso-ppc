//
//  MyDocument.m
//  Reverso Context
//
//  Created by Francesco Mattiussi on 21/05/21.
//  Copyright __MyCompanyName__ 2021 . All rights reserved.
//

#import "MyDocument.h"


@implementation MyDocument

@synthesize responseData, sourceLanguage, targetLanguage, sourceLanguageId, targetLanguageId;

@synthesize currentElement, source_example, target_example, elementValue, translation;

@synthesize sourceExampleArray, targetExampleArray;

@synthesize resultsTableView, tableViewData, translationsTableView, translationsTableViewData, translations;

@synthesize searchField;

@synthesize drawer, drawerView, service, spinner, targetText, sourceText;

@synthesize preferences, servicesTabView;

- (id)init
{
    self = [super init];
    if (self) {
    
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
    
    }
    return self;
}

- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MyDocument";
}

// Language indexing

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
	
	[[self drawer] setDelegate:self];
	[[self drawer] close:self];
	[[self drawer] setTrailingOffset:10.];
	[[self drawer] setLeadingOffset:10.];
	[[self drawer] setContentSize:NSMakeSize(300., 368.)];
	
	[[self resultsTableView] setDelegate:self];
	[[self resultsTableView] setDataSource:self];
	[[self resultsTableView] setTarget:self];
	
	[[self translationsTableView] setDelegate:self];
	[[self translationsTableView] setDataSource:self];
	[[self translationsTableView] setTarget:self];
	
	[[self servicesTabView] setDelegate:self];
	
	sourceLanguageId = [self locale:[sourceLanguage indexOfSelectedItem]];
	targetLanguageId = [self locale:[targetLanguage indexOfSelectedItem]];
}

// Menu 

- (IBAction)openPreferences:(id)sender {
	[preferences makeKeyAndOrderFront:self];
}

// Drawer actions

- (IBAction)toggleDrawer:(id)sender {
	if ([drawer state] == NSDrawerClosedState) {
		[drawer open:sender];
	} else {
		[drawer close];
	}
	NSLog(@"eee");
	
}

// TableView's delegates and functions
- (void)tableViewSelectionDidChange:(NSNotification *)notification {

	if ([drawer state] == NSDrawerClosedState) {
		[drawer open:self];
	}
	
	if (service == 1) {
		NSInteger index = [resultsTableView selectedRow];
	
		if (index != -1) {
			NSRange sourceRange;
			sourceRange = NSMakeRange(0, [[sourceText string] length]);
			[sourceText replaceCharactersInRange:sourceRange withString:[sourceExampleArray objectAtIndex:index]];
	
			NSRange targetRange;
			targetRange = NSMakeRange(0, [[targetText string] length]);
			[targetText replaceCharactersInRange:targetRange withString:[targetExampleArray objectAtIndex:index]];
		}
	} else if (service == 2) {
		NSInteger index = [translationsTableView selectedRow];
	
		if (index != -1) {
			NSRange sourceRange;
			sourceRange = NSMakeRange(0, [[sourceText string] length]);
			[sourceText replaceCharactersInRange:sourceRange withString:[searchField stringValue]];
	
			NSRange targetRange;
			targetRange = NSMakeRange(0, [[targetText string] length]);
			[targetText replaceCharactersInRange:targetRange withString:[translations objectAtIndex:index]];
		}
	}

}

- (void)mergeData:(NSMutableArray *)outputData firstArray:(NSMutableArray *)arrayOne secondArray:(NSMutableArray *)arrayTwo {
	if ([arrayOne count] == [arrayTwo count]) {
		int i;
		for (i = 0; i < [arrayOne count] - 1; i++) {
			TableViewDataObject *dataObject = [[TableViewDataObject alloc] initWithExamples:[arrayOne objectAtIndex:i] target:[arrayTwo objectAtIndex:i]];
			[outputData addObject:dataObject];
		}
	}
}

- (int)numberOfRowsInTableView:(NSTableView *)pTableViewObj {

	if (pTableViewObj == resultsTableView) {
		
		return [self.tableViewData count];
		
	} else if (pTableViewObj == translationsTableView) {
		
		return [self.translationsTableViewData count];
		
	}
} 


- (id) tableView:(NSTableView *)pTableViewObj objectValueForTableColumn:(NSTableColumn *)pTableColumn row:(int)pRowIndex {
   
	if (pTableViewObj == resultsTableView) {
		TableViewDataObject *dataObject = (TableViewDataObject *)[self.tableViewData objectAtIndex:pRowIndex];
		
		if ([[pTableColumn identifier] isEqualToString:@"s_example"]) {
			return [dataObject sourceExample];
		}
   
		if ([[pTableColumn identifier] isEqualToString:@"t_example"]) {
			return [dataObject targetExample];
		}
		
	} else if (pTableViewObj == translationsTableView) {
		TranslationDataObject *dataObject = (TranslationDataObject *)[self.translationsTableViewData objectAtIndex:pRowIndex];
		
		if ([[pTableColumn identifier] isEqualToString:@"translation"]) {
			return [dataObject translation];
		}
	}

	NSLog(@"error in managing identifiers");
	return NULL;
   
} // end tableView:objectValueForTableColumn:row:


- (void)tableView:(NSTableView *)pTableViewObj setObjectValue:(id)pObject forTableColumn:(NSTableColumn *)pTableColumn row:(int)pRowIndex {

   NSLog(@"set object value impostato");
   
	if (pTableViewObj == resultsTableView) {
		TableViewDataObject * dataObject = (TableViewDataObject *)[self.tableViewData objectAtIndex:pRowIndex];
                       
		if ([[pTableColumn identifier] isEqualToString:@"s_example"]) {
			[dataObject setSourceExample:(NSString *)pObject];
		}
   
		if ([[pTableColumn identifier] isEqualToString:@"t_example"]) {
			[dataObject setTargetExample:(NSString *)pObject];
		}
		
	} else if (pTableViewObj == translationsTableView) {
		TranslationDataObject *dataObject = (TranslationDataObject *)[self.translationsTableViewData objectAtIndex:pRowIndex];
		
		if ([[pTableColumn identifier] isEqualToString:@"translation"]) {
			[dataObject setTranslation:(NSString *)pObject];
		}
	}
   
} // end tableView:setObjectValue:forTableColumn:row:


- (IBAction)sourceLanguageSelected:(id)sender {

	sourceLanguageId = [self locale:[sender indexOfSelectedItem]];
	
	[[NSUserDefaults standardUserDefaults] setObject:[sender titleOfSelectedItem] forKey:@"currentSource"];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"updateSource" object:self];
	NSLog(@"%@", sourceLanguageId);
}

- (IBAction)targetLanguageSelected:(id)sender {

	targetLanguageId = [self locale:[sender indexOfSelectedItem]];
	
	[[NSUserDefaults standardUserDefaults] setObject:[sender titleOfSelectedItem] forKey:@"currentTarget"];
	[[NSNotificationCenter defaultCenter] postNotificationName:@"updateTarget" object:self];
	NSLog(@"%@", targetLanguageId);
	
}

// Parser's events

- (void) parserDidStartDocument:(NSXMLParser *)parser {
	
	if (service == 1) {
		sourceExampleArray = [[NSMutableArray alloc] init];
		targetExampleArray = [[NSMutableArray alloc] init];
	} else if (service == 2) {
		translations = [[NSMutableArray alloc] init];
	}
}

- (void) parserDidEndDocument:(NSXMLParser *)parser {
	
	if (service == 1) {
		self.tableViewData = [[NSMutableArray alloc] init];
		[self mergeData:self.tableViewData firstArray:sourceExampleArray secondArray:targetExampleArray];
		[[self resultsTableView] reloadData];
	} else if (service == 2) {
		self.translationsTableViewData = [[NSMutableArray alloc] init];
		
		int i;
		for (i = 0; i < [translations count] - 1; i++) {
			TranslationDataObject *dataObject = [[TranslationDataObject alloc] initWithTranslations:[translations objectAtIndex:i]];
			[self.translationsTableViewData addObject:dataObject];
		}
		[[self translationsTableView] reloadData];
		NSLog(@"reloading data for translations");
	}
	
	[spinner stopAnimation:self];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	NSLog(@"didendelement");
	
	if (service == 1) {
		if ([@"source_example" isEqualToString:elementName]) {
			source_example = [elementValue copy];
		} else if ([@"target_example" isEqualToString:elementName]) {
			target_example = [elementValue copy];
		} if ([@"Sample" isEqualToString:elementName]) {
			[sourceExampleArray addObject:source_example];
			[targetExampleArray addObject:target_example];
		}
	} else if (service == 2) {
		if ([@"translation" isEqualToString:elementName]) {
			translation = [elementValue copy];
		}
		
		if ([@"Translation" isEqualToString:elementName]) {
			[translations addObject:translation];
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

// Internet requests management

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
	[spinner stopAnimation:self];
}

// Intrafce Builder's actions

- (void)tabView:(NSTabView *)tabView didSelectTabViewItem:(NSTabViewItem *)item {

	if ([drawer state] == NSDrawerOpenState) {
		[drawer close];
	}
	
	NSLog(@"assigned at %@", item.identifier);
	if ([item.identifier isEqualTo:@"1"]) {
		self.service = 1;
	} else if ([item.identifier isEqualTo:@"2"]) {
		self.service = 2;
	}
}

- (void)find {
	responseData = [NSMutableData new];
	
	NSString *inputText = [searchField stringValue];
	
	// retrieving data from preferences
	NSString *serverAddress = [[NSUserDefaults standardUserDefaults] stringForKey:@"serverAddress"];
	NSString *serverPort = [[NSUserDefaults standardUserDefaults] stringForKey:@"serverPort"];
	
	NSString *service_str = [[NSString alloc] init];
	
	if ([self service] == 1) {
		service_str = @"context";
		NSLog(@"%@", service_str);
	} else if ([self service] == 2) {
		service_str = @"translation";
		NSLog(@"%@", service_str);
	}
	
	NSString *componentsPath = [NSString stringWithFormat:@"http://%@:%@/?service=%@&text=%@&inputlang=%@&outputlang=%@&number=10", serverAddress, serverPort, service_str, inputText, sourceLanguageId, targetLanguageId];
	componentsPath = [componentsPath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
	NSLog(@"%@", componentsPath);
	NSURL *url = [NSURL URLWithString:componentsPath];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	NSLog(@"richiesta inviata");
	[spinner startAnimation:self];
	[request setHTTPMethod:@"GET"];
	[[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (IBAction)search:(id)pId {
	if (![[searchField stringValue] isEqualToString:@""]) {
		if ([drawer state] == NSDrawerOpenState) {
			[drawer close];
		}
		[self find];
	}
}

- (IBAction)saveToPasteboard:(id)sender {
	NSPasteboard *pasteboard = [NSPasteboard generalPasteboard];
	[pasteboard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
	
	if ([self service] == 1) {
		[pasteboard setString:[targetExampleArray objectAtIndex:[resultsTableView selectedRow]] forType:NSStringPboardType];
	} else if ([self service] == 2) {
		[pasteboard setString:[translations objectAtIndex:[translationsTableView selectedRow]] forType:NSStringPboardType];
	}
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If the given outError != NULL, ensure that you set *outError when returning nil.

    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.

    // For applications targeted for Panther or earlier systems, you should use the deprecated API -dataRepresentationOfType:. In this case you can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.

    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
	return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type.  If the given outError != NULL, ensure that you set *outError when returning NO.

    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead. 
    
    // For applications targeted for Panther or earlier systems, you should use the deprecated API -loadDataRepresentation:ofType. In this case you can also choose to override -readFromFile:ofType: or -loadFileWrapperRepresentation:ofType: instead.
    
    if ( outError != NULL ) {
		*outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:NULL];
	}
    return YES;
}

@end
