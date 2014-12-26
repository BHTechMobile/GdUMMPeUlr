//
//  NewsObj.m
//  Millenium
//
//  Created by Mr Lemon on 3/3/14.
//  Copyright (c) 2014 Fruity. All rights reserved.
//

#import "NewsObj.h"
#import "Util.h"

@implementation NewsObj

-(void)copyFromNews:(News*)news
{
    self.publicId = news.publicId;
    self.code     = news.code;
    self.title    = news.title;
    self.mediaType = news.mediaType;
    self.lang      = news.lang;
    self.imageUrl  = news.imageUrl;
    self.videoUrl  = news.videoUrl;
    self.description    = news.descriptions;
    self.shortDescription = news.shortDescriptions;
    self.createdTime  = news.createTime;
    self.updatedTime  = news.updateTime;
    if (news.translation) {
        self.tranlation = [Util convertJSONToObject: [Validator getSafeString:news.translation]];
    }
}

-(void)setDescription:(NSString *)description{
    _des = description;
}

-(NSString*)description{
    return _des;
}

@end
