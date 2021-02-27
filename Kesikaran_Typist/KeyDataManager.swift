//
//  lordCSV.swift
//  Kesikaran_Typist
//
//  Created by Tomishige Ryosuke on 2020/12/24.
//

import Foundation


// https://qiita.com/takehiro224/items/77122fe66105c4b5f986

//==================================================
//1つのキーに関する情報を管理する構造体
//==================================================
struct KeyData {
    
    let kana: String          // "あ", "ょ"
    let keyCodes: [Int]        // [20], [421,25]
    let keyChar: String    // "3" , "shift_9"
    let keyNum: Int        // "21", "100" keyViewListの何番目か？
    // shiftは右左でキーコードが違うので421に統一
    
    //クラスが生成された時の処理
    init(kana: String, keyCodes: [Int], keyChar: String, keyNum: Int) {
        self.kana = kana
        self.keyCodes = keyCodes
        self.keyChar = keyChar
        self.keyNum = keyNum
    }
}

//==================================================
//全てのキーに関する情報を管理するモデルクラス
//==================================================
class KeysDataManager {
    
    //シングルトンオブジェクトを作成
    static let sharedInstance = KeysDataManager()
    
    //キーデータを格納するための配列
    var keyDataArray = [KeyData]()
    
    
    //初期化処理
    private init(){
        //シングルトンであることを保証するためにprivateで宣言
    }
    
    //------------------------------
    //単語の読み込み処理
    //------------------------------
    
    func searchKeyKana(keyCode: [Int]) -> String {
        // ex) [421, 29] -> "を"
        for keydata in keyDataArray {
            if keydata.keyCodes == keyCode {
                return keydata.keyChar
            }
        }
        return "Not found"
    }
    
    func searchKeyChar(keyCode: [Int]) -> String {
        // ex) [421, 29] -> "shift_0"
        for keydata in keyDataArray {
            if keydata.keyCodes == keyCode {
                return keydata.kana
            }
        }
        return "Not found"
    }
    
    func searchKeyNums(keyCodes: [Int]) -> [Int] {
        var nums: Array<Int> = []
        for keyCode in keyCodes {
            for keydata in keyDataArray {
                if keydata.keyCodes == [keyCode] {
                    nums.append(keydata.keyNum)
                }
            }
        }
        return nums
    }
    
    private func formatNums(_ codes: String) -> [Int] {
        // ex) "421,33" -> [421, 33]
        let rows = codes.components(separatedBy: ",").filter{!$0.isEmpty}
        var result: [Int] = []
        for row in rows {
            result.append(Int(row)!)
        }
        return result
    }
    
    private func removeQuarto(_ char: String) -> String {
        // CSV上で文字列は可読性を上げるために"で囲ってる
        // それを外すためのメソッド
        // ex) "return" -> return
        return String(char.dropFirst(1).dropLast(1).replacingOccurrences(of: "_", with: " "))
        }
    
    func loadKeyData() {
        //格納済みのデータがあれば一旦削除
        keyDataArray.removeAll()
        
        //CSVファイルパスを取得
        if let csvFilePath = Bundle.main.url(forResource: "keys", withExtension: "csv") {
            let csvFilePathStr: String = csvFilePath.path
            // print(csvFilePathStr)
            
            //CSVデータ読み込み
            if let csvStringData: String = try? String(contentsOfFile: csvFilePathStr, encoding: String.Encoding.utf8) {
                // 読み込んだデータを行ごとに分解
                let rows = csvStringData.components(separatedBy: "\n").filter{!$0.isEmpty}
                for row in rows {
                    // スペースで分割
                    let values = row.components(separatedBy: " ")
                    let keyData = KeyData(kana: removeQuarto(values[0]), keyCodes: formatNums(values[1]), keyChar: removeQuarto(values[2]), keyNum: Int(values[3])!)
                    // print("\(keyData.char)の文字コードは、\(keyData.keyCodes)、キーは\(keyData.keycapChar)です。")
                    self.keyDataArray.append(keyData)
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

