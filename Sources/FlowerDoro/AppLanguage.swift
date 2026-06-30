import Foundation

public enum AppLanguage: String, CaseIterable, Codable, Identifiable, Equatable {
    case vietnamese = "vi"
    case english = "en"

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .vietnamese:
            "Tiếng Việt"
        case .english:
            "English"
        }
    }
}

public struct FlowerLocalizedInfo: Equatable {
    public let name: String
    public let shortDescription: String
    public let facts: [String]
}

public struct AppCopy {
    public let language: AppLanguage

    public init(language: AppLanguage) {
        self.language = language
    }

    public var focus: String { language == .vietnamese ? "Tập trung" : "Focus" }
    public var breakTime: String { language == .vietnamese ? "Nghỉ" : "Break" }
    public var session: String { language == .vietnamese ? "Phiên" : "Session" }
    public var work: String { language == .vietnamese ? "Làm việc" : "Work" }
    public var breakLabel: String { language == .vietnamese ? "Nghỉ" : "Break" }
    public var minuteShort: String { language == .vietnamese ? "phút" : "min" }
    public var start: String { language == .vietnamese ? "Bắt đầu" : "Start" }
    public var pause: String { language == .vietnamese ? "Tạm dừng" : "Pause" }
    public var reset: String { language == .vietnamese ? "Đặt lại" : "Reset" }
    public var clock: String { language == .vietnamese ? "Đồng hồ" : "Clock" }
    public var today: String { language == .vietnamese ? "Hôm nay" : "Today" }
    public var week: String { language == .vietnamese ? "Tuần" : "Week" }
    public var month: String { language == .vietnamese ? "Tháng" : "Month" }
    public var garden: String { language == .vietnamese ? "Vườn" : "Garden" }
    public var flowerBook: String { language == .vietnamese ? "Sách hoa" : "Flower Book" }
    public var collection: String { language == .vietnamese ? "Bộ sưu tập" : "Collection" }
    public var app: String { language == .vietnamese ? "Ứng dụng" : "App" }
    public var appSettings: String { language == .vietnamese ? "Cài đặt" : "Settings" }
    public var languageLabel: String { language == .vietnamese ? "Ngôn ngữ" : "Language" }
    public var autoCheckUpdates: String { language == .vietnamese ? "Tự kiểm tra cập nhật" : "Auto check updates" }
    public var checkUpdates: String { language == .vietnamese ? "Kiểm tra" : "Check Updates" }
    public var installUpdate: String { language == .vietnamese ? "Cài đặt" : "Install" }
    public var installAndRestart: String { language == .vietnamese ? "Cài đặt và mở lại" : "Install and Restart" }
    public var cancel: String { language == .vietnamese ? "Hủy" : "Cancel" }
    public var openRelease: String { language == .vietnamese ? "Mở bản phát hành" : "Open Release" }
    public var quit: String { language == .vietnamese ? "Thoát" : "Quit" }
    public var updatesUseGitHub: String { language == .vietnamese ? "Cập nhật dùng GitHub Releases." : "Updates use GitHub releases." }
    public var checkingReleases: String { language == .vietnamese ? "Đang kiểm tra GitHub Releases..." : "Checking GitHub releases..." }
    public var installingUpdate: String { language == .vietnamese ? "Đang tải và cài đặt bản cập nhật..." : "Downloading and installing update..." }
    public var upToDate: String { language == .vietnamese ? "Bạn đang dùng bản mới nhất." : "You are up to date." }
    public var finishFirstFlower: String { language == .vietnamese ? "Hoàn thành một phiên tập trung để trồng bông hoa đầu tiên." : "Finish a focus session to grow your first flower." }
    public var flowers: String { language == .vietnamese ? "hoa" : "flowers" }
    public var blooms: String { language == .vietnamese ? "bông hoa" : "blooms" }
    public var recentBlooms: String { language == .vietnamese ? "Hoa gần đây" : "Recent blooms" }
    public var growing: String { language == .vietnamese ? "Đang nở" : "Growing" }
    public var collected: String { language == .vietnamese ? "đã sưu tầm" : "collected" }
    public var unknownFlower: String { language == .vietnamese ? "Hoa chưa biết" : "Unknown flower" }
    public var lockedFlowerPrompt: String { language == .vietnamese ? "Tiếp tục tập trung để mở trang này." : "Keep focusing to reveal this page." }
    public var lockedEntry: String { language == .vietnamese ? "Đã khóa" : "Locked" }
    public var previousPage: String { language == .vietnamese ? "Trang trước" : "Previous page" }
    public var nextPage: String { language == .vietnamese ? "Trang sau" : "Next page" }
    public var flowerGrowingAccessibility: String { language == .vietnamese ? "Hoa đang nở" : "Flower growing" }
    public var openGardenAccessibility: String { language == .vietnamese ? "Mở vườn" : "Open garden" }
    public var releaseUnreachable: String { language == .vietnamese ? "Không thể kết nối GitHub Releases." : "Could not reach GitHub releases." }
    public var releaseInvalidLink: String { language == .vietnamese ? "Liên kết bản phát hành không hợp lệ." : "Latest release link was invalid." }
    public var releaseCheckFailed: String { language == .vietnamese ? "Kiểm tra cập nhật thất bại." : "Update check failed." }
    public var updateAssetMissing: String { language == .vietnamese ? "Không tìm thấy file tải FlowerDoro trong bản phát hành." : "Could not find the FlowerDoro download in this release." }
    public var updateInstallFailed: String { language == .vietnamese ? "Không thể cài đặt bản cập nhật." : "Could not install the update." }
    public var updateInstallFallback: String { language == .vietnamese ? "Đã tải bản cập nhật. Finder sẽ mở để bạn kéo FlowerDoro vào Applications." : "The update was downloaded. Finder will open so you can drag FlowerDoro to Applications." }

