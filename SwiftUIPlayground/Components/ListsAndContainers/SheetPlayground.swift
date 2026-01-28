import SwiftUI

struct SheetPlayground: View {
    @State private var showSheet = false
    @State private var showFullScreen = false
    @State private var presentationStyle = PresentationStyleOption.sheet
    @State private var sheetDetent = SheetDetentOption.large
    @State private var showDragIndicator = true

    enum PresentationStyleOption: String, CaseIterable {
        case sheet = "Sheet"
        case fullScreenCover = "Full Screen Cover"
    }

    enum SheetDetentOption: String, CaseIterable {
        case medium = "Medium"
        case large = "Large"
        case fraction = "Fraction (0.3)"
    }

    var body: some View {
        ComponentPage(
            title: "Sheet",
            description: "A modal presentation that slides up from the bottom of the screen.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/swiftui/view/sheet(ispresented:ondismiss:content:)")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
        .sheet(isPresented: $showSheet) {
            sheetContent
                .presentationDetents(detents)
                .presentationDragIndicator(showDragIndicator ? .visible : .hidden)
        }
        .fullScreenCover(isPresented: $showFullScreen) {
            fullScreenContent
        }
    }

    private var detents: Set<PresentationDetent> {
        switch sheetDetent {
        case .medium:
            [.medium]
        case .large:
            [.large]
        case .fraction:
            [.fraction(0.3), .medium, .large]
        }
    }

    @ViewBuilder
    private var previewContent: some View {
        VStack(spacing: 16) {
            Button("Present \(presentationStyle.rawValue)") {
                if presentationStyle == .sheet {
                    showSheet = true
                } else {
                    showFullScreen = true
                }
            }
            .buttonStyle(.borderedProminent)
        }
    }

    @ViewBuilder
    private var sheetContent: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "hand.wave.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.blue)

                Text("Hello from Sheet!")
                    .font(.title2)

                Text("Drag down to dismiss or tap the button below")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Sheet")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        showSheet = false
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var fullScreenContent: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(systemName: "arrow.up.left.and.arrow.down.right")
                    .font(.system(size: 60))
                    .foregroundStyle(.purple)

                Text("Full Screen Cover")
                    .font(.title2)

                Text("This covers the entire screen")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Full Screen")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        showFullScreen = false
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Presentation",
                selection: $presentationStyle,
                options: PresentationStyleOption.allCases,
                optionLabel: { $0.rawValue }
            )

            if presentationStyle == .sheet {
                PickerControl(
                    label: "Detent",
                    selection: $sheetDetent,
                    options: SheetDetentOption.allCases,
                    optionLabel: { $0.rawValue }
                )

                ToggleControl(label: "Show Drag Indicator", isOn: $showDragIndicator)
            }
        }
    }

    private var generatedCode: String {
        if presentationStyle == .fullScreenCover {
            return """
            // Full screen cover presentation
            @State private var isPresented = false

            Button("Present") {
                isPresented = true
            }
            .fullScreenCover(isPresented: $isPresented) {
                ContentView()
            }
            """
        }

        var code = """
        // Sheet presentation
        @State private var isPresented = false

        Button("Present Sheet") {
            isPresented = true
        }
        .sheet(isPresented: $isPresented) {
            SheetContent()
        """

        switch sheetDetent {
        case .medium:
            code += "\n        .presentationDetents([.medium])"
        case .large:
            code += "\n        .presentationDetents([.large])"
        case .fraction:
            code += "\n        .presentationDetents([.fraction(0.3), .medium, .large])"
        }

        if !showDragIndicator {
            code += "\n        .presentationDragIndicator(.hidden)"
        }

        code += "\n}"

        return code
    }
}

#Preview {
    NavigationStack {
        SheetPlayground()
    }
}
