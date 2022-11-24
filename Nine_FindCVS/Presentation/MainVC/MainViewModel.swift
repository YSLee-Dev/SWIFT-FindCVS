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
    
    private let documentData = PublishRelay<[KLDocument]>()
    
    init(model : MainModel = .init()){
        // 네트워크 통신 후 데이터 return
        let cvsLocationDataResult = mapCenterPoint
            .flatMapLatest(model.getLocation)
            .share()
        
        let cvsLocationDataValue = cvsLocationDataResult
            .compactMap{data -> LocationData? in
                guard case let .success(value) = data else {return nil}
                return value
            }
        
        let cvsLocationDataErrorMsg =  cvsLocationDataResult
            .compactMap{data -> String? in
                switch data{
                case let .success(value) where value.documents.isEmpty:
                    return "500M 근처에는 편의점이 없습니다."
                case let .failure(error) :
                    return error.localizedDescription
                default:
                    return nil
                }
            }
        
        cvsLocationDataValue
            .map{
                $0.documents
            }
            .bind(to: self.documentData)
            .disposed(by: self.bag)
        
        // 지도의 센터 설정
        let selectDetailListItem = self.detailListCellClick
            .withLatestFrom(self.documentData){
                $1[$0]
            }
            .map{ data -> MTMapPoint in
                guard let longtitue = Double(data.y),
                      let latitude = Double(data.x) else{
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
        
        self.errorMsg = Observable
            .merge(self.mapViewError.asObservable(),
                   cvsLocationDataErrorMsg
            )
            .asSignal(onErrorJustReturn: "잠시 후 다시 시도")
        
        self.detailListCellData = self.documentData
            .map{
                model.documentToCellData(data: $0)
            }
            .asDriver(onErrorDriveWith: .empty())
        
        documentData
            .map{
                !$0.isEmpty
            }
            .bind(to: self.detailListBackgroundViewModel.shouldHideLabel)
            .disposed(by: self.bag)
        
        self.scrollToSeletedLocation = self.selectPOIItem
            .map{
                $0.tag
            }
            .asSignal(onErrorSignalWith: .empty())
    }
}
