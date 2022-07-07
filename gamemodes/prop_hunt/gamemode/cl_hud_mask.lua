local function MakeCirclePoly(_x, _y, r, points)
    local u = (_x + r * 320) - _x
    local v = (_y + r * 320) - _y

    local slices = (2 * math.pi) / points
    local poly = {}
    
    for i = 0, points - 1 do
        local angle = (slices * i) % points
        local x = _x + r * math.cos(angle)
        local y = _y + r * math.sin(angle)
        table.insert(poly, { x = x, y = y, u = u, v = v })
    end

    return poly
end

local PANEL = {}

function PANEL:Init()
    self.Avatar = vgui.Create("AvatarImage", self)
    self.Avatar:SetPaintedManually(true)
    self.material = Material("effects/flashlight001")
    self:OnSizeChanged(self:GetWide(), self:GetTall())
end

function PANEL:PerformLayout()
    self:OnSizeChanged(self:GetWide(), self:GetTall())
end

function PANEL:SetSteamID(...)
    self.Avatar:SetSteamID(...)
end

function PANEL:SetPlayer(...)
    self.Avatar:SetPlayer(...)
end

function PANEL:OnSizeChanged(w, h)
    self.Avatar:SetSize(self:GetWide(), self:GetTall())
    self.points = math.Max(self:GetWide() / 4, 32)
    self.poly = MakeCirclePoly(self:GetWide() / 2, self:GetTall() / 2, self:GetWide() / 2, self.points)
end

function PANEL:DrawMask(w, h)
    draw.NoTexture()
    surface.SetMaterial(self.material)
    surface.SetDrawColor(color_white)
    surface.DrawPoly(self.poly)
end

function PANEL:Paint(w, h)
    render.ClearStencil()
    render.SetStencilEnable(true)

    render.SetStencilWriteMask(1)
    render.SetStencilTestMask(1)

    render.SetStencilFailOperation(STENCILOPERATION_REPLACE)
    render.SetStencilPassOperation(STENCILOPERATION_ZERO)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
    render.SetStencilReferenceValue(1)

    self:DrawMask(w, h)

    render.SetStencilFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilPassOperation(STENCILOPERATION_REPLACE)
    render.SetStencilZFailOperation(STENCILOPERATION_ZERO)
    render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_EQUAL)
    render.SetStencilReferenceValue(1)

    self.Avatar:SetPaintedManually(false)
    self.Avatar:PaintManual()
    self.Avatar:SetPaintedManually(true)

    render.SetStencilEnable(false)
    render.ClearStencil()
end

vgui.Register("AvatarMask", PANEL)