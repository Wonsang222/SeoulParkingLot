//
//  NetworkService.swift
//  Final_ParkingLotofSeoul
//
//  Created by 황원상 on 2022/11/01.
//

import Foundation

struct NetworkService{

    static func search(value:String, completion:@escaping(Result<[SearchModel], Error>)->Void){
        DispatchQueue.global(qos: .default).async {
           
            let clientID = "C037bokFFGW0Gq9lN1hC"
            let secretID = "ywy8uUyasm"
            
            let query = "https://openapi.naver.com/v1/search/local.json?query=\(value)&display=10&start=1&sort=random"
            
            guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {return}
            
            guard let url = URL(string: encodedQuery) else {return}
            
            var requestURL = URLRequest(url: url)
            
            requestURL.addValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
            requestURL.addValue(secretID, forHTTPHeaderField: "X-Naver-Client-Secret")
            
            URLSession.shared.dataTask(with: requestURL) { data, respones, error in
                if error != nil {
                    completion(.failure(error!))
                    return
                }
                
                guard let data = data else {return}
             
                do {
                    let decodeData = try JSONDecoder().decode(SearchModelList.self, from: data)

                    let searhModels = decodeData.items.map {
                        SearchModel(name: $0.title, address: $0.roadAddress, x: $0.mapx, y: $0.mapy, realAdress: $0.address)
                    }
                    completion(.success(searhModels))
                } catch {
                }
            }.resume()
        }
    }
    
    
    // 동을 기준으로 api 호출
    static func fetchParkingLots(location:String, completion: @escaping (Result<[ParkingLotModel], Error>)->Void){
        let query = "http://openapi.seoul.go.kr:8088/4d4b52596d77696e3234686a546c6e/json/GetParkInfo/1/999/\(location)"
     
        guard let safeQuery = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {return}
        
        guard let url = URL(string: safeQuery) else {return print("url issue")}
        
        let requestURL = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: requestURL) { data, respones, error in
            if error != nil {
                print(error!.localizedDescription)
                completion(.failure(error!))
                return
            }
            guard let data = data else {return print("something wrong")}
            
            do {
                let decodedData = try JSONDecoder().decode(ParkingLotEntitiy.self, from: data)
                let models = decodedData.getParkInfo.row.map{
                    ParkingLotModel(name: $0.parkingName, description: $0.operationRuleNm, tel: $0.tel, capacity: $0.capacity, isPaid: $0.payYn, nightFreeOpen: $0.nightFreeOpen, weekdayBeginTime: $0.weekdayBeginTime, weekdayEndTime: $0.weekdayEndTime, weekendBeginTime: $0.weekendBeginTime, weekendEndTime: $0.weekendEndTime, holidayBeginTime: $0.holidayBeginTime, holidayEndTime: $0.holidayEndTime, isPaidInSatur: $0.saturdayPayYn, isPaidInHoliday: $0.holidayPayYn, rates: $0.rates, timeRate: $0.timeRate, addRates: $0.addRates, addTimeRate: $0.addTimeRate, dayMaximum: $0.dayMaximum, lat: $0.lat, lng: $0.lng)
                }
                completion(.success(models))
            }
         catch {
             print(error.localizedDescription)
        }
    }
        .resume()
    }
    static func fetchAvenue(x:Double, y:Double, completion:@escaping (Result<[AvenueModel],Error>)->Void){
        let key = "KakaoAK 9bf0bf65fe3166940096c6c63adc795f"
        let query = "https://dapi.kakao.com/v2/local/geo/coord2address.json?x=\(x)&y=\(y)&input_coord=WGS84"
        
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) else {return}
        guard let url = URL(string: encodedQuery) else {return}
        
        var requestURL = URLRequest(url: url)
        
        requestURL.addValue(key, forHTTPHeaderField: "Authorization")
        
        URLSession.shared.dataTask(with: requestURL) { data, response, error in
            if error != nil{
                print(error!.localizedDescription)
                completion(.failure(error!))
                return
            }
            guard let data = data else {return}
            
            do{
                let decodedData = try JSONDecoder().decode(AvenueEntity.self, from: data)
                var model:[AvenueModel] = []
                for i in decodedData.documents{
                    if i.address.region1DepthName == "서울"{
                        model.append(AvenueModel(avenue: i.address.region3DepthName))
                    }
                }
                completion(.success(model))
            }catch{
                
            }
        }.resume()
    }
}

