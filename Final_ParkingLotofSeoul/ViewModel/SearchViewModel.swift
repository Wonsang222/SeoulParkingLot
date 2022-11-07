//
//  SearchViewModel.swift
//  Final_ParkingLotofSeoul
//
//  Created by 황원상 on 2022/11/01.
//

import Foundation
import NMapsMap

final class SearchViewModel {
    
    var models : [SearchModel] = []
    
    var beginning: (() -> Void)?
    
    var finishing: (() -> Void)?
    
    var count: Int {
        return models.count
    }
    
    func name(index: Int) -> String {
        return models[index].name.components(separatedBy: ["b","/","<",">"]).joined()
    }
    
    func address(index: Int) -> String {
        return models[index].address
    }
    
    func oldAdress(index:Int) -> String {
        let avenue = models[index].realAdress.components(separatedBy: " ")
        var result = ""
        if avenue[0] == "서울특별시"{
            for i in avenue[2]{
                if i == "동"{
                    if let number = Int(String(i)){
                        continue
                    }
                    if i != "동"{
                        result.append(i)
                    }else{
                        break
                    }
                }else{
                    return "\(avenue[1])"
                }
            }
            return "\(result)동"
        }else{
            return " "
        }
    }

    func lating(index: Int) -> NMGLatLng {
        guard let xInt = Int(models[index].x) else {return NMGLatLng()}
        guard let yInt = Int(models[index].y) else {return NMGLatLng()}
        let xDouble = Double(xInt)
        let yDouble = Double(yInt)
        let tm = NMGTm128(x: xDouble, y: yDouble)
        let lating = tm.toLatLng()
        return lating
    }
    
    func fetch(searchText: String) {
        guard let beginning = beginning else {return}
        guard let finishing = finishing else {return}
        beginning()
        NetworkService.search(value: searchText) { [weak self] result in
            switch result{
            case.success(let res):
                self?.models = []
                self?.models = res
                finishing()
            case.failure(let err):
                print(err.localizedDescription)
                finishing()
            }
        }
    }
}


