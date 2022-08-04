//
//  Networking.swift
//  BooksAssignment
//
//  Created by omaestra on 3/4/22.
//

import Foundation
import Alamofire

protocol NetworkingProtocol {
    func fetch<T: Decodable>(_ endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void)
    func create<T: Codable>(_ endpoint: Endpoint, requestBody: [String: Any], completion: @escaping (Result<T, Error>) -> Void)
}

final class AlamofireNetworking: NetworkingProtocol {
    func fetch<T>(_ endpoint: Endpoint, completion: @escaping (Result<T, Error>) -> Void) where T : Decodable {
        let decoder = JSONDecoder()
        AF.request(endpoint)
            .responseDecodable(of: T.self, decoder: decoder) { response in
                switch response.result {
                case .success(let result):
                    completion(.success(result))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func create<T>(_ endpoint: Endpoint, requestBody: [String : Any], completion: @escaping (Result<T, Error>) -> Void) where T : Decodable, T : Encodable {
        // TODO
    }
}

final class MockNetworking: NetworkingProtocol {
    func fetch<T: Decodable>(_ endpoint: Endpoint,
                             completion: @escaping (Result<T, Error>) -> Void) {
        loadJsonDataFromFile(endpoint.mockFileName) { result in
            do {
                let jsonDecoder = JSONDecoder()
                let decodedValue = try jsonDecoder.decode(T.self, from: result.get())
                completion(.success(decodedValue))
            } catch (let error) {
                debugPrint(error.localizedDescription)
                completion(.failure(error))
            }
        }
    }
    
    func create<T: Codable>(_ endpoint: Endpoint,
                            requestBody: [String: Any],
                            completion: @escaping (Result<T, Error>) -> Void) {
        writeJsonDataToFile(endpoint.mockFileName, data: requestBody) { result in
            do {
                let jsonDecoder = JSONDecoder()
                let decodedValue = try jsonDecoder.decode(T.self, from: result.get())
                completion(.success(decodedValue))
            } catch (let error) {
                completion(.failure(error))
            }
        }
    }
    
    internal func loadJsonDataFromFile(_ path: String,
                                       completion: @escaping (Result<Data, Error>) -> Void) {
        if let fileUrl = Bundle.main.url(forResource: path, withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileUrl, options: [])
                completion(.success(data))
            } catch (let error) {
                print(error.localizedDescription)
                completion(.failure(error))
            }
        } else {
            completion(.failure(CustomError.notFound))
        }
    }
    
    private func writeJsonDataToFile(_ path: String,
                                     data: [String: Any],
                                     completion: @escaping (Result<Data, Error>) -> Void) {
        do {
            let success = try JSONSerialization.save(jsonObject: data, toFilename: path)
            let jsonObject = try JSONSerialization.data(withJSONObject: data, options: [.prettyPrinted])
            if success {
                completion(.success(jsonObject))
            } else {
                completion(.failure(CustomError.notFound))
            }
        } catch(let error) {
            debugPrint(error.localizedDescription)
            completion(.failure(error))
        }
    }
}
