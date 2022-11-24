//
//  MainModel.swift
//  Nine_FindCVS
//
//  Created by 이윤수 on 2022/11/24.
//

import Foundation

import RxSwift

struct MainModel {
    var localNetwork : LocalNetwork
    
    init(localNetwork : LocalNetwork = .init()){
        self.localNetwork = localNetwork
    }
    
    func getLocation(mapPoint : MTMapPoint) -> Single<Result<LocationData, URLError>>{
        return localNetwork.getLocation(mapPoint: mapPoint)
    }
    
    func documentToCellData(data : [KLDocument]) -> [DetailListCellData]{
        return data.map{
            let address = $0.roadAddressName.isEmpty ? $0.addressName : $0.roadAddressName
            let point = documentToMTMapPoint(document: $0)
            return DetailListCellData(placeName: $0.placeName, address: address, distance: $0.distance, point: point)
        }
    }
    
    func documentToMTMapPoint(document : KLDocument) -> MTMapPoint{
        let longitude = Double(document.x) ?? .zero
        let latitude = Double(document.y) ?? .zero
        
        return MTMapPoint(geoCoord: MTMapPointGeo(latitude: latitude, longitude: longitude))
    }
}
