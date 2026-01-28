import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @State private var expandedCategories: Set<ComponentCategory> = Set(ComponentCategory.allCases)

    var filteredCategories: [(ComponentCategory, [ComponentItem])] {
        if searchText.isEmpty {
            return ComponentCategory.allCases.map { ($0, $0.components) }
        }

        return ComponentCategory.allCases.compactMap { category in
            let filtered = category.components.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
            return filtered.isEmpty ? nil : (category, filtered)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                ForEach(filteredCategories, id: \.0) { category, components in
                    Section(isExpanded: binding(for: category)) {
                        ForEach(components) { component in
                            NavigationLink(value: component.destination) {
                                Text(component.name)
                            }
                        }
                    } header: {
                        Label(category.rawValue, systemImage: category.icon)
                    }
                }
            }
            .navigationTitle("SwiftUI Playground")
            .searchable(text: $searchText, prompt: "Search components")
            .navigationDestination(for: ComponentDestination.self) { destination in
                destinationView(for: destination)
            }
        }
    }

    private func binding(for category: ComponentCategory) -> Binding<Bool> {
        Binding(
            get: { expandedCategories.contains(category) },
            set: { isExpanded in
                if isExpanded {
                    expandedCategories.insert(category)
                } else {
                    expandedCategories.remove(category)
                }
            }
        )
    }

    @ViewBuilder
    private func destinationView(for destination: ComponentDestination) -> some View {
        switch destination {
        // Controls
        case .button: ButtonPlayground()
        case .toggle: TogglePlayground()
        case .slider: SliderPlayground()
        case .stepper: StepperPlayground()
        case .picker: PickerPlayground()
        case .datePicker: DatePickerPlayground()
        case .colorPicker: ColorPickerPlayground()
        case .textField: TextFieldPlayground()
        case .progressView: ProgressViewPlayground()
        case .gauge: GaugePlayground()
        case .menu: MenuPlayground()
        // Layout
        case .vStack: VStackPlayground()
        case .hStack: HStackPlayground()
        case .zStack: ZStackPlayground()
        case .grid: GridPlayground()
        case .spacer: SpacerPlayground()
        case .divider: DividerPlayground()
        // Text & Images
        case .text: TextPlayground()
        case .label: LabelPlayground()
        case .image: ImagePlayground()
        case .asyncImage: AsyncImagePlayground()
        // Lists & Containers
        case .list: ListPlayground()
        case .scrollView: ScrollViewPlayground()
        case .form: FormPlayground()
        case .tabView: TabViewPlayground()
        case .sheet: SheetPlayground()
        case .alert: AlertPlayground()
        // Shapes
        case .rectangle: RectanglePlayground()
        case .circle: CirclePlayground()
        }
    }
}

#Preview {
    ContentView()
}
