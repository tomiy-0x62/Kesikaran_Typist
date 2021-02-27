//
//  ViewController.swift
//  Kesikaran_Typist
//
//  Created by Tomishige Ryosuke on 2020/12/19.
//

import Cocoa

enum side {
    case right, left, none
}

class ViewController: NSViewController {
    
    // @IBOutlet weak var textField: NSTextField! // textField
    @IBOutlet weak var sampleSentenceLabel: NSTextField! // 数年に１回レベルの大変楽しい日本語訳を発見いたしました
    @IBOutlet weak var kanaSampleSentenceLabel: NSTextField!  // すうねんにいっかいれへ゛るのたいへんたのしいにほんこ゛やくをはっけんいたしました！
    
    @IBOutlet weak var typedKeyCharLabel: NSTextField!  // Typed: a
    @IBOutlet weak var typedKeyKanaLabel: NSTextField!  // Kana: ち
    @IBOutlet weak var typedKanaSentenceLabel: NSTextField!   // ちとしは
    // 全キーを手動で接続した。 これは大変けしからん実装である
    // しかし、outlet collection は macOS では使えない(大昔は使えたらしい)から無理。
    // 仕方なくこの実装にした。
    @IBOutlet weak var accent_grave: KeyView!  // 0
    @IBOutlet weak var one: KeyView!  // 1
    @IBOutlet weak var two: KeyView!  // 2
    @IBOutlet weak var three: KeyView!  // 3
    @IBOutlet weak var four: KeyView!  // 4
    @IBOutlet weak var five: KeyView!  // 5
    @IBOutlet weak var six: KeyView!  // 6
    @IBOutlet weak var seven: KeyView!  // 7
    @IBOutlet weak var eight: KeyView!  // 8
    @IBOutlet weak var nine: KeyView!  // 9
    @IBOutlet weak var zero: KeyView!  // 10
    
    @IBOutlet weak var A: KeyView!   // 11
    @IBOutlet weak var B: KeyView!  // 12
    @IBOutlet weak var C: KeyView!  // 13
    @IBOutlet weak var D: KeyView!  // 14
    @IBOutlet weak var E: KeyView!  // 15
    @IBOutlet weak var F: KeyView!  // 16
    @IBOutlet weak var G: KeyView!  // 17
    @IBOutlet weak var H: KeyView!  // 18
    @IBOutlet weak var I: KeyView!  // 19
    @IBOutlet weak var J: KeyView!  // 20
    @IBOutlet weak var K: KeyView!  // 21
    @IBOutlet weak var L: KeyView!  // 22
    @IBOutlet weak var M: KeyView!  // 23
    @IBOutlet weak var N: KeyView!  // 24
    @IBOutlet weak var O: KeyView!  // 25
    @IBOutlet weak var P: KeyView!  // 26
    @IBOutlet weak var Q: KeyView!  // 27
    @IBOutlet weak var R: KeyView!  // 28
    @IBOutlet weak var S: KeyView!  // 29
    @IBOutlet weak var T: KeyView!  // 30
    @IBOutlet weak var U: KeyView!  // 31
    @IBOutlet weak var V: KeyView!  // 32
    @IBOutlet weak var W: KeyView!  // 33
    @IBOutlet weak var X: KeyView!  // 34
    @IBOutlet weak var Y: KeyView!  // 35
    @IBOutlet weak var Z: KeyView!  // 36
    
    @IBOutlet weak var hyphen: KeyView!  // 37  -
    @IBOutlet weak var equal: KeyView!  // 38  =
    @IBOutlet weak var delete: KeyView!  // 39
    @IBOutlet weak var tab: KeyView!  // 40
    @IBOutlet weak var l_sq_bracket: KeyView!  // 41  [
    @IBOutlet weak var r_sq_bracket: KeyView!  // 42  ]
    @IBOutlet weak var back_slash: KeyView!  // 43  \
    @IBOutlet weak var l_control: KeyView!  // 44 Ctrl
    @IBOutlet weak var colon: KeyView!  // 45  ;
    @IBOutlet weak var quotation: KeyView!  // 46  '
    @IBOutlet weak var returnKey: KeyView!  // 47
    @IBOutlet weak var l_shift: KeyView!  // 48
    @IBOutlet weak var comma: KeyView!  // 49  ,
    @IBOutlet weak var dot: KeyView!  // 50  .
    @IBOutlet weak var slash: KeyView!  // 51  /
    @IBOutlet weak var r_shift: KeyView!  // 52
    @IBOutlet weak var caps_lock: KeyView!  // 53
    @IBOutlet weak var l_option: KeyView!  // 54  Opt
    @IBOutlet weak var l_command: KeyView!  // 55  ⌘
    @IBOutlet weak var spase: KeyView!  // 56
    @IBOutlet weak var r_command: KeyView!  // 57  ⌘
    @IBOutlet weak var r_option: KeyView!  // 58 Opt
    @IBOutlet weak var r_control: KeyView!  // 59 Ctrl
    @IBOutlet weak var Fn: KeyView!  // 60
    
