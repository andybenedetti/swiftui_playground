import SwiftUI

struct MenuPlayground: View {
    @State private var label = "Options"
    @State private var showIcon = true
    @State private var selectedOption = "None selected"

    private let menuOptions = ["Edit", "Duplicate", "Share", "Delete"]

    var body: some View {
        ComponentPage(
            title: "Menu",
            description: "A control for presenting a menu of actions.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/menu")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        VStack(spacing: 16) {
            Menu {
                ForEach(menuOptions, id: \.self) { option in
                    Button(option) {
                        selectedOption = option
                    }
                }

                Divider()

                Menu("More") {
                    Button("Option A") { selectedOption = "Option A" }
                    Button("Option B") { selectedOption = "Option B" }
                }
            } label: {
                if showIcon {
                    Label(label, systemImage: "ellipsis.circle")
                } else {
                    Text(label)
                }
            }

            Text("Selected: \(selectedOption)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            TextFieldControl(label: "Label", text: $label)
            ToggleControl(label: "Show Icon", isOn: $showIcon)

            Text("Menus support nested submenus, dividers, and various button styles.")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private var generatedCode: String {
        var code = """
        Menu {
            Button("Edit") { }
            Button("Duplicate") { }
            Button("Share") { }
            Button("Delete") { }

            Divider()

            Menu("More") {
                Button("Option A") { }
                Button("Option B") { }
            }
        } label: {
        """

        if showIcon {
            code += """

            Label("\(label)", systemImage: "ellipsis.circle")
        }
        """
        } else {
            code += """

            Text("\(label)")
        }
        """
        }

        return code
    }
}

#Preview {
    NavigationStack {
        MenuPlayground()
    }
}
