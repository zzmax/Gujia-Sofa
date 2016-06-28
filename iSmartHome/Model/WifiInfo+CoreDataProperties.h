//
//  WifiInfo+CoreDataProperties.h
//  
//
//  Created by admin on 16/6/28.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "WifiInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface WifiInfo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *connectionTime;
@property (nullable, nonatomic, retain) NSString *ip;
@property (nullable, nonatomic, retain) NSString *psd;
@property (nullable, nonatomic, retain) NSString *ssid;
@property (nullable, nonatomic, retain) NSNumber *state;
@property (nullable, nonatomic, retain) NSString *mac;
@property (nullable, nonatomic, retain) NSNumber *port;

@end

NS_ASSUME_NONNULL_END
