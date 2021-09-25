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
    let keyCodes: [Int]        // [20], [56,25]
    let keyChar: String    // "3" , "shift_9"
    
    //構造体の初期化処理
    init(kana: String, keyCodes: [Int], keyChar: String) {
        self.kana = kana
        self.keyCodes = keyCodes
        self.keyChar = keyChar
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
        loadKeyData()
    }
    
    //------------------------------
    //単語の読み込み処理
    //------------------------------
    
    private func removeShift(keyCode: [Int]) -> [Int] {
        // ex) [60, 29] -> [29]
        // ex) [56, 29] -> [29]
        var newKeyCode = keyCode
        if let shiftIndex = keyCode.firstIndex(where: { $0 == 56 || $0 == 60}) {
            newKeyCode.remove(at: Int(shiftIndex))
            return newKeyCode
        } else {
            return keyCode
        }
    }
    
    private func trShift(keyCode: [Int]) -> [Int] {
        // ex) [60, 29] -> [116, 29]
        // ex) [56, 29] -> [116, 29]
        var newKeyCode = keyCode
        if let shiftIndex = keyCode.firstIndex(where: { $0 == 56 || $0 == 60}) {
            newKeyCode[Int(shiftIndex)] = 116
            return newKeyCode
        } else {
            return keyCode
        }
    }
    
    private func cmpKeyCodes(_ a: [Int], _ b:[Int]) -> Bool {
        if (a.count == b.count){
            if (a.count == 1) {
                if (a == b) {
                    return true
                }
            }
            if (a.count == 2) {
                if (trShift(keyCode: a) == trShift(keyCode: b)){
                    return true
                }
            }
        }
        return false
    }
    
    func searchKeyChar(keyCodes: [Int]) -> String {
        // ex) [56, 29] -> "shift_0"
        // ex) [60, 29] -> "shift_0"
        // ex) [0] -> "A"
        for keydata in keyDataArray {
            if cmpKeyCodes(keydata.keyCodes, keyCodes) {
                return keydata.keyChar
            }
        }
        let newKeyCode = removeShift(keyCode: keyCodes)
        for keydata in keyDataArray {
            if cmpKeyCodes(keydata.keyCodes, newKeyCode) {
                return keydata.keyChar
            }
        }
        return "Not found"
    }
    
    func searchKeyKana(keyCodes: [Int]) -> String {
        // ex) [56, 29] -> "を"
        // ex) [60, 29] -> "を"
        // ex) [0] -> "ち"
        for keydata in keyDataArray {
            if cmpKeyCodes(keydata.keyCodes, keyCodes) {
                return keydata.kana
            }
        }
        let newKeyCode = removeShift(keyCode: keyCodes)
        for keydata in keyDataArray {
            if cmpKeyCodes(keydata.keyCodes, newKeyCode) {
                return keydata.kana
            }
        }
        return "Not found"
    }
    
    func searchKeyCodes(keyKana: String) -> [Int] {
        // ex) "お" -> [22]
        for keydata in keyDataArray {
            if keydata.kana == keyKana {
                return keydata.keyCodes
            }
        }
        return [1]
    }
    
    private func formatNums(_ codes: String) -> [Int] {
        // ex) "60,33" -> [60, 33]
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
    
    private func loadKeyData() {
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
                    let keyData = KeyData(kana: removeQuarto(values[0]), keyCodes: formatNums(values[1]), keyChar: removeQuarto(values[2]))
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

