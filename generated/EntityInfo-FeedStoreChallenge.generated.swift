// Generated using the ObjectBox Swift Generator — https://objectbox.io
// DO NOT EDIT

// swiftlint:disable all
import ObjectBox
import Foundation

// MARK: - Entity metadata


extension Cache: ObjectBox.__EntityRelatable {
    internal typealias EntityType = Cache

    internal var _id: EntityId<Cache> {
        return EntityId<Cache>(self.id.value)
    }
}

extension Cache: ObjectBox.EntityInspectable {
    internal typealias EntityBindingType = CacheBinding

    /// Generated metadata used by ObjectBox to persist the entity.
    internal static var entityInfo = ObjectBox.EntityInfo(name: "Cache", id: 1)

    internal static var entityBinding = EntityBindingType()

    fileprivate static func buildEntity(modelBuilder: ObjectBox.ModelBuilder) throws {
        let entityBuilder = try modelBuilder.entityBuilder(for: Cache.self, id: 1, uid: 164709581013642496)
        try entityBuilder.addProperty(name: "id", type: Id.entityPropertyType, flags: [.id], id: 1, uid: 5702401820512701184)
        try entityBuilder.addProperty(name: "timestamp", type: Date.entityPropertyType, id: 2, uid: 869714109721840384)

        try entityBuilder.lastProperty(id: 4, uid: 756950014483775232)
    }
}

extension Cache {
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { Cache.id == myId }
    internal static var id: Property<Cache, Id, Id> { return Property<Cache, Id, Id>(propertyId: 1, isPrimaryKey: true) }
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { Cache.timestamp > 1234 }
    internal static var timestamp: Property<Cache, Date, Void> { return Property<Cache, Date, Void>(propertyId: 2, isPrimaryKey: false) }
    /// Use `Cache.feed` to refer to this ToMany relation property in queries,
    /// like when using `QueryBuilder.and(property:, conditions:)`.

    internal static var feed: ToManyProperty<StoreFeed> { return ToManyProperty(.valuePropertyId(9)) }


    fileprivate func __setId(identifier: ObjectBox.Id) {
        self.id = Id(identifier)
    }
}

extension ObjectBox.Property where E == Cache {
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { .id == myId }

    internal static var id: Property<Cache, Id, Id> { return Property<Cache, Id, Id>(propertyId: 1, isPrimaryKey: true) }

    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { .timestamp > 1234 }

    internal static var timestamp: Property<Cache, Date, Void> { return Property<Cache, Date, Void>(propertyId: 2, isPrimaryKey: false) }

    /// Use `.feed` to refer to this ToMany relation property in queries, like when using
    /// `QueryBuilder.and(property:, conditions:)`.

    internal static var feed: ToManyProperty<StoreFeed> { return ToManyProperty(.valuePropertyId(9)) }

}


/// Generated service type to handle persisting and reading entity data. Exposed through `Cache.EntityBindingType`.
internal class CacheBinding: ObjectBox.EntityBinding {
    internal typealias EntityType = Cache
    internal typealias IdType = Id

    internal required init() {}

    internal func generatorBindingVersion() -> Int { 1 }

    internal func setEntityIdUnlessStruct(of entity: EntityType, to entityId: ObjectBox.Id) {
        entity.__setId(identifier: entityId)
    }

    internal func entityId(of entity: EntityType) -> ObjectBox.Id {
        return entity.id.value
    }

    internal func collect(fromEntity entity: EntityType, id: ObjectBox.Id,
                                  propertyCollector: ObjectBox.FlatBufferBuilder, store: ObjectBox.Store) throws {

        propertyCollector.collect(id, at: 2 + 2 * 1)
        propertyCollector.collect(entity.timestamp, at: 2 + 2 * 2)
    }

    internal func postPut(fromEntity entity: EntityType, id: ObjectBox.Id, store: ObjectBox.Store) throws {
        if entityId(of: entity) == 0 {  // New object was put? Attach relations now that we have an ID.
            let feed = ToMany<StoreFeed>.backlink(
                sourceBox: store.box(for: ToMany<StoreFeed>.ReferencedType.self),
                sourceProperty: ToMany<StoreFeed>.ReferencedType.cache,
                targetId: EntityId<Cache>(id.value))
            if !entity.feed.isEmpty {
                feed.replace(entity.feed)
            }
            entity.feed = feed
            try entity.feed.applyToDb()
        }
    }
    internal func createEntity(entityReader: ObjectBox.FlatBufferReader, store: ObjectBox.Store) -> EntityType {
        let entity = Cache()

        entity.id = entityReader.read(at: 2 + 2 * 1)
        entity.timestamp = entityReader.read(at: 2 + 2 * 2)

        entity.feed = ToMany<StoreFeed>.backlink(
            sourceBox: store.box(for: ToMany<StoreFeed>.ReferencedType.self),
            sourceProperty: ToMany<StoreFeed>.ReferencedType.cache,
            targetId: EntityId<Cache>(entity.id.value))
        return entity
    }
}



extension StoreFeed: ObjectBox.__EntityRelatable {
    internal typealias EntityType = StoreFeed

