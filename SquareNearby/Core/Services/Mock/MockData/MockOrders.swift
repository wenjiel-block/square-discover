import Foundation

struct MockOrders {
    private static let menuItems = MockMenuItems.allItems

    /// Helper to find a menu item by partial name match.
    private static func item(named partialName: String) -> MenuItem? {
        menuItems.first { $0.name.localizedCaseInsensitiveContains(partialName) }
    }

    static let all: [Order] = {
        // We need to build orders from available menu items.
        // Fall back gracefully if items aren't found.
        var orders: [Order] = []

        // Order 1 - La Taqueria - placed (most recent)
        if let carneAsada = item(named: "Carne Asada Burrito"),
           let horchata = item(named: "Horchata") {
            orders.append(Order(
                merchantId: MockMerchants.laTaqueriaId,
                merchantName: "La Taqueria",
                items: [
                    OrderItem(menuItem: carneAsada, quantity: 2),
                    OrderItem(menuItem: horchata, quantity: 1),
                ],
                status: .placed,
                subtotalCents: 2 * carneAsada.priceCents + horchata.priceCents,
                taxCents: Int(round(Double(2 * carneAsada.priceCents + horchata.priceCents) * 0.0875)),
                totalCents: {
                    let sub = 2 * carneAsada.priceCents + horchata.priceCents
                    let tax = Int(round(Double(sub) * 0.0875))
                    return sub + tax
                }(),
                pickupTime: Calendar.current.date(byAdding: .minute, value: 15, to: .now),
                createdAt: Calendar.current.date(byAdding: .minute, value: -3, to: .now)!,
                estimatedReadyAt: Calendar.current.date(byAdding: .minute, value: 12, to: .now)
            ))
        }

        // Order 2 - Sakura Ramen - confirmed
        if let tonkotsu = item(named: "Tonkotsu Ramen"),
           let gyoza = item(named: "Gyoza") {
            orders.append(Order(
                merchantId: MockMerchants.sakuraRamenId,
                merchantName: "Sakura Ramen",
                items: [
                    OrderItem(menuItem: tonkotsu, quantity: 1),
                    OrderItem(menuItem: gyoza, quantity: 1),
                ],
                status: .confirmed,
                subtotalCents: tonkotsu.priceCents + gyoza.priceCents,
                taxCents: Int(round(Double(tonkotsu.priceCents + gyoza.priceCents) * 0.0875)),
                totalCents: {
                    let sub = tonkotsu.priceCents + gyoza.priceCents
                    return sub + Int(round(Double(sub) * 0.0875))
                }(),
                pickupTime: Calendar.current.date(byAdding: .minute, value: 25, to: .now),
                createdAt: Calendar.current.date(byAdding: .minute, value: -10, to: .now)!,
                estimatedReadyAt: Calendar.current.date(byAdding: .minute, value: 15, to: .now)
            ))
        }

        // Order 3 - Nonna's Kitchen - preparing
        if let cacio = item(named: "Cacio e Pepe"),
           let burrata = item(named: "Burrata"),
           let tiramisu = item(named: "Tiramisu") {
            orders.append(Order(
                merchantId: MockMerchants.nonnasKitchenId,
                merchantName: "Nonna's Kitchen",
                items: [
                    OrderItem(menuItem: cacio, quantity: 1),
                    OrderItem(menuItem: burrata, quantity: 1),
                    OrderItem(menuItem: tiramisu, quantity: 1),
                ],
                status: .preparing,
                subtotalCents: cacio.priceCents + burrata.priceCents + tiramisu.priceCents,
                taxCents: Int(round(Double(cacio.priceCents + burrata.priceCents + tiramisu.priceCents) * 0.0875)),
                totalCents: {
                    let sub = cacio.priceCents + burrata.priceCents + tiramisu.priceCents
                    return sub + Int(round(Double(sub) * 0.0875))
                }(),
                createdAt: Calendar.current.date(byAdding: .minute, value: -20, to: .now)!,
                estimatedReadyAt: Calendar.current.date(byAdding: .minute, value: 5, to: .now)
            ))
        }

        // Order 4 - The Burger Joint - ready
        if let smashBurger = item(named: "Classic Smash Burger"),
           let fries = item(named: "Hand-Cut Fries"),
           let shake = item(named: "Oreo Cookie Shake") {
            orders.append(Order(
                merchantId: MockMerchants.burgerJointId,
                merchantName: "The Burger Joint",
                items: [
                    OrderItem(menuItem: smashBurger, quantity: 2),
                    OrderItem(menuItem: fries, quantity: 1),
                    OrderItem(menuItem: shake, quantity: 2),
                ],
                status: .ready,
                subtotalCents: 2 * smashBurger.priceCents + fries.priceCents + 2 * shake.priceCents,
                taxCents: Int(round(Double(2 * smashBurger.priceCents + fries.priceCents + 2 * shake.priceCents) * 0.0875)),
                totalCents: {
                    let sub = 2 * smashBurger.priceCents + fries.priceCents + 2 * shake.priceCents
                    return sub + Int(round(Double(sub) * 0.0875))
                }(),
                createdAt: Calendar.current.date(byAdding: .minute, value: -30, to: .now)!,
                estimatedReadyAt: .now
            ))
        }

        // Order 5 - La Taqueria - pickedUp (historical)
        if let carnitasBurrito = item(named: "Carnitas Burrito"),
           let alPastorTaco = item(named: "Al Pastor Taco") {
            orders.append(Order(
                merchantId: MockMerchants.laTaqueriaId,
                merchantName: "La Taqueria",
                items: [
                    OrderItem(menuItem: carnitasBurrito, quantity: 1),
                    OrderItem(menuItem: alPastorTaco, quantity: 3),
                ],
                status: .pickedUp,
                subtotalCents: carnitasBurrito.priceCents + 3 * alPastorTaco.priceCents,
                taxCents: Int(round(Double(carnitasBurrito.priceCents + 3 * alPastorTaco.priceCents) * 0.0875)),
                totalCents: {
                    let sub = carnitasBurrito.priceCents + 3 * alPastorTaco.priceCents
                    return sub + Int(round(Double(sub) * 0.0875))
                }(),
                createdAt: Calendar.current.date(byAdding: .day, value: -2, to: .now)!
            ))
        }

        // Order 6 - Sakura Ramen - cancelled
        if let spicyMiso = item(named: "Spicy Miso") {
            orders.append(Order(
                merchantId: MockMerchants.sakuraRamenId,
                merchantName: "Sakura Ramen",
                items: [
                    OrderItem(menuItem: spicyMiso, quantity: 1),
                ],
                status: .cancelled,
                subtotalCents: spicyMiso.priceCents,
                taxCents: Int(round(Double(spicyMiso.priceCents) * 0.0875)),
                totalCents: {
                    let sub = spicyMiso.priceCents
                    return sub + Int(round(Double(sub) * 0.0875))
                }(),
                createdAt: Calendar.current.date(byAdding: .day, value: -5, to: .now)!
            ))
        }

        // Order 7 - Nonna's Kitchen - pickedUp (historical)
        if let margherita = item(named: "Margherita"),
           let bolognese = item(named: "Bolognese") {
            orders.append(Order(
                merchantId: MockMerchants.nonnasKitchenId,
                merchantName: "Nonna's Kitchen",
                items: [
                    OrderItem(menuItem: margherita, quantity: 1),
                    OrderItem(menuItem: bolognese, quantity: 1),
                ],
                status: .pickedUp,
                subtotalCents: margherita.priceCents + bolognese.priceCents,
                taxCents: Int(round(Double(margherita.priceCents + bolognese.priceCents) * 0.0875)),
                totalCents: {
                    let sub = margherita.priceCents + bolognese.priceCents
                    return sub + Int(round(Double(sub) * 0.0875))
                }(),
                createdAt: Calendar.current.date(byAdding: .day, value: -8, to: .now)!
            ))
        }

        return orders
    }()
}
