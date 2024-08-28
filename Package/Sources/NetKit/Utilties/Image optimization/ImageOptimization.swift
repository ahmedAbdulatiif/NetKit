//
//  ImageOptimization.swift
//  El-Araby
//
//  Created by Aya Fayad on 7/9/20.
//  Copyright © 2020 Robusta. All rights reserved.
//

import Foundation

struct ImageOptimization {
//    static let staticImgBaseUrl = "https://robusta.hypernode.io"
    //        static let optimizedBaseUrl = "https://d3hjmm2sg88tse.cloudfront.net"
    //        static let imgBaseUrl = "https://elaraby-magento-dev.s3.eu-west-2.amazonaws.com"

    static let imgBaseUrl = "https://elaraby-group.s3.eu-central-1.amazonaws.com"
    static let staticImgBaseUrl = "https://elarabygroup.hypernode.io"
    static let optimizedBaseUrl = "https://dbiox4whpxl64.cloudfront.net"
    static let mediaString = "/media/"
    static let mediaStringWithBackslash = "//media/"
    static let staticString = "/static/"

    static func buildOptimizedURL(with urlString: String) -> String {
        var optimizedUrlString = ""
        if urlString.contains(ImageOptimization.staticImgBaseUrl) {
            if urlString.contains(ImageOptimization.staticString) {
                let urlArray = urlString.components(separatedBy: "/")
                optimizedUrlString = "\(ImageOptimization.optimizedBaseUrl)/\(urlArray.last ?? "")"
            } else {
                optimizedUrlString = ((urlString
                    .replacingOccurrences(of: ImageOptimization.mediaStringWithBackslash, with: "/"))
                    .replacingOccurrences(of: ImageOptimization.mediaString, with: "/"))
                    .replacingOccurrences(of: ImageOptimization.staticImgBaseUrl, with: ImageOptimization.optimizedBaseUrl)
            }
        } else {
            optimizedUrlString = ((urlString
            .replacingOccurrences(of: ImageOptimization.imgBaseUrl,
                                  with: ImageOptimization.optimizedBaseUrl))
            .replacingOccurrences(of: ImageOptimization.mediaString, with: "/"))
        }
        return optimizedUrlString
    }
}
