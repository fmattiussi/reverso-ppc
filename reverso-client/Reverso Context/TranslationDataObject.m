//
//  TranslationDataObject.m
//  Reverso Context
//
//  Created by Francesco Mattiussi on 11/06/21.
//  Copyright 2021 __MyCompanyName__. All rights reserved.
//

#import "TranslationDataObject.h"

@implementation TranslationDataObject

@synthesize translation;

- (id)initWithTranslations:(NSString *)_translation {

   if (! (self = [super init])) {
         NSLog(@"MyDataObject **** ERROR : [super init] failed ***");
         return self;
      } // end if
   
   self.translation = _translation;
   
   return self;

}

@end