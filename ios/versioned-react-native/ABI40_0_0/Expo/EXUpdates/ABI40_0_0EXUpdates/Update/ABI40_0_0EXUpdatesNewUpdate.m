//  Copyright © 2019 650 Industries. All rights reserved.

#import <ABI40_0_0EXStructuredHeaders/ABI40_0_0EXStructuredHeadersParser.h>
#import <ABI40_0_0EXUpdates/ABI40_0_0EXUpdatesEmbeddedAppLoader.h>
#import <ABI40_0_0EXUpdates/ABI40_0_0EXUpdatesNewUpdate.h>
#import <ABI40_0_0EXUpdates/ABI40_0_0EXUpdatesUpdate+Private.h>
#import <ABI40_0_0EXUpdates/ABI40_0_0EXUpdatesUtils.h>
#import <ABI40_0_0React/ABI40_0_0RCTConvert.h>

NS_ASSUME_NONNULL_BEGIN

@implementation ABI40_0_0EXUpdatesNewUpdate

+ (ABI40_0_0EXUpdatesUpdate *)updateWithNewManifest:(ABI40_0_0EXRawManifestsNewRawManifest *)manifest
                                  response:(nullable NSURLResponse *)response
                                    config:(ABI40_0_0EXUpdatesConfig *)config
                                  database:(ABI40_0_0EXUpdatesDatabase *)database
{
  ABI40_0_0EXUpdatesUpdate *update = [[ABI40_0_0EXUpdatesUpdate alloc] initWithRawManifest:manifest
                                                                  config:config
                                                                database:database];
  
  NSString *updateId = manifest.rawId;
  NSString *commitTime = manifest.createdAt;
  NSString *runtimeVersion = manifest.runtimeVersion;
  NSDictionary *launchAsset = manifest.launchAsset;
  NSArray *assets = manifest.assets;
  
  NSAssert(updateId != nil, @"update ID should not be null");
  
  NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:(NSString *)updateId];
  NSAssert(uuid, @"update ID should be a valid UUID");
  
  id bundleUrlString = (NSDictionary *)launchAsset[@"url"];
  NSAssert([bundleUrlString isKindOfClass:[NSString class]], @"launchAsset.url should be a string");
  NSURL *bundleUrl = [NSURL URLWithString:bundleUrlString];
  NSAssert(bundleUrl, @"launchAsset.url should be a valid URL");
  
  NSMutableArray<ABI40_0_0EXUpdatesAsset *> *processedAssets = [NSMutableArray new];
  
  NSString *bundleKey = launchAsset[@"key"];
  ABI40_0_0EXUpdatesAsset *jsBundleAsset = [[ABI40_0_0EXUpdatesAsset alloc] initWithKey:bundleKey type:ABI40_0_0EXUpdatesEmbeddedBundleFileType];
  jsBundleAsset.url = bundleUrl;
  jsBundleAsset.isLaunchAsset = YES;
  jsBundleAsset.mainBundleFilename = ABI40_0_0EXUpdatesEmbeddedBundleFilename;
  [processedAssets addObject:jsBundleAsset];
  
  if (assets) {
    for (NSDictionary *assetDict in (NSArray *)assets) {
      NSAssert([assetDict isKindOfClass:[NSDictionary class]], @"assets must be objects");
      id key = assetDict[@"key"];
      id urlString = assetDict[@"url"];
      id type = assetDict[@"contentType"];
      id metadata = assetDict[@"metadata"];
      id mainBundleFilename = assetDict[@"mainBundleFilename"];
      NSAssert(key && [key isKindOfClass:[NSString class]], @"asset key should be a nonnull string");
      NSAssert(urlString && [urlString isKindOfClass:[NSString class]], @"asset url should be a nonnull string");
      NSAssert(type && [type isKindOfClass:[NSString class]], @"asset contentType should be a nonnull string");
      NSURL *url = [NSURL URLWithString:(NSString *)urlString];
      NSAssert(url, @"asset url should be a valid URL");
      
      ABI40_0_0EXUpdatesAsset *asset = [[ABI40_0_0EXUpdatesAsset alloc] initWithKey:key type:(NSString *)type];
      asset.url = url;
      
      if (metadata) {
        NSAssert([metadata isKindOfClass:[NSDictionary class]], @"asset metadata should be an object");
        asset.metadata = (NSDictionary *)metadata;
      }
      
      if (mainBundleFilename) {
        NSAssert([mainBundleFilename isKindOfClass:[NSString class]], @"asset localPath should be a string");
        asset.mainBundleFilename = (NSString *)mainBundleFilename;
      }
      
      [processedAssets addObject:asset];
    }
  }
  
  update.updateId = uuid;
  update.commitTime = [ABI40_0_0RCTConvert NSDate:(NSString *)commitTime];
  update.runtimeVersion = (NSString *)runtimeVersion;
  update.status = ABI40_0_0EXUpdatesUpdateStatusPending;
  update.keep = YES;
  update.bundleUrl = bundleUrl;
  update.assets = processedAssets;
  update.manifest = manifest.rawManifestJSON;
  
  if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
    NSDictionary *headersDictionary = ((NSHTTPURLResponse *)response).allHeaderFields;
    update.serverDefinedHeaders = [[self class] dictionaryWithStructuredHeader:headersDictionary[@"expo-server-defined-headers"]];
    update.manifestFilters = [[self class] dictionaryWithStructuredHeader:headersDictionary[@"expo-manifest-filters"]];
  }
  
  return update;
}

+ (nullable NSDictionary *)dictionaryWithStructuredHeader:(NSString *)headerString
{
  if (!headerString) {
    return nil;
  }
  
  ABI40_0_0EXStructuredHeadersParser *parser = [[ABI40_0_0EXStructuredHeadersParser alloc] initWithRawInput:headerString fieldType:ABI40_0_0EXStructuredHeadersParserFieldTypeDictionary ignoringParameters:YES];
  NSError *error;
  NSDictionary *parserOutput = [parser parseStructuredFieldsWithError:&error];
  if (!parserOutput || error || ![parserOutput isKindOfClass:[NSDictionary class]]) {
    NSLog(@"Error parsing header value: %@", error ? error.localizedDescription : @"Header was not a structured fields dictionary");
    return nil;
  }
  
  NSMutableDictionary *mutableDict = [NSMutableDictionary dictionaryWithCapacity:parserOutput.count];
  [parserOutput enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
    // ignore any dictionary entries whose type is not string, number, or boolean
    // since this will be re-serialized to JSON
    if ([obj isKindOfClass:[NSString class]] || [obj isKindOfClass:[NSNumber class]]) {
      mutableDict[key] = obj;
    }
  }];
  return mutableDict.copy;
}

@end

NS_ASSUME_NONNULL_END
