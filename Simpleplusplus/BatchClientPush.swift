//
//  BatchClientPush.swift
//
//  This file is licenced under the MIT license

/*
 The MIT License (MIT)
 Copyright (c) 2016 Batch.com
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import Foundation

// TODO: Document this
@objc
public class BatchClientPush: NSObject, URLSessionDelegate {
    private static let apiURLFormat = "https://api.batch.com/1.0/%@/transactional/send"
    private static let apiMaxRecipients = 10000
    private static let jsonContentType = "application/json"
    
    private let apiKey: String
    private let restKey: String
    
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    
    // TODO: Document all this
    public private(set) var message = BatchClientPushMessage()
    public private(set) var recipients = BatchClientPushRecipients()
    public var sandbox = false
    public var customPayload: [String: AnyObject]? = nil
    public var groupId = "ios_push"
    public var deeplink: String? = nil
    
    init?(apiKey: String, restKey: String) {
        
        if apiKey.characters.count != 30 {
            return nil
        }
        
        if restKey.characters.count != 32 {
            return nil
        }
        
        self.apiKey = apiKey
        self.restKey = restKey
    }
    
    func send(completionHandler: @escaping (_ response: String?, _ error: NSError?) -> ()) {
        guard recipients.count > 0 else {
            completionHandler(nil, NSError(domain: "BatchClientPushErrorDomain",
                                                            code: -2,
                                                            userInfo: [NSLocalizedDescriptionKey: "Validation error: No recipients were specified"]))
            return
        }
        
        guard recipients.count <= BatchClientPush.apiMaxRecipients else {
            completionHandler(nil, NSError(domain: "BatchClientPushErrorDomain",
                                                            code: -2,
                                                            userInfo: [NSLocalizedDescriptionKey: "Validation error: Recipients count exceeds \(BatchClientPush.apiMaxRecipients)"]))
            return
        }
        
        var jsonPayload: NSData?
        
        if let customPayload = customPayload {
            do {
                jsonPayload = try JSONSerialization.data(withJSONObject: customPayload, options: []) as NSData?
            } catch let error as NSError {
                completionHandler(nil, NSError(domain: "BatchClientPushErrorDomain",
                                                                code: -3,
                                                                userInfo: [
                                                                    NSUnderlyingErrorKey: error,
                                                                    NSLocalizedDescriptionKey: "Validation error: An error occurred while serializing the custom payload to JSON. Make sure it's a dictionary only made of foundation objects compatible with NSJSONSerialization. (Additional info: \(error.localizedDescription)"
                    ]))
                return
            }
        }
        
        guard let request = buildRequest(customPayload: jsonPayload) else {
            completionHandler(nil, NSError(domain: "BatchClientPushErrorDomain",
                                                            code: -1,
                                                            userInfo: [NSLocalizedDescriptionKey: "Unknown error while building the HTTP request"]))
            return
        }
        
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            
            var stringResponseData: String?
            if let data = data {
                stringResponseData = String(data: data, encoding: String.Encoding.utf8)
            }
            
            var userFacingError: NSError? = error as NSError?
            
            if let response = response as? HTTPURLResponse
                , response.statusCode != 201 && error == nil {
                userFacingError = NSError(domain: "BatchClientPushErrorDomain",
                                          code: -4,
                                          userInfo: [
                                            NSLocalizedDescriptionKey: "Server error: Status code \(response.statusCode), please see the response string for more info."
                    ])
            }
            
            completionHandler(stringResponseData, userFacingError)
        }
        
        task.resume()
    }
    
    private func buildRequest(customPayload: NSData?) -> NSURLRequest? {
        guard let url = NSURL(string: String(format: BatchClientPush.apiURLFormat, apiKey)) else { return nil }
        
        guard let body = buildRequestBody(customPayload: customPayload) else { return nil }
        
        let request = NSMutableURLRequest(url: url as URL)
        
        request.httpMethod = "POST"
        request.httpBody = body as Data
        request.setValue(restKey, forHTTPHeaderField: "X-Authorization")
        request.setValue(BatchClientPush.jsonContentType, forHTTPHeaderField: "Accept")
        request.setValue(BatchClientPush.jsonContentType, forHTTPHeaderField: "Content-Type")
        
        return request
    }
    
    private func buildRequestBody(customPayload: NSData?) -> NSData? {
        var body: [String: AnyObject] = [:]
        body["group_id"] = groupId as AnyObject?
        body["sandbox"] = sandbox as AnyObject?
        body["recipients"] = [
            "custom_ids": recipients.customIds,
            "tokens": recipients.tokens,
            "install_ids": recipients.installIds
        ] as AnyObject?
        
        body["message"] = message.dictionaryRepresentation() as AnyObject?
        
        if let customPayload = customPayload {
            body["custom_payload"] = String(data: customPayload as Data, encoding: String.Encoding.utf8) as AnyObject?
        }
        
        if let deeplink = deeplink {
            body["deeplink"] = deeplink as AnyObject?
        }
        
        do {
            return try JSONSerialization.data(withJSONObject: body, options: []) as NSData?
        } catch {
            return nil
        }
    }
    
}

@objc
public class BatchClientPushMessage: NSObject {
    var title: String?
    var body: String = ""
    
    public func dictionaryRepresentation() -> [String: AnyObject] {
        var res = ["body": body]
        if let title = title {
            res["title"] = title
        }
        
        return res as [String : AnyObject]
    }
    
}

@objc
public class BatchClientPushRecipients: NSObject {
    var customIds: [String] = []
    var installIds: [String] = []
    var tokens: [String] = []
    
    public var count: Int {
        get {
            return customIds.count + installIds.count + tokens.count
        }
    }
    
}
