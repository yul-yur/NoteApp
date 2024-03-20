//
//  StorageManager.swift
//  NoteApp
//
//  Created by Юлия Sun on 20.03.2024.
//

import CoreData

class StorageManager {
    static let shared = StorageManager()
    

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NoteApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init() {}

    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getFetchedResultsController(entityName: String, keyForSort: String) -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let sortDescriptor = NSSortDescriptor(key: keyForSort, ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        return fetchResultsController
    }
    
    func saveNote(withTitle title: String) {
        let note = Note(context: viewContext)
        note.title = title
        note.date = Date()
        saveContext()
    }
    
    func delete(note: Note) {
        viewContext.delete(note)
        saveContext()
    }
    
    func edit(note: Note, with newTitle: String) {
        note.title = newTitle
        saveContext()
    }
}
