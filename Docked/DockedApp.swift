import NetworkKit
import SwiftUI

@main
struct DockedApp: App {
    private let client = DefaultNetworkService(baseURL: URL(string: "https://api.tfl.gov.uk")!)
    private var bikePointService: BikePointService
    @State private var bikePointsViewModel: BikePointsViewModel
    
    init() {
        self.bikePointService = BikePointService(client: client)
        self.bikePointsViewModel = BikePointsViewModel(service: bikePointService)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(bikePointsViewModel)
        }
    }
}
