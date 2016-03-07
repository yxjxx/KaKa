//
//  KKAudioRecordModel.m
//  KaKa
//
//  Created by Linzer on 16/3/4.
//  Copyright © 2016年 yxj. All rights reserved.
//

#import "KKAudioRecordModel.h"
#import "AppDelegate.h"

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

+ (KKAudioRecordModel *)sharedInstance{
    static KKAudioRecordModel *sharedLocalAudioModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLocalAudioModel = [[KKAudioRecordModel alloc] init];
    });
    return sharedLocalAudioModel;
}

- (BOOL)isLocalAudioExistWithFileName:(NSString *)theAudioName{
    if ([theAudioName characterAtIndex:0] == '/') {
        NSMutableString *mutableAudioName = [theAudioName mutableCopy];
        [mutableAudioName deleteCharactersInRange:NSMakeRange(0, 1)];
        theAudioName = [[NSString alloc] initWithString:mutableAudioName];
    }
    
    NSArray *localAudioList = [self getLocalAudioList];
    for (NSString *audioPath in localAudioList) {
        if ([audioPath isEqualToString:theAudioName]) {
            return YES;
        }
    }
    return NO;
}


//TODO: 获取本地音频文件的文件名列表
- (NSArray *)getLocalAudioList{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSMutableArray *arr = [NSMutableArray array];
    for (KKAudioRecordModel *localAudio in appDelegate.audio_library_data) {
        [arr addObject:localAudio.path];
    }
    
    return arr;
}

- (BOOL)updateGlobalAudioLibraryData:(KKAudioModel *)audioModel{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    KKAudioRecordModel *aLocalAudio = [[KKAudioRecordModel alloc] init];
    aLocalAudio.path = [audioModel.audioPath lastPathComponent];
    aLocalAudio.subject = audioModel.audioSubject;
    aLocalAudio.aid = [audioModel.audioMid integerValue];
//    update global audio_library_data array
    [appDelegate.audio_library_data addObject:aLocalAudio];
//    write the array to file
    [NSKeyedArchiver archiveRootObject:appDelegate.audio_library_data toFile:appDelegate.audio_library];
    
    
#warning testing
//    NSMutableArray *myMutableArr = [NSKeyedUnarchiver unarchiveObjectWithFile:appDelegate.audio_library];
//    for (KKAudioRecordModel *item in myMutableArr) {
//        
//        NSLog(@"%@", item.path);
//    }
    
    return YES;
}


@end
