//
//  KeyView.swift
//  Kesikaran_Typist
//
//  Created by Tomishige Ryosuke on 2021/01/20.
//

import Cocoa

class KeyView: NSImageView {
    
    var bgLayer = CALayer()
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        // Drawing code here.
    }
    
    func changeImage(image: String) {
        // change image
    }
    
    func  turnOn() {
        var imageLayer: CALayer = CALayer()
        bgLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        bgLayer.backgroundColor = CGColor.init(red: 1.0, green: 0.7058, blue: 0.4078, alpha: 0.8)
        bgLayer.cornerRadius = 5
        self.layer?.addSublayer(bgLayer)
        self.layer?.sublayers?.forEach {
            print(type(of: $0))
            if type(of: $0) != CALayer.self {
                imageLayer = $0
                $0.removeFromSuperlayer()
            }
        }
        self.layer?.addSublayer(imageLayer)
    }
    
    func turnOff() {
        self.layer?.sublayers?.forEach {
            if type(of: $0) == CALayer.self {
                $0.removeFromSuperlayer()
            }
        }
    }
    
}
