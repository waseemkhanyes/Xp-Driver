//
//  AlamofireAppDotNetApiClient.swift
//  XPDriver
//
//  Created by Waseem  on 11/01/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

//import Alamofire
////import JDStatusBarNotification
//import GoogleMaps
//
//enum AlamofireNetworkReachabilityStatus: Int {
//    case Unknown = -1, NotReachable, ReachableViaWWan, ReachableWifi
////    AFNetworkReachabilityStatusUnknown          = -1,
////    AFNetworkReachabilityStatusNotReachable     = 0,
////    AFNetworkReachabilityStatusReachableViaWWAN = 1,
////    AFNetworkReachabilityStatusReachableViaWiFi = 2,
//}
//
//
//let INTERNET_CONNECTION_OFFLINE = "The Internet connection appears to be offline."
//
//class AFAppDotNetAPIClient {
//    
//    static let sharedClient: AFAppDotNetAPIClient = {
//        let instance = AFAppDotNetAPIClient()
//        instance.sessionManager = Alamofire.Session.default
//        instance.sessionManager.securityPolicy = .none
//        return instance
//    }()
//    
////    private var sessionManager: SessionManager!
//    
//    var networkStatus: AlamofireNetworkReachabilityStatus = .notReachable
//    
//    func isInternetAvailable() -> Bool {
//        return (networkStatus == .ReachableWifi || networkStatus == .ReachableViaWWan)
//    }
//    
//    func checkNetworkConnection() {
//        sessionManager.startRequestsImmediately = true
//        sessionManager.reachabilityManager?.startListening { status in
//            self.networkStatus = status
//            SHAREMANAGER.setIsInternetAvailable(self.isInternetAvailable())
//            
//            if status != .reachableViaWiFi && status != .reachableViaWWAN {
//                JDStatusBarNotification.show(withStatus: INTERNET_CONNECTION_OFFLINE, styleName: JDStatusBarStyleError)
//            } else if status == .unknown {
//                // Do nothing or handle unknown status as needed
//            } else {
//                JDStatusBarNotification.dismiss()
//            }
//        }
//    }
//    
//    func post(withURLString urlString: String, parameters: [String: Any]?, completion: @escaping AFJSONCompletion) {
//        sessionManager.request(urlString, method: .post, parameters: parameters, encoding: URLEncoding.default)
//            .validate()
//            .responseJSON { response in
//                switch response.result {
//                case .success(let value):
//                    if let JSON = value as? [String: Any] {
//                        completion(JSON, nil)
//                    }
//                case .failure(let error):
//                    completion(nil, error)
//                }
//            }
//    }
//    
//    func fetchRoutePath(from origin: String?, to destination: String?, completion: @escaping AFRouteCompletion) {
//        let urlString = "https://maps.googleapis.com/maps/api/directions/json"
//        var parameters: [String: Any] = [
//            "origin": origin ?? "",
//            "destination": destination ?? "",
//            "mode": "driving",
//            "key": "AIzaSyCMNT51gPtbeVnUWr4j56UzuQqMioSuwAk"
//        ]
//        
//        sessionManager.request(urlString, method: .get, parameters: parameters, encoding: URLEncoding.default)
//            .validate()
//            .responseJSON { response in
//                switch response.result {
//                case .success(let value):
//                    if let JSON = value as? [String: Any],
//                       let routes = JSON["routes"] as? [[String: Any]], !routes.isEmpty,
//                       let overviewPolyline = routes[0]["overview_polyline"] as? [String: Any],
//                       let points = overviewPolyline["points"] as? String {
//                        let path = GMSMutablePath(fromEncodedPath: points)
//                        let legs = routes[0]["legs"] as? [[String: Any]]
//                        let distance = legs?.first?["distance"]?["text"] as? String ?? ""
//                        let duration = legs?.first?["duration"]?["text"] as? String ?? ""
//                        completion(path, distance, duration, nil)
//                    } else {
//                        completion(nil, nil, nil, nil)
//                    }
//                case .failure(let error):
//                    completion(nil, nil, nil, error)
//                }
//            }
//    }
//    
//    func uploadImage(parameters: [String: Any]?, completion: @escaping AFUploadingCompletion) {
//        guard let fileData = parameters?["file"] as? Data else { return }
//        var parameters = parameters
//        parameters?.removeValue(forKey: "file")
//        
//        sessionManager.upload(
//            multipartFormData: { multipartFormData in
//                multipartFormData.append(fileData, withName: "file", fileName: "photo.jpg", mimeType: "image/jpeg")
//                for (key, value) in parameters ?? [:] {
//                    if let data = "\(value)".data(using: .utf8) {
//                        multipartFormData.append(data, withName: key)
//                    }
//                }
//            },
//            to: "index.php",
//            method: .post,
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .success(let upload, _, _):
//                    upload.responseJSON { response in
//                        switch response.result {
//                        case .success(let value):
//                            if let JSON = value as? [String: Any],
//                               let fileName = JSON["data"]?["file_name"] as? String {
//                                completion(fileName, nil)
//                            }
//                        case .failure(let error):
//                            if error.code == NSURLErrorTimedOut {
//                                self.uploadImage(parameters: nil, completion: completion)
//                            } else {
//                                completion(nil, error)
//                            }
//                        }
//                    }
//                case .failure(let encodingError):
//                    completion(nil, encodingError)
//                }
//            }
//        )
//    }
//}