    var keyViewList: Array<KeyView> = []
    
    
    // shiftキーの状態を保存
    var isShift: Bool = false
    var sideOfShift = side.none
    
    let keyDataManager = KeysDataManager.sharedInstance  // keyDataが保存してあるクラスのインスタンス
    let sentenceManager = SentenceManager.sharedInstance  // タイプされた文章を保存するクラスのインスタンス
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        keyViewList = [accent_grave, one, two, three, four, five, six, seven, eight, nine, zero, A, B, C, D, E, F, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V, W, X, Y, Z, hyphen, equal, delete, tab, l_sq_bracket, r_sq_bracket, back_slash, l_control, colon, quotation, returnKey, l_shift, comma, dot, slash, r_shift, caps_lock, l_option, l_command, spase, r_command, r_option, Fn]
        
        keyDataManager.loadKeyData()
        sentenceManager.loadSampleSentence()
        
        sentenceManager.setSequentialSampleSentence()
        sampleSentenceLabel.stringValue = sentenceManager.nowSentence.sentence
        kanaSampleSentenceLabel.stringValue = sentenceManager.nowSentence.kanaSentence
        
        typedKanaSentenceLabel.isSelectable = true
        sampleSentenceLabel.isSelectable = true
        kanaSampleSentenceLabel.isSelectable = true
        
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
    
    func genKeycodesforNum(keycode: UInt16) -> [Int] {
        // shift + ○ に対応させる (shiftの左右を区別する)
        // right shift + 32 -> [60, 32]
        // 48 -> [48]
        if isShift {
            switch sideOfShift{
            case side.right:
                return [60, Int(keycode)]
            case side.left:
                return [56, Int(keycode)]
            default:
                return [56, Int(keycode)]
            }
        }
        return [Int(keycode)]
    }
    
    /*
     func checkText(typedKey: String) -> Bool {
     // なにこれ？
     let text = sampleSentenceManager.nowSentence.kanaSentence
     if typedKey == String(text[text.index(text.startIndex, offsetBy: sampleSentenceManager.nowSentenceIndex)]) {
     sampleSentenceManager.nowSentenceIndex += 1
     return true
     }
     return false
     }*/
    
    func searchNextKey() {
        //
    }
    
    override func keyDown(with event: NSEvent) {
        // textField.stringValue = String(describing: event.characters!)
        print("KeDown: Code '\(event.keyCode)'")
        let typedKeyChars = keyDataManager.searchKeyKana(keyCode: genKeycodes(keycode: event.keyCode))
        let typedKeyNums = keyDataManager.searchKeyNums(keyCodes: genKeycodesforNum(keycode: event.keyCode))
        let typedKana = keyDataManager.searchKeyChar(keyCode: genKeycodes(keycode: event.keyCode))
        print("typedKey: \(typedKeyChars)")
        typedKeyCharLabel.stringValue = ("Typed: \(typedKeyChars)")
        typedKeyKanaLabel.stringValue = ("Char: \(typedKana)")
        sentenceManager.updateTypedKanaSentence(char: typedKeyChars, kana: typedKana)
        typedKanaSentenceLabel.stringValue = sentenceManager.typedKanaSentence
        print("typedKeyNums: \(typedKeyNums)")
        // checkText(typedKey: typedChar)
        for keyNum in typedKeyNums {
            if keyNum == 61{
                print("esc")
            }else {
                keyViewList[keyNum].turnOn(color: keyColor.green)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.keyViewList[keyNum].turnOff()
                }
            }
            if sentenceManager.checkTypedSentence() {
                typedKanaSentenceLabel.stringValue = sentenceManager.typedKanaSentence
                sampleSentenceLabel.stringValue = sentenceManager.nowSentence.sentence
                kanaSampleSentenceLabel.stringValue = sentenceManager.nowSentence.kanaSentence
            }
        }
        
    }
    
    override func flagsChanged(with event: NSEvent) {
        // print(event.keyCode)
        let typedKeyKana = keyDataManager.searchKeyKana(keyCode: [Int(event.keyCode)])
        print("apple: \(typedKeyKana)")
        switch event.modifierFlags.intersection(.deviceIndependentFlagsMask) {
        case [.shift]:
            print("shift key is pressed")
            self.isShift = true
            if typedKeyKana == "left shift" {
                self.sideOfShift = side.left
            }
            if typedKeyKana == "right shift" {
                self.sideOfShift = side.right
            }
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
            self.sideOfShift = side.none
        }
    }
}

