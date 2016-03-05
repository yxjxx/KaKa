//
//  KKVideoRecordModel.m
//  KaKa
//
//  Created by Linzer on 16/3/4.
//  Copyright © 2016年 yxj. All rights reserved.
//

#import "KKVideoRecordModel.h"

@implementation KKVideoRecordModel
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.path forKey:@"path"];
    [aCoder encodeObject:self.snapshot forKey:@"snapshot"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.aid forKey:@"aid"];
    [aCoder encodeInteger:self.timelen forKey:@"timelen"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [self init];
    if(self){
        _path = [aDecoder decodeObjectForKey:@"path"];
        _snapshot = [aDecoder decodeObjectForKey:@"snapshot"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _aid = [aDecoder decodeIntForKey:@"aid"];
        _timelen = [aDecoder decodeIntForKey:@"timelen"];
    }
    
    return self;
}
@end
