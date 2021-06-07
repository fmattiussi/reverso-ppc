//
//  TaleViewDataObject.h
//  Reverso Context
//
//  Created by Francesco Mattiussi on 22/05/21.
//  Copyright 2021 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TableViewDataObject : NSObject {
   NSString *sourceExample;
   NSString *targetExample;

}
@property (copy) NSString *sourceExample;
@property (copy) NSString *targetExample;

- (id)initWithExamples:(NSString *)sourceExample target:(NSString *)targetExample;

@end
