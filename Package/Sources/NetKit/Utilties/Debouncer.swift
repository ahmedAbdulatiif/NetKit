//
//  Debouncer.swift
//  El-Araby
//
//  Created by Nesreen Mamdouh on 6/19/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation

open class Debouncer {
    private let delay: TimeInterval
    private var pendingWorkItem: DispatchWorkItem?

    public init(delay: TimeInterval) {
        self.delay = delay
    }

    /// Trigger the action after some delay
    public func run(action: @escaping () -> Void) {
        pendingWorkItem?.cancel()
        pendingWorkItem = DispatchWorkItem(block: action)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: pendingWorkItem!)
    }
}
