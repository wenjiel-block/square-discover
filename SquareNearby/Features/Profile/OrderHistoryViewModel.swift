import Foundation

@Observable
final class OrderHistoryViewModel {
    var orders: [Order] = []
    var isLoading: Bool = false
    var error: String?

    @MainActor
    func loadOrders(using orderService: any OrderServiceProtocol) async {
        isLoading = true
        error = nil

        do {
            orders = try await orderService.fetchOrderHistory(page: 1)
        } catch {
            self.error = error.localizedDescription
        }

        isLoading = false
    }
}
