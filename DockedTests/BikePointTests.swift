import CoreLocation
import Foundation
import Testing
@testable import Docked

@MainActor
struct BikePointTests {
    @Test func decodesDockAndTypedProperties() throws {
        let docks = try JSONDecoder().decode([BikePoint].self, from: Data(SampleJSON.dock.utf8))
        let dock = try #require(docks.first)

        #expect(dock.id == "BikePoints_1")
        #expect(dock.commonName == "River Street , Clerkenwell")
        #expect(dock.placeType == "BikePoint")
        #expect(dock.lat == 51.529163)
        #expect(dock.lon == -0.10997)
        #expect(dock.children == [])
        #expect(dock.childrenUrls == [])

        #expect(dock.terminalName == "001023")
        #expect(dock.isInstalled == true)
        #expect(dock.isLocked == false)
        #expect(dock.isTemporary == nil)
        #expect(dock.installDate == Date(timeIntervalSince1970: 1_609_459_200))
        #expect(dock.removalDate == nil)
        #expect(dock.nbBikes == 12)
        #expect(dock.nbEmptyDocks == 8)
        #expect(dock.nbDocks == 20)
        #expect(dock.nbStandardBikes == 10)
        #expect(dock.nbEBikes == nil)
    }

    @Test func decodesWhenOptionalArraysAreMissing() throws {
        let json = """
        {
          "id": "BikePoints_2",
          "url": "/Place/BikePoints_2",
          "commonName": "Phillimore Gardens, Kensington",
          "placeType": "BikePoint",
          "lat": 51.499606,
          "lon": -0.197574,
          "additionalProperties": []
        }
        """
        let dock = try JSONDecoder().decode(BikePoint.self, from: Data(json.utf8))

        #expect(dock.children == nil)
        #expect(dock.childrenUrls == nil)
        #expect(dock.nbBikes == nil)
        #expect(dock.isInstalled == nil)
        #expect(dock.terminalName == nil)
    }

    @Test func rejectsNonNumericCountsAndUnknownBools() {
        let dock = BikePoint(
            id: "BikePoints_3",
            url: "/Place/BikePoints_3",
            commonName: "Hop Exchange, The Borough",
            placeType: "BikePoint",
            lat: 51.504581,
            lon: -0.091088,
            additionalProperties: [
                AdditionalProperty(category: "Description", key: "NbBikes", sourceSystemKey: "BikePoints", value: "twelve", modified: nil),
                AdditionalProperty(category: "Description", key: "NbEmptyDocks", sourceSystemKey: "BikePoints", value: "", modified: nil),
                AdditionalProperty(category: "Description", key: "Installed", sourceSystemKey: "BikePoints", value: "yes", modified: nil),
                AdditionalProperty(category: "Description", key: "Locked", sourceSystemKey: "BikePoints", value: "TRUE", modified: nil)
            ],
            children: nil,
            childrenUrls: nil
        )

        #expect(dock.nbBikes == nil)
        #expect(dock.nbEmptyDocks == nil)
        #expect(dock.isInstalled == nil)
        #expect(dock.isLocked == true)
    }

    @Test func distanceIsZeroAtTheDockAndGrowsWithLatitude() {
        let dock = BikePoint(
            id: "BikePoints_1",
            url: "/Place/BikePoints_1",
            commonName: "River Street , Clerkenwell",
            placeType: "BikePoint",
            lat: 51.529163,
            lon: -0.10997,
            additionalProperties: [],
            children: [],
            childrenUrls: []
        )
        let here = CLLocationCoordinate2D(latitude: dock.lat, longitude: dock.lon)
        let nearby = CLLocationCoordinate2D(latitude: dock.lat + 0.001, longitude: dock.lon)
        let farther = CLLocationCoordinate2D(latitude: dock.lat + 0.01, longitude: dock.lon)

        #expect(dock.distance(to: here) == 0)
        #expect(dock.distance(to: nearby) > 100)
        #expect(dock.distance(to: nearby) < 120)
        #expect(dock.distance(to: farther) > dock.distance(to: nearby))
    }
}

private enum SampleJSON {
    static let dock = """
    [
      {
        "$type": "Tfl.Api.Presentation.Entities.Place, Tfl.Api.Presentation.Entities",
        "id": "BikePoints_1",
        "url": "/Place/BikePoints_1",
        "commonName": "River Street , Clerkenwell",
        "placeType": "BikePoint",
        "lat": 51.529163,
        "lon": -0.10997,
        "additionalProperties": [
          {
            "$type": "Tfl.Api.Presentation.Entities.AdditionalProperties, Tfl.Api.Presentation.Entities",
            "category": "Description",
            "key": "TerminalName",
            "sourceSystemKey": "BikePoints",
            "value": "001023",
            "modified": "2024-01-01T00:00:00Z"
          },
          {"category": "Description", "key": "Installed", "sourceSystemKey": "BikePoints", "value": "true"},
          {"category": "Description", "key": "Locked", "sourceSystemKey": "BikePoints", "value": "false"},
          {"category": "Description", "key": "Temporary", "sourceSystemKey": "BikePoints", "value": "maybe"},
          {"category": "Description", "key": "InstallDate", "sourceSystemKey": "BikePoints", "value": "1609459200000"},
          {"category": "Description", "key": "RemovalDate", "sourceSystemKey": "BikePoints", "value": ""},
          {"category": "Description", "key": "NbBikes", "sourceSystemKey": "BikePoints", "value": "12"},
          {"category": "Description", "key": "NbEmptyDocks", "sourceSystemKey": "BikePoints", "value": "8"},
          {"category": "Description", "key": "NbDocks", "sourceSystemKey": "BikePoints", "value": "20"},
          {"category": "Description", "key": "NbStandardBikes", "sourceSystemKey": "BikePoints", "value": "10"},
          {"category": "Description", "key": "NbEBikes", "sourceSystemKey": "BikePoints", "value": ""}
        ],
        "children": [],
        "childrenUrls": []
      }
    ]
    """
}
