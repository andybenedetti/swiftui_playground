import SwiftUI

struct ContentView: View {
    @State private var searchText = ""
    @State private var expandedCategories: Set<ComponentCategory> = []

    var filteredCategories: [(ComponentCategory, [ComponentItem])] {
        let sortedCategories = ComponentCategory.allCases.sorted { $0.rawValue < $1.rawValue }

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
                ForEach(filteredCategories, id: \.0) { category, components in
                    Section(isExpanded: binding(for: category)) {
                        ForEach(components) { component in
                            NavigationLink(value: component.destination) {
                                Text(component.name)
                            }
                        }
                    } header: {
                        HStack {
                            Label(category.rawValue, systemImage: category.icon)
                            Spacer()
                            Text("\(components.count)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
            .listStyle(.sidebar)
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
        case .secureField: SecureFieldPlayground()
        case .textEditor: TextEditorPlayground()
        case .progressView: ProgressViewPlayground()
        case .gauge: GaugePlayground()
        case .menu: MenuPlayground()
        case .link: LinkPlayground()
        case .shareLink: ShareLinkPlayground()
        case .multiDatePicker: MultiDatePickerPlayground()
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
        case .disclosureGroup: DisclosureGroupPlayground()
        case .contentUnavailableView: ContentUnavailableViewPlayground()
        // Shapes
        case .rectangle: RectanglePlayground()
        case .roundedRectangle: RoundedRectanglePlayground()
        case .circle: CirclePlayground()
        case .ellipse: EllipsePlayground()
        case .capsule: CapsulePlayground()
        // Effects
        case .shadow: ShadowPlayground()
        case .blur: BlurPlayground()
        case .rotation: RotationPlayground()
        case .opacity: OpacityPlayground()
        case .scale: ScalePlayground()
        // Gestures
        case .tapGesture: TapGesturePlayground()
        case .longPressGesture: LongPressGesturePlayground()
        case .dragGesture: DragGesturePlayground()
        // Animation
        case .animationCurves: AnimationCurvesPlayground()
        case .withAnimation: WithAnimationPlayground()
        case .transition: TransitionPlayground()
        case .phaseAnimator: PhaseAnimatorPlayground()
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
        // Drawing
        case .path: PathPlayground()
        case .canvas: CanvasPlayground()
        case .customShape: CustomShapePlayground()
        // Media
        case .videoPlayer: VideoPlayerPlayground()
        case .photosPicker: PhotosPickerPlayground()
        // Charts
        case .barChart: BarChartPlayground()
        case .lineChart: LineChartPlayground()
        case .areaChart: AreaChartPlayground()
        case .pieChart: PieChartPlayground()
        // Data Flow
        case .appStorage: AppStoragePlayground()
        case .binding: BindingPlayground()
        case .environment: EnvironmentPlayground()
        case .observable: ObservablePlayground()
        case .state: StatePlayground()
        // Maps
        case .mapBasics: MapBasicsPlayground()
        case .mapMarkers: MapMarkersPlayground()
        case .mapCamera: MapCameraPlayground()
        }
    }
}

#Preview {
    ContentView()
}
