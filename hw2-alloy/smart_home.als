module smartHome
open smartHomeCore

fact { all a : Room | (some b : a.accessories, c : a.accessories | b.category = AccessoryCategoryOutlet && c.category = AccessoryCategoryOutlet && b != c) }
fact { all a : Room | (some b : a.accessories | b.category = AccessoryCategoryLightbulb) }
fact { all a : Room | (some b : a.accessories | b.category = AccessoryCategoryWindow) }

fact { all a : Home | (one b : a.accessories | b.category = AccessoryCategoryFan) }
fact { all a : Home | (one b : a.accessories | b.category = AccessoryCategoryAlarm) }

run {} for 20 but exactly 1 Home, exactly 4 Room, exactly 20 Accessory
