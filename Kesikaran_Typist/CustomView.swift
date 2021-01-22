//
//  CustomView.swift
//  Kesikaran_Typist
//
//  Created by Tomishige Ryosuke on 2020/12/19.
//

import Cocoa
import QuartzCore

/*
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
 
 }*/

class CustomView: NSView, CALayerDelegate {
    /*
    var bgLayer     = CALayer()
    
    override func awakeFromNib() {
        self.wantsLayer = true  // Layer Backed Viewにする
        self.layer?.delegate = self
        self.layer?.addSublayer(bgLayer)
    }*/
    
    // KeyDownに対応するためのクラス
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        return true
    }
    /*
    override func layout() {
        // 諸々レイアウト
        super.layout()
        
        bgLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        bgLayer.backgroundColor = CGColor.init(red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        bgLayer.cornerRadius = 15
        bgLayer.borderWidth = 10
        bgLayer.borderColor = CGColor.black
    }*/
    
}

// 背景に図形を描画したい
// https://clrmemory.com/programming/swift/cocoa-nsgraphicscontext-draw/
// https://qiita.com/Kyome/items/258cc0c1ee1291b0f207
