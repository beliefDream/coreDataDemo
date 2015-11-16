//
//  Entity.h
//  summaryCoreData
//
//  Created by zhs on 15/11/11.
//  Copyright (c) 2015年 zhs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Entity : NSManagedObject

@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * phoneNumber;

@end
