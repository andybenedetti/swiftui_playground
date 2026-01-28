import SwiftUI

struct StepperPlayground: View {
    @State private var value = 5
    @State private var minValue = 0
    @State private var maxValue = 10
    @State private var step = 1
    @State private var label = "Quantity"

    var body: some View {
        ComponentPage(
            title: "Stepper",
            description: "A control for incrementing or decrementing a value.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/stepper")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        Stepper("\(label): \(value)", value: $value, in: minValue...maxValue, step: step)
            .padding(.horizontal, 20)
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            TextFieldControl(label: "Label", text: $label)

            SliderControl(
                label: "Minimum",
                value: Binding(get: { Double(minValue) }, set: { minValue = Int($0) }),
                range: -10...10,
                format: "%.0f"
            )

            SliderControl(
                label: "Maximum",
                value: Binding(get: { Double(maxValue) }, set: { maxValue = Int($0) }),
                range: 1...100,
                format: "%.0f"
            )

            SliderControl(
                label: "Step",
                value: Binding(get: { Double(step) }, set: { step = Int($0) }),
                range: 1...10,
                format: "%.0f"
            )
        }
    }

    private var generatedCode: String {
        """
        @State private var value = \(value)

        Stepper("\\(\(label.lowercased().replacingOccurrences(of: " ", with: ""))): \\(value)", value: $value, in: \(minValue)...\(maxValue), step: \(step))
        """
    }
}

#Preview {
    NavigationStack {
        StepperPlayground()
    }
}
