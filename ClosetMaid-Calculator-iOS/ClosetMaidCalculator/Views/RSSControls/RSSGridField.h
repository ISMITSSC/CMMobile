//
//  RSSGridField.h
//  ENPContactSearch
//
//  Created by Vlad Manolache on 10/5/12.
//  Copyright (c) 2012 Vlad Manolache. All rights reserved.
//


@protocol RSSGridField <NSObject>

@optional
-(NSValue*) defaultValue;

-(id) value;
-(void) setValue:(id) theValue;

-(NSString*) associatedEntityKey;
-(void) setAssociatedEntityKey:(NSString*) theAssociatedEntityKey;

@end
