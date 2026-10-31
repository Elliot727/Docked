import Foundation
@testable import Docked

func makeDock(
    id: String,
    name: String = "River Street , Clerkenwell",
    lat: Double = 51.529163,
    lon: Double = -0.10997
) -> BikePoint {
    BikePoint(
        id: id,
        url: "/Place/\(id)",
        commonName: name,
        placeType: "BikePoint",
        lat: lat,
        lon: lon,
        additionalProperties: [],
        children: [],
        childrenUrls: []
    )
}
