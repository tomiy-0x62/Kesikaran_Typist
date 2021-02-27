//
//  KeyView.swift
//  Kesikaran_Typist
//
//  Created by Tomishige Ryosuke on 2021/01/20.
//

import Cocoa

enum keyColor {
    case orange, red, green
}

class KeyView: NSImageView {
    
    var bgLayer = CALayer()
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
    }
    
    func changeImage(image: String) {
        // change image
    }
    
    func  turnOn(color: keyColor) {
        // キーの背景色を変える
        // 色付きのレイヤを上にのせる。そうすると刻印の入った画像が隠れる
        // その上にさらに画像のレイヤーを載せて対処
        let imageLayer = CALayer()
        let keyImage = self.image
        // print(keyImage!)
        bgLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        // bgLayer.backgroundColor = CGColor.init(red: 1.0, green: 0.7058, blue: 0.4078, alpha: 1.0)
        switch color {
            case keyColor.green:
                bgLayer.backgroundColor = CGColor.init(red: 0.4039, green: 0.9333, blue: 0.4627, alpha: 1.0)
            case keyColor.red:
                bgLayer.backgroundColor = CGColor.init(red: 0.8941, green: 0.4313, blue: 0.4313, alpha: 1.0)
            case keyColor.orange:
                bgLayer.backgroundColor = CGColor.init(red: 1.0, green: 0.7058, blue: 0.4078, alpha: 1.0)
        }
        bgLayer.cornerRadius = 5
        // bgLayer.zPosition = -1
        self.layer?.addSublayer(bgLayer)
        imageLayer.contents = keyImage!
        imageLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        // imageLayer.zPosition = 0
        self.layer?.addSublayer(imageLayer)
    }
    
    func turnOff() {
        // キーの背景色を削除
        self.layer?.sublayers?.forEach {
            // print(type(of: $0))
            if type(of: $0) == CALayer.self {
                $0.removeFromSuperlayer()
                // print("hello")
            }
        }
    }
    
}
