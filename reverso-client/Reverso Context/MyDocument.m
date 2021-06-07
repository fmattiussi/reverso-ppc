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

@synthesize currentElement, source_example, target_example, elementValue;

@synthesize sourceExampleArray, targetExampleArray;

@synthesize resultsTableView, tableViewData;

@synthesize searchField;

@synthesize drawer, drawerView, tabView, service, spinner;

@synthesize preferences;

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
	
	service = @"context";
	
	[[self drawer] setDelegate:self];
	[[self drawer] close:self];
	[[self drawer] setTrailingOffset:10.];
	[[self drawer] setLeadingOffset:10.];
	[[self drawer] setContentSize:NSMakeSize(327., 379.)];
	
	[[self resultsTableView] setDelegate:self];
	[[self resultsTableView] setDataSource:self];
	
	sourceLanguageId = [self locale:[sourceLanguage indexOfSelectedItem]];
	targetLanguageId = [self locale:[targetLanguage indexOfSelectedItem]];
}

// Menu 

- (IBAction)openPreferences:(id)sender {
	[preferences makeKeyAndOrderFront:self];
}

// Drawer actions

- (IBAction)toggleDrawer:(id)sender {
	//if ([drawer state] == NSDrawerClosedState) {
	//	[drawer open:sender];
	//}
	NSLog(@"eee");
	
}

// TableView's delegates and functions

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
   return [self.tableViewData count];
} 


- (id) tableView:(NSTableView *)pTableViewObj 
           objectValueForTableColumn:(NSTableColumn *)pTableColumn
                                 row:(int)pRowIndex {
   TableViewDataObject * dataObject = (TableViewDataObject *)
                           [self.tableViewData objectAtIndex:pRowIndex];
   if (! dataObject) {
      NSLog(@"tableView: objectAtIndex:%d = NULL",pRowIndex);
      return NULL;
   } // end if
   
   if ([[pTableColumn identifier] isEqualToString:@"s_example"]) {
      return [dataObject sourceExample];
   }
   
   if ([[pTableColumn identifier] isEqualToString:@"t_example"]) {
      return [dataObject targetExample];
   }
   
   NSLog(@"***ERROR** dropped through pTableColumn identifiers");
   return NULL;
   
} // end tableView:objectValueForTableColumn:row:


- (void)tableView:(NSTableView *)pTableViewObj 
   setObjectValue:(id)pObject 
   forTableColumn:(NSTableColumn *)pTableColumn 
              row:(int)pRowIndex {
              
   NSLog(@"set object value impostato");
   TableViewDataObject * dataObject = (TableViewDataObject *)
                           [self.tableViewData objectAtIndex:pRowIndex];
                       
   if ([[pTableColumn identifier] isEqualToString:@"s_example"]) {
      [dataObject setSourceExample:(NSString *)pObject];
   }
   
   if ([[pTableColumn identifier] isEqualToString:@"t_example"]) {
      [dataObject setTargetExample:(NSString *)pObject];
   }
   
} // end tableView:setObjectValue:forTableColumn:row:


- (IBAction)sourceLanguageSelected:(id)sender {

	sourceLanguageId = [self locale:[sender indexOfSelectedItem]];
	NSLog(@"%@", sourceLanguageId);
}

- (IBAction)targetLanguageSelected:(id)sender {

	targetLanguageId = [self locale:[sender indexOfSelectedItem]];
	NSLog(@"%@", targetLanguageId);
	
}

// Parser's events

- (void) parserDidStartDocument:(NSXMLParser *)parser {
	sourceExampleArray = [[NSMutableArray alloc] init];
	targetExampleArray = [[NSMutableArray alloc] init];
}

- (void) parserDidEndDocument:(NSXMLParser *)parser {
	self.tableViewData = [[NSMutableArray alloc] init];
	NSLog(@"tabelviewdata init");
	[self mergeData:self.tableViewData firstArray:sourceExampleArray secondArray:targetExampleArray];
	NSLog(@"data has benn merged");
	[[self resultsTableView] reloadData];
	NSLog(@"tableviewrealoaddata");
	
	[spinner stopAnimation:self];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	NSLog(@"didendelement");
	if ([@"source_example" isEqualToString:elementName]) {
		source_example = [elementValue copy];
	} else if ([@"target_example" isEqualToString:elementName]) {
		target_example = [elementValue copy];
	} if ([@"Sample" isEqualToString:elementName]) {
		[sourceExampleArray addObject:source_example];
		[targetExampleArray addObject:target_example];
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

- (IBAction)tabChanged:(id)sender {
	int tabSelection;
	
	tabSelection = [tabView indexOfTabViewItem:[tabView selectedTabViewItem]];
	
	if (tabSelection == 1) {
		self.service = @"context";
	} else if (tabSelection == 2) {
		self.service = @"translation";
	}
}

- (void)find {
	responseData = [NSMutableData new];
	
	NSString *inputText = [searchField stringValue];
	
	// retrieving data from preferences
	NSString *serverAddress = [[NSUserDefaults standardUserDefaults] stringForKey:@"serverAddress"];
	NSString *serverPort = [[NSUserDefaults standardUserDefaults] stringForKey:@"serverPort"];
	
	//NSLog(@"%@ %@ %@", inputText, sourceLanguageId, targetLanguageId);
	
	NSString *componentsPath = [NSString stringWithFormat:@"http://%@:%@/?service=%@&text=%@&inputlang=%@&outputlang=%@&number=10", serverAddress, serverPort, [self service], inputText, sourceLanguageId, targetLanguageId];
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
		[self find];
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
