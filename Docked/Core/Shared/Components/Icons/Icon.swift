import SwiftUI

struct Icon: View {
    let icon: String

    var body: some View {
        Image(systemName: icon)
            .frame(width: 44, height: 44)
            .contentShape(Rectangle())
    }
}

#Preview {
    Icon(icon: "person")
}
