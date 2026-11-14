-- Hidden Bar icons drawn inline in the workspace bar, so menu-bar apps
-- covered by the overlay stay one click away.
local look = require("../lib/look")

function render(ctx)
    local hidden = ctx.data.hiddenBar
    local row = { gap = 2 }
    if not hidden or not hidden.enabled then
        return ui.row(row)
    end
    for _, item in ipairs(hidden.items) do
        local w = math.max(20, math.ceil(item.w))
        row[#row + 1] = ui.stack{ key = item.id, w = w, h = 20, help = item.name,
            onClick = "hidden-bar activate " .. item.id,
            ui.box{ w = w - 2, h = 18, radius = look.radius(6), hover = look.hover },
            if item.image then ui.image{ image = item.image, w = item.w, h = item.h }
                else look.glyph{ name = "app.dashed", w = 16, h = 16, color = "secondaryForeground" } }
    end
    return ui.row(row)
end
