//
//  MainVC.swift
//  Nine_FindCVS
//
//  Created by 이윤수 on 2022/11/22.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then
import CoreLocation

class MainVC : UIViewController{
    let bag = DisposeBag()
    
    let locationManager = CLLocationManager()
    let mapView = MTMapView().then{
        $0.currentLocationTrackingMode = .onWithHeadingWithoutMapMoving
    }
    let currentLocationBtn = UIButton().then{
        $0.setImage(UIImage(systemName: "location.fill"), for: .normal)
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 20
    }
    let detailList = UITableView()
    
    let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        self.layout()
        self.attribute()
        self.bind(viewModel: viewModel)
    }
}

extension MainVC{
    private func bind(viewModel : MainViewModel){
        self.currentLocationBtn.rx.tap
            .bind(to: viewModel.currentLocationBtnClick)
            .disposed(by: self.bag)
        
        viewModel.setMapCenter
            .emit(to: self.mapView.rx.setMapCenterPoint)
            .disposed(by: self.bag)
        
        viewModel.errorMsg
            .emit(to: self.rx.alertPresent)
            .disposed(by: self.bag)
    }
    
    private func layout(){
        [self.mapView, self.detailList, self.currentLocationBtn]
            .forEach{
                self.view.addSubview($0)
            }
        self.mapView.snp.makeConstraints{
            $0.top.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(self.view.snp.centerY).offset(150)
        }
        
        self.detailList.snp.makeConstraints{
            $0.top.equalTo(self.mapView.snp.bottom)
            $0.leading.bottom.trailing.equalToSuperview()
        }
        
        self.currentLocationBtn.snp.makeConstraints{
            $0.bottom.equalTo(self.mapView.snp.bottom).offset(15)
            $0.leading.equalToSuperview().offset(15)
            $0.size.equalTo(40)
        }
    }
    
    private func attribute(){
        self.title = "내 주변 편의점 찾기"
        self.view.backgroundColor = .white
        self.mapView.delegate = self
        self.locationManager.delegate = self
    }
}

extension MainVC : MTMapViewDelegate{
    // 현재 위치를 업데이트
    func mapView(_ mapView: MTMapView!, updateCurrentLocation location: MTMapPoint!, withAccuracy accuracy: MTMapLocationAccuracy) {
        #if DEBUG
        self.viewModel.currentLocation.accept(MTMapPoint(geoCoord: MTMapPointGeo(latitude: 37.394225, longitude: 127.110341)))
        #else
        self.viewModel.currentLocation.accept(location)
        #endif
    }
    
    // 맵에 이동이 끝났을 때 포인트 전달
    func mapView(_ mapView: MTMapView!, finishedMapMoveAnimation mapCenterPoint: MTMapPoint!) {
        self.viewModel.mapCenterPoint.accept(mapCenterPoint)
    }
    
    // PIN을 탭할 때 마다 PIN이 있었던 좌표 값을 전달함
    func mapView(_ mapView: MTMapView!, selectedPOIItem poiItem: MTMapPOIItem!) -> Bool {
        self.viewModel.selectPOIItem.accept(poiItem)
        return false
    }
    
    // 현재위치를 불러오지 못했을 때
    func mapView(_ mapView: MTMapView!, failedUpdatingCurrentLocationWithError error: Error!) {
        self.viewModel.mapViewError.accept(error.localizedDescription)
    }
}

extension MainVC : CLLocationManagerDelegate{
    // 권한 체크
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus{
        case .authorizedAlways,
                .authorizedWhenInUse,
                .notDetermined:
            return
        default:
            self.viewModel.mapViewError.accept(MTMapViewErorr.locationAuthorizaationDenied.localizedDescription)
            return
        }
    }
}

extension Reactive where Base : MTMapView{
    var setMapCenterPoint : Binder<MTMapPoint>{
        return Binder(base){base, point in
            base.setMapCenter(point, animated: true)
        }
    }
}

extension Reactive where Base : MainVC{
    var alertPresent : Binder<String>{
        return Binder(base) {base, msg in
            let alert = UIAlertController(title: "에러", message: msg, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            base.present(alert, animated: true)
        }
    }
}
