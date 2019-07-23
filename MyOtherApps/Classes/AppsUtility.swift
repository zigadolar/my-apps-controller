//
//  AppsUtility.swift
//  MyOtherApps
//
//  Created by Dolar, Ziga on 7/23/19.
//

import Foundation

public struct AppsSet {
    public var name: String
    public var apps: [App]

    public init(name: String, apps: [App]) {
        self.name = name
        self.apps = apps
    }
}

public struct App {
    public enum Category {
        case app, game

        public var description: String {
            switch self {
            case .app: return "Apps"
            case .game: return "Games"
            }
        }
    }

    public let name: String
    public let type: Category
    public let genres: [String]
    public let identifier: Int
    public let iconURL: URL
    public let bundleIdentifier: String

    public init(name: String, type: Category, genres: [String], identifier: Int, iconURL: URL, bundleIdentifier: String) {
        self.name = name
        self.type = type
        self.genres = genres
        self.identifier = identifier
        self.iconURL = iconURL
        self.bundleIdentifier = bundleIdentifier
    }
}

struct Response: Codable {
    var results: [Result]

    struct Result: Codable {
        var wrapperType: String
        var primaryGenreName: String?
        var artworkUrl512: String?
        var trackId: Int?
        var trackName: String?
        var genres: [String]?
        var bundleId: String?
    }
}

extension Response.Result {
    func convert() -> App? {
        guard wrapperType == "software",
            let primaryGenreName = primaryGenreName,
            let artworkUrl = artworkUrl512,
            let url = URL(string: artworkUrl),
            let identifier = trackId,
            let name = trackName,
            let genres = genres,
            let bundleId = bundleId else {
                return nil
        }

        return App(name: name,
                   type: primaryGenreName.lowercased() == "games" ? .game : .app,
                   genres: genres.filter { $0.lowercased() != "games" },
                   identifier: identifier,
                   iconURL: url,
                   bundleIdentifier: bundleId)
    }
}

public class AppsUtility {
    private var itunesId: String?
    lazy private var defaultLookupUrlString: String = {
        guard let itunesId = itunesId else {
            return ""
        }

        return "https://itunes.apple.com/lookup?id=\(itunesId)&entity=software"
    }()

    private var defaultResponseParsingHandler: ((Data) -> [App]) = { data in
        guard let itunesResponse = try? JSONDecoder().decode(Response.self, from: data) else {
            return []
        }

        let apps: [App] = itunesResponse.results.compactMap { $0.convert() }
        return apps
    }

    private var customLookupURL: URL?
    private var customResponseParsingHandler: ((Data) -> [App])?

    private var lookupURL: URL? {
        if customLookupURL != nil, customResponseParsingHandler != nil {
            return customLookupURL
        }

        return URL(string: defaultLookupUrlString)
    }

    private var responseParsingHandler: ((Data) -> [App]) {
        return customResponseParsingHandler ?? defaultResponseParsingHandler
    }

    public init(with itunesId: String) {
        self.itunesId = itunesId
    }

    public init(with lookupUrl: URL, responseParsingHandler: @escaping ((Data) -> [App])) {
        self.customLookupURL = lookupUrl
        self.customResponseParsingHandler = responseParsingHandler
    }

    func fetch(_ completionHandler: @escaping ([App]) -> Void) {
        guard let url = lookupURL else {
            completionHandler([])
            return
        }

        let session = URLSession.shared
        let request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30)

        let parsingHandler = responseParsingHandler
        let task = session.dataTask(with: request) { data, response, error in
            guard let data = data else {
                completionHandler([])
                return
            }

            let apps = parsingHandler(data)

            completionHandler(apps)
        }

        task.resume()
    }
}
