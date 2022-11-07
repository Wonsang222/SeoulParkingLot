//
//  MainViewModel.swift
//  Final_ParkingLotofSeoul
//
//  Created by 황원상 on 2022/11/01.
//

import Foundation

protocol MainViewModelDelegate{
    func clearMapView()
    func showHud()
    func clearHud()
    func markLocation(x:Double, y:Double)
    func markParkingLots()
    func resetAlarm()
    
    
}

class MainViewModel{
    
    var delegate:MainViewModelDelegate?
    
    var avenue:String?
    
    var parkingLots:[ParkingLotModel] = []
    
    func fetchParkingLots(x:Double, y:Double){

        delegate?.clearMapView()

        let group1 = DispatchGroup()
        
        delegate?.showHud()
        
        group1.enter()
        NetworkService.fetchAvenue(x: x, y: y) { result in
            
            switch result{
            case .success(let res):
                for i in res{
                    self.avenue = i.avenue
                }
                group1.leave()
            case .failure(let err):
                print(err)
                self.delegate?.clearHud()
                return
            }
        }
        
        group1.notify(queue: .main){
            if self.avenue == ""{
                self.delegate?.clearHud()
                self.delegate?.resetAlarm()
                return
            }
            guard let location = self.avenue else {
                self.delegate?.clearHud()
                self.delegate?.resetAlarm()
                return }
            
            self.delegate?.markLocation(x: y, y: x)
            
            self.delegate?.clearHud()
            self.fetchParkingLots2(location: location)
        }
    }
    
    func fetchParkingLots2(location:String){
        
        if location == " " || location == ""{
            delegate?.resetAlarm()
            return
        }
        
        delegate?.showHud()
        
        let group2 = DispatchGroup()
        
        group2.enter()
        
        NetworkService.fetchParkingLots(location: location) { result in
            switch result{
            case .success(let res):
                self.parkingLots = res
                group2.leave()
            case .failure(let err):
                print(err)
                self.delegate?.clearHud()
                return
            }
        }
        group2.notify(queue: .main){
            self.delegate?.markParkingLots()
            self.delegate?.clearHud()
        }
    }
}

