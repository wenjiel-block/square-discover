import AVFoundation
import Observation

@Observable
final class VideoPlayerManager {

    /// Maximum number of AVPlayer instances kept alive simultaneously.
    private let poolSize: Int = 3

    /// Maps a feed item id (UUID string) to its player + looper pair.
    private var playerPool: [String: PlayerEntry] = [:]

    /// Ordered list of item ids currently in the pool (oldest first).
    private var poolOrder: [String] = []

    /// The id of the item that is currently playing.
    private(set) var currentPlayingId: String?

    /// Global mute toggle.
    var isMuted: Bool = false {
        didSet {
            for entry in playerPool.values {
                entry.player.isMuted = isMuted
            }
        }
    }

    // MARK: - Pool Entry

    private final class PlayerEntry {
        let player: AVQueuePlayer
        var looper: AVPlayerLooper?

        init(player: AVQueuePlayer, looper: AVPlayerLooper? = nil) {
            self.player = player
            self.looper = looper
        }
    }

    // MARK: - Public API

    /// Returns the `AVQueuePlayer` for a given feed item id, or `nil` if that item
    /// is not currently in the player pool.
    func player(for itemId: String) -> AVQueuePlayer? {
        playerPool[itemId]?.player
    }

    /// Updates which players are alive and which one is playing.
    ///
    /// This keeps a sliding window of `[previous, current, next]` around the
    /// currently visible item. Players outside the window are torn down.
    func updateVisibility(
        currentId: String?,
        items: [FeedItem],
        currentIndex: Int
    ) {
        guard let currentId else { return }

        // Determine the window of item ids to keep alive.
        var windowIds: [String] = []
        let prevIndex = max(currentIndex - 1, 0)
        let nextIndex = min(currentIndex + 1, items.count - 1)

        for idx in prevIndex...nextIndex {
            let item = items[idx]
            if item.content.isVideo {
                windowIds.append(item.id.uuidString)
            }
        }

        // Ensure players exist for items in the window.
        for idx in prevIndex...nextIndex {
            let item = items[idx]
            guard item.content.isVideo else { continue }
            let key = item.id.uuidString
            if playerPool[key] == nil {
                createPlayer(for: item)
            }
        }

        // Evict players that are outside the window.
        let windowSet = Set(windowIds)
        let keysToRemove = playerPool.keys.filter { !windowSet.contains($0) }
        for key in keysToRemove {
            tearDownPlayer(for: key)
        }

        // Play the current item and pause the rest.
        currentPlayingId = currentId
        for (key, entry) in playerPool {
            if key == currentId {
                entry.player.play()
            } else {
                entry.player.pause()
            }
        }
    }

    /// Pauses all players. Useful when the feed view disappears.
    func pauseAll() {
        for entry in playerPool.values {
            entry.player.pause()
        }
        currentPlayingId = nil
    }

    /// Tears down all player resources.
    func tearDownAll() {
        for key in Array(playerPool.keys) {
            tearDownPlayer(for: key)
        }
        currentPlayingId = nil
    }

    // MARK: - Private

    private func createPlayer(for item: FeedItem) {
        let key = item.id.uuidString
        guard playerPool[key] == nil else { return }

        let playerItem = AVPlayerItem(url: item.content.url)
        let player = AVQueuePlayer(playerItem: playerItem)
        player.isMuted = isMuted
        player.automaticallyWaitsToMinimizeStalling = true

        let looper = AVPlayerLooper(player: player, templateItem: playerItem)

        let entry = PlayerEntry(player: player, looper: looper)
        playerPool[key] = entry
        poolOrder.append(key)

        // Enforce pool size -- evict the oldest entry that is not in the current window.
        trimPool()
    }

    private func tearDownPlayer(for key: String) {
        guard let entry = playerPool.removeValue(forKey: key) else { return }
        entry.player.pause()
        entry.player.removeAllItems()
        entry.looper?.disableLooping()
        entry.looper = nil
        poolOrder.removeAll { $0 == key }
    }

    private func trimPool() {
        while playerPool.count > poolSize, let oldest = poolOrder.first {
            // Do not evict the currently playing item.
            if oldest == currentPlayingId {
                poolOrder.removeFirst()
                poolOrder.append(oldest)
                continue
            }
            tearDownPlayer(for: oldest)
        }
    }
}
