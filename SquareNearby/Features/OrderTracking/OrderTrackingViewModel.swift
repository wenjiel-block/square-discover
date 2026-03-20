import Foundation

@Observable
final class OrderTrackingViewModel {

    // MARK: - State

    private(set) var order: Order?
    private(set) var isLoading: Bool = false
    private(set) var error: Error?

    /// Timer task for simulating status progression.
    private var progressionTask: Task<Void, Never>?

    deinit {
        progressionTask?.cancel()
    }

    // MARK: - Loading

    /// Fetches the order and begins simulated status progression.
    func loadOrder(id: String, using orderService: any OrderServiceProtocol) async {
        guard !isLoading else { return }

        isLoading = true
        error = nil

        do {
            guard let uuid = UUID(uuidString: id) else {
                throw ServiceError.invalidInput("Invalid order ID")
            }
            let fetchedOrder = try await orderService.fetchOrder(id: uuid)
            self.order = fetchedOrder

            // Start simulated progression if the order is active
            if fetchedOrder.isActive {
                startStatusProgression()
            }
        } catch {
            self.error = error
        }

        isLoading = false
    }

    /// Refreshes the order state from the service.
    func refreshOrder(using orderService: any OrderServiceProtocol) async {
        guard let currentOrder = order else { return }

        do {
            let updated = try await orderService.fetchOrder(id: currentOrder.id)
            self.order = updated
        } catch {
            // Keep the current order state on refresh failure
        }
    }

    // MARK: - Status Progression Simulation

    /// Simulates order status changes over time for demo purposes.
    private func startStatusProgression() {
        progressionTask?.cancel()

        progressionTask = Task { [weak self] in
            // Status progression intervals in seconds
            let progressionDelays: [(OrderStatus, TimeInterval)] = [
                (.confirmed, 5),
                (.preparing, 10),
                (.ready, 15),
            ]

            for (nextStatus, delay) in progressionDelays {
                guard !Task.isCancelled else { return }

                // Wait before transitioning
                try? await Task.sleep(for: .seconds(delay))

                guard !Task.isCancelled else { return }

                // Only advance if the current status is before the next status
                guard let currentOrder = self?.order,
                      currentOrder.isActive,
                      currentOrder.status.sortOrder < nextStatus.sortOrder else {
                    return
                }

                await MainActor.run {
                    self?.order?.status = nextStatus
                }
            }
        }
    }

    /// Stops the automatic status progression.
    func stopProgression() {
        progressionTask?.cancel()
        progressionTask = nil
    }

    // MARK: - Computed Properties

    /// All statuses up to and including the current one (for timeline display).
    var completedStatuses: [OrderStatus] {
        guard let order else { return [] }
        return OrderStatus.allCases.filter { $0.sortOrder <= order.status.sortOrder && $0 != .cancelled }
    }

    /// The next expected status after the current one.
    var nextStatus: OrderStatus? {
        guard let order, order.isActive else { return nil }
        return OrderStatus.allCases.first { $0.sortOrder == order.status.sortOrder + 1 && $0 != .cancelled }
    }

    /// The active statuses to display in the timeline (excludes pickedUp and cancelled for active orders).
    var timelineStatuses: [OrderStatus] {
        if order?.status == .cancelled {
            return [.placed, .cancelled]
        }
        return [.placed, .confirmed, .preparing, .ready, .pickedUp]
    }
}
