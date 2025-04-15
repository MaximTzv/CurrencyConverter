//
//  Network.swift
//  CurrencyConverter
//
//  Created by Maxim Tzvetkov on 15.04.25.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    // PUT, DELETE, etc.
}

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingFailed(Error)
}

protocol NetworkService {
    func request<T: Decodable>(
        baseURL: String,
        path: String,
        method: HTTPMethod) async throws -> T
}

struct NetworkManager: NetworkService {
    
    let apiKey: String
    
    func request<T: Decodable>(
        baseURL: String,
        path: String,
        method: HTTPMethod
    ) async throws -> T {
        
        var components = URLComponents(string: baseURL)
        components?.path += path
        
        guard let url = components?.url else { throw NetworkError.invalidURL }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                throw NetworkError.invalidResponse
            }
            
            do {
                return try JSONDecoder().decode(T.self, from: data)
            } catch {
                throw NetworkError.decodingFailed(error)
            }
            
        } catch {
            throw NetworkError.requestFailed(error)
        }
    }
}
