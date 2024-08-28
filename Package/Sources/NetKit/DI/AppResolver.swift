//
//  AppResolver.swift
//  iOS-kernel
//
//  Created by Youssef El-Ansary on 09/03/2022.
//  Copyright © 2022 Robusta. All rights reserved.
//

// Wrappers for Resolver to isolate foreign code

public typealias AppResolverName = Resolver.Name
public typealias AppResolverScope = ResolverScope

// TODO: Provide a way for named lazy injection
@propertyWrapper
public struct AppLazyInjected<Service> {
    
    @LazyInjected public var wrappedValue: Service
    
    public init() {}
}

@propertyWrapper
public struct AppInjected<Service> {
    
    private var service: Service
    public var wrappedValue: Service {
        get { return service }
        mutating set { service = newValue }
    }
    
    public init(name: AppResolverName? = nil) {
        self.service = AppResolver.resolve(name: name)
    }
}

public struct ResolverArgs {
    
    fileprivate let arguments: Resolver.Args
    
    init(args: Resolver.Args) {
        self.arguments = args
    }
    
    /// Used in case of only one arg is passed
    func get<T>() -> T? {
        self.arguments.optional()
    }
    
    func get<T>(key: String) -> T? {
        self.arguments.optional(key)
    }
}

public class AppResolver {
    
    public static func register<Service>(name: AppResolverName? = nil,
                                         scope: AppResolverScope = .graph,
                                         _ closure: @escaping (ResolverArgs) -> Service) {
        Resolver.register(name: name) { (_, args) in
            closure(ResolverArgs(args: args))
        }.scope(scope)
    }
    
    public static func register<Service>(name: AppResolverName? = nil,
                                         scope: AppResolverScope = .graph,
                                         _ closure: @escaping () -> Service) {
        Resolver.register(name: name) { closure() }.scope(scope)
    }
    
    public static func resolve<T>(name: AppResolverName? = nil,
                                  args: Any? = nil) -> T {
        let args = (args as? ResolverArgs)?.arguments ?? args
        return Resolver.resolve(name: name, args: args)
    }
    
    public static func resolveOptional<T>(name: AppResolverName? = nil,
                                          args: Any? = nil) -> T? {
        let args = (args as? ResolverArgs)?.arguments ?? args
        return Resolver.optional(name: name, args: args)
    }
}
