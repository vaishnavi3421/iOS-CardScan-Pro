//
//  Coordinator.swift
//  ScanCardPro
//
//  Created by Lead iOS Architect.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}
