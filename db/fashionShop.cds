namespace app.fashionShop;
using {
    Currency
} from '@sap/cds/common';

type Flag : String(1);

entity Sections {
    key id: UUID @(title: 'Section ID');
        name :String(16) @(title: 'Section name');
        description: String(64) @(title: 'Section description');
}

entity Fashion_Types {
    key id: UUID @(title: 'Fashion Type ID');
        section: Association to Sections @(title: 'Section ID');
        typename :String(16) @(title: 'Fashion Type');
        description: String(64) @(title: 'Fashion Type Description');
}

entity Fashion_Items {
    key id: UUID @(title: 'Fashion Item ID');
        fashionType: Association to Fashion_Types @(title: 'Fashion Type ID');
        itemname :String(16) @(title: 'Fashion Item');
        brand :String(16) @(title: 'Brand');
        size :String(8) @(title: 'Size');
        material :String(16) @(title: 'Material');
        price: String(10) @(title: 'Price');
        currency: Currency @(title: 'Currency');
        isAvailable: Flag @(title: 'Is Available?');
}

view VC_FashionShop as select from Fashion_Items as fItem{
    fItem.fashionType.section.id as sectionId,
    fItem.fashionType.section.name as sectionName,
    fItem.fashionType.section.description as sectionDesc,
    fItem.fashionType.id as fashionTypeId,
    fItem.fashionType.typename as fashionTypeName,
    fItem.fashionType.description as fashionTypeDesc,
    fItem.id as fashionItemId,
    fItem.fashionType as fashionItemfashionType,
    fItem.itemname as fashionItemItemName,
    fItem.brand as fashionItemBrand,
    fItem.size as fashionItemSize,
    fItem.material as fashionItemMaterial,
    fItem.price as fashionItemPrice,
    fItem.currency as fashionItemCurrency,
    fItem.isAvailable as fashionItemIsAvailable,
    concat(fItem.brand, concat(' ',fItem.itemname)) as itemDetails : String(12),
    case 
        when fItem.price >= 500 then 'Premium'
        when fItem.price >= 100 and fItem.price < 500 then 'Mid-Range'
        else 'Low-Range'
    end as priceRange : String(10)
} where fItem.isAvailable = 'X';

view VC_FashionType as select from Fashion_Types as fTypes{
    fTypes.id as fashionTypeID,
    fTypes.typename as fashionTypeName,
    fTypes.section.name as sectionName
}