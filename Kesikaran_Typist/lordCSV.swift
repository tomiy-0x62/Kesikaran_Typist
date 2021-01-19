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
struct KeyData {
    
    let char: String          // "あ", "ょ"
    let keyCodes: [Int]        // [20], [421,25]
    let keycapChar: String    // "3" , "shift_9"
    // shiftは右左で違うので421に統一
    
    //クラスが生成された時の処理
    init(char: String, keyCodes: [Int], keycapChar: String) {
        self.char = char
        self.keyCodes = keyCodes
        self.keycapChar = keycapChar
    }
}

//==================================================
//全ての単語に関する情報を管理するモデルクラス
//==================================================
class KeysDataManager {
    
    //シングルトンオブジェクトを作成
    static let sharedInstance = KeysDataManager()
    
    //単語を格納するための配列
    var keyDataArray = [KeyData]()
    
    //現在の単語のインデックス
    var nowWordIndex: Int = 0

    //初期化処理
    private init(){
        //シングルトンであることを保証するためにprivateで宣言
    }
    
    //------------------------------
    //単語の読み込み処理
    //------------------------------
    
    func formatKeycode(_ codes: String) -> [Int] {
        let rows = codes.components(separatedBy: ",").filter{!$0.isEmpty}
        var result: [Int] = []
        for row in rows {
            result.append(Int(row)!)
        }
        return result
    }
    
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
                        let keyData = KeyData(char: values[0], keyCodes: formatKeycode(values[1]), keycapChar: values[2])
                        print("\(keyData.char)の文字コードは、\(keyData.keyCodes)、キーは\(keyData.keycapChar)です。")
                        self.keyDataArray.append(keyData)
                    }
                } else {
                    print("Fail to get contens of keys.csv")
                }
            } catch let error {
                //ファイル読み込みエラー時
                print(error)
            }
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

