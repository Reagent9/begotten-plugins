ENT.Type = "anim";
ENT.Base = "base_gmodentity";
ENT.Author = "Reagent";
ENT.PrintName = "Dueling Leaderboard";
ENT.Spawnable = true;
ENT.AdminSpawnable = true;
ENT.Category = "Begotten";
ENT.RenderGroup = RENDERGROUP_TRANSLUCENT


function ENT:SetupDataTables()
    self:NetworkVar("String", 0, "TopText", {
        KeyName = "toptext",
        Edit = {
            type = "Generic",
            title = "Top text",
            category = "Text",
            order = 0
        }
    })

    self:NetworkVar("String", 1, "BottomText", {
        KeyName = "bottomtext",
        Edit = {
            type = "Generic",
            title = "Bottom text",
            category = "Text",
            order = 1
        }
    })

    self:NetworkVar("Vector", 0, "BackgroundColor", {
        KeyName = "backgroundcolor",
        Edit = {
            type = "VectorColor",
            title = "Background color",
            category = "Color",
            order = 0
        }
    })

    self:NetworkVar("Vector", 1, "BarColor", {
        KeyName = "barcolor",
        Edit = {
            type = "VectorColor",
            title = "Top bar color",
            category = "Color",
            order = 1
        }
    })
end