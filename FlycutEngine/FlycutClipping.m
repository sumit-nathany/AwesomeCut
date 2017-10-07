//
//  FlycutClipping.m
//  Flycut
//
//  Flycut by Gennadiy Potapov and contributors. Based on Jumpcut by Steve Cook.
//  Copyright 2011 General Arcade. All rights reserved.
//
//  This code is open-source software subject to the MIT License; see the homepage
//  at <https://github.com/TermiT/Flycut> for details.
//


#import "FlycutClipping.h"

@implementation FlycutClipping

-(id) init
{
    if (!(self = [self initWithContents:@""
                  withType:@""
         withDisplayLength:40
      withAppLocalizedName:@""
          withAppBundleURL:nil
             withTimestamp:0])) return nil;
    return self;
}

-(id) initWithContents:(NSString *)contents withType:(NSString *)type withDisplayLength:(int)displayLength withAppLocalizedName:(NSString *)localizedName withAppBundleURL:(NSString*)bundleURL withTimestamp:(int)timestamp
{
    if (!(self = [super init])) return nil;
    clipContents = [[NSString alloc] init];
    clipDisplayString = [[NSString alloc] init];
    clipType = [[NSString alloc] init];

    [self setContents:contents setDisplayLength:displayLength];
    [self setType:type];
    [self setAppLocalizedName:localizedName];
    [self setAppBundleURL:bundleURL];
    [self setTimestamp:[@(timestamp) stringValue]];
    [self setHasName:false];
    
    return self;
}

/* - (id)initWithCoder:(NSCoder *)coder
{
    NSString * newContents;
    int newDisplayLength;
    NSString *newType;
    BOOL newHasName;
    if ( self = [super init]) {
        newContents = [NSString stringWithString:[coder decodeObject]];
        [coder decodeValueOfObjCType:@encode(int) at:&newDisplayLength];
        newType = [NSString stringWithString:[coder decodeObject]];
        [coder decodeValueOfObjCType:@encode(BOOL) at:&newHasName];
        [self          setContents:newContents
                setDisplayLength:newDisplayLength];
        [self setType:newType];
        [self setHasName:newHasName];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    int codeDisplayLength = [self displayLength];
    BOOL codeHasName = [self hasName];
    [coder encodeObject:[self contents]];
    [coder encodeValueOfObjCType:@encode(int) at:&codeDisplayLength];
    [coder encodeObject:[self type]];
    [coder encodeValueOfObjCType:@encode(BOOL) at:&codeHasName];
} */

-(void) setContents:(NSString *)newContents setDisplayLength:(int)newDisplayLength
{
    id old = clipContents;
    clipContents = newContents;
    if ( newDisplayLength  > 0 ) {
        clipDisplayLength = newDisplayLength;
    }
   [self resetDisplayString];
}

-(void) setContents:(NSString *)newContents
{
    id old = clipContents;
    clipContents = newContents;
    [self resetDisplayString];
}

-(void) setType:(NSString *)newType
{
    id old = clipType;
    clipType = newType;
}

-(void) setDisplayLength:(int)newDisplayLength
{
    if ( newDisplayLength  > 0 ) {
        clipDisplayLength = newDisplayLength;
        [self resetDisplayString];
    }
}

-(void) setAppLocalizedName:(NSString *)new
{
    id old = appLocalizedName;
    appLocalizedName = new;
}

-(void) setAppBundleURL:(NSString *)new
{
    id old = appBundleURL;
    appBundleURL = new;
}

-(void) setTimestamp:(NSString *)newTimestamp
{
    clipTimestamp = newTimestamp;
}

-(void) setHasName:(BOOL)newHasName
{
        clipHasName = newHasName;
}

-(void) resetDisplayString
{
    NSString *newDisplayString, *firstLineOfClipping, *trimmedString;
    NSUInteger start, lineEnd, contentsEnd;
    NSRange startRange = NSMakeRange(0,0);
    NSRange contentsRange;
    // We're resetting the display string, so release the old one.
    // We want to restrict the display string to the clipping contents through the first line break.
    trimmedString = [clipContents stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [trimmedString getLineStart:&start end:&lineEnd contentsEnd:&contentsEnd forRange:startRange];
    contentsRange = NSMakeRange(0, contentsEnd);
    firstLineOfClipping = [trimmedString substringWithRange:contentsRange];
    if ( [firstLineOfClipping length] > clipDisplayLength ) {
        newDisplayString = [[NSString stringWithString:[firstLineOfClipping substringToIndex:clipDisplayLength]] stringByAppendingString:@"…"];   
    } else {
        newDisplayString = [NSString stringWithString:firstLineOfClipping];
    }
    clipDisplayString = newDisplayString;
}

-(NSString *) description
{
    NSString *description = [[super description] stringByAppendingString:@": "];
    description = [description stringByAppendingString:[self displayString]];   
    return description;
}

-(FlycutClipping *) clipping
{
    return self;
}

-(NSString *) contents
{
//    NSString *returnClipContents;
//    returnClipContents = [NSString stringWithString:clipContents];
//    return returnClipContents;
    return clipContents;
}

-(NSString *) appLocalizedName
{
    return appLocalizedName;
}

-(NSString *) appBundleURL
{
    return appBundleURL;
}

-(int) timestamp
{
    return clipTimestamp;
}

-(int) displayLength
{
    return clipDisplayLength;
}

-(NSString *) type
{
    return clipType;
}

-(NSString *) displayString
{
    // QUESTION
    // Why doesn't the below work?
    // NSString *returnClipDisplayString;
    // returnClipDisplayString = [NSString stringWithString:clipDisplayString];
    // return returnClipDisplayString;
    return clipDisplayString;
}

-(BOOL) hasName
{
    return clipHasName;
}

- (BOOL)isEqual:(id)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    FlycutClipping * otherClip = (FlycutClipping *)other;
    return ([self.type isEqualToString:otherClip.type] &&
            [self.displayString isEqualToString:otherClip.displayString] &&
            (self.displayLength == otherClip.displayLength) &&
            [self.contents isEqualToString:otherClip.contents]);
}



-(void) dealloc
{
    clipDisplayLength = 0;
    clipHasName = 0;
}
@end
