//
//  lordCSV.swift
//  Kesikaran_Typist
//
//  Created by Tomishige Ryosuke on 2020/12/24.
//

import Foundation


// https://qiita.com/takehiro224/items/77122fe66105c4b5f986

//==================================================
//1つの単語に関する情報を管理するデータクラス
//==================================================
class KeyData {
    
    //単語
    var char: String?
    
    //説明
    var meaning: String?
    
    //単語の番号
    var keyCode: Int = 0
    
    //クラスが生成された時の処理
    init(wordSourceDataArray: [String]) {
        char = wordSourceDataArray[0]
        meaning = wordSourceDataArray[1]
    }
}

//==================================================
//全ての単語に関する情報を管理するモデルクラス
//==================================================
class WordsDataManager {
    
    //シングルトンオブジェクトを作成
    static let sharedInstance = WordsDataManager()
    
    //単語を格納するための配列
    var keyDataArray = [KeyData]()
    
    //現在の単語のインデックス
    var nowWordIndex: Int = 0
    
    var hoge: String = ""

    //初期化処理
    private init(){
        //シングルトンであることを保証するためにprivateで宣言
    }
    
    //------------------------------
    //単語の読み込み処理
    //------------------------------
    func loadWord() {
        //格納済みの単語があれば一旦削除
        keyDataArray.removeAll()
        //現在の単語のインデックスを初期化
        nowWordIndex = 0
        
        //CSVファイルパスを取得
        if let csvFilePath = Bundle.main.url(forResource: "keys", withExtension: "csv") {
            let csvFilePathStr: String = csvFilePath.path
            // print(csvFilePathStr)
            //CSVデータ読み込み
            do {
                if let csvStringData: String = try? String(contentsOfFile: csvFilePathStr, encoding: String.Encoding.utf8) {
                    let rows = csvStringData.components(separatedBy: "\n").filter{!$0.isEmpty}
                    for row in rows {
                        let values = row.components(separatedBy: " ")
                        print("\(values[0])の文字コードは、\(values[1])、キーは\(values[2])です。")
                    }
                    /*
                     //CSVデータを1行ずつ読み込む
                     csvStringData.enumerateLines({ (line, stop) -> () in
                     //カンマ区切りで分割
                     let wordSourceDataArray = line.componentsSeparatedByString(" ")
                     //単語データを格納するオブジェクトを作成
                     let wordData = WordData(wordSourceDataArray: wordSourceDataArray)
                     //単語を追加
                     self.wordDataArray.append(wordData)
                     //単語番号を設定
                     wordData.wordNumber = self.wordDataArray.count
                     })*/
                    // print(csvStringData)
                    hoge = csvStringData
                } else {
                    print("Fail to get contens of keys.csv")
                }
            } catch let error {
                //ファイル読み込みエラー時
                print(error)
            }
            // print(hoge)
        }else{
            print("Fail to get URL of keys.csv")
        }
    }
    
    //------------------------------
    //次の単語を取り出す
    //------------------------------
    func nextWord() -> KeyData? {
        if nowWordIndex < keyDataArray.count {
            let nextWord = keyDataArray[nowWordIndex]
            nowWordIndex += 1
            return nextWord
        }
        return nil
    }
}

