import SwiftUI

struct ContentView: View {
    @Environment(BikePointsViewModel.self) var bikePointsViewModel
    var body: some View {
        AsyncContentView(state: bikePointsViewModel.state) { bikes in
            ScrollView {
                ForEach(bikes) {bike in
                    Text(bike.commonName)
                }
            }
        } retry: {
            await bikePointsViewModel.fetchAll()
        }
        .task {
            await bikePointsViewModel.fetchAll()
        }
    }
}

#Preview {
    ContentView()
}
