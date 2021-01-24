//
//  ViewController.swift
//  Kesikaran_Typist
//
//  Created by Tomishige Ryosuke on 2020/12/19.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var textField: NSTextField! // textField
    @IBOutlet weak var label: NSTextField! // Hello, World
    @IBOutlet weak var typedLabel: NSTextField!  // Typed: a
    @IBOutlet weak var typedCharLabel: NSTextField!  // Char: ち
    @IBOutlet weak var typedKeyLabel: NSTextField!    // asdf
    @IBOutlet weak var typedKanaLabel: NSTextField!   // ちとしは
    
    @IBOutlet weak var accent_grave: KeyView!
    @IBOutlet weak var one: KeyView!
    @IBOutlet weak var two: KeyView!
    @IBOutlet weak var three: KeyView!
    @IBOutlet weak var four: KeyView!
    @IBOutlet weak var five: KeyView!
    @IBOutlet weak var six: KeyView!
    @IBOutlet weak var seven: KeyView!
    @IBOutlet weak var eight: KeyView!
    @IBOutlet weak var nine: KeyView!
    @IBOutlet weak var zero: KeyView!
    @IBOutlet weak var hyphen: KeyView!
    @IBOutlet weak var equal: KeyView!
    @IBOutlet weak var delete: KeyView!
    @IBOutlet weak var tab: KeyView!
    @IBOutlet weak var l_sq_bracket: KeyView!
    @IBOutlet weak var r_sq_bracket: KeyView!
    @IBOutlet weak var back_slash: KeyView!
    @IBOutlet weak var l_control: KeyView!
    @IBOutlet weak var colon: KeyView!
    @IBOutlet weak var quotation: KeyView!
    @IBOutlet weak var returnKey: KeyView!
    @IBOutlet weak var l_shift: KeyView!
    @IBOutlet weak var comma: KeyView!
    @IBOutlet weak var dot: KeyView!
    @IBOutlet weak var slash: KeyView!
    @IBOutlet weak var shift: KeyView!
    @IBOutlet weak var caps_lock: KeyView!
    @IBOutlet weak var l_option: KeyView!
    @IBOutlet weak var l_command: KeyView!
    @IBOutlet weak var spase: KeyView!
    @IBOutlet weak var r_command: KeyView!
    @IBOutlet weak var r_option: KeyView!
    @IBOutlet weak var r_control: KeyView!
    @IBOutlet weak var Fn: KeyView!
    
    @IBOutlet weak var A: KeyView!
    @IBOutlet weak var B: KeyView!
    @IBOutlet weak var C: KeyView!
    @IBOutlet weak var D: KeyView!
    @IBOutlet weak var E: KeyView!
    @IBOutlet weak var F: KeyView!
    @IBOutlet weak var G: KeyView!
    @IBOutlet weak var H: KeyView!
    @IBOutlet weak var I: KeyView!
    @IBOutlet weak var J: KeyView!
    @IBOutlet weak var K: KeyView!
    @IBOutlet weak var L: KeyView!
    @IBOutlet weak var M: KeyView!
    @IBOutlet weak var N: KeyView!
    @IBOutlet weak var O: KeyView!
    @IBOutlet weak var P: KeyView!
    @IBOutlet weak var Q: KeyView!
    @IBOutlet weak var R: KeyView!
    @IBOutlet weak var S: KeyView!
    @IBOutlet weak var T: KeyView!
    @IBOutlet weak var U: KeyView!
    @IBOutlet weak var V: KeyView!
    @IBOutlet weak var W: KeyView!
    @IBOutlet weak var X: KeyView!
    @IBOutlet weak var Y: KeyView!
    @IBOutlet weak var Z: KeyView!
    
    
    
    // shiftキーの状態を保存
    var isShift: Bool = false
    
    let keyDataClass = KeysDataManager.sharedInstance
    let TextDataClass = TextManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyDataClass.loadWord()
        
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
    
    func genKeycodes(keycode: UInt16) -> [Int] {
        // shift + ○ に対応させる
        // shift + 56 -> [421, 56]
        // 48 -> [48]
        if isShift {
            return [421, Int(keycode)]
        }
        return [Int(keycode)]
    }
    
    override func keyDown(with event: NSEvent) {
        // textField.stringValue = String(describing: event.characters!)
        print("KeDown: Code '\(event.keyCode)'")
        let typedKey = keyDataClass.searchKey(keyCode: genKeycodes(keycode: event.keyCode))
        let typedChar = keyDataClass.searchChar(keyCode: genKeycodes(keycode: event.keyCode))
        print("typedKey: \(typedKey)")
        typedLabel.stringValue = ("Typed: \(typedKey)")
        typedCharLabel.stringValue = ("Char: \(typedChar)")
        TextDataClass.update(key: typedKey, char: typedChar)
        typedKeyLabel.stringValue = TextDataClass.keyData
        typedKanaLabel.stringValue = TextDataClass.StrData
        /*
        if typedKey == "return"{
            testKey.turnOn()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                self.testKey.turnOff()
            }
        }*/
        
    }
    
    override func flagsChanged(with event: NSEvent) {
        // print(event.keyCode)
        let typedKey = keyDataClass.searchKey(keyCode: genKeycodes(keycode: event.keyCode))
        print(typedKey)
        switch event.modifierFlags.intersection(.deviceIndependentFlagsMask) {
        case [.shift]:
            print("shift key is pressed")
            self.isShift = true
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
            self.isShift = false
        }
    }
}