//import Alamofire
//
//class NetworkManager {
//
//    static let shared = NetworkManager()
//    private var reachabilityManager: NetworkReachabilityManager?
//
//    private init() {
//        configureReachability()
//    }
//
//    private func configureReachability() {
//        reachabilityManager = NetworkReachabilityManager()
//
//        // Start listening to network reachability changes
//        reachabilityManager?.startListening(onUpdatePerforming: { [weak self] status in
//            switch status {
//            case .reachable(.ethernetOrWiFi), .reachable(.cellular):
//                print("Connected to the network.")
//            default:
//                print("Not connected to the network.")
//            }
//        })
//    }
//
//    func stopMonitoring() {
//        reachabilityManager?.stopListening()
//    }
//}


class AppDotNetAPIClient {
    static let shared: AppDotNetAPIClient = {
        let sharedClient = AppDotNetAPIClient()
        sharedClient.sessionManager = Session(configuration: URLSessionConfiguration.default)
//        sharedClient.sessionManager?.startRequestsImmediately = false
        return sharedClient
    }()
    
    static let networkClass = NetworkController()

    var sessionManager: Session?
    var networkStatus: NetworkReachabilityManager.NetworkReachabilityStatus = .unknown

    private init() {}

    func isInternetAvailable() -> Bool {
        print("print network status: isInternetAvailable: \((networkStatus == .reachable(.ethernetOrWiFi) || networkStatus == .reachable(.cellular)))")
        return (networkStatus == .reachable(.ethernetOrWiFi) || networkStatus == .reachable(.cellular))
    }

    func checkNetworkConnection() {
        guard let reachabilityManager = NetworkReachabilityManager(host: "www.apple.com") else {
            return
        }

        reachabilityManager.startListening { [weak self] status in
            guard let self = self else { return }

            self.networkStatus = status
            print("wk networkStatus: \(self.networkStatus)")
            // Assuming SHAREMANAGER and rootViewController are global instances
            
//            SHAREMANAGER.isInternetAvailable = self.isInternetAvailable()

            if status != .reachable(.ethernetOrWiFi) && status != .reachable(.cellular) {
                AppDotNetAPIClient.networkClass.showInternetError("The Internet connection appears to be offline.")
//                ShareManager.share().showInternetError("The Internet connection appears to be offline.")
                // Not reachable
                // DLog("Not reachable"))
                // SHAREMANAGER.rootViewController.zingleWithMessage(INTERNET_CONNECTION_OFFLINE)
            } else if status == .unknown {
                // Unknown
                // DLog("Unknown")
            } else {
                AppDotNetAPIClient.networkClass.dismissInternetError()
                // Reachable
                // DLog("Reachable")
            }
        }
    }
}
