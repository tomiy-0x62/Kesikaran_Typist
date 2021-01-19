//
//  CustomView.swift
//  Kesikaran_Typist
//
//  Created by Tomishige Ryosuke on 2020/12/19.
//

import Cocoa

class CustomView: NSView {
    
    // KeyDownに対応するためのクラス
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        return true
    }
    
}
