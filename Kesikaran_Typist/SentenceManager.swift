//
//  TypedKanaSentenceManager.swift
//  Kesikaran_Typist
//
//  Created by Tomishige Ryosuke on 2021/01/20.
//

import Foundation

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
    
    //シングルトンオブジェクトを作成
    static let sharedInstance = SentenceManager()
    
    var sampleSentenceArray: Array<SampleSentenceData> = []
    var sentenceNum = 0 // sequentialText()用 現在のテキスト番号
    var nowSentence = SampleSentenceData(sentence: "サンプル", kana: "さんぷる")
    
    func setSequentialSentence() {
        // 順番にテキストを選択
        // self.nowSentence = sampleSentenceArray[sentenceNum]
        self.nowSentence = SampleSentenceData(sentence: "けしからん", kana: "けしからん")
        sentenceNum += 1
        if sampleSentenceArray.count == sentenceNum {
            sentenceNum = 0
        }
    }
    
    func setRandomSentence() {
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
    
    // 入力されかかな文を保持するため
    var StrData = ""
    
    //初期化処理
    private init(){
        //シングルトンであることを保証するためにprivateで宣言
    }
    
    func update(char: String, kana: String){
        if char == "return" {
            // self.StrData = ""
        } else if char == "tab" {
            self.StrData += ""
        } else if char == "delete" {
            self.StrData = String(self.StrData.dropLast(1))
        }  else if char == "space" {
            self.StrData += "　"
        } else if char == "Not found" {
            self.StrData += ""
        } else{
            self.StrData += kana
        }
    }
    
}
