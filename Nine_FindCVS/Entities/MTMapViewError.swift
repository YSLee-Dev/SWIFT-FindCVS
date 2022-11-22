//
//  MTMapViewError.swift
//  Nine_FindCVS
//
//  Created by 이윤수 on 2022/11/22.
//

import Foundation

enum MTMapViewErorr : Error{
    case failedUpdatingCurrentLocation
    case locationAuthorizaationDenied
    
    var errorDescription : String{
        switch self {
        case .failedUpdatingCurrentLocation:
            return "현재 위치를 불러오지 못했습니다."
        case .locationAuthorizaationDenied:
            return "위치 정보를 가져올 권한을 부여받지 못했습니다."
        }
    }
}
