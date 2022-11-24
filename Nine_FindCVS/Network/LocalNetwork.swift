//
//  LocalNetwork.swift
//  Nine_FindCVS
//
//  Created by 이윤수 on 2022/11/24.
//

import Foundation

import RxSwift
import RxCocoa

class LocalNetwork{
    private let session : URLSession
    let api = LocalAPI()
    
    init(session : URLSession = .shared){
        self.session = session
    }
    
    func getLocation(mapPoint : MTMapPoint) -> Single<Result<LocationData, URLError>>{
        guard let url = api.getLoaction(mapPoint: mapPoint).url else {return .just(.failure(URLError(.badURL)))}
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK ef898db9fd24ab232b5a112a8110c63b", forHTTPHeaderField: "Authorization")
        
        return self.session.rx.data(request: request)
            .map{
                do{
                    let json = try JSONDecoder().decode(LocationData.self, from: $0)
                    return .success(json)
                }catch{
                    return .failure(URLError(.cannotParseResponse))
                }
            }
            .catch{ _ in
                    .just(.failure(URLError(.cannotLoadFromNetwork)))
            }
            .asSingle()
    }
}