    internal var _id: EntityId<StoreFeed> {
        return EntityId<StoreFeed>(self.id.value)
    }
}

extension StoreFeed: ObjectBox.EntityInspectable {
    internal typealias EntityBindingType = StoreFeedBinding

    /// Generated metadata used by ObjectBox to persist the entity.
    internal static var entityInfo = ObjectBox.EntityInfo(name: "StoreFeed", id: 3)

    internal static var entityBinding = EntityBindingType()

    fileprivate static func buildEntity(modelBuilder: ObjectBox.ModelBuilder) throws {
        let entityBuilder = try modelBuilder.entityBuilder(for: StoreFeed.self, id: 3, uid: 1279985559828492032)
        try entityBuilder.addProperty(name: "id", type: Id.entityPropertyType, flags: [.id], id: 1, uid: 531653916369714176)
        try entityBuilder.addProperty(name: "modelId", type: String.entityPropertyType, id: 8, uid: 987271467962104320)
        try entityBuilder.addProperty(name: "description", type: String.entityPropertyType, id: 3, uid: 1494078386516337152)
        try entityBuilder.addProperty(name: "location", type: String.entityPropertyType, id: 4, uid: 2472612915786842368)
        try entityBuilder.addProperty(name: "url", type: String.entityPropertyType, id: 7, uid: 6849507745496307456)
        try entityBuilder.addToOneRelation(name: "cache", targetEntityInfo: ToOne<Cache>.Target.entityInfo, id: 9, uid: 5030882315265892864, indexId: 1, indexUid: 2084810483463286016)

        try entityBuilder.lastProperty(id: 9, uid: 5030882315265892864)
    }
}

extension StoreFeed {
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { StoreFeed.id == myId }
    internal static var id: Property<StoreFeed, Id, Id> { return Property<StoreFeed, Id, Id>(propertyId: 1, isPrimaryKey: true) }
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { StoreFeed.modelId.startsWith("X") }
    internal static var modelId: Property<StoreFeed, String, Void> { return Property<StoreFeed, String, Void>(propertyId: 8, isPrimaryKey: false) }
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { StoreFeed.description.startsWith("X") }
    internal static var description: Property<StoreFeed, String?, Void> { return Property<StoreFeed, String?, Void>(propertyId: 3, isPrimaryKey: false) }
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { StoreFeed.location.startsWith("X") }
    internal static var location: Property<StoreFeed, String?, Void> { return Property<StoreFeed, String?, Void>(propertyId: 4, isPrimaryKey: false) }
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { StoreFeed.url.startsWith("X") }
    internal static var url: Property<StoreFeed, String, Void> { return Property<StoreFeed, String, Void>(propertyId: 7, isPrimaryKey: false) }
    internal static var cache: Property<StoreFeed, EntityId<ToOne<Cache>.Target>, ToOne<Cache>.Target> { return Property(propertyId: 9) }


    fileprivate func __setId(identifier: ObjectBox.Id) {
        self.id = Id(identifier)
    }
}

extension ObjectBox.Property where E == StoreFeed {
    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { .id == myId }

    internal static var id: Property<StoreFeed, Id, Id> { return Property<StoreFeed, Id, Id>(propertyId: 1, isPrimaryKey: true) }

    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { .modelId.startsWith("X") }

    internal static var modelId: Property<StoreFeed, String, Void> { return Property<StoreFeed, String, Void>(propertyId: 8, isPrimaryKey: false) }

    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { .description.startsWith("X") }

    internal static var description: Property<StoreFeed, String?, Void> { return Property<StoreFeed, String?, Void>(propertyId: 3, isPrimaryKey: false) }

    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { .location.startsWith("X") }

    internal static var location: Property<StoreFeed, String?, Void> { return Property<StoreFeed, String?, Void>(propertyId: 4, isPrimaryKey: false) }

    /// Generated entity property information.
    ///
    /// You may want to use this in queries to specify fetch conditions, for example:
    ///
    ///     box.query { .url.startsWith("X") }

    internal static var url: Property<StoreFeed, String, Void> { return Property<StoreFeed, String, Void>(propertyId: 7, isPrimaryKey: false) }

    internal static var cache: Property<StoreFeed, ToOne<Cache>.Target.EntityBindingType.IdType, ToOne<Cache>.Target> { return Property<StoreFeed, ToOne<Cache>.Target.EntityBindingType.IdType, ToOne<Cache>.Target>(propertyId: 9) }

}


/// Generated service type to handle persisting and reading entity data. Exposed through `StoreFeed.EntityBindingType`.
internal class StoreFeedBinding: ObjectBox.EntityBinding {
    internal typealias EntityType = StoreFeed
    internal typealias IdType = Id

    internal required init() {}

    internal func generatorBindingVersion() -> Int { 1 }

    internal func setEntityIdUnlessStruct(of entity: EntityType, to entityId: ObjectBox.Id) {
        entity.__setId(identifier: entityId)
    }

    internal func entityId(of entity: EntityType) -> ObjectBox.Id {
        return entity.id.value
    }

