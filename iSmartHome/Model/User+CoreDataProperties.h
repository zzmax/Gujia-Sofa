//
//  User+CoreDataProperties.h
//  iSmartHome
//
//  Created by admin on 16/1/13.
//  Copyright © 2016年 zzmax. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "User.h"

NS_ASSUME_NONNULL_BEGIN

@interface User (CoreDataProperties)

@property (nonatomic, retain) NSString * section;
@property (nullable, nonatomic, retain) NSDate *birthday;
@property (nullable, nonatomic, retain) NSNumber *height;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSNumber *sex;
@property (nullable, nonatomic, retain) NSString *userName;
@property (nullable, nonatomic, retain) NSNumber *weight;
@property (nullable, nonatomic, retain) NSSet<HealthExamResults *> *healthInfo;

@end

@interface User (CoreDataGeneratedAccessors)

- (void)addHealthInfoObject:(HealthExamResults *)value;
- (void)removeHealthInfoObject:(HealthExamResults *)value;
- (void)addHealthInfo:(NSSet<HealthExamResults *> *)values;
- (void)removeHealthInfo:(NSSet<HealthExamResults *> *)values;

@end

NS_ASSUME_NONNULL_END
