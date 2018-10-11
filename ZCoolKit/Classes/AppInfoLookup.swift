//
//  VersionLookup.swift
//  ForceUpdateApp
//
//  Created by Zaldy on 28/09/2018.
//  Copyright © 2018 Zaldy. All rights reserved.
//

import Foundation
import UIKit

// App Info Lookup
public final class AppInfoLookup: NSObject {
    enum VersionError: Error {
        case invalidBundleInfo, invalidResponse
    }
    class LookupResult: Decodable {
        var results: [AppInfo]
    }
    class AppInfo: Decodable {
        var version: String
        var trackViewUrl: String
        //let identifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String,
        // You can add many thing based on "http://itunes.apple.com/lookup?bundleId=\(identifier)"  response
        // here version and trackViewUrl are key of URL response
        // so you can add all key beased on your requirement.
        
    }
    class func checkVersion(completion:((_ appVersion: String)->())?) {
        // self.appId
        let url = URL(string: "http://itunes.apple.com/lookup?bundleId=com.internetbrands.smb")
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }
                
                let result = try JSONDecoder().decode(LookupResult.self, from: data)
                //let dictionary = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                
                guard let info = result.results.first else { throw VersionError.invalidResponse }
                //let appStoreVersion = (info as AnyObject)["results"]["version"]
                print("App Store Version: \(info.version)")
                completion?(info.version)
            } catch {
                
            }
        }
        task.resume()
    }
    class func openStore(id: String) {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id\(id)"),
            UIApplication.shared.canOpenURL(url)
        {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}
