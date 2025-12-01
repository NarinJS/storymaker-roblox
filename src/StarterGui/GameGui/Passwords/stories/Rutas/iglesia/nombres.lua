local nombres = {
    ashura = {
        texto = "Ashura! Si! Definitivamente ese era su nombre"
    },
    sukuna = {
        texto = "Sukuna tocatetas fantasmales 30000, algo asi usaremos para el relato"
    },
    asriel = {
        texto = "Se siente... mas peludo, pero funcionara para el relato"
    },
    ashborn = {
        texto = "Se siente cercano... servira para el relato"
    },
    khazrael = {
        texto = "Joder, pues lo llamaremos Khazrael Khazrael"
    },
    iglesia = {
        texto = "Muy original, no?"
    },

    archonia = {
        textos = {"{Archonia}\nNo mames, el nombre es ashura puto gilipollas",
                    "*El narrador obtiene el poder para escribir de nuevo*",
                    "Calla joder, que es mi historia, pues nuestro lector eligio \"Archonia\" "
                }
    },

    astaroth = {
        texto = "Hmmm... el nombre le queda demasiado grande a nuestro protagonista de momento, pero servira para el relato"
    },

    ataraxia = {
        texto = "Nah, no es tan viejo, pero servira para el relato"
    },

    indura = {
        textos = {"Maestro de miles, enseñado por uno, pero nuestro protagonista es autodidacta.",
                "Eso no evita que para esta historia su nombre sea tomado prestado"}
    },

    champion = {
        texto = "Realmente nuestro protagonista es alguien GOAT, este nombre le queda ni que pintado! Aunque aun algo no me convence..."
    },

    astarte = {
        textos = {"Pero la queria tanto...",
                "O eso diria si yo fuera cierto demonio, que no soy. Este amado nombre nos servira para el relato"}
    },

    ejecutor = {
        texto = "Un nombre muy letal, me gusta, servira para el relato"
    },

    thrain = {
        texto = "Un nombre muy letal, me gusta, servira para el relato"
    },

    lucifer = {
        textos = {
            "*Le cae una maldicion al lector pero el narrador le salva*",
            "En mi relato no quiero maldiciones hacia los espectadores, usaremos su nombre."
        }
    }
}

return function (storyMaker, nombre)
    local data = nombres[nombre]

    if not data then
        storyMaker:Write("Hmmm, si, " .. nombre .. ", definitivamente podria funcionar")
    end

    if data.texto then
        storyMaker:Write(data.texto)
    end

    if data.textos then
        for _, i in ipairs(data.textos) do
            storyMaker:Write(i)
            task.wait(0.5)
        end
    end
    
end