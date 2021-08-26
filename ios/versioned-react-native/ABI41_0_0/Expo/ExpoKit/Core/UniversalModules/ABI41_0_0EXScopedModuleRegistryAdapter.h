// Copyright © 2018 650 Industries. All rights reserved.

#import <ABI41_0_0UMReactNativeAdapter/ABI41_0_0UMModuleRegistryAdapter.h>
#import <ABI41_0_0EXRawManifests/ABI41_0_0EXRawManifestsRawManifest.h>

@interface ABI41_0_0EXScopedModuleRegistryAdapter : ABI41_0_0UMModuleRegistryAdapter

- (ABI41_0_0UMModuleRegistry *)moduleRegistryForParams:(NSDictionary *)params
                           forExperienceStableLegacyId:(NSString *)experienceStableLegacyId
                                              scopeKey:(NSString *)scopeKey
                                              manifest:(ABI41_0_0EXRawManifestsRawManifest *)manifest
                                    withKernelServices:(NSDictionary *)kernelServices;

@end
