--[[
MIT License
Copyright (c) 2020 Kyando
Permission is hereby granted, free of charge, to any person obtaining a copy of
this file and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
of the Software, and to permit persons to whom the Software is furnished to do
so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
]]--
local logger = require("bin.utils.logs") -- External module 'logger' handles logging errors/infos/warns

local metadata = {}
local names = {}

string.startswith = function(self, str)
    return self:find('^' .. str) ~= nil
end

function metadata.__call(class, ...)
    local instance = setmetatable({}, self)
    for k, v in pairs(class.__dict) do instance[k] = v end --
    if instance.INIT ~= nil then instance:INIT(...) end
    return instance
end

function metadata.__newindex(class, k, v)
    if not k:startswith("__")  then
        logger.info('Adding instance attribute ' .. k ..' to Class ' .. class.__name)
        class.__dict[k] = v
    else
        local x = class.__name == nil and "Unnamed" or class.__name
        logger.info("Adding class attribute " .. k .. " to Class " .. x)
        rawset(class, k ,v)
    end
end

function inherit(child, ancestor) -- ancestor is a class
    for k1, v1 in pairs(ancestor.__dict) do
        if not k1:startswith("__") or k1 == "__init" then
            logger.info('Adding inherited property ' .. k1 .. ' from ancestor ' .. ancestor.__name)
            child.__dict[k1] = v1
        end
    end
end

return setmetatable({},
    {__call =
    function(_, name, ...)
        if names[name] ~= nil then return names[name] end -- Returns the class if it was already loaded
        logger.info('Attempting to create class ' .. name)
        local parents = { ... }
        parents.n = nil

        local class = setmetatable({__name = name}, metadata)
        --[[
        The dict contains variables of the class that will be transmitted to instances of it,
        but that are not accessible through the class itself. Any attribute that is added to
        the class that is not prefixed with '__' will be added to this. Attributes that *are*
        prefixed with '__' will not be added to it at all.
        ]]--
        class.__dict = {}
        local getter = {}
        --[[
        Inherits all the pairs of attributes from the given parents' __dict attribute
        This will only inherit attributes that are *instance attributes*. Hence attributes
        that were prefixed with __ will not be added here.

        Example:

            class1 = classModule("Class1")
            class1.foo = 'foo!'
            class1.__bar = 'bar!'
            class2 = classModule("Class2, class1)
            class2.foo
            >> nil
            class2.__bar
            >> nil
            class2.__dict.foo
            >> foo!
            local instanceOfClass2 = class2()
            instanceOfClass2.foo
            >> 'foo!'
        ]]--
        if parents then
            for _, v in pairs(parents) do
                inherit(class, v)
            end
        end

        function class.__index(instance, k)
            -- Checks if INDEX exists | if it does have it do the indexing
            if k ~= "INIT" then
                if rawget(class, "INDEX") then return rawget(class, "INDEX")(instance, cls, k) end
            end
            -- Checks if this attribute is handled by the getter
            if getter[k] then return getter[k](instance) end
            -- Checks the instance itself for the attributes
            if rawget(instance, k) ~= nil then
                return rawget(instance, k)
            end
            return nil
        end

        function class.__newindex(instance, k, v)
            -- Checks if NEWINDEX exists | if it does have it create the index
            if rawget(instance, "NEWINDEX") then return rawget(instance, "NEWINDEX")(instance, k, v) end
            return rawset(instance, k, v)
        end
        --[[
        any function added to the getter table will be called when trying to access an attribute
        Example:
            function getter.name(self)
                return self:_name()
            end
            -- Define _name for the class.

        This would call someInstance._name() any time someInstance.name is accessed.
        In a real situation you would like to try to get from cache and then attempt
        to get it instead.
        ]]--
        class.__getter = getter
        names[name] = class
        return class, getter
    end})