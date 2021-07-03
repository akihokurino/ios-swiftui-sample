//
//  RootPresentationMode.swift
//  SwiftUISample
//
//  Created by akiho on 2020/11/19.
//

import SwiftUI

struct RootPresentationModeKey: EnvironmentKey {
    static let defaultValue: Binding<RootPresentationMode> = .constant(RootPresentationMode())
}

extension EnvironmentValues {
    var rootPresentationMode: Binding<RootPresentationMode> {
        get { return self[RootPresentationModeKey.self] }
        set { self[RootPresentationModeKey.self] = newValue }
    }
}

typealias RootPresentationMode = Bool

public extension RootPresentationMode {
    mutating func dismiss() {
        self.toggle()
    }
}
