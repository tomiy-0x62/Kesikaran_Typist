//
//  KeybordBack.swift
//  Kesikaran_Typist
//
//  Created by Tomishige Ryosuke on 2021/01/22.
//


import Cocoa
import QuartzCore

class KeybordBackground: NSView, CALayerDelegate {
    
    var bgLayer     = CALayer()
    
    override func awakeFromNib() {
        self.wantsLayer = true  // Layer Backed Viewにする
        self.layer?.delegate = self
        self.layer?.addSublayer(bgLayer)
    }
    
    // KeyDownに対応するためのクラス
    override func performKeyEquivalent(with event: NSEvent) -> Bool {
        return true
    }
    
    override func layout() {
        // 諸々レイアウト
        super.layout()
        
        bgLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        bgLayer.backgroundColor = CGColor.init(red: 0.7294, green: 0.9568, blue: 1.0, alpha: 0.8)
        bgLayer.cornerRadius = 10
        bgLayer.borderWidth = 2
        bgLayer.borderColor = CGColor.init(gray: 0.7, alpha: 1.0)
    }
    
    
    
    // 背景に図形を描画したい
    // https://clrmemory.com/programming/swift/cocoa-nsgraphicscontext-draw/
    // https://qiita.com/Kyome/items/258cc0c1ee1291b0f207
    
    
}
