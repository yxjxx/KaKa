//
//  KKAudioRecordModel.m
//  KaKa
//
//  Created by Linzer on 16/3/4.
//  Copyright © 2016年 yxj. All rights reserved.
//

#import "KKAudioRecordModel.h"

@implementation KKAudioRecordModel

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.path forKey:@"path"];
    [aCoder encodeObject:self.subject forKey:@"subject"];
    [aCoder encodeInteger:self.aid forKey:@"aid"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [self init];
    if(self){
        _path = [aDecoder decodeObjectForKey:@"path"];
        _subject = [aDecoder decodeObjectForKey:@"subject"];
        _aid = [aDecoder decodeIntForKey:@"aid"];
    }
    
    return self;
}
@end
