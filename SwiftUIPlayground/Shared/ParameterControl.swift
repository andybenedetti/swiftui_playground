import SwiftUI

struct ParameterControl<Content: View>: View {
    let label: String
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
            content()
        }
    }
}

struct SliderControl: View {
    let label: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    var step: Double? = nil
    var format: String = "%.1f"

    var body: some View {
        ParameterControl(label: "\(label): \(String(format: format, value))") {
            if let step {
                Slider(value: $value, in: range, step: step)
            } else {
                Slider(value: $value, in: range)
            }
        }
    }
}

struct PickerControl<T: Hashable>: View {
    let label: String
    @Binding var selection: T
    let options: [T]
    let optionLabel: (T) -> String
    var segmentedThreshold: Int = 5

    var body: some View {
        if options.count <= segmentedThreshold {
            ParameterControl(label: label) {
                Picker(label, selection: $selection) {
                    ForEach(options, id: \.self) { option in
                        Text(optionLabel(option)).tag(option)
                    }
                }
                .pickerStyle(.segmented)
            }
        } else {
            HStack {
                Text(label)
                Spacer()
                Picker(label, selection: $selection) {
                    ForEach(options, id: \.self) { option in
                        Text(optionLabel(option)).tag(option)
                    }
                }
                .pickerStyle(.menu)
            }
        }
    }
}

struct ToggleControl: View {
    let label: String
    @Binding var isOn: Bool

    var body: some View {
        Toggle(label, isOn: $isOn)
    }
}

struct ColorControl: View {
    let label: String
    @Binding var color: Color

    var body: some View {
        ColorPicker(label, selection: $color)
    }
}

struct TextFieldControl: View {
    let label: String
    @Binding var text: String

    var body: some View {
        ParameterControl(label: label) {
            TextField(label, text: $text)
                .textFieldStyle(.roundedBorder)
        }
    }
}

#Preview {
    Form {
        SliderControl(label: "Padding", value: .constant(16), range: 0...50)
        PickerControl(
            label: "Alignment",
            selection: .constant("leading"),
            options: ["leading", "center", "trailing"],
            optionLabel: { $0 }
        )
        ToggleControl(label: "Enabled", isOn: .constant(true))
        ColorControl(label: "Color", color: .constant(.blue))
        TextFieldControl(label: "Title", text: .constant("Hello"))
    }
}
