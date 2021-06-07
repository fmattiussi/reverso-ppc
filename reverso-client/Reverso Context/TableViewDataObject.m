//
//  TaleViewDataObject.m
//  Reverso Context
//
//  Created by Francesco Mattiussi on 22/05/21.
//  Copyright 2021 __MyCompanyName__. All rights reserved.
//

#import "TableViewDataObject.h"


@implementation TableViewDataObject

@synthesize sourceExample;
@synthesize targetExample;

- (id)initWithExamples:(NSString *)s_Example target:(NSString *)t_Example {

   if (! (self = [super init])) {
         NSLog(@"MyDataObject **** ERROR : [super init] failed ***");
         return self;
      } // end if
   
   self.sourceExample = s_Example;
   self.targetExample = t_Example;
   
   return self;

}

@end
