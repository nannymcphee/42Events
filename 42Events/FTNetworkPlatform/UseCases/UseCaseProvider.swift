//
//  UseCaseProvider.swift
//  FTNetworkPlatform
//
//  Created by Duy Nguyen on 19/07/2021.
//

import Foundation

public protocol UseCaseProvider {
    func makeEventUseCase() -> EventUseCase
}

public final class UseCaseProviderImpl: UseCaseProvider {
    public init(config: BuildConfig) {
        BuildConfig.default = config
    }
    
    public func makeEventUseCase() -> EventUseCase {
        return EventUseCaseImpl()
    }
}
