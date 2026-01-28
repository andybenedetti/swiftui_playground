import SwiftUI
import AVKit

struct VideoPlayerPlayground: View {
    @State private var player: AVPlayer?
    @State private var isPlaying = false
    @State private var videoSource = VideoSource.bunny
    @State private var showControls = true
    @State private var videoGravity = AVLayerVideoGravity.resizeAspect

    enum VideoSource: String, CaseIterable {
        case bunny = "Big Buck Bunny"
        case sintel = "Sintel Trailer"
        case tears = "Tears of Steel"

        var url: URL {
            switch self {
            case .bunny:
                URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4")!
            case .sintel:
                URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/Sintel.mp4")!
            case .tears:
                URL(string: "https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4")!
            }
        }
    }

    var body: some View {
        ComponentPage(
            title: "VideoPlayer",
            description: "Display video content with native playback controls.",
            documentationURL: URL(string: "https://developer.apple.com/documentation/avkit/videoplayer")!,
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
            if let player {
                VideoPlayer(player: player)
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(.secondary.opacity(0.2))
                    .frame(height: 200)
                    .overlay {
                        ProgressView()
                    }
            }

            HStack(spacing: 20) {
                Button {
                    player?.seek(to: .zero)
                } label: {
                    Image(systemName: "backward.fill")
                }

                Button {
                    if isPlaying {
                        player?.pause()
                    } else {
                        player?.play()
                    }
                    isPlaying.toggle()
                } label: {
                    Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                        .font(.title)
                }

                Button {
                    player?.pause()
                    isPlaying = false
                } label: {
                    Image(systemName: "stop.fill")
                }
            }
            .buttonStyle(.bordered)
        }
        .task {
            player = AVPlayer(url: videoSource.url)
        }
        .onChange(of: videoSource) { _, newValue in
            player?.pause()
            isPlaying = false
            player = AVPlayer(url: newValue.url)
        }
    }

    @ViewBuilder
    private var controlsContent: some View {
        VStack(spacing: 16) {
            PickerControl(
                label: "Video",
                selection: $videoSource,
                options: VideoSource.allCases,
                optionLabel: { $0.rawValue }
            )
        }
    }

    private var generatedCode: String {
        """
        import AVKit

        struct VideoView: View {
            @State private var player: AVPlayer?
            @State private var isPlaying = false

            var body: some View {
                VStack {
                    if let player {
                        VideoPlayer(player: player)
                            .frame(height: 200)
                    }

                    Button {
                        isPlaying ? player?.pause() : player?.play()
                        isPlaying.toggle()
                    } label: {
                        Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    }
                }
                .task {
                    let url = URL(string: "https://example.com/video.mp4")!
                    player = AVPlayer(url: url)
                }
            }
        }
        """
    }
}

#Preview {
    NavigationStack {
        VideoPlayerPlayground()
    }
}
