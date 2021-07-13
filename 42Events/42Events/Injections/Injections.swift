//
//  Injections.swift
//  42Events
//
//  Created by Duy Nguyen on 13/07/2021.
//

import Resolver

extension Resolver: ResolverRegistering {
    public static func registerAllServices() {
        registerEventsRepo()
    }
    
    private static func registerEventsRepo() {
        register {
            EventsRepoImpl() as EventsRepo
        }.scope(.cached)
    }
}
