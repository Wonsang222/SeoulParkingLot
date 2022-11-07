//
//  MainController.swift
//  Final_ParkingLotofSeoul
//
//  Created by 황원상 on 2022/11/01.
//

import UIKit
import CoreLocation
import NMapsMap
import JGProgressHUD

class MainController:UIViewController {
    
    //MARK: - Properties
    let viewmodel = MainViewModel()
    
    var lon:CLLocationDegrees?
    var lat:CLLocationDegrees?

    let hud:JGProgressHUD = {
        let hud = JGProgressHUD()
        hud.addtext("데이터를 불러오고 있습니다.")
        return hud
    }()
    
    lazy var mapView = NMFMapView(frame: view.frame)
    let marker:NMFMarker = {
        let marker = NMFMarker()
        marker.iconImage = NMF_MARKER_IMAGE_BLACK
        marker.iconTintColor = .systemBlue
        return marker
    }()
    
    let locationManager = CLLocationManager()
    
    private let searchButton:UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        button.backgroundColor = .white
        button.setTitle("목적지 검색하기", for: .normal)
        button.setTitleColor(.lightGray, for: .normal)
        button.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let locationButton: UIButton = {
        let button = UIButton().imageButton(image: "location.fill", color: .systemBlue)
        button.addTarget(self, action: #selector(navigationButtonTapped), for: .touchUpInside)
        return button
    }()
    
    
    //MARK: - ModalView
    
    private let modalView = ModalView()

    //모달의 디폴트 높이
    private var defaultHeight: CGFloat = UIScreen.main.bounds.height / 2.5
    
    //모달이 꺼지는 높이
    private let dismissibleHeight: CGFloat = UIScreen.main.bounds.height / 2.8
    
    //모달이 올라가는 최대 위치
    private let maximumContainerHeight: CGFloat = UIScreen.main.bounds.height * 0.7
    
    //모달이 움직일때 순간 높이 디폴트 높이랑 같게 해야함
    private var currentContainerHeight: CGFloat = UIScreen.main.bounds.height / 2.5
    
    //동적 높이
    private var containerViewHeightConstraint: NSLayoutConstraint?
    private var containerViewBottomConstraint: NSLayoutConstraint?
    
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureLocationService()
        configureMap()
        configureModalView()
        setupPanGesture()
        
        locationManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    //MARK: - Helpers
    
    func configureUI(){
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        viewmodel.delegate = self
        
        view.addSubview(mapView)
        
        view.addSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 10)
        ])
        
        view.addSubview(locationButton)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            locationButton.topAnchor.constraint(equalTo: searchButton.bottomAnchor, constant: 30),
            locationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            locationButton.heightAnchor.constraint(equalToConstant: 50),
            locationButton.widthAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func resetAlarmPopup(_ value:String, _ value2:String){
        let alert = UIAlertController(title: value, message: value2, preferredStyle: .alert)
        let success = UIAlertAction(title: "확인", style: .default)
        alert.addAction(success)
        self.present(alert, animated: true, completion: nil)
    }
    
    func configureLocationService(){
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
    }
    
    func configureMap(){
        mapView.isScrollGestureEnabled = true
        mapView.isZoomGestureEnabled = true
    }
    
    //MARK: - Actions
    
    @objc private func searchButtonTapped(){
        let controller = SearchController()
        controller.delegate = self
        navigationController?.pushViewController(controller, animated: true)
    }
    
    private func cameraZoom() {
        let camZoom = NMFCameraUpdate(zoomTo: 12)
        mapView.moveCamera(camZoom)
    }
    
    private func selectCameraZoom() {
        let camZoom = NMFCameraUpdate(zoomTo: 13)
        mapView.moveCamera(camZoom)

    }
    
    @objc private func navigationButtonTapped(){
        guard let lat = lat else {return resetAlarmPopup("기다려주세요", "위치정보를 불러오고있습니다. 다시 시도해주세요")}
        guard let lon = lon else {return resetAlarmPopup("기다려주세요", "위치정보를 불러오고있습니다. 다시 시도해주세요")}
    
        viewmodel.fetchParkingLots(x: lon, y: lat)
    }
    //MARK: - Modalview Actions

    private func configureModalView() {
        modalView.delegate = self
        modalView.frame = view.frame
        
        currentContainerHeight = view.frame.height / 2
        view.addSubview(modalView)
        modalView.anchor(leading: view.leadingAnchor, trailing: view.trailingAnchor)
        containerViewHeightConstraint = modalView.heightAnchor.constraint(equalToConstant: defaultHeight)
        containerViewBottomConstraint = modalView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: defaultHeight)
        containerViewHeightConstraint?.isActive = true
        containerViewBottomConstraint?.isActive = true
        
        currentContainerHeight = defaultHeight
    }
    
    private func setupPanGesture() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gesture:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        modalView.addGestureRecognizer(panGesture)
    }

    
    private func animateContainerHeight(_ height: CGFloat) {
        UIView.animate(withDuration: 0.4) {
            //현재 컨테이너 높이를 업데이트합니다
            self.containerViewHeightConstraint?.constant = height
            //레이아웃 새로고침
            self.view.layoutIfNeeded()
        }
        //현재높이를 저장
        currentContainerHeight = height
    }
    
    private func animatePresentContainer() {
        UIView.animate(withDuration: 0.4) {
            self.containerViewBottomConstraint?.constant = 0
            self.view.layoutIfNeeded()
            self.containerViewHeightConstraint?.constant = self.defaultHeight
        }
    }
    
    //제스처를 맨위로 드래그하면 마이너스값이되고 그반대로하면 플러스값이됨
    @objc private func handlePan (gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        
        
        //드래그 방향을 가져옵니다
        let isDraggingDown = translation.y > 0
        
        //새로운 높이는 현재 높이 - 제스처한만큼의 높이
        let newHeight = currentContainerHeight - translation.y
        
        //제스처 상태에 따라 처리합니다.
        switch gesture.state {
        case .changed:
            //드래그할때 발생합니다
            if newHeight < maximumContainerHeight {
                //높이 제약조건을 업데이트
                containerViewHeightConstraint?.constant = newHeight
                
                if isDraggingDown {
                    //뷰가 아래로로 내려가는 순간 새로운레이아웃을 만듭니다.
                    self.modalView.showDown()
                }
            }
        case .ended:
            //드래그를 멈추면 발생합니다
            
            //새로운 높이가 최소값 미만이면 뷰를 닫습니다.
            if newHeight < dismissibleHeight {
                self.animateDismissView()
            }
            //새로운 높이가 기본값보다 낮으면 최소값 이상이면 기본값으로 돌립니다
            else if newHeight < defaultHeight {
                animateContainerHeight(defaultHeight)
                
            }
            //새로운 높이가 기본값보다 높고 최대값보다 낮은상태로 "내려간다면" 기본값으로 내립니다.
            else if newHeight < maximumContainerHeight && isDraggingDown {
                animateContainerHeight(defaultHeight)
                self.modalView.showDown()
            }
            //새로운 높이가 기본값보다 높고 최대값보다 낮은상태로 "올라간다면" 뷰를 최대치로 올립니다.
            else if newHeight > defaultHeight && !isDraggingDown {
                animateContainerHeight(maximumContainerHeight)
                //뷰가 최대치로 올라간다면 일정 시간을 두고 새로운 레이아웃을 만듭니다.
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) { [weak self] in
                    self?.modalView.showUp()
                }
            }
        default:
            break
        }
    }

    //뷰를 닫습니다
    private func animateDismissView() {
        UIView.animate(withDuration: 0.4) {
            self.containerViewBottomConstraint?.constant = self.defaultHeight
            self.view.layoutIfNeeded()
            self.modalView.viewModel = nil
        }
    }
}


