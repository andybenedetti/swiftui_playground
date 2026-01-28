import SwiftUI

struct ContentView: View {
    @State private var searchText = ""

    var sortedCategories: [ComponentCategory] {
        ComponentCategory.allCases.sorted { $0.rawValue < $1.rawValue }
    }

    var filteredCategories: [(ComponentCategory, [ComponentItem])] {
        if searchText.isEmpty {
            return sortedCategories.map { ($0, $0.components.sorted { $0.name < $1.name }) }
        }

        return sortedCategories.compactMap { category in
            let filtered = category.components.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }.sorted { $0.name < $1.name }
            return filtered.isEmpty ? nil : (category, filtered)
        }
    }

    var body: some View {
        NavigationStack {
            List {
                if searchText.isEmpty {
                    ForEach(sortedCategories) { category in
                        NavigationLink(value: category) {
                            HStack {
                                Label(category.rawValue, systemImage: category.icon)
                                Spacer()
                                Text("\(category.components.count)")
                                    .font(.body.bold())
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                } else {
                    ForEach(filteredCategories, id: \.0) { category, components in
                        Section(category.rawValue) {
                            ForEach(components) { component in
                                NavigationLink(value: component.destination) {
                                    Text(component.name)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("SwiftUI Playground")
            .searchable(text: $searchText, prompt: "Search components")
            .navigationDestination(for: ComponentCategory.self) { category in
                CategoryDetailView(category: category)
            }
            .navigationDestination(for: ComponentDestination.self) { destination in
                destinationView(for: destination)
            }
        }
    }

    @ViewBuilder
    private func destinationView(for destination: ComponentDestination) -> some View {
        switch destination {
        // Animation
        case .animationCurves: AnimationCurvesPlayground()
        case .withAnimation: WithAnimationPlayground()
        case .transition: TransitionPlayground()
        case .phaseAnimator: PhaseAnimatorPlayground()
        // Charts
        case .barChart: BarChartPlayground()
        case .lineChart: LineChartPlayground()
        case .areaChart: AreaChartPlayground()
        case .pieChart: PieChartPlayground()
        // Containers
        case .form: FormPlayground()
        case .tabView: TabViewPlayground()
        case .sheet: SheetPlayground()
        case .alert: AlertPlayground()
        case .disclosureGroup: DisclosureGroupPlayground()
        case .contentUnavailableView: ContentUnavailableViewPlayground()
        // Controls
        case .button: ButtonPlayground()
        case .toggle: TogglePlayground()
        case .slider: SliderPlayground()
        case .stepper: StepperPlayground()
        case .picker: PickerPlayground()
        case .datePicker: DatePickerPlayground()
        case .colorPicker: ColorPickerPlayground()
        case .textField: TextFieldPlayground()
        case .secureField: SecureFieldPlayground()
        case .textEditor: TextEditorPlayground()
        case .progressView: ProgressViewPlayground()
        case .gauge: GaugePlayground()
        case .menu: MenuPlayground()
        case .link: LinkPlayground()
        case .shareLink: ShareLinkPlayground()
        case .multiDatePicker: MultiDatePickerPlayground()
        // Data Flow
        case .appStorage: AppStoragePlayground()
        case .binding: BindingPlayground()
        case .environment: EnvironmentPlayground()
        case .observable: ObservablePlayground()
        case .state: StatePlayground()
        // Drawing
        case .path: PathPlayground()
        case .canvas: CanvasPlayground()
        case .customShape: CustomShapePlayground()
        // Effects
        case .shadow: ShadowPlayground()
        case .blur: BlurPlayground()
        case .rotation: RotationPlayground()
        case .opacity: OpacityPlayground()
        case .scale: ScalePlayground()
        // Focus & Keyboard
        case .focusState: FocusStatePlayground()
        case .keyboardToolbar: KeyboardToolbarPlayground()
        case .submitActions: SubmitActionsPlayground()
        // Gestures
        case .tapGesture: TapGesturePlayground()
        case .longPressGesture: LongPressGesturePlayground()
        case .dragGesture: DragGesturePlayground()
        // Images
        case .image: ImagePlayground()
        case .asyncImage: AsyncImagePlayground()
        // Layout
        case .vStack: VStackPlayground()
        case .hStack: HStackPlayground()
        case .zStack: ZStackPlayground()
        case .grid: GridPlayground()
        case .spacer: SpacerPlayground()
        case .divider: DividerPlayground()
        case .viewThatFits: ViewThatFitsPlayground()
        case .timelineView: TimelineViewPlayground()
        case .geometryReader: GeometryReaderPlayground()
        // Lists
        case .list: ListPlayground()
        case .scrollView: ScrollViewPlayground()
        // Maps
        case .mapBasics: MapBasicsPlayground()
        case .mapMarkers: MapMarkersPlayground()
        case .mapCamera: MapCameraPlayground()
        // Media
        case .videoPlayer: VideoPlayerPlayground()
        case .photosPicker: PhotosPickerPlayground()
        // Modifiers
        case .frame: FramePlayground()
        case .padding: PaddingPlayground()
        case .background: BackgroundPlayground()
        case .overlay: OverlayPlayground()
        case .clipShape: ClipShapePlayground()
        // Navigation
        case .navigationLink: NavigationLinkPlayground()
        case .toolbar: ToolbarPlayground()
        case .navigationSplitView: NavigationSplitViewPlayground()
        case .navigationPath: NavigationPathPlayground()
        // Shapes
        case .rectangle: RectanglePlayground()
        case .roundedRectangle: RoundedRectanglePlayground()
        case .circle: CirclePlayground()
        case .ellipse: EllipsePlayground()
        case .capsule: CapsulePlayground()
        // Text
        case .text: TextPlayground()
        case .label: LabelPlayground()
        }
    }
}

struct CategoryDetailView: View {
    let category: ComponentCategory

    var sortedComponents: [ComponentItem] {
        category.components.sorted { $0.name < $1.name }
    }

    var body: some View {
        List {
            ForEach(sortedComponents) { component in
                NavigationLink(value: component.destination) {
                    Text(component.name)
                }
            }
        }
        .navigationTitle(category.rawValue)
    }
}

#Preview {
    ContentView()
}
