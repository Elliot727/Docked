import SwiftUI

struct ContentView: View {
    @Environment(BikePointsViewModel.self) var bikePointsViewModel
    var body: some View {
        AppBackground {
            AsyncContentView(state: bikePointsViewModel.state) { bikes in
                ScrollView {
                    VStack(spacing: 0) {
                        ForEach(Array(bikes.enumerated()), id: \.element.id) { index, bike in
                            BikePointCard(
                                bikePoint: bike,
                                distance: 120,
                                position: position(for: index, in: bikes.count)) {
                                    
                                }
                        }
                    }
                    .padding([.top, .horizontal])
                }

            } retry: {
                await bikePointsViewModel.fetchAll()
            }
        }
        .task {
            await bikePointsViewModel.fetchAll()
        }
        .refreshable {
            await bikePointsViewModel.fetchAll()
        }
    }
    private func position(for index: Int, in count: Int) -> CardPosition {
        if count == 1 { return .only }
        if index == 0 { return .top }
        if index == count - 1 { return .bottom }
        return .middle
    }
}

#Preview {
    ContentView()
}
