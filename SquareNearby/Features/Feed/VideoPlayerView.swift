import AVFoundation
import SwiftUI
import UIKit

/// A `UIViewRepresentable` that renders video frames from an `AVQueuePlayer`
/// using an `AVPlayerLayer` with aspect-fill gravity.
struct VideoPlayerView: UIViewRepresentable {
    let player: AVQueuePlayer?

    func makeUIView(context: Context) -> PlayerUIView {
        let view = PlayerUIView()
        view.playerLayer.videoGravity = .resizeAspectFill
        view.playerLayer.player = player
        return view
    }

    func updateUIView(_ uiView: PlayerUIView, context: Context) {
        if uiView.playerLayer.player !== player {
            uiView.playerLayer.player = player
        }
    }
}

/// A plain `UIView` whose backing layer is an `AVPlayerLayer`, which lets
/// Core Animation drive the video rendering directly.
final class PlayerUIView: UIView {

    override class var layerClass: AnyClass {
        AVPlayerLayer.self
    }

    var playerLayer: AVPlayerLayer {
        // swiftlint:disable:next force_cast
        layer as! AVPlayerLayer
    }
}
