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
    
    // OUTPUT
    let setMapCenter : Signal<MTMapPoint>
    let errorMsg : Signal<String>
    
    // BAG
    let bag = DisposeBag()
    
    init(){
        // 지도의 센터 설정
        let moveToCurrentLocation = self.currentLocationBtnClick
            .withLatestFrom(self.currentLocation)
        
        self.setMapCenter = Observable
            .merge(
                self.currentLocation.take(1),
                moveToCurrentLocation
            )
            .asSignal(onErrorSignalWith: .empty())
        
        self.errorMsg = self.mapViewError
            .asSignal(onErrorJustReturn: "잠시 후 다시 시도")
    }
}
