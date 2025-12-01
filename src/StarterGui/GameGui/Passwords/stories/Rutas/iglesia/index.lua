local rutas = {}

for _, module in pairs(script.Parent:GetChildren()) do
    if module:IsA("ModuleScript") and module.name ~= script.name then
        rutas[module.Name] = require(module)
    end
end

return rutas
