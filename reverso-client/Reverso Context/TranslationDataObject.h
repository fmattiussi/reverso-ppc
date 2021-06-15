//
//  TranslationDataObject.h
//  Reverso Context
//
//  Created by Francesco Mattiussi on 11/06/21.
//  Copyright 2021 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface TranslationDataObject : NSObject {
   NSString *translation;

}
@property (copy) NSString *translation;

- (id)initWithTranslations:(NSString *)translation;

@end
