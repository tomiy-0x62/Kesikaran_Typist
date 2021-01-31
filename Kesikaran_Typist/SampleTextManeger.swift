//
//  SampleTextManeger.swift
//  Kesikaran_Typist
//
//  Created by Tomishige Ryosuke on 2021/01/31.
//

import Foundation

struct SampleTextData {
    
    let text: String
    let kana: String
    
    //クラスが生成された時の処理
    init(text: String, kana: String) {
        self.text = text
        self.kana = kana
    }
}

class SampleTextManager {
    
    //シングルトンオブジェクトを作成
    static let sharedInstance = SampleTextManager()
    
    var sampleTextArray: Array<SampleTextData> = []
    var textNum = 0
    
    //初期化処理
    private init(){
        //シングルトンであることを保証するためにprivateで宣言
    }
    
    func randomText() -> SampleTextData {
        
        if sampleTextArray.count == 0 {
            return SampleTextData(text: "けしからん！", kana: "けしからん！")
        }
        return sampleTextArray.randomElement()!
        
    }
    
    func loadSampleText() {
        
        
        //格納済みのデータがあれば一旦削除
        sampleTextArray.removeAll()
        
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
                    let sampleTextData = SampleTextData(text: values[0], kana: values[1])
                    // print("\(keyData.char)の文字コードは、\(keyData.keyCodes)、キーは\(keyData.keycapChar)です。")
                    self.sampleTextArray.append(sampleTextData)
                    // print(keyData)
                }
            } else {
                print("Fail to get contens of keys.csv")
            }
            
        }else{
            print("Fail to get URL of keys.csv")
        }
        self.textNum = sampleTextArray.count
        
    }
    
}
