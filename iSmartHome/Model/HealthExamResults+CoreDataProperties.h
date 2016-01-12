//
//  HealthExamResults+CoreDataProperties.h
//  iSmartHome
//
//  Created by admin on 16/1/11.
//  Copyright © 2016年 zzmax. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "HealthExamResults.h"

NS_ASSUME_NONNULL_BEGIN

@interface HealthExamResults (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *userName;
@property (nullable, nonatomic, retain) NSNumber *weight;
@property (nullable, nonatomic, retain) NSNumber *bloodDiastolicPressure;
@property (nullable, nonatomic, retain) NSNumber *heartRate;
@property (nullable, nonatomic, retain) NSNumber *bloodO2;
@property (nullable, nonatomic, retain) NSNumber *bloodSystolicPressure;
@property (nullable, nonatomic, retain) NSNumber *bodyTemp;
@property (nullable, nonatomic, retain) User *fromTherUser;

@end

NS_ASSUME_NONNULL_END
