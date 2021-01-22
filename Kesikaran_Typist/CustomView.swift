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
    
    required init?(coder decoder: NSCoder) {
            super.init(coder: decoder)

            wantsLayer = true
            layer?.backgroundColor = NSColor.gray.cgColor
        
        var views = NSView()
        views = DrawRectangle(frame: NSRect(x: 5, y: 5, width: self.bounds.width - 10, height: self.bounds.height - 10))
        self.addSubview(views)
        
        }
    
}

// 背景に図形を描画したい
// https://clrmemory.com/programming/swift/cocoa-nsgraphicscontext-draw/
// https://qiita.com/Kyome/items/258cc0c1ee1291b0f207

class DrawRectangle: NSView{
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        if let context = NSGraphicsContext.current?.cgContext {
                    context.beginPath()

                    // 線の幅の設定
                    context.setLineWidth(2.0)
                    // 線の色の設定
                    context.setStrokeColor(CGColor.black)
                    // 塗りつぶし色の設定
                    context.setFillColor(CGColor.white)
                    // 描画色のモード設定
                    context.setBlendMode(CGBlendMode.multiply)

                    // 中塗りパスの描画
                    context.fillPath()
                    //　パスのアウトラインの描画
                    context.strokePath()
                }
    }
}


