//
//  ModalViewModel.swift
//  Final_ParkingLotofSeoul
//
//  Created by 황원상 on 2022/11/01.
//

import Foundation

class ModalViewViewModel{
    
    let now = Date()
    
    lazy var time:String = {
        let formater = DateFormatter()
        formater.dateFormat = "HHmm"
        let nowDate = formater.string(from: now)
        return nowDate
    }()
    
    lazy var day:String = {
        let formater = DateFormatter()
        formater.dateFormat = "EEEE"
        let nowDate = formater.string(from: now)
        return nowDate
    }()
    
    let model: ParkingLotModel

    var name: String {
        return model.name
    }
    
    var parkingLotType: String {
        return model.description
    }
    
    var phoneNumber: String {
        return model.tel
    }
    
    var capacity: Int {
        return model.capacity
    }
    
    var runtime: [String] {
        if day == "토요일" || day == "일요일"{
            var tempStart = model.weekendBeginTime
            var tempEnd = model.weekendEndTime
            tempStart.insert(":", at: tempStart.index(tempStart.startIndex, offsetBy: 2))
            tempEnd.insert(":", at: tempEnd.index(tempEnd.startIndex, offsetBy: 2))
            return [tempStart, tempEnd]
        } else{
            var tempStart = model.weekdayBeginTime
            var tempEnd = model.weekdayEndTime
            tempStart.insert(":", at: tempStart.index(tempStart.startIndex, offsetBy: 2))
            tempEnd.insert(":", at: tempEnd.index(tempEnd.startIndex, offsetBy: 2))
            return [tempStart, tempEnd]
        }
    }

    var minimumRate: String {
        return "\(model.rates)원/\(model.timeRate)분"
    }
    
    var extraRate:String{
        return "\(model.addRates)원/\(model.addTimeRate)분"
    }
    
    var maximumDailyRate:String{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let result = numberFormatter.string(from: NSNumber(value: model.dayMaximum))
        guard let result = result else {return " "}
        let final = result == "0" ? "최대요금 없음" : "\(result)원"
        return final
    }
    
    var x: Double {
        return model.lat
    }
    
    var y: Double {
        return model.lng
    }
    
    init(model: ParkingLotModel) {
        self.model = model
    }
}

