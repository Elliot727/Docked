import SwiftUI

struct Card<Content: View>: View {
    let position: CardPosition
    let content: Content

    init(
        position: CardPosition = .only,
        @ViewBuilder content: () -> Content
    ) {
        self.position = position
        self.content = content()
    }

    var body: some View {
        content
            .padding(Spacing.md)
            .background {
                UnevenRoundedRectangle(
                    topLeadingRadius: position.roundsTop ? Radii.lg : 0,
                    bottomLeadingRadius: position.roundsBottom ? Radii.lg : 0,
                    bottomTrailingRadius: position.roundsBottom ? Radii.lg : 0,
                    topTrailingRadius: position.roundsTop ? Radii.lg : 0
                )
                .fill(.surface)
            }
    }
}

enum CardPosition {
    case top, middle, bottom, only

    var roundsTop: Bool {
        self == .top || self == .only
    }

    var roundsBottom: Bool {
        self == .bottom || self == .only
    }
}
