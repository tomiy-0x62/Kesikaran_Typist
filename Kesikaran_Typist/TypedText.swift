//
//  TypedText.swift
//  Kesikaran_Typist
//
//  Created by Tomishige Ryosuke on 2021/01/20.
//

import Foundation

class TextManager {
    
    //シングルトンオブジェクトを作成
    static let sharedInstance = TextManager()
    
    //キーデータを格納するための配列
    var keyData = ""
    var StrData = ""
    
    //初期化処理
    private init(){
        //シングルトンであることを保証するためにprivateで宣言
    }
    
    func update(key: String, char: String){
        if key == "return" {
            self.StrData = ""
            self.keyData = ""
        } else if key == "delete" {
            self.StrData = String(self.StrData.dropLast(1))
            self.keyData = String(self.keyData.dropLast(1))
        }  else if key == "space" {
            self.StrData += " "
            self.keyData += " "
        } else {
            self.StrData += char
            self.keyData += key
        }
    }
    
}
