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
    @IBOutlet weak var typedLabel: NSTextField!
    
    
    var count:Int = 0
    
    let testClass = KeysDataManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testClass.loadWord()
        
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
    
    override func keyDown(with event: NSEvent) {
        // print(event)
        // print("\n")
        label.stringValue = ("I'm Mac.")
        textField.stringValue = String(describing: event.characters!)
        print("KeDown: Code '\(event.keyCode)'")
        print(event.keyCode)
    }
    
    override func flagsChanged(with event: NSEvent) {
        // print(event)
        // print("\n")
        print(event.keyCode)
            switch event.modifierFlags.intersection(.deviceIndependentFlagsMask) {
            case [.shift]:
                print("shift key is pressed")
            case [.control]:
                print("control key is pressed")
            case [.option] :
                print("option key is pressed")
            case [.command]:
                print("Command key is pressed")
            case [.control, .shift]:
                print("control-shift keys are pressed")
            case [.option, .shift]:
                print("option-shift keys are pressed")
            case [.command, .shift]:
                print("command-shift keys are pressed")
            case [.control, .option]:
                print("control-option keys are pressed")
            case [.control, .command]:
                print("control-command keys are pressed")
            case [.option, .command]:
                print("option-command keys are pressed")
            case [.shift, .control, .option]:
                print("shift-control-option keys are pressed")
            case [.shift, .control, .command]:
                print("shift-control-command keys are pressed")
            case [.control, .option, .command]:
                print("control-option-command keys are pressed")
            case [.shift, .command, .option]:
                print("shift-command-option keys are pressed")
            case [.shift, .control, .option, .command]:
                print("shift-control-option-command keys are pressed")
            default:
                print("no modifier keys are pressed")
            }
    }
}

