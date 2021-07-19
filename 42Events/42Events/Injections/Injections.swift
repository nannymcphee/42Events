//
//  Injections.swift
//  42Events
//
//  Created by Duy Nguyen on 13/07/2021.
//

import Resolver
import FTNetworkPlatform

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        registerConfigService()
        registerNetworkService()
        registerEventsRepo()
    }
    
    private static func registerEventsRepo() {
        register {
            EventsRepoImpl() as EventsRepo
        }.scope(.cached)
    }
    
    private static func registerConfigService() {
        register { ServerConfig.testing as ServerConfigType }
            .scope(.cached)
    }
    
    private static func registerNetworkService() {
        register {
            FTNetworkPlatform.UseCaseProviderImpl(
                config: resolve() as ServerConfigType
            )  as FTNetworkPlatform.UseCaseProvider
        }
        .scope(.cached)

        register { () -> FTNetworkPlatform.EventUseCase in
            let network = resolve() as FTNetworkPlatform.UseCaseProvider

            return network.makeEventUseCase()
        }
        .scope(.cached)
    }
}

// MARK: Utils
extension FTNetworkPlatform.UseCaseProviderImpl {
    convenience init(config: ServerConfigType) {
        self.init(config: BuildConfig(baseURL: config.serverUrl,
                                      detailURL: config.detailURL))
    }
}
