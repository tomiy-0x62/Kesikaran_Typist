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
    
    var lastNextKeyNums: Array<Int> = []
    var nextKeyNums: Array<Int> = []
    
    var sampleSentenceArray: Array<SampleSentenceData> = []
    var sentenceNum = 0 // sequentialText()用 現在のテキスト番号
    var nowSampleSentence = SampleSentenceData(sentence: "サンプル", kana: "さんぷる")
    
    var correctCharIndex = 0 // nowSampleSentenceとtypedKanaSentenceが何文字目まで一致してるか
    
    func getCharfromStr(text: String, index: Int) -> String {
        // text の index 番目の文字を取得
        // ex) text: "すうねんにいっかいれへ゛る", index: 3 -> ん
        return String(text[text.index(text.startIndex, offsetBy: index)])
    }
    
    func test() {
        print("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&")
        print(getNextKeyNums())
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
    
    func getNextKeyNums() -> [Int] {
        // 次にタイプするキーのkeyNumを取得
        if typedKanaSentence.utf16.count == correctCharIndex {
            let nextKeyKana = getCharfromStr(text: nowSampleSentence.kanaSentence, index: correctCharIndex)
            print("Next Kana = \(nextKeyKana)")
            self.lastNextKeyNums = self.nextKeyNums
            self.nextKeyNums = keyDataManager.searchKeyNums(keyKana: nextKeyKana)
            return self.nextKeyNums
        } else {
            let nextKeyKana = "delete"
            print("Next Kana = \(nextKeyKana)")
            self.lastNextKeyNums = self.nextKeyNums
            self.nextKeyNums = keyDataManager.searchKeyNums(keyKana: nextKeyKana)
            return self.nextKeyNums
        }
    }
    
    func setSequentialSampleSentence() {
        // 順番にテキストを選択
        // self.nowSentence = sampleSentenceArray[sentenceNum]
        self.nowSampleSentence = SampleSentenceData(sentence: "けしからん", kana: "けしからん")
        sentenceNum += 1
        if sampleSentenceArray.count == sentenceNum {
            sentenceNum = 0
        }
    }
    
    func setRandomSampleSentence() {
        // ランダムにテキストを選択
        if sampleSentenceArray.count == 0 {
            self.nowSampleSentence = SampleSentenceData(sentence: "けしからん", kana: "けしからん")
        }
        self.nowSampleSentence = sampleSentenceArray.randomElement()!
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
                    let sampleTextData = SampleSentenceData(sentence: values[0], kana: values[1])
                    // print("\(keyData.char)の文字コードは、\(keyData.keyCodes)、キーは\(keyData.keycapChar)です。")
                    self.sampleSentenceArray.append(sampleTextData)
                    // print(keyData)
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
    }
    
}
