import SwiftUI

struct BikePointCard: View {
    let bikePoint: BikePoint
    //remove hardcoded distance later
    let distance: Int
    let position: CardPosition
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Card(position: position) {
                HStack(spacing: Spacing.md) {
                    VStack(alignment: .leading, spacing: Spacing.xs) {
                        Text(bikePoint.shortName)
                            .font(.headline)
                            .foregroundStyle(.textPrimary)
                            .lineLimit(1)
                            .truncationMode(.tail)
                        HStack(spacing: Spacing.sm) {
                            Text("\(distance) m")
                                .font(.caption)
                                .foregroundStyle(.textSecondary)
                            Text("\(bikePoint.nbEmptyDocks ?? 0) docks free")
                                .font(.caption)
                                .foregroundStyle(.textSecondary)
                        }
                    }
                    Spacer()
                    VStack(spacing: Spacing.xs) {
                        Text("\(bikePoint.nbStandardBikes ?? 0)")
                            .font(.headline)
                            .foregroundStyle(.textPrimary)
                        Text("bikes")
                            .font(.caption)
                            .foregroundStyle(.textSecondary)
                    }
                    VStack(spacing: Spacing.xs) {
                        Text("\(bikePoint.nbEBikes ?? 0)")
                            .font(.headline)
                            .foregroundStyle(.blue)
                        Text("e-bikes")
                            .font(.caption)
                            .foregroundStyle(.textSecondary)
                    }
                }
            }
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(bikePoint.shortName)
        .accessibilityValue(
            "\(bikePoint.nbStandardBikes ?? 0) standard bikes, " +
            "\(bikePoint.nbEBikes ?? 0) e-bikes, " +
            "\(bikePoint.nbEmptyDocks ?? 0) empty docks, " +
            "\(distance) metres away"
        )
        .accessibilityHint("Opens bike point details")
    }
}

#Preview {
    BikePointCard(
        bikePoint: BikePoint(
            id: "BikePoints_1",
            url: "/BikePoints/1",
            commonName: "River Street, Clerkenwell",
            placeType: "BikePoint",
            lat: 51.529163,
            lon: -0.10997,
            additionalProperties: [
                AdditionalProperty(
                    category: "Description",
                    key: "TerminalName",
                    sourceSystemKey: "TerminalName",
                    value: "001023",
                    modified: nil
                ),
                AdditionalProperty(
                    category: "Description",
                    key: "Installed",
                    sourceSystemKey: "Installed",
                    value: "true",
                    modified: nil
                ),
                AdditionalProperty(
                    category: "Description",
                    key: "Locked",
                    sourceSystemKey: "Locked",
                    value: "false",
                    modified: nil
                ),
                AdditionalProperty(
                    category: "Description",
                    key: "NbBikes",
                    sourceSystemKey: "NbBikes",
                    value: "12",
                    modified: nil
                ),
                AdditionalProperty(
                    category: "Description",
                    key: "NbEmptyDocks",
                    sourceSystemKey: "NbEmptyDocks",
                    value: "8",
                    modified: nil
                ),
                AdditionalProperty(
                    category: "Description",
                    key: "NbDocks",
                    sourceSystemKey: "NbDocks",
                    value: "20",
                    modified: nil
                ),
                AdditionalProperty(
                    category: "Description",
                    key: "NbStandardBikes",
                    sourceSystemKey: "NbStandardBikes",
                    value: "9",
                    modified: nil
                ),
                AdditionalProperty(
                    category: "Description",
                    key: "NbEBikes",
                    sourceSystemKey: "NbEBikes",
                    value: "3",
                    modified: nil
                ),
                AdditionalProperty(
                    category: "Description",
                    key: "Temporary",
                    sourceSystemKey: "Temporary",
                    value: "false",
                    modified: nil
                )
            ],
            children: [],
            childrenUrls: []
        ),
        distance: 120,
        position: .middle) {
            
        }
}
