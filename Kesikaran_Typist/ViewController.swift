//
//  ViewController.swift
//  Kesikaran_Typist
//
//  Created by Tomishige Ryosuke on 2020/12/19.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var textField: NSTextField!
    @IBOutlet weak var label: NSTextField!
    
    var count:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSEvent.addLocalMonitorForEvents(matching: .flagsChanged) {
            self.flagsChanged(with: $0)
            return $0
        }
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            self.keyDown(with: $0)
            return $0
        }
    }
    
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    /*
     override func keyUp(with event: NSEvent) {
     print("KeyUp")
     label.stringValue = ("I'm Mac.")
     textField.stringValue = String(describing: event.characters!)
     print(event.keyCode)
     }*/
    
    override func keyDown(with event: NSEvent) {
        print("KeDown")
        label.stringValue = ("I'm Mac.")
        textField.stringValue = String(describing: event.characters!)
        print(event.keyCode)
    }
    
}

