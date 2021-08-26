// Copyright 2015-present 650 Industries. All rights reserved.

#import "EXAppFetcher+Private.h"
#import <EXRawManifests/EXRawManifestsRawManifest.h>

NS_ASSUME_NONNULL_BEGIN

@interface EXAppFetcherCacheOnly : EXAppFetcher

- (instancetype)initWithAppLoader:(EXAppLoader *)appLoader manifest:(EXRawManifestsRawManifest *)manifest;

@end

NS_ASSUME_NONNULL_END
