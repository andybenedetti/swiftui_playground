import SwiftUI

struct LabelPlayground: View {
    @State private var title = "Favorites"
    @State private var systemImage = "star.fill"
    @State private var labelStyle = LabelStyleOption.automatic

    enum LabelStyleOption: String, CaseIterable {
        case automatic = "Automatic"
        case iconOnly = "Icon Only"
        case titleOnly = "Title Only"
        case titleAndIcon = "Title and Icon"
    }

    private let commonIcons = [
        "star.fill", "heart.fill", "person.fill", "gear",
        "house.fill", "folder.fill", "doc.fill", "bell.fill",
        "envelope.fill", "phone.fill", "camera.fill", "photo.fill"
    ]

    var body: some View {
        ComponentPage(
            title: "Label",
            description: "A standard label for user interface items, consisting of an icon and a title.",
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        labelView
            .font(.title2)
    }

    @ViewBuilder
    private var labelView: some View {
        let label = Label(title, systemImage: systemImage)

        switch labelStyle {
        case .automatic:
            label
        case .iconOnly:
            label.labelStyle(.iconOnly)
        case .titleOnly:
            label.labelStyle(.titleOnly)
        case .titleAndIcon:
            label.labelStyle(.titleAndIcon)
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            TextFieldControl(label: "Title", text: $title)

            ParameterControl(label: "Icon") {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(commonIcons, id: \.self) { icon in
                            Button {
                                systemImage = icon
                            } label: {
                                Image(systemName: icon)
                                    .font(.title2)
                                    .foregroundStyle(systemImage == icon ? .blue : .secondary)
                                    .padding(8)
                                    .background(
                                        RoundedRectangle(cornerRadius: 8)
                                            .fill(systemImage == icon ? Color.blue.opacity(0.1) : Color.clear)
                                    )
                            }
                        }
                    }
                }
            }

            TextFieldControl(label: "Custom Icon Name", text: $systemImage)

            PickerControl(
                label: "Style",
                selection: $labelStyle,
                options: LabelStyleOption.allCases,
                optionLabel: { $0.rawValue }
            )
        }
    }

    private var generatedCode: String {
        var code = """
        // Label with icon
        Label("\(title)", systemImage: "\(systemImage)")
        """

        switch labelStyle {
        case .automatic:
            break
        case .iconOnly:
            code += "\n    .labelStyle(.iconOnly)"
        case .titleOnly:
            code += "\n    .labelStyle(.titleOnly)"
        case .titleAndIcon:
            code += "\n    .labelStyle(.titleAndIcon)"
        }

        return code
    }
}

#Preview {
    NavigationStack {
        LabelPlayground()
    }
}
