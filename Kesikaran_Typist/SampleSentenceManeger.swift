//
//  SampleTextManeger.swift
//  Kesikaran_Typist
//
//  Created by Tomishige Ryosuke on 2021/01/31.
//

import Foundation

struct SampleSentenceData {
    
    let sentence: String
    let kana: String
    
    //クラスが生成された時の処理
    init(sentence: String, kana: String) {
        self.sentence = sentence
        self.kana = kana
    }
}

class SampleSentenceManeger {
    
    //シングルトンオブジェクトを作成
    static let sharedInstance = SampleSentenceManeger()
    
    var sampleSentenceArray: Array<SampleSentenceData> = []
    var textNum = 0 // sequentialText()用 現在のテキスト番号
    
    var nowText = SampleSentenceData(sentence: "サンプル", kana: "さんぷる")
    var nowTextIndex: Int = 0 // 今何文字目まで入力したか？
    
    //初期化処理
    private init(){
        //シングルトンであることを保証するためにprivateで宣言
    }
    
    func sequentialText() {
        // 順番にテキストを選択
        self.nowText = sampleSentenceArray[textNum]
        textNum += 1
        if sampleSentenceArray.count == textNum {
            textNum = 0
        }
    }
    
    func randomText() {
        // ランダムにテキストを選択
        if sampleSentenceArray.count == 0 {
            self.nowText = SampleSentenceData(sentence: "けしからん！", kana: "けしからん！")
        }
        self.nowText = sampleSentenceArray.randomElement()!
        
    }
    
    func loadSampleText() {
        
        
        //格納済みのデータがあれば一旦削除
        sampleSentenceArray.removeAll()
        
        //CSVファイルパスを取得
        if let csvFilePath = Bundle.main.url(forResource: "text", withExtension: "txt") {
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
    
}
