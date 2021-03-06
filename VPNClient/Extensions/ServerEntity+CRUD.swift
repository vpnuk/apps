//
//  ServerEntity+CRUD.swift
//  VPNClient
//
//  Created by Igor Kasyanenko on 21.10.2019.
//  Copyright © 2019 VPNUK. All rights reserved.
//  Distributed under the GNU GPL v3 For full terms see the file LICENSE
//

import Foundation
import CoreData

extension ServerEntity {
    static func find(byIP ip: String, in context: NSManagedObjectContext) -> ServerEntity? {
        let request = NSFetchRequest<ServerEntity>(entityName: "ServerEntity")
        request.sortDescriptors = []
        request.predicate = NSPredicate(format: "address == %@", ip)
        return try? context.fetch(request).first
    }
    
    static func find(byTypes types: [ServerType], in context: NSManagedObjectContext) -> [ServerEntity] {
        let request = NSFetchRequest<ServerEntity>(entityName: "ServerEntity")
        request.sortDescriptors = []
        let predicates = types.map { NSPredicate(format: "type == %@", $0.rawValue) }
        request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: predicates)
        request.sortDescriptors = [NSSortDescriptor(key: "type", ascending: false), NSSortDescriptor(key: "order", ascending: true), NSSortDescriptor(key: "name", ascending: true)]
        let items = (try? context.fetch(request)) ?? []
        return items
    }

    func update(withDTO dto: ServerDTO) {
        address = dto.address
        name = dto.location?.name
        icon = dto.location?.icon
        city = dto.location?.city
        dns = dto.dns
        speed = dto.speed
        type = dto.type?.rawValue
    }
    
    static func update(withDtos dtos: [ServerDTO], in context: NSManagedObjectContext, completion: @escaping () -> ()) {
        let request = NSFetchRequest<ServerEntity>(entityName: "ServerEntity")
        request.sortDescriptors = []
        let newAddresses = dtos.compactMap { $0.address }
        request.predicate = NSPredicate(format: "NOT (address IN %@)", newAddresses)
        let itemsToDelete = (try? context.fetch(request)) ?? []
        itemsToDelete.forEach { context.delete($0) }
        
        for (index, dto) in dtos.enumerated() {
            var server: ServerEntity
            if let foundServer = ServerEntity.find(byIP: dto.address!, in: context) {
                server = foundServer
            } else {
                server = ServerEntity(context: context)
            }
            server.order = Int64(index)
            server.update(withDTO: dto)
        }
        try? context.save()
        completion()
    }
}
