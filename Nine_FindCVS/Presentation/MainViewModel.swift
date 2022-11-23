//
//  MainViewModel.swift
//  Nine_FindCVS
//
//  Created by 이윤수 on 2022/11/22.
//

import Foundation

import RxSwift
import RxCocoa

struct MainViewModel{
    // INPUT
    let currentLocationBtnClick = PublishRelay<Void>()
    let currentLocation = PublishRelay<MTMapPoint>()
    let mapCenterPoint = PublishRelay<MTMapPoint>()
    let selectPOIItem = PublishRelay<MTMapPOIItem>()
    let mapViewError = PublishRelay<String>()
    let detailListCellClick = PublishRelay<Int>()
    
    // OUTPUT
    let setMapCenter : Signal<MTMapPoint>
    let errorMsg : Signal<String>
    let detailListCellData : Driver<[DetailListCellData]>
    let scrollToSeletedLocation : Signal<Int>
    
    // SUBVIEWMODEL
    let detailListBackgroundViewModel = DetailListBackgroundViewModel()
    
    // BAG
    let bag = DisposeBag()
    
    let documentData = PublishRelay<[KLDocument]>()
    
    init(){
        // 지도의 센터 설정
        let selectDetailListItem = self.detailListCellClick
            .withLatestFrom(self.documentData){
                $1[$0]
            }
            .map{ data -> MTMapPoint in
                guard let longtitue = Double(data.x),
                      let latitude = Double(data.y) else{
                    return MTMapPoint()
                }
                return MTMapPoint(geoCoord: MTMapPointGeo(latitude: longtitue, longitude: latitude))
            }
        
        let moveToCurrentLocation = self.currentLocationBtnClick
            .withLatestFrom(self.currentLocation)
        
        self.setMapCenter = Observable
            .merge(
                self.currentLocation.take(1),
                moveToCurrentLocation,
                selectDetailListItem
            )
            .asSignal(onErrorSignalWith: .empty())
        
        self.errorMsg = self.mapViewError
            .asSignal(onErrorJustReturn: "잠시 후 다시 시도")
        
        self.detailListCellData = Driver.just([])
        self.scrollToSeletedLocation = self.selectPOIItem
            .map{
                $0.tag
            }
            .asSignal(onErrorSignalWith: .empty())
    }
}
