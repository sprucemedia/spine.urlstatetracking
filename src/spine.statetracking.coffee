StateTracker = 

    modelName: null

    initStateTracking: (modelName) ->

        @modelName = modelName

        @[@modelName].bind("change", => @updateState())
        $(window).bind("hashchange", => @syncState())

        @syncState()

    updateState: ->
        state = @parseHash()

        for key of @statefields
            if @model.hasOwnProperty(key)
                    state[key] = @[@modelName][key]

        @writeHash(state)

    syncState: ->
        isDirty = false
        state = @parseHash()

        for key of @statefields
            if @statefields.hasOwnProperty(key) and state.hasOwnProperty(key)
                newValue = @parseValue(state[key], @statefields[key])
                if newValue isnt @[@modelName][key]
                    @[@modelName][key] = newValue
                    isDirty = true

        if isDirty
            @[@modelName].trigger("change")

    parseHash: ->
        hash = window.location.hash.substring(1)
        obj = {}

        if not hash? or hash is ""
            return obj

        for pair in hash.split("&")
            do (pair) ->
                split = pair.split("=")
                obj[split[0]] = split[1]

        return obj

    writeHash: (obj) ->
        hash = ''

        for key of obj
            hash += "&#{key}=#{obj[key]}"

        window.location.hash = hash.substring(1)

    parseValue: (value, type) ->
        switch(type)
            when "Int" then return parseInt(value, 10)
            when "Float" then return parseFloat(value)
            else return value

@Spine.StateTracker = StateTracker