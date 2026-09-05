//
//  Coordinator.swift
//  Samir-MiniProject
//
//  Created by Mario Pandapotan Simarmata on 05/09/26.
//

import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get }

    func start()
}
