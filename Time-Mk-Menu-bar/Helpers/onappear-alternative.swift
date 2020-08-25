//
//  onappear-alternative.swift
//  Time-Mk-Menu-bar
//
//  Created by Matej Plavevski on 8/25/20.
//  Copyright © 2020 Golden Chopper. All rights reserved.
//

import Foundation

import SwiftUI

struct AppearAware: NSViewRepresentable {
    var onAppear: () -> Void

    func makeNSView(context: NSViewRepresentableContext<AppearAware>) -> AwareView {
        let view = AwareView()
        view.onAppear = onAppear
        return view
    }

    func updateNSView(_ nsView: AwareView, context: NSViewRepresentableContext<AppearAware>) {

    }
}

final class AwareView: NSView {
    private var trigged: Bool = false
    var onAppear: () -> Void = {}

    override func viewDidMoveToSuperview() {
        super.viewDidMoveToSuperview()

        guard !trigged else { return }
        trigged = true
        onAppear()
    }
}