//MARK: - CLLocationManagerDelegate
extension MainController:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location  = locations.last else {return}
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        
    }
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            func locationManager(_: CLLocationManager, didFailWithError error: Error) {
                let err = CLError.Code(rawValue: (error as NSError).code)!
                switch err {
                case .locationUnknown:
                    resetAlarmPopup("위치정보 오류", "위치 정보를 가지고 올 수 없습니다. 핸드폰의 GPS 기능을 확인해주세요")
                default:
                    resetAlarmPopup("위치정보 오류", "위치 정보를 가지고 올 수 없습니다. 핸드폰의 GPS 기능을 확인해주세요.")
                }
            }
            
        }
}

//MARK: - SearchControllerDelegate
extension MainController:SearchControllerDelegate{
    func markOnTheMap(location: NMGLatLng, avenue: String) {
        marker.mapView = nil
        marker.position = location
        marker.mapView = mapView
        let camUpdate = NMFCameraUpdate(scrollTo: location)
        mapView.moveCamera(camUpdate)
        cameraZoom()
        viewmodel.fetchParkingLots2(location: avenue)
        
      
    }
}

//MARK: - ModalViewDelegate
extension MainController:ModalViewDelegate{

    func popAlarm() {
        resetAlarmPopup("전화번호", "해당 주차장은 전화번호가 제공되지 않습니다.")
    }
    
    func accessToReport(location: String) {
        let controller = ModifyController()
        controller.location = location
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func scrollDown() {
        animateContainerHeight(defaultHeight)
        modalView.showDown()
    }
}

//MARK: - MainViewModelDelegate
extension MainController:MainViewModelDelegate{
    func clearMapView() {
        marker.mapView = nil
    }
    
    func showHud() {
        hud.show(in: view)
    }
    
    func clearHud() {
        hud.dismiss(animated: true)
    }
    
    func markLocation(x: Double, y: Double) {
        self.marker.position = NMGLatLng(lat: y, lng: x)
        self.marker.mapView = self.mapView
        self.mapView.positionMode = .direction
        cameraZoom()
    }
    
    func markParkingLots() {
        for var i in viewmodel.parkingLots{
            let parkingMarker = NMFMarker()
            parkingMarker.iconImage = NMF_MARKER_IMAGE_BLACK
            parkingMarker.position = NMGLatLng(lat: i.lat, lng: i.lng)
            parkingMarker.iconTintColor = UIColor.systemGreen
            parkingMarker.isHideCollidedMarkers = true
            parkingMarker.captionTextSize = 16
            parkingMarker.captionAligns = [NMFAlignType.top]
            parkingMarker.captionText = i.isAvailable()
            parkingMarker.touchHandler = {(overlay: NMFOverlay) -> Bool in
                self.modalView.viewModel = ModalViewViewModel(model: i)
                self.animatePresentContainer()
                return true
            }
            parkingMarker.mapView = self.mapView
        }
    }
    
    func resetAlarm() {
        self.resetAlarmPopup("위치정보 오류", "서울의 공영주차장 정보만을 제공합니다.")
        return }
    }
