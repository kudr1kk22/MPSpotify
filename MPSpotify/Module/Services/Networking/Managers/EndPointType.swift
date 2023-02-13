//
//  EndPointType.swift
//  MPSpotify
//
//  Created by Eugene Kudritsky on 1.02.23.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case PUT
    case POST
    case DELETE
}

enum HeaderKeys: String {
    case contentType = "Content-Type"
    case authorization = "Authorization"
}