    internal func collect(fromEntity entity: EntityType, id: ObjectBox.Id,
                                  propertyCollector: ObjectBox.FlatBufferBuilder, store: ObjectBox.Store) throws {
        let propertyOffset_modelId = propertyCollector.prepare(string: entity.modelId)
        let propertyOffset_description = propertyCollector.prepare(string: entity.description)
        let propertyOffset_location = propertyCollector.prepare(string: entity.location)
        let propertyOffset_url = propertyCollector.prepare(string: entity.url)

        propertyCollector.collect(id, at: 2 + 2 * 1)
        try propertyCollector.collect(entity.cache, at: 2 + 2 * 9, store: store)
        propertyCollector.collect(dataOffset: propertyOffset_modelId, at: 2 + 2 * 8)
        propertyCollector.collect(dataOffset: propertyOffset_description, at: 2 + 2 * 3)
        propertyCollector.collect(dataOffset: propertyOffset_location, at: 2 + 2 * 4)
        propertyCollector.collect(dataOffset: propertyOffset_url, at: 2 + 2 * 7)
    }

    internal func postPut(fromEntity entity: EntityType, id: ObjectBox.Id, store: ObjectBox.Store) throws {
        if entityId(of: entity) == 0 {  // New object was put? Attach relations now that we have an ID.
            entity.cache.attach(to: store.box(for: Cache.self))
        }
    }
    internal func setToOneRelation(_ propertyId: obx_schema_id, of entity: EntityType, to entityId: ObjectBox.Id?) {
        switch propertyId {
            case 9:
                entity.cache.targetId = (entityId != nil) ? EntityId<Cache>(entityId!) : nil
            default:
                fatalError("Attempt to change nonexistent ToOne relation with ID \(propertyId)")
        }
    }
    internal func createEntity(entityReader: ObjectBox.FlatBufferReader, store: ObjectBox.Store) -> EntityType {
        let entity = StoreFeed()

        entity.id = entityReader.read(at: 2 + 2 * 1)
        entity.modelId = entityReader.read(at: 2 + 2 * 8)
        entity.description = entityReader.read(at: 2 + 2 * 3)
        entity.location = entityReader.read(at: 2 + 2 * 4)
        entity.url = entityReader.read(at: 2 + 2 * 7)

        entity.cache = entityReader.read(at: 2 + 2 * 9, store: store)
        return entity
    }
}


/// Helper function that allows calling Enum(rawValue: value) with a nil value, which will return nil.
fileprivate func optConstruct<T: RawRepresentable>(_ type: T.Type, rawValue: T.RawValue?) -> T? {
    guard let rawValue = rawValue else { return nil }
    return T(rawValue: rawValue)
}

// MARK: - Store setup

fileprivate func cModel() throws -> OpaquePointer {
    let modelBuilder = try ObjectBox.ModelBuilder()
    try Cache.buildEntity(modelBuilder: modelBuilder)
    try StoreFeed.buildEntity(modelBuilder: modelBuilder)
    modelBuilder.lastEntity(id: 3, uid: 1279985559828492032)
    modelBuilder.lastIndex(id: 1, uid: 2084810483463286016)
    modelBuilder.lastRelation(id: 2, uid: 7487802946618554624)
    return modelBuilder.finish()
}

extension ObjectBox.Store {
    /// A store with a fully configured model. Created by the code generator with your model's metadata in place.
    ///
    /// - Parameters:
    ///   - directoryPath: The directory path in which ObjectBox places its database files for this store.
    ///   - maxDbSizeInKByte: Limit of on-disk space for the database files. Default is `1024 * 1024` (1 GiB).
    ///   - fileMode: UNIX-style bit mask used for the database files; default is `0o644`.
    ///     Note: directories become searchable if the "read" or "write" permission is set (e.g. 0640 becomes 0750).
    ///   - maxReaders: The maximum number of readers.
    ///     "Readers" are a finite resource for which we need to define a maximum number upfront.
    ///     The default value is enough for most apps and usually you can ignore it completely.
    ///     However, if you get the maxReadersExceeded error, you should verify your
    ///     threading. For each thread, ObjectBox uses multiple readers. Their number (per thread) depends
    ///     on number of types, relations, and usage patterns. Thus, if you are working with many threads
    ///     (e.g. in a server-like scenario), it can make sense to increase the maximum number of readers.
    ///     Note: The internal default is currently around 120.
    ///           So when hitting this limit, try values around 200-500.
    /// - important: This initializer is created by the code generator. If you only see the internal `init(model:...)`
    ///              initializer, trigger code generation by building your project.
    internal convenience init(directoryPath: String, maxDbSizeInKByte: UInt64 = 1024 * 1024,
                            fileMode: UInt32 = 0o644, maxReaders: UInt32 = 0, readOnly: Bool = false) throws {
        try self.init(
            model: try cModel(),
            directory: directoryPath,
            maxDbSizeInKByte: maxDbSizeInKByte,
            fileMode: fileMode,
            maxReaders: maxReaders,
            readOnly: readOnly)
    }
}

// swiftlint:enable all
