//
//  TypedKanaSentenceManager.swift
//  Kesikaran_Typist
//
//  Created by Tomishige Ryosuke on 2021/01/20.
//

import Foundation

enum Mode {
    case random, sequential
}

struct SampleSentenceData {
    
    let sentence: String
    let kanaSentence: String
    
    //クラスが生成された時の処理
    init(sentence: String, kana: String) {
        self.sentence = sentence
        self.kanaSentence = kana
    }
}

class SentenceManager {
    
    
    //初期化処理
    private init(){
        //シングルトンであることを保証するためにprivateで宣言
    }
    
    //シングルトンオブジェクトを作成
    static let sharedInstance = SentenceManager()
    
    let keyDataManager = KeysDataManager.sharedInstance
    
    // 入力されかかな文を保持するため
    var typedKanaSentence = ""
    
    var attributedKanaSampleSentence = NSMutableAttributedString()
    
    var lastNextKeyCodes: Array<Int> = []
    var nextKeyCodes: Array<Int> = []
    
    var sampleSentenceArray: Array<SampleSentenceData> = []
    var sentenceIndex = 0 // sequentialText()用 現在のテキスト番号
    var nowSampleSentence = SampleSentenceData(sentence: "サンプル", kana: "さんぷる")
    
    var correctCharIndex = 0 // nowSampleSentenceとtypedKanaSentenceが何文字目まで一致してるか
    
    func getCharfromStr(text: String, index: Int) -> String {
        // text の index 番目の文字を取得
        // ex) text: "すうねんにいっかいれへ゛る", index: 3 -> ん
        return String(text[text.index(text.startIndex, offsetBy: index)])
    }
    
    func test() {
        print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&")
        print(getNextKeyCodes())
        print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&")
    }
    
    func calcCorrectCharIndex() -> Int {
        // nowSampleSentenceとtypedKanaSentenceが何文字目まで一致してるか計算
        if typedKanaSentence.utf16.count < nowSampleSentence.kanaSentence.utf16.count {
            for i in 0..<typedKanaSentence.utf16.count {
                if getCharfromStr(text: typedKanaSentence, index: i) == getCharfromStr(text: nowSampleSentence.kanaSentence, index: i) {
                    // pass
                }else {
                    return i
                }
            }
            return typedKanaSentence.utf16.count
        } else {
            for i in 0..<nowSampleSentence.kanaSentence.utf16.count {
                if getCharfromStr(text: typedKanaSentence, index: i) == getCharfromStr(text: nowSampleSentence.kanaSentence, index: i) {
                    // pass
                } else {
                    return i
                }
            }
            return nowSampleSentence.kanaSentence.utf16.count
        }
    }
    
    func getNextKeyCodes() -> [Int] {
        // 次にタイプするキーのkeyCOdeを取得
        if typedKanaSentence.utf16.count == correctCharIndex {
            let nextKeyKana = getCharfromStr(text: nowSampleSentence.kanaSentence, index: correctCharIndex)
            print("Next Kana = \(nextKeyKana)")
            self.lastNextKeyCodes = self.nextKeyCodes
            self.nextKeyCodes = keyDataManager.searchKeyCodes(keyKana: nextKeyKana)
            return self.nextKeyCodes
        } else {
            let nextKeyKana = "delete"
            print("Next Kana = \(nextKeyKana)")
            self.lastNextKeyCodes = self.nextKeyCodes
            self.nextKeyCodes = keyDataManager.searchKeyCodes(keyKana: nextKeyKana)
            return self.nextKeyCodes
        }
    }
    
    func setSequentialSampleSentence() {
        // 順番にテキストを選択
        // self.nowSentence = sampleSentenceArray[sentenceNum]
        self.nowSampleSentence = SampleSentenceData(sentence: "けしからん", kana: "けしからん")
        sentenceIndex += 1
        if sampleSentenceArray.count == sentenceIndex {
            sentenceIndex = 0
        }
        self.attributedKanaSampleSentence = NSMutableAttributedString()
        self.attributedKanaSampleSentence.append(NSAttributedString(string: nowSampleSentence.kanaSentence))
    }
    
