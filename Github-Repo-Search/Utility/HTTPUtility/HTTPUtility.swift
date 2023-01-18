//
//  HTTPUtility.swift
//  Github-Repo-Search
//
//  Created by love on 18/01/23.
//

import Foundation

public class HttpUtility: NSObject {
    
    public static let shared = HttpUtility()
    
    private override init() {}
    
    public func request<T: Decodable>(huRequest: HURequest,
                                      resultType: T.Type,
                                      completionHandler: @escaping (Result<T?, HUNetworkError>) -> Void) {
        switch huRequest.method {
        case .get:
            getData(request: huRequest,
                    resultType: resultType) { completionHandler($0)}
        }
    }
    
    // MARK: - Private functions
    private func createJsonDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
    
    private func decodeJsonResponse<T: Decodable>(data: Data,
                                                  responseType: T.Type) -> T? {
        let decoder = createJsonDecoder()
        do {
            return try decoder.decode(responseType, from: data)
        } catch let DecodingError.dataCorrupted(context) {
            debugPrint(context)
        } catch let DecodingError.keyNotFound(key, context) {
            debugPrint("Key '\(key)' not found:", context.debugDescription)
            debugPrint("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            debugPrint("Value '\(value)' not found:", context.debugDescription)
            debugPrint("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context) {
            debugPrint("Type '\(type)' mismatch:", context.debugDescription)
            debugPrint("codingPath:", context.codingPath)
        } catch {
            debugPrint("error: ", error)
        }
        return nil
    }
    
    // MARK: - GET Api
    private func getData<T: Decodable>(request: HURequest,
                                       resultType: T.Type,
                                       completionHandler: @escaping (Result<T?, HUNetworkError>) -> Void) {
        if let queryURL = queryString(request.url.absoluteString,
                                      params: request.queryParams) {
            
            var urlRequest = URLRequest(url: queryURL)
            urlRequest.httpMethod = HUHttpMethods.get.rawValue
            urlRequest.allHTTPHeaderFields = request.headers
            
            performOperation(requestUrl: urlRequest, responseType: T.self) { (result) in
                DispatchQueue.main.async {
                    completionHandler(result)
                }
            }
        } else {
            completionHandler(.failure(HUNetworkError.init(forRequestUrl: request.url,
                                                           errorMessage: "Invalid Request URL",
                                                           forStatusCode: 400)))
        }
    }
    
    func queryString(_ urlString: String,
                     params: [String: String]) -> URL? {
        var components = URLComponents(string: urlString)
        components?.queryItems = params.map { element in URLQueryItem(name: element.key, value: element.value) }
        return components?.url
    }
    
    // MARK: - Perform data task
    private func performOperation<T: Decodable>(requestUrl: URLRequest,
                                                responseType: T.Type,
                                                completionHandler: @escaping(Result<T?, HUNetworkError>) -> Void) {
        URLSession.shared.dataTask(with: requestUrl) { (data, httpUrlResponse, error) in
            
            let statusCode = (httpUrlResponse as? HTTPURLResponse)?.statusCode
            
            if let error = error {
                let networkError = HUNetworkError(withServerResponse: data,
                                                  forRequestUrl: requestUrl.url!,
                                                  withHttpBody: requestUrl.httpBody,
                                                  errorMessage: error.localizedDescription,
                                                  forStatusCode: statusCode ?? 500)
                completionHandler(.failure(networkError))
            } else {
                if let data = data {
                    if let response = self.decodeJsonResponse(data: data,
                                                              responseType: responseType) {
                        completionHandler(.success(response))
                    } else {
                        completionHandler(.failure(HUNetworkError(withServerResponse: data,
                                                                  forRequestUrl: requestUrl.url!,
                                                                  withHttpBody: requestUrl.httpBody,
                                                                  errorMessage: "deocding error",
                                                                  forStatusCode: statusCode!)))
                    }
                } else {
                    completionHandler(.failure(HUNetworkError(withServerResponse: data,
                                                              forRequestUrl: requestUrl.url!,
                                                              withHttpBody: requestUrl.httpBody,
                                                              errorMessage: error.debugDescription,
                                                              forStatusCode: statusCode!)))
                }
            }
        }.resume()
    }
}