    public func latestRelease(_ name: String) -> String {
        language == .vietnamese ? "Mới nhất: \(name)" : "Latest: \(name)"
    }

    public func installUpdateTitle(_ name: String) -> String {
        language == .vietnamese ? "Cài đặt \(name)?" : "Install \(name)?"
    }

    public func installUpdateMessage(_ name: String) -> String {
        if language == .vietnamese {
            return "FlowerDoro sẽ tải \(name), thay app hiện tại, rồi mở lại."
        }
        return "FlowerDoro will download \(name), replace the current app, then reopen."
    }

    public func releaseFailureMessage(_ message: String) -> String {
        switch message {
        case ReleaseUpdateChecker.FailureMessage.unreachable:
            releaseUnreachable
        case ReleaseUpdateChecker.FailureMessage.invalidLink:
            releaseInvalidLink
        case ReleaseUpdateChecker.FailureMessage.checkFailed:
            releaseCheckFailed
        default:
            message
        }
    }

    public func gardenTitle(userName: String) -> String {
        if userName == "You" {
            return language == .vietnamese ? "Vườn của bạn" : "Your Garden"
        }
        return language == .vietnamese ? "Vườn của \(userName)" : "\(userName)'s Garden"
    }

    public func page(_ current: Int, _ total: Int) -> String {
        language == .vietnamese ? "Trang \(current) / \(total)" : "Page \(current) / \(total)"
    }

    public func collectedCount(_ count: Int) -> String {
        language == .vietnamese ? "\(count) đã sưu tầm" : "\(count) collected"
    }

    public func focusMinutes(_ minutes: Int) -> String {
        language == .vietnamese ? "\(minutes) phút" : "\(minutes)m"
    }

    public func flowerBookPageAccessibility(_ name: String, unlocked: Bool) -> String {
        if unlocked {
            return language == .vietnamese ? "Trang sách hoa \(name)" : "\(name) flower book page"
        }
        return language == .vietnamese ? "Trang sách hoa bị khóa" : "Locked flower book page"
    }

    public func flowerRewardAccessibility(_ name: String, minutes: Int) -> String {
        language == .vietnamese ? "\(name) nhận được sau \(minutes) phút tập trung" : "\(name) earned from \(minutes) minutes of focus"
    }

    public func phaseTitle(_ phase: FocusPhase) -> String {
        switch phase {
        case .work:
            focus
        case .break:
            breakTime
        }
    }

    public func clockStyleName(_ style: ClockStyle) -> String {
        switch style {
        case .outline:
            language == .vietnamese ? "Viền mảnh" : "Outline"
        case .petal:
            language == .vietnamese ? "Cánh hoa" : "Petal"
        case .gardenBed:
            language == .vietnamese ? "Luống hoa" : "Garden Bed"
        }
    }

    public func flowerInfo(_ kind: FlowerKind) -> FlowerLocalizedInfo {
        switch language {
        case .english:
            kind.englishInfo
        case .vietnamese:
            kind.vietnameseInfo
        }
    }
}
