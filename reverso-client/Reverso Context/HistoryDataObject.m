//
//  HistoryDataObject.m
//  Reverso Context
//
//  Created by Francesco Mattiussi on 16/06/21.
//  Copyright 2021 __MyCompanyName__. All rights reserved.
//

#import "HistoryDataObject.h"


@implementation HistoryDataObject

@synthesize translations, sourceLanguage, sourceText, targetLanguage;

/* - (id)initWithHistory:(NSMutableArray *)_translations sourceLanguage:(NSString *)_sourceLanguage sourceText:(NSString *)_sourceText targetLanguage:(NSString *)_targetLanguage {

   if (! (self = [super init])) {
		 NSLog(@"HistoryDataObject **** ERROR : [super init] failed ***");
		 return self;
	  } 
   
   self.translations = _translations;
   self.sourceLanguage = _sourceLanguage;
   self.sourceText = _sourceText;
   self.targetLanguage = _targetLanguage;
   
   return self;

} */

- (id)initWithHistory:(NSString *)_targetLanguage {

   if (! (self = [super init])) {
		 NSLog(@"HistoryDataObject **** ERROR : [super init] failed ***");
		 return self;
	  } 
   
   self.targetLanguage = _targetLanguage;
   
   return self;

}

@end
