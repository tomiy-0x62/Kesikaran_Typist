//
//  TypedKanaSentenceManager.swift
//  Kesikaran_Typist
//
//  Created by Tomishige Ryosuke on 2021/01/20.
//

import Foundation

class TypedKanaSentenceManager {
    
    //シングルトンオブジェクトを作成
    static let sharedInstance = TypedKanaSentenceManager()
    
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
