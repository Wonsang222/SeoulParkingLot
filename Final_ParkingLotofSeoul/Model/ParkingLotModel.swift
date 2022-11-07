//
//  ParkingLotModel.swift
//  Final_ParkingLotofSeoul
//
//  Created by 황원상 on 2022/11/02.
//

import UIKit

// MARK: - Welcome
struct ParkingLotEntitiy: Codable {
    let getParkInfo: GetParkInfo

    enum CodingKeys: String, CodingKey {
        case getParkInfo = "GetParkInfo"
    }
}

// MARK: - GetParkInfo
struct GetParkInfo: Codable {
    let listTotalCount: Int
    let row: [Row]

    enum CodingKeys: String, CodingKey {
        case listTotalCount = "list_total_count"
        case row
    }
}

// MARK: - Row
struct Row: Codable {
    let parkingName, addr, parkingCode, parkingType: String
    let parkingTypeNm, operationRule, operationRuleNm, tel: String
    let capacity: Int
    let payYn, payNm, nightFreeOpen, nightFreeOpenNm: String
    let weekdayBeginTime, weekdayEndTime, weekendBeginTime, weekendEndTime: String
    let holidayBeginTime, holidayEndTime, syncTime, saturdayPayYn: String
    let saturdayPayNm, holidayPayYn, holidayPayNm, fulltimeMonthly: String
    let grpParknm: String
    let rates, timeRate, addRates, addTimeRate: Int
    let busRates, busTimeRate, busAddTimeRate, busAddRates: Int
    let dayMaximum: Int
    let lat, lng: Double

    enum CodingKeys: String, CodingKey {
        case parkingName = "PARKING_NAME"
        case addr = "ADDR"
        case parkingCode = "PARKING_CODE"
        case parkingType = "PARKING_TYPE"
        case parkingTypeNm = "PARKING_TYPE_NM"
        case operationRule = "OPERATION_RULE"
        case operationRuleNm = "OPERATION_RULE_NM"
        case tel = "TEL"
        case capacity = "CAPACITY"
        case payYn = "PAY_YN"
        case payNm = "PAY_NM"
        case nightFreeOpen = "NIGHT_FREE_OPEN"
        case nightFreeOpenNm = "NIGHT_FREE_OPEN_NM"
        case weekdayBeginTime = "WEEKDAY_BEGIN_TIME"
        case weekdayEndTime = "WEEKDAY_END_TIME"
        case weekendBeginTime = "WEEKEND_BEGIN_TIME"
        case weekendEndTime = "WEEKEND_END_TIME"
        case holidayBeginTime = "HOLIDAY_BEGIN_TIME"
        case holidayEndTime = "HOLIDAY_END_TIME"
        case syncTime = "SYNC_TIME"
        case saturdayPayYn = "SATURDAY_PAY_YN"
        case saturdayPayNm = "SATURDAY_PAY_NM"
        case holidayPayYn = "HOLIDAY_PAY_YN"
        case holidayPayNm = "HOLIDAY_PAY_NM"
        case fulltimeMonthly = "FULLTIME_MONTHLY"
        case grpParknm = "GRP_PARKNM"
        case rates = "RATES"
        case timeRate = "TIME_RATE"
        case addRates = "ADD_RATES"
        case addTimeRate = "ADD_TIME_RATE"
        case busRates = "BUS_RATES"
        case busTimeRate = "BUS_TIME_RATE"
        case busAddTimeRate = "BUS_ADD_TIME_RATE"
        case busAddRates = "BUS_ADD_RATES"
        case dayMaximum = "DAY_MAXIMUM"
        case lat = "LAT"
        case lng = "LNG"
    }
}





struct ParkingLotModel{
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
    let name:String
    let description:String
    let tel:String
    let capacity:Int
    let isPaid:String
    let nightFreeOpen:String
    let weekdayBeginTime, weekdayEndTime, weekendBeginTime, weekendEndTime: String
    let holidayBeginTime, holidayEndTime: String
    let isPaidInSatur:String
    let isPaidInHoliday:String
    let rates, timeRate, addRates, addTimeRate: Int
    let dayMaximum: Int
    let lat, lng: Double
    
    mutating func isAvailable()-> String{
        if day == "토요일" || day == "일요일"{
            if time < weekendEndTime && time > weekendBeginTime{
                return "현재 유료"
            }else{
                return "현재 무료"
            }
        }else{
            if time < weekdayEndTime && time > weekdayBeginTime {
                return "현재 유료"
            }else{
                return "현재 무료"
            }
        }
    }
}



