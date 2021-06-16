//
//  HistoryDataObject.h
//  Reverso Context
//
//  Created by Francesco Mattiussi on 16/06/21.
//  Copyright 2021 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface HistoryDataObject : NSObject {
	NSMutableArray *translations;
	NSString *sourceLanguage;
	NSString *sourceText;
	NSString *targetLanguage;
}

@property (copy) NSMutableArray *translations;
@property (copy) NSString *sourceLanguage;
@property (copy) NSString *sourceText;
@property (copy) NSString *targetLanguage;

- (id)initWithHistory:(NSString *)targetLanguage;

//- (id)initWithHistory:(NSMutableArray *)translations sourceLanguage:(NSString *)sourceLanguage sourceText:(NSString *)sourceText targetLanguage:(NSString *)targetLanguage;

@end
