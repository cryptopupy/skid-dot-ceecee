print("internal injected baby")


if getgenv then --// just sets getgenv env put it in a unc test duh
    return
end

local env = {}
local shadowenvs = {}

function getgenv()
    if not env._loaded then
        for k, v in pairs(getfenv(0)) do
            env[k] = v
        end
        env._loaded = true  --// this is tuff i promise
    end
    return env
end

function setgenv(env_table)
    env = env_table or {}
end

function newenv(name)
    if shadowenvs[name] then
        return shadowenvs[name]
    end
    
    local new_env = {}
    for k, v in pairs(getgenv()) do
        new_env[k] = v
    end
    new_env.newenv_ = name
    shadowenvs[name] = new_env
    return new_env
end

function restoreenv()
    env = {}
    shadowenvs = {}
end

local original_mt = getmetatable(_g)
local new_mt = original_mt or {}
local old_index = new_mt.__index

new_mt.__index = function(t, k)
    local val = env[k]
    if val ~= nil then
        return val
    elseif old_index then
        return old_index(t, k)
    else
        return rawget(t, k)
    end
end

setmetatable(_g, new_mt)
