import SwiftUI

struct PickerPlayground: View {
    @State private var selection = "Option 1"
    @State private var pickerStyle = PickerStyleOption.automatic
    @State private var options = ["Option 1", "Option 2", "Option 3"]
    @State private var label = "Choose"

    enum PickerStyleOption: String, CaseIterable {
        case automatic = "Automatic"
        case inline = "Inline"
        case menu = "Menu"
        case segmented = "Segmented"
        case wheel = "Wheel"
    }

    var body: some View {
        ComponentPage(
            title: "Picker",
            description: "A control for selecting from a set of mutually exclusive values.",
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
            pickerView
                .padding(.horizontal, 20)

            Text("Selected: \(selection)")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var pickerView: some View {
        let picker = Picker(label, selection: $selection) {
            ForEach(options, id: \.self) { option in
                Text(option).tag(option)
            }
        }

        switch pickerStyle {
        case .automatic:
            picker
        case .inline:
            picker.pickerStyle(.inline)
        case .menu:
            picker.pickerStyle(.menu)
        case .segmented:
            picker.pickerStyle(.segmented)
        case .wheel:
            picker.pickerStyle(.wheel)
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            TextFieldControl(label: "Label", text: $label)

            PickerControl(
                label: "Style",
                selection: $pickerStyle,
                options: PickerStyleOption.allCases,
                optionLabel: { $0.rawValue }
            )

            VStack(alignment: .leading, spacing: 8) {
                Text("Options")
                    .font(.caption)
                    .foregroundStyle(.secondary)

                ForEach(options.indices, id: \.self) { index in
                    HStack {
                        TextField("Option \(index + 1)", text: $options[index])
                            .textFieldStyle(.roundedBorder)

                        if options.count > 2 {
                            Button(role: .destructive) {
                                options.remove(at: index)
                                if !options.contains(selection) {
                                    selection = options.first ?? ""
                                }
                            } label: {
                                Image(systemName: "minus.circle.fill")
                            }
                        }
                    }
                }

                if options.count < 6 {
                    Button {
                        options.append("Option \(options.count + 1)")
                    } label: {
                        Label("Add Option", systemImage: "plus.circle.fill")
                    }
                }
            }
        }
    }

    private var generatedCode: String {
        var code = """
        // Picker control
        @State private var selection = "\(selection)"

        Picker("\(label)", selection: $selection) {

        """

        for option in options {
            code += "    Text(\"\(option)\").tag(\"\(option)\")\n"
        }

        code += "}"

        switch pickerStyle {
        case .automatic:
            break
        case .inline:
            code += "\n.pickerStyle(.inline)"
        case .menu:
            code += "\n.pickerStyle(.menu)"
        case .segmented:
            code += "\n.pickerStyle(.segmented)"
        case .wheel:
            code += "\n.pickerStyle(.wheel)"
        }

        return code
    }
}

#Preview {
    NavigationStack {
        PickerPlayground()
    }
}