    func setRandomSampleSentence() {
        // ランダムにテキストを選択
        if sampleSentenceArray.count == 0 {
            self.nowSampleSentence = SampleSentenceData(sentence: "けしからん", kana: "けしからん")
        }
        self.nowSampleSentence = sampleSentenceArray.randomElement()!
        self.attributedKanaSampleSentence = NSMutableAttributedString()
        self.attributedKanaSampleSentence.append(NSAttributedString(string: nowSampleSentence.kanaSentence))
    }
    
    func loadSampleSentence() {
        
        //格納済みのデータがあれば一旦削除
        sampleSentenceArray.removeAll()
        
        //CSVファイルパスを取得
        if let csvFilePath = Bundle.main.url(forResource: "SampleSentence", withExtension: "txt") {
            let csvFilePathStr: String = csvFilePath.path
            // print(csvFilePathStr)
            
            //CSVデータ読み込み
            if let csvStringData: String = try? String(contentsOfFile: csvFilePathStr, encoding: String.Encoding.utf8) {
                // 読み込んだデータを行ごとに分解
                let rows = csvStringData.components(separatedBy: "\n").filter{!$0.isEmpty}
                for row in rows {
                    // スペースで分割
                    let values = row.components(separatedBy: ",")
                    // 54を超えてないかチェック
                    if values[1].utf16.count > 54 {
                        print("Can't add \(values[1]), because num of char over 54")
                    } else {
                        let sampleTextData = SampleSentenceData(sentence: values[0], kana: values[1])
                        // print("\(keyData.char)の文字コードは、\(keyData.keyCodes)、キーは\(keyData.keycapChar)です。")
                        self.sampleSentenceArray.append(sampleTextData)
                        // print(keyData)
                    }
                }
            } else {
                print("Fail to get contens of keys.csv")
            }
            
        }else{
            print("Fail to get URL of keys.csv")
        }
        
    }
    
    func checkTypedSentence() -> Bool{
        // 正確にタイプし終わったか確認
        if typedKanaSentence == nowSampleSentence.kanaSentence {
            updateSelf(mode: Mode.random)
            return true
        }
        return false
    }
    
    func updateSelf(mode: Mode) {
        // nowSampleSentenceを変更し、typedKanaSentenceをリセット
        self.typedKanaSentence = ""
        self.correctCharIndex = 0
        switch mode {
        case Mode.random:
            self.setRandomSampleSentence()
        case Mode.sequential:
            self.setSequentialSampleSentence()
        }
    }
    
    private func updateAttributedKanaSampleSentence() {
        self.attributedKanaSampleSentence = NSMutableAttributedString()
        let text = nowSampleSentence.kanaSentence
        let to = text.index(text.startIndex, offsetBy: correctCharIndex)
        let from = text.index(text.startIndex, offsetBy: correctCharIndex)
        // calcCorrectCharIndex()
        let compStr = String(text[text.startIndex..<to])
        let ncompStr = String(text[from..<text.endIndex])
        let orangeAttribute: [NSAttributedString.Key : Any] = [
            .foregroundColor : CGColor.init(red: 1.0, green: 0.3921, blue: 0.0, alpha: 1.0)
        ]
        let comp = NSAttributedString(string: compStr, attributes: orangeAttribute)
        let ncomp = NSAttributedString(string: ncompStr)
        self.attributedKanaSampleSentence.append(comp)
        self.attributedKanaSampleSentence.append(ncomp)
        
    }
    
    
    func updateTypedKanaSentence(char: String, kana: String){
        // キー入力の結果を反映
        if char == "return" {
            // self.StrData = ""
        } else if char == "tab" {
            self.typedKanaSentence += ""
        } else if char == "delete" {
            self.typedKanaSentence = String(self.typedKanaSentence.dropLast(1))
        }  else if char == "space" {
            self.typedKanaSentence += "　"
        }else if char == "esc" {
            self.typedKanaSentence += ""
        } else if char == "Not found" {
            self.typedKanaSentence += ""
        } else{
            self.typedKanaSentence += kana
        }
        correctCharIndex = calcCorrectCharIndex()
        updateAttributedKanaSampleSentence()
    }
    
}
