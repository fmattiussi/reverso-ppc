//
//  FavoriteDataObject.m
//  Reverso Context
//
//  Created by Francesco Mattiussi on 16/06/21.
//  Copyright 2021 __MyCompanyName__. All rights reserved.
//

#import "FavoriteDataObject.h"


@implementation FavoriteDataObject

@synthesize sourceText, sourceLanguage, sourceContext, targetText, targetLanguage, targetContext;

/* - (id)initWithFavorites:(NSString *)_sourceText sourceLanguage:(NSString *)_sourceLanguage sourceContext:(NSString *)_sourceContext targetText:(NSString *)_targetText targetLanguage:(NSString *)_targetLanguage targetContext:(NSString *)_targetContext {

   if (! (self = [super init])) {
		 NSLog(@"FavoriteDataObject **** ERROR : [super init] failed ***");
		 return self;
	  } 
   
   self.sourceText = _sourceText;
   self.sourceLanguage = _sourceLanguage;
   self.sourceContext = _sourceContext;
   
   self.targetText = _targetText;
   self.targetLanguage = _targetLanguage;
   self.targetContext = _targetContext;
   
   return self;

} */

- (id)initWithFavorites:(NSString *)_targetContext {

   if (! (self = [super init])) {
         NSLog(@"FavoriteDataObject **** ERROR : [super init] failed ***");
         return self;
      } 
   
   self.targetContext = _targetContext;
   
   return self;

}

@end
