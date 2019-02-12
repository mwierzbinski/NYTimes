//
//  NetworkingAPI.swift
//  NYTimesArticles
//
//  Created by Michal W on 11/02/2019.
//  Copyright © 2019 Michal W. All rights reserved.
//

import Foundation

fileprivate struct NetworkingConsts {
    static let apiKey = "n1CzW4GM3GI9WCOuibTwjp3Xthb38vqV"
    static let mostViewed = "https://api.nytimes.com/svc/mostpopular/v2/mostviewed/"
}

fileprivate enum Period: Int {
    case day = 1
    case week = 7
    case month = 30
}

fileprivate enum Section: String {
    case allSections = "all-sections"
}

protocol NetworkingService {
    func mostViewedArticles( completion: @escaping ([Article]) -> ())
}

final class NetworkingAPI: NetworkingService {
    private let session: URLSession
    
    init() {
        self.session = URLSession.shared
    }
    
    init(session: URLSession) {
        self.session = session
    }
    
    func mostViewedArticles( completion: @escaping ([Article]) -> ()) {
        mostViewedArticles(section: .allSections, period: .week, completion: completion)
    }
    
    @discardableResult
    fileprivate func mostViewedArticles(section: Section, period: Period, completion: @escaping ([Article])-> ()) -> URLSessionDataTask? {
        // TODO: how should we handle error here ?
        
        let urlString = "\(NetworkingConsts.mostViewed)\(section.rawValue)/\(period.rawValue).json?api-key=\(NetworkingConsts.apiKey)"
        
        guard let url = URL(string: urlString) else {
            return nil
        }
        
        let request = URLRequest(url: url)
        
        let task = session.dataTask(with: request) { data, response, error in
            
            guard error == nil else { // should we use guard or if here ?
                print("Error - ", error!.localizedDescription + "\n")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("ServerSide did not return Status Code 200\n")
                return
            }
            
            let jsonDecoder = JSONDecoder()
            jsonDecoder.dateDecodingStrategy = .customNYTimes
            
            guard let data = data, let parsedData = try? jsonDecoder.decode(SearchResponse.self, from: data) else {
                print("JSON decoding went wrong\n")
                return
            }
            
            DispatchQueue.main.async {
                completion(parsedData.results)
            }
        }
        
        task.resume()
        
        return task
    }
}

fileprivate struct SearchResponse: Decodable {
    let results: [Article]
}

extension DateFormatter {
    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

extension JSONDecoder.DateDecodingStrategy {
    static let customNYTimes = custom { decoder throws -> Date in
        
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        
        let formatter = DateFormatter.yyyyMMdd
        if let date = formatter.date(from: string) {
            return date
        }

        throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid date: \(string)")
    }
}
