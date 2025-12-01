local sangres = {
    khazrael = {
        texto = "Si! estoy seguro que era ese, no seras vidente, lector?"
    },

    jade = {
        texto = "No siento que sea este precisamente, pero es bastante bueno igualmente!"
    },

    reloj = {
        texto = "Ding dong? Nah bro te has lucido en esta, pero me servira para el relato"
    }
}



return function (storyMaker, sangre)
    local data = sangres[sangre]

    if not data then
        storyMaker:Write("Del clan " .. sangre .. ", debo admitir tienes una mente ingeniosa para los nombres, lector!")
    end

    if data.texto then
        storyMaker:Write(data.texto)
    end

end