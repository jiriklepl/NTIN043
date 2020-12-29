module smartHome

sig Name {
    // TODO: I don't know what
}

sig Room {
    name : one Name,
    accessories : set Accessory
}

sig Home {
    name : one Name,
    rooms : set Room,
    accessories : set Accessory,
    services : set Service
}

sig Accessory {
    name : one Name,
    category : one AccessoryCategory,
    room : one Room,
    services: set Service
}

sig AccessoryCategory {
    // TODO
}

sig Service {
    name : one Name,
    type : one ServiceType,
    accessory : lone Accessory, // TODO: why lone and not one?
    characteristics: set Characteristic
}

sig ServiceType {
    // TODO
}

sig Characteristic {
    value : lone Value, // TODO: why lone and not one?
    type : one CharacteristicType,
    service : lone Service // TODO: why lone and not one?
}

sig CharacteristicType {
    // TODO
}
