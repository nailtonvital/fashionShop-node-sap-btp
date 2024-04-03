using app.fashionShop from '../db/fashionShop';

service fashionShop_service {
    entity Sections        as projection on fashionShop.Sections;

    @cds.redirection.target: true
    entity Fashion_Types   as projection on fashionShop.Fashion_Types;

    entity Fashion_Items   as projection on fashionShop.Fashion_Items;
    entity Srv_FashionShop as projection on fashionShop.VC_FashionShop;
    entity F4_FashionType  as projection on fashionShop.VC_FashionType;
}

@odata.draft.enabled
annotate fashionShop.Fashion_Items with @(UI: {
    CreateHidden           : false,
    UpdateHidden           : false,
    DeleteHidden           : false,
    HeaderInfo             : {
        $Type         : 'UI.HeaderInfoType',
        TypeName      : 'Online Fashion Shop',
        TypeNamePlural: 'Online Fashion Shop',
        Title         : {Value: itemname},
        Description   : {Value: 'Online Fashion Shop'}
    },

    SelectionFields        : [
        fashionType_id,
        itemname,
        brand,
        size,
        price
    ],

    LineItem               : [
        {Value: fashionType.section.name},
        {Value: fashionType.typename},
        {Value: itemname},
        {Value: brand},
        {Value: size},
        {Value: price},
        {Value: currency_code},
    ],

    Facets                 : [
        {
            $Type : 'UI.CollectionFacet',
            ID    : '0',
            Label : 'Fashion Type & Section',
            Facets: [{
                $Type : 'UI.ReferenceFacet',
                Target: '@UI.FieldGroup#TypeSection',
            }],
        },
        {
            $Type : 'UI.CollectionFacet',
            ID    : '1',
            Label : 'Fashion Item',
            Facets: [{
                $Type : 'UI.ReferenceFacet',
                Target: '@UI.FieldGroup#FItem',
            }],
        }
    ],

    FieldGroup #TypeSection: {Data: [
        {Value: fashionType_id},
        {
            Value                  : fashionType.typename,
            ![@Common.FieldControl]: #ReadOnly
        },
        {
            Value                  : fashionType.description,
            ![@Common.FieldControl]: #ReadOnly
        },
        {
            Value                  : fashionType.section.id,
            ![@Common.FieldControl]: #ReadOnly
        },
        {
            Value                  : fashionType.section.name,
            ![@Common.FieldControl]: #ReadOnly
        }
    ]},
    FieldGroup #FItem      : {Data: [
        {Value: id},
        {Value: itemname},
        {Value: brand},
        {Value: material},
        {Value: size},
        {Value: currency_code},
        {Value: isAvailable},
    ]}
});

annotate fashionShop_service.Fashion_Items with {

    fashionType @(
        title         : 'Fashion Type',
        sap.value.list: 'fixed-values',
        Common        : {
            ValueListWithFixedValues,
            ValueList: {
                CollectionPath: 'F4_FashionType',
                Parameters    : [
                    {
                        $Type            : 'Common.ValueListParameterInOut',
                        ValueListProperty: 'fashionTypeID',
                        LocalDataProperty: fashionType_id
                    },
                    {
                        $Type            : 'Common.ValueListParameterDisplayOnly',
                        ValueListProperty: 'sectionName',
                    },
                    {
                        $Type            : 'Common.ValueListParameterDisplayOnly',
                        ValueListProperty: 'fashionTypeName',
                    },
                ]
            }
        }
    )

}
