//
//  FavoriteDataObject.h
//  Reverso Context
//
//  Created by Francesco Mattiussi on 16/06/21.
//  Copyright 2021 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface FavoriteDataObject : NSObject {
	NSString *sourceText;
	NSString *sourceLanguage;
	NSString *sourceContext;
	
	NSString *targetText;
	NSString *targetLanguage;
	NSString *targetContext;
}

@property (copy) NSString *sourceText;
@property (copy) NSString *sourceLanguage;
@property (copy) NSString *sourceContext;
	
@property (copy) NSString *targetText;
@property (copy) NSString *targetLanguage;
@property (copy) NSString *targetContext;

- (id)initWithFavorites:(NSString *)targetContext;
//- (id)initWithFavorites:(NSString *)sourceText sourceLanguage:(NSString *)sourceLanguage sourceContext:(NSString *)sourceContext targetText:(NSString *)targetText targetLanguage:(NSString *)targetLanguage targetContext:(NSString *)targetContext;

@end
