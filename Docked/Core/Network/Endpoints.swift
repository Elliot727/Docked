import NetworkKit


extension Endpoint where Response == [BikePoint] {
    static func fetchDocks() -> Self {
        Endpoint(path: "BikePoint", method: .get)
    }
}
