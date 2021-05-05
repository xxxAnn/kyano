--[[
MIT License
Copyright (c) 2020 Kyando
Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]--


local metadata = {}
local names = {}
local __printer = print

-- Toggle for the print function
local debugMode = false

function print(...)
    if debugMode then
        __printer(...)
    end
end

string.startswith = function(self, str)
    return self:find('^' .. str) ~= nil
end

function metadata.__call(class, ...)
    local instance = setmetatable({}, self)
    for k, v in pairs(class.__dict) do instance[k] = v end --
    instance:INIT(...)
    return instance
end

function metadata.__newindex(class, k, v)
    if not k:startswith("__")  then
        print('Adding inheritable property ' .. k ..' to Class ' .. class.__name)
        class.__dict[k] = v
    else
        local x = class.__name == nil and "Unnamed" or class.__name
        print("Adding non-inheritable property " .. k .. " to Class " .. x)
        rawset(class, k ,v)
    end
end

function inherit(child, ancestor) -- ancestor is a class
    for k1, v1 in pairs(ancestor.__dict) do
        if not k1:startswith("__") or k1 == "__init" then
            print('Adding inherited property ' .. k1 .. ' from ancestor ' .. ancestor.__name)
            child.__dict[k1] = v1
        end
    end
end

return setmetatable({},
    {__call =
    function(_, name, ...)
        if names[name] ~= nil then return names[name] end -- Returns the class if it was already loaded
        print('\n--- Generating Class ---')
        print(name)
        local parents = { ... }
        parents.n = nil

        local class = setmetatable({__name = name}, metadata)
        class.__dict = { }
        local getter = {}
        if parents then
            for _, v in pairs(parents) do
                inherit(class, v)
            end
        end

        function class.__index(instance, k)
            -- Checks if INDEX exists
            if k ~= "INIT" then
                if rawget(class, "INDEX") then return rawget(class, "INDEX")(self, cls, k) end
            end
            -- Checks if this attribute is handled by the getter
            if getter[k] then return getter[k](self) end
            -- Tries to check if the table has the attribute
            if rawget(instance, k) ~= nil then
                return rawget(instance, k)
            end
            return nil
        end

        function class.__newindex(instance, k, v)
            if rawget(instance, "NEWINDEX") then return rawget(instance, "NEWINDEX")(instance, k, v) end
            return rawset(instance, k, v)
        end
        --[[
        **THE GETTER**
        any function added to the getter table will be called when trying to access an attribute
        Example:
        Imagine a class with a _name method which returns the class' name
            function getter.name(self)
                return self:_name()
            end
        This, put simply, transform a call of object:_name() to object.name
        ]]--
        class.__getter = getter
        names[name] = class
        print('------------------------\n')
        return class, getter
    end})