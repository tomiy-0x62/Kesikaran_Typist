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
    
    // 入力されかかな文を保持するため
    var typedKanaSentence = ""
    
    var sampleSentenceArray: Array<SampleSentenceData> = []
    var sentenceNum = 0 // sequentialText()用 現在のテキスト番号
    var nowSentence = SampleSentenceData(sentence: "サンプル", kana: "さんぷる")
    
    func setSequentialSampleSentence() {
        // 順番にテキストを選択
        // self.nowSentence = sampleSentenceArray[sentenceNum]
        self.nowSentence = SampleSentenceData(sentence: "けしからん", kana: "けしからん")
        sentenceNum += 1
        if sampleSentenceArray.count == sentenceNum {
            sentenceNum = 0
        }
    }
    
    func setRandomSampleSentence() {
        // ランダムにテキストを選択
        if sampleSentenceArray.count == 0 {
            self.nowSentence = SampleSentenceData(sentence: "けしからん", kana: "けしからん")
        }
        self.nowSentence = sampleSentenceArray.randomElement()!
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
        if typedKanaSentence == nowSentence.kanaSentence {
            updateSelf(mode: Mode.random)
            return true
        }
        return false
    }
    
    func updateSelf(mode: Mode) {
        self.typedKanaSentence = ""
        switch mode {
        case Mode.random:
            self.setRandomSampleSentence()
        case Mode.sequential:
            self.setSequentialSampleSentence()
        }
    }
    
    
    func updateTypedKanaSentence(char: String, kana: String){
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
    }
    
}
