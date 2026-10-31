import CoreLocation
import Foundation
// MARK: - Response root
// GET https://api.tfl.gov.uk/BikePoint
// Returns [BikePoint]

struct BikePoint: Codable, Identifiable {
    let id: String
    let url: String
    let commonName: String
    let placeType: String
    let lat: Double
    let lon: Double
    let additionalProperties: [AdditionalProperty]
    let children: [String]?          // usually empty
    let childrenUrls: [String]?      // usually empty

    // Convenient typed accessors (values arrive as strings)
    var terminalName: String? { value(for: "TerminalName") }
    var isInstalled: Bool? { boolValue(for: "Installed") }
    var isLocked: Bool? { boolValue(for: "Locked") }
    var isTemporary: Bool? { boolValue(for: "Temporary") }
    var installDate: Date? { dateValue(for: "InstallDate") }
    var removalDate: Date? { dateValue(for: "RemovalDate") }

    var nbBikes: Int? { intValue(for: "NbBikes") }
    var nbEmptyDocks: Int? { intValue(for: "NbEmptyDocks") }
    var nbDocks: Int? { intValue(for: "NbDocks") }
    var nbStandardBikes: Int? { intValue(for: "NbStandardBikes") }
    var nbEBikes: Int? { intValue(for: "NbEBikes") }

    // MARK: - Helpers
    private func value(for key: String) -> String? {
        additionalProperties.first { $0.key == key }?.value
    }

    private func intValue(for key: String) -> Int? {
        guard let raw = value(for: key), !raw.isEmpty else { return nil }
        return Int(raw)
    }

    private func boolValue(for key: String) -> Bool? {
        guard let raw = value(for: key)?.lowercased() else { return nil }
        switch raw {
        case "true": return true
        case "false": return false
        default: return nil
        }
    }

    private func dateValue(for key: String) -> Date? {
        guard let raw = value(for: key), !raw.isEmpty,
              let ms = Double(raw) else { return nil }
        return Date(timeIntervalSince1970: ms / 1000)
    }
}

extension BikePoint {
    func distance(to user: CLLocationCoordinate2D) -> CLLocationDistance {
        let userLocation = CLLocation(latitude: user.latitude, longitude: user.longitude)
        let dockLocation = CLLocation(latitude: lat, longitude: lon)
        return userLocation.distance(from: dockLocation) // metres
    }
}

struct AdditionalProperty: Codable {
    let category: String
    let key: String
    let sourceSystemKey: String
    let value: String
    let modified: String?   // ISO8601; ignore if you don't need it

    // Ignore $type
    enum CodingKeys: String, CodingKey {
        case category, key, sourceSystemKey, value, modified
    }
}
