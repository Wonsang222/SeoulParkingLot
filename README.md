# 공영주차장IN서울

## 프로젝트 설명

1. 차를 가지고 외출을 하면 주차비 걱정이 많았음.
2. 많은 앱들이 있지만, 저렴한 공영주차장을 직관적이고 빠르게 찾아주는 어플이 있으면 좋겠다고 생각했음.

## 프로젝트 진행

1. 주차장에 대한 정보를 제공하는 API 사용 -> 서울시에서 제공하는 API사용 (서울시로 한정) -> query는 '동'을 입력하여 검색
2. 앱의 기능은 크게 두 가지. 현재 위치, 목적지 기준의 '동'에 있는 공영주차장 검색
3. 목적지는 네이버 api, 현재 위치에 대한 '동' 정보는 kakao api를 사용함.
4. NaverMap SDK를 사용
5. 정보 수정에 대한 요청은 Firebase를 통해서 이뤄짐.

## 구현기능

1. 목적지 주변의 공영주차장 마킹 : 목적지 검색은 네이버 api를 사용했습니다. 그 이후 목적지를 유저가 선택을 하면, 해당 장소의 위치와 주변의 공영주차장 정보를 불러옵니다.
2. 현재 위치 주변의 공영주차장 마킹: CoreLocation으로 현재 위치를 마킹하고, 카카오 api를 사용하여 '동'을 알아내고, 주변의 공영주차장 정보를 불러옵니다.
3. 정보 수정:  오기 된 정보가 있다면 수정요청을 하기위해 Firebase를 사용했습니다.
4. 전화걸기 기능 : UIApplication.shared.canOpenURL 을 이용했습니다.

## 배운점 및 고민점

1. MVVM 디자인 패턴을 공부하고 적용했습니다.
2. NaverMap과 같은 SDK를 사용해보며 외연을 확장했습니다.
3. 연속된 비동기 작업들의 동기화를 Dispatch Group과 JGProgressHUD를 통해 해결 해봤습니다.
4. 디자인 모티브가 되었던, 네이버 지도의 ModalView를 UIPangestrue를 통해 구현해 봤습니다.
5. 개발 초기에는 주차장 정보들을 다운받아 FireStore에 저장하고 앱 실행때마다 불러와서 마킹을 해놓으려고 했는데 고민해보니 불필요한 데이터들도 매번 로딩되기 때문에 개발 방향을 바꿨습니다.

## 프로젝트 사진
![2-2](https://user-images.githubusercontent.com/92086662/201286643-927d06bd-85ab-44b1-9250-e6fd701c74c9.gif)  
현재 위치를 불러오는 작업은, 서울 지역내에서만 작동합니다.  

![2-111](https://user-images.githubusercontent.com/92086662/201286955-5950b2e9-c736-4ba5-b4ae-58132a35c0ae.gif)  
해당 작업은 두개의 비동기 작업인 위,경도(Kakao API) -> 주차장 검색(서울 API)을 거쳐 실행됩니다.  
그러므로 DispatchGroup을 사용하여 두 개의 비동기 작업을 하나의 동기 작업으로 묶어주었습니다.  

<details markdown="1">
<summary>코드보기</summary>

```swift
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

```

</details>


