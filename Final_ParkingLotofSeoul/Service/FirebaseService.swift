//
//  FirebaseService.swift
//  Final_ParkingLotofSeoul
//
//  Created by 황원상 on 2022/11/01.
//

import Foundation
import FirebaseFirestore

struct FirebaseService{
    static func reportModification(type:String, name:String, text:String, completion:@escaping(Error?)->Void){
        let db = Firestore.firestore().collection(type)
        db.document().setData(["주차장이름": name,"수정내용" : text]) { error in
            completion(error)
        }
    }
}
