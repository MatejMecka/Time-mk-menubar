//
//  onappear-alternative.swift
//  Time-Mk-Menu-bar
//
//  Created by Matej Plavevski on 8/25/20.
//  Copyright © 2020 Matej Plavevski. All rights reserved.
//

import Foundation
import SwiftUI

// https://stackoverflow.com/questions/57518852/swiftui-picker-onchange-or-equivalent
extension Binding {
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        return Binding(
            get: { self.wrappedValue },
            set: { selection in
                self.wrappedValue = selection
                handler(selection)
        })
    }
}
