//
//  CustomView.swift
//  Kesikaran_Typist
//
//  Created by Tomishige Ryosuke on 2020/12/19.
//

import Cocoa

extension NSView {

    @IBInspectable var backgroundColor: NSColor? {
        get {
            guard let layer = layer, let backgroundColor = layer.backgroundColor else {return nil}
            return NSColor(cgColor: backgroundColor)
        }
        set {
            wantsLayer = true
            layer?.backgroundColor = newValue?.cgColor
        }
    }

}

class CustomView: NSView {
    
    // KeyDownに対応するためのクラス
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        return true
    }
    
}
