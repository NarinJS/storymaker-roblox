-- Lo devolvemos con el parametro storyMaker, que obtendra de el localscript
local rutas = require(script.Parent.Rutas.iglesia.index)

return function (storyMaker)

    local function Write(text)
        task.wait(0.5)
        storyMaker:Write(text)
    end

    storyMaker:Write("Habia una vez, un buen hombre, un hombre que se llamaba...\n")
    storyMaker:Escribir("Se llamaba...")
    task.wait(0.5)
    local nombre = storyMaker:GetInput("Como se llamaba?"):lower():match("^%s*(.-)%s*$")

    rutas.nombres(storyMaker, nombre)

    nombre = nombre:sub(1,1):upper() .. nombre:sub(2)

    Write(nombre .. ", nuestro buen amigo, estaba una vez, con su padre de nombre desconocido")

    Write("En una linea temporal donde todo marchaba relativamente bien, estos andaban haciendo sus labores de agricultor")

    Write("Era un dia normal, donde nuestros protagonistas disfrutaban de su sangre privilegiada")

    task.wait(0.5)
    local sangre = storyMaker:GetInput("Pero... como se llamaba ese clan? O familia de sangre, como le quieras decir"):lower():match("^%s*(.-)%s*$")

    rutas.sangre(storyMaker, sangre)

    sangre = sangre:sub(1,1):upper() .. sangre:sub(2)

    Write("Nuestro amigo " .. nombre .. " perteneciente a los " .. sangre  .. " estaba recolectando la recolecta familiar con su padre cuando de repente. . .")
    Write("Una plaga de gusanos ataca! No es gran cosa para nuestros amigos de sangre privilegiada pues, pero igualmete, les ha molestado.")
    Write("Una anecdota graciosa para ser contada en el futuro, o en alguna linea donde " .. nombre .. " sea un emperador y su padre un alto mando")
    Write("Pero nah, seguro que eso no existe, hasta la proxima!")

end