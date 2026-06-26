import Foundation

public struct ReleaseUpdate: Equatable {
    public let tagName: String
    public let name: String
    public let htmlURL: URL
    public let publishedAt: Date?
}

@MainActor
public final class ReleaseUpdateChecker: ObservableObject {
    public enum FailureMessage {
        public static let unreachable = "release.unreachable"
        public static let invalidLink = "release.invalidLink"
        public static let checkFailed = "release.checkFailed"
    }

    public enum Status: Equatable {
        case idle
        case checking
        case available(ReleaseUpdate)
        case unavailable(Date)
        case failed(String)
    }

    @Published public private(set) var status: Status = .idle

    private let latestReleaseURL: URL
    private let decoder: JSONDecoder

    public init(
        latestReleaseURL: URL = URL(string: "https://api.github.com/repos/Aquariues/flower-doro/releases/latest")!
    ) {
        self.latestReleaseURL = latestReleaseURL
        self.decoder = JSONDecoder()
        self.decoder.dateDecodingStrategy = .iso8601
    }

    public func checkForUpdates() async {
        status = .checking

        do {
            var request = URLRequest(url: latestReleaseURL)
            request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
            request.setValue("FlowerDoro", forHTTPHeaderField: "User-Agent")

            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                status = .failed(FailureMessage.unreachable)
                return
            }

            let release = try decoder.decode(GitHubRelease.self, from: data)
            guard let htmlURL = URL(string: release.htmlURL) else {
                status = .failed(FailureMessage.invalidLink)
                return
            }

            status = .available(
                ReleaseUpdate(
                    tagName: release.tagName,
                    name: release.name ?? release.tagName,
                    htmlURL: htmlURL,
                    publishedAt: release.publishedAt
                )
            )
        } catch {
            status = .failed(FailureMessage.checkFailed)
        }
    }
}

private struct GitHubRelease: Decodable {
    let tagName: String
    let name: String?
    let htmlURL: String
    let publishedAt: Date?

    enum CodingKeys: String, CodingKey {
        case tagName = "tag_name"
        case name
        case htmlURL = "html_url"
        case publishedAt = "published_at"
    }
}
