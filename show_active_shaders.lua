-- 显示当前活动的着色器
local mp = require 'mp'
local utils = require 'mp.utils'

-- 获取当前活动的着色器列表
local function get_active_shaders()
    local shaders = mp.get_property_native("glsl-shaders")
    -- 如果没有活动着色器，返回提示信息
    if not shaders or #shaders == 0 then
        return "No active shaders"
    end
    return table.concat(shaders, ", ")
end

-- 更新OSC上显示的着色器信息
local function update_osc_shader_info()
    local shaders = get_active_shaders()
    if shaders == "No active shaders" then
        mp.osd_message(shaders, 2)  -- 显示2秒
    else
        local message = "Active Shaders:\n" .. shaders:gsub(", ", "\n")
        mp.osd_message(message, 2)  -- 显示2秒
    end
end

-- 添加按键绑定以手动触发显示着色器信息
mp.add_key_binding('e', "show-shaders", update_osc_shader_info)

-- 监听着色器变化事件
mp.observe_property("glsl-shaders", "native", function()
    update_osc_shader_info()
end)

-- 初始化时显示一次着色器信息
update_osc_shader_info()
