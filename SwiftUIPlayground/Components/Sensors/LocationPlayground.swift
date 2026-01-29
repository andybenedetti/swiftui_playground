import SwiftUI
import CoreLocation
import MapKit

struct LocationPlayground: View {
    // MARK: - State
    @State private var coordinate: CLLocationCoordinate2D?
    @State private var accuracy: Double = 0
    @State private var showAccuracyCircle = true
    @State private var showRawValues = false
    @State private var isTracking = false
    @State private var errorMessage: String?
    @State private var locationTask: Task<Void, Never>?

    // MARK: - Body
    var body: some View {
        ComponentPage(
            title: "Location",
            description: "Access device location using CoreLocation's async stream API. Uses CLLocationUpdate.liveUpdates() for continuous updates with MapKit visualization.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/corelocation/cllocationupdate")!,
            code: generatedCode
        ) {
            previewContent
        } controls: {
            controlsContent
        }
        .onDisappear {
            locationTask?.cancel()
        }
    }

    // MARK: - Preview
    @ViewBuilder
    private var previewContent: some View {
        if let coordinate {
            Map {
                Annotation("You", coordinate: coordinate) {
                    ZStack {
                        if showAccuracyCircle && accuracy > 0 {
                            Circle()
                                .fill(.blue.opacity(0.1))
                                .stroke(.blue.opacity(0.3), lineWidth: 1)
                                .frame(width: max(40, accuracy / 2), height: max(40, accuracy / 2))
                        }
                        Circle()
                            .fill(.blue)
                            .frame(width: 14, height: 14)
                        Circle()
                            .stroke(.white, lineWidth: 3)
                            .frame(width: 14, height: 14)
                    }
                }
            }
            .mapStyle(.standard)
            .frame(height: 250)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(alignment: .bottom) {
                if showRawValues {
                    rawValuesOverlay
                }
            }
        } else if let errorMessage {
            ContentUnavailableView {
                Label("Location Unavailable", systemImage: "location.slash")
            } description: {
                Text(errorMessage)
            } actions: {
                Button("Request Permission") {
                    startTracking()
                }
                .buttonStyle(.bordered)
            }
        } else {
            ContentUnavailableView {
                Label("Location", systemImage: "location.circle")
            } description: {
                Text(isTracking ? "Waiting for location..." : "Tap Start to begin tracking")
            } actions: {
                if !isTracking {
                    Button("Start Tracking") {
                        startTracking()
                    }
                    .buttonStyle(.borderedProminent)
                } else {
                    ProgressView()
                }
            }
        }
    }

    private var rawValuesOverlay: some View {
        VStack(alignment: .leading, spacing: 2) {
            if let coordinate {
                Text("Lat: \(coordinate.latitude, format: .number.precision(.fractionLength(6)))")
                Text("Lon: \(coordinate.longitude, format: .number.precision(.fractionLength(6)))")
                Text("Accuracy: \(accuracy, format: .number.precision(.fractionLength(1)))m")
            }
        }
        .font(.caption.monospaced())
        .padding(8)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))
        .padding(8)
    }

    // MARK: - Controls
    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            ToggleControl(label: "Show Accuracy Circle", isOn: $showAccuracyCircle)
            ToggleControl(label: "Show Raw Values", isOn: $showRawValues)

            if isTracking {
                Button("Stop Tracking", role: .destructive) {
                    stopTracking()
                }
                .buttonStyle(.bordered)
            } else {
                Button("Start Tracking") {
                    startTracking()
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }

    // MARK: - Location Logic
    private func startTracking() {
        isTracking = true
        errorMessage = nil
        locationTask = Task {
            do {
                let updates = CLLocationUpdate.liveUpdates()
                for try await update in updates {
                    if let location = update.location {
                        withAnimation {
                            coordinate = location.coordinate
                            accuracy = location.horizontalAccuracy
                        }
                    }
                }
            } catch {
                await MainActor.run {
                    errorMessage = error.localizedDescription
                    isTracking = false
                }
            }
        }
    }

    private func stopTracking() {
        locationTask?.cancel()
        locationTask = nil
        isTracking = false
    }

    // MARK: - Code Generation
    private var generatedCode: String {
        """
        import CoreLocation
        import MapKit

        // iOS 17+ async location stream
        let updates = CLLocationUpdate.liveUpdates()
        for try await update in updates {
            if let location = update.location {
                coordinate = location.coordinate
                accuracy = location.horizontalAccuracy
            }
        }

        // Display on Map
        Map {
            Annotation("You", coordinate: coordinate) {
                Circle()
                    .fill(.blue)
                    .frame(width: 14, height: 14)
            }
        }
        """
    }
}

#Preview {
    NavigationStack {
        LocationPlayground()
    }
}
