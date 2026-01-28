import SwiftUI

struct ColorPickerPlayground: View {
    @State private var selectedColor = Color.blue
    @State private var label = "Pick a color"
    @State private var supportsOpacity = true

    var body: some View {
        ComponentPage(
            title: "ColorPicker",
            description: "A control for selecting a color from the system color picker.",
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
            ColorPicker(label, selection: $selectedColor, supportsOpacity: supportsOpacity)
                .padding(.horizontal, 40)

            RoundedRectangle(cornerRadius: 12)
                .fill(selectedColor)
                .frame(width: 100, height: 100)
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            TextFieldControl(label: "Label", text: $label)
            ToggleControl(label: "Supports Opacity", isOn: $supportsOpacity)
        }
    }

    private var generatedCode: String {
        """
        // ColorPicker control
        @State private var selectedColor = Color.blue

        ColorPicker("\(label)", selection: $selectedColor, supportsOpacity: \(supportsOpacity))
        """
    }
}

#Preview {
    NavigationStack {
        ColorPickerPlayground()
    }
}
