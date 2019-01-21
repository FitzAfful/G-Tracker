//
//  APIClient.swift
//  G-Tracker
//
//  Created by Fitzgerald Afful on 18/01/2019.
//  Copyright © 2019 Glivion. All rights reserved.
//

import Foundation
import Alamofire

class APIClient {
	static func getCarDetails(channelName: String, secretKey: String, completion:@escaping (Result<ThingSpeakResponse>)->Void) {
		AF.request(APIRouter.getThingSpeak(channel: channelName, apiKey: secretKey))
			.responseDecodable { (response: DataResponse<ThingSpeakResponse>) in
				print(response)
				completion(response.result)
		}
	}
}

struct ApiError: Error {
	let data: Data?
	let httpUrlResponse: HTTPURLResponse
}

struct NetworkRequestError: Error {
	let error: Error?
	
	var localizedDescription: String {
		return error?.localizedDescription ?? "Network request error - no other information"
	}
}

enum APIRouter: URLRequestConvertible {
	
	case getThingSpeak(channel:String, apiKey:String)
	
	// MARK: - HTTPMethod
	private var method: HTTPMethod {
		switch self {
		case .getThingSpeak:
			return .get
		}
	}
	
	private var apiKey: String {
		switch self {
		case .getThingSpeak( _, let apiKey):
			return apiKey
		}
	}
	
	// MARK: - Path
	private var path: String {
		switch self {
		case .getThingSpeak(let channel, _):
			return "/channels/\(channel)/feeds.json"
		}
	}
	
	// MARK: - URLRequestConvertible
	func asURLRequest() throws -> URLRequest {
		
		var urlComponents = URLComponents(string: K.ProductionServer.baseURL+path)!
		urlComponents.queryItems = [
			URLQueryItem(name: "api_key", value: apiKey)
		]
		
		let url = urlComponents.url!
		var urlRequest = URLRequest(url: url)
		urlRequest.httpMethod = method.rawValue
		
		// Common Headers
		urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.acceptType.rawValue)
		urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
		
		return urlRequest
	}
}

struct K {
	struct ProductionServer {
		static let baseURL = "https://api.thingspeak.com"
	}
	
	struct APIParameterKey {
		static let channel = "channel"
		static let apiKey = "api_key"
	}
}

enum HTTPHeaderField: String {
	case authentication = "Authorization"
	case contentType = "Content-Type"
	case acceptType = "Accept"
	case acceptEncoding = "Accept-Encoding"
}

enum ContentType: String {
	case json = "application/json"
}

protocol APIConfiguration: URLRequestConvertible {
	var method: HTTPMethod { get }
	var path: String { get }
}
