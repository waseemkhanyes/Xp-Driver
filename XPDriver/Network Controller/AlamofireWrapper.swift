//
//  AlamofireWrapper.swift
//  XPDriver
//
//  Created by Waseem  on 08/01/2024.
//  Copyright © 2024 Syed zia. All rights reserved.
//

import Foundation
import UIKit

@objc public enum RequestMethod: Int {
    case options, get, head, post, put, patch, delete, trace, connect
}

@objc public enum RequestParameterEncoding: Int {
    case url, urlEncodedInURL, json
}

@objcMembers
public class AlamofireWrapper: NSObject {
    
    // Maps the custom RequestMethod enum values to the Alamofire.HTTPMethod values
    private class func translateMethod(method: RequestMethod) -> HTTPMethod {
        switch method {
        case .get:
            return .get
        case .post:
            return .post
        case .delete:
            return .delete
        case .head:
            return .head
        case .put:
            return .put
        case .patch:
            return .patch
        case .trace:
            return .trace
        case .connect:
            return .connect
        case .options:
            return .options
        }
    }
    
    // Maps the custom RequestParameterEncoding enum values to the Alamofire.ParameterEncoding values
    private class func translateEncoding(encoding: RequestParameterEncoding) -> ParameterEncoding {
        switch encoding {
        case .json:
            return JSONEncoding.default
        case .urlEncodedInURL:
            return URLEncoding.default
        case .url:
            return URLEncoding(destination: .methodDependent)
        }
    }
    
    public class func performJSONRequest(
        method: RequestMethod,
        urlString: String,
        parameters: [String: Any]?,
        encoding: RequestParameterEncoding = .url,
        headers: [String: String]?,
        success: @escaping (_ request: URLRequest?, _ response: HTTPURLResponse?, _ json: [String: Any]?) -> Void,
        failure: @escaping (_ request: URLRequest?, _ response: HTTPURLResponse?, _ error: Error?) -> Void
    ) {
//        if !AppDotNetAPIClient.shared.isInternetAvailable() {
//            AppDotNetAPIClient.shared.checkNetworkConnection()
//            return
//        }
        
        let method = translateMethod(method: method)
        let encoding = translateEncoding(encoding: encoding)
        
        // Convert headers to HTTPHeaders type
        let httpHeaders = HTTPHeaders(headers ?? [:])
        print("** wk url: \(urlString)")
        print("** wk parameters: \(parameters ?? [:])")
        //            let request = AF.request(urlString, method: method, parameters: parameters, encoding: encoding, headers: httpHeaders)
        //            request.responseJSON { response in
        AF.request(urlString, method: method, parameters: parameters, encoding: URLEncoding.default, headers: nil)
            .validate(contentType: ["application/json", "text/json", "text/javascript", "text/html"])
//            .responseJSON { response in
//                print("** wk response: \(response.result)")
//                parseResponse(response, success: success, failure: failure)
//            }
            .responseJSON1 { response in
                parseResponse1(response, success: success, failure: failure)
            }
    }
    
    public class func checkAppVersionApi(completion: @escaping (String?) -> Void) {
        let bundleID = "com.kaimeramedia.myxptripdriver"
        let urlString = "https://itunes.apple.com/lookup?bundleId=\(bundleID)"
        
        AF.request(urlString).responseJSON1 { response in
            switch response.result {
            case .success(let value):
                if let data = value["results"].arrayValue.first {
                    
                    let appVersion = data["version"].stringValue
                    if let localVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                        let checkVersion = checkIsNewVersion(olderVersion: localVersion, newVersion: appVersion)
                            
                        completion(checkVersion ? "true" : "false")
                    } else {
                        completion(nil)
                    }
                } else {
                    completion(nil)
                }
            case .failure:
                completion(nil)
            }
        }
    }
    
    private class func parseResponse1(
        _ response: DataResponse<JSON, AFError>,
        success: @escaping (_ request: URLRequest?, _ response: HTTPURLResponse?, _ json: [String: Any]?) -> Void,
        failure: @escaping (_ request: URLRequest?, _ response: HTTPURLResponse?, _ error: Error?) -> Void
    ) {
        let urlRequest = response.request
        let urlResponse = response.response
        if let error = response.error {
//            print("** wk failure 1: \(error)")
            failure(urlRequest, urlResponse, error)
        } else {
//            print("** wk newData: \(response.value)")
            if let object = response.value?.dictionaryObject {
                success(urlRequest, urlResponse, object)
            } else {
                failure(urlRequest, urlResponse, nil)
            }
        }
    }
     
    public class func uploadImage(parameters: [String: Any], completion: @escaping (_ fileName: String?, _ error: String?) -> Void) {
        if let fileData = parameters["file"] as? Data {
            var updatedParameters = parameters
            updatedParameters.removeValue(forKey: "file")
            
            let urlString = "https://www.xpeats.com/api/index.php"  // Replace with your actual base URL
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(fileData, withName: "file", fileName: "photo.jpg", mimeType: "image/jpeg")
                for (key, value) in updatedParameters {
                    if let data = "\(value)".data(using: .utf8) {
                        multipartFormData.append(data, withName: key)
                    }
                }
            }, to: urlString)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let json = value as? [String: Any], let fileName = json["data"] as? [String: Any], let actualFileName = fileName["file_name"] as? String {
                        completion(actualFileName, nil)
                    } else {
                        completion(nil, "Invalid response format")
                    }
                case .failure(let error):
                    if let afError = error as? AFError, afError.isRequestRetryError {
                        // Handle retry logic if needed
                    } else {
                        completion(nil, error.localizedDescription)
                    }
                }
            }
        } else {
            completion(nil, "Invalid file data")
        }
    }
    

    public class func downloadImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        print("wk url: \(url)")
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                guard let downloadedImage = UIImage(data: data) else {
                    completion(nil)
                    return
                }
                
                completion(downloadedImage)
                
            case .failure(let error):
                print("Error downloading image: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }

}

extension DataRequest {
    func responseJSON1(_ handler:@escaping (DataResponse<JSON, AFError>) -> Void) {
        self.responseDecodable(of: JSON.self, completionHandler: handler)
    }
}
