import Foundation

#if os(macOS)
import AppKit

enum ReleaseUpdateInstallResult: Equatable {
    case willRestart
    case manualInstall(URL)
}

enum ReleaseUpdateInstallError: Error {
    case missingAsset
    case missingApp
    case installFailed
}

@MainActor
struct ReleaseUpdateInstaller {
    func install(_ release: ReleaseUpdate) async throws -> ReleaseUpdateInstallResult {
        guard let assetURL = release.assetURL else {
            throw ReleaseUpdateInstallError.missingAsset
        }

        let fileManager = FileManager.default
        let installRoot = fileManager.temporaryDirectory
            .appendingPathComponent("FlowerDoroUpdate-\(UUID().uuidString)", isDirectory: true)
        let archiveURL = installRoot.appendingPathComponent(assetURL.lastPathComponent)
        let extractionURL = installRoot.appendingPathComponent("Extracted", isDirectory: true)

        try fileManager.createDirectory(at: installRoot, withIntermediateDirectories: true)
        try fileManager.createDirectory(at: extractionURL, withIntermediateDirectories: true)

        let downloadedArchiveURL = try await download(assetURL)
        if fileManager.fileExists(atPath: archiveURL.path) {
            try fileManager.removeItem(at: archiveURL)
        }
        try fileManager.moveItem(at: downloadedArchiveURL, to: archiveURL)

        try unzip(archiveURL: archiveURL, destinationURL: extractionURL)

        guard let downloadedAppURL = try findFlowerDoroApp(in: extractionURL) else {
            throw ReleaseUpdateInstallError.missingApp
        }

        let destinationURL = installDestinationURL()
        guard isWritableInstallDestination(destinationURL) else {
            NSWorkspace.shared.activateFileViewerSelecting([downloadedAppURL])
            return .manualInstall(downloadedAppURL)
        }

        try scheduleInstall(downloadedAppURL: downloadedAppURL, destinationURL: destinationURL)
        NSApplication.shared.terminate(nil)
        return .willRestart
    }

    private func download(_ url: URL) async throws -> URL {
        var request = URLRequest(url: url)
        request.setValue("FlowerDoro", forHTTPHeaderField: "User-Agent")
        let (downloadedURL, response) = try await URLSession.shared.download(for: request)
        guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
            throw ReleaseUpdateInstallError.installFailed
        }
        return downloadedURL
    }

    private func unzip(archiveURL: URL, destinationURL: URL) throws {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/ditto")
        process.arguments = ["-x", "-k", archiveURL.path, destinationURL.path]
        try process.run()
        process.waitUntilExit()
        guard process.terminationStatus == 0 else {
            throw ReleaseUpdateInstallError.installFailed
        }
    }

    private func findFlowerDoroApp(in directoryURL: URL) throws -> URL? {
        let fileManager = FileManager.default
        let contents = try fileManager.contentsOfDirectory(
            at: directoryURL,
            includingPropertiesForKeys: [.isDirectoryKey],
            options: [.skipsHiddenFiles]
        )

        for url in contents {
            if url.lastPathComponent == "FlowerDoro.app" {
                return url
            }

            let values = try url.resourceValues(forKeys: [.isDirectoryKey])
            if values.isDirectory == true, let nestedURL = try findFlowerDoroApp(in: url) {
                return nestedURL
            }
        }

        return nil
    }

    private func installDestinationURL() -> URL {
        let currentAppURL = Bundle.main.bundleURL
        let currentPath = currentAppURL.path
        if currentAppURL.pathExtension == "app",
           !currentPath.contains("/.build/"),
           !currentPath.contains("/AppTranslocation/") {
            return currentAppURL
        }
        return URL(fileURLWithPath: "/Applications/FlowerDoro.app")
    }

    private func isWritableInstallDestination(_ destinationURL: URL) -> Bool {
        let fileManager = FileManager.default
        let parentURL = destinationURL.deletingLastPathComponent()

        if fileManager.fileExists(atPath: destinationURL.path) {
            return fileManager.isWritableFile(atPath: destinationURL.path)
        }

        return fileManager.isWritableFile(atPath: parentURL.path)
    }

    private func scheduleInstall(downloadedAppURL: URL, destinationURL: URL) throws {
        let script = """
        sleep 1
        rm -rf \(shellEscaped(destinationURL.path))
        /usr/bin/ditto \(shellEscaped(downloadedAppURL.path)) \(shellEscaped(destinationURL.path))
        /usr/bin/open \(shellEscaped(destinationURL.path))
        """

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/bin/sh")
        process.arguments = ["-c", script]
        try process.run()
    }

    private func shellEscaped(_ value: String) -> String {
        "'\(value.replacingOccurrences(of: "'", with: "'\\''"))'"
    }
}
#endif
