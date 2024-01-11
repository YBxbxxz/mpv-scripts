-- A simple script to show multiple shaders running, in a clean list. Also hides osd messages of shader changes.
-- 显示着色器列表,隐藏着色器更改的osd消息
-- 修复新版本mpv异常,去除清除着色器的函数

sview_ov = mp.create_osd_overlay("ass-events")
shader_t = false

function slist(input)
    local fileNames = {}
    local paths = {}
	if input ~= '' then
		for path in input:gmatch("[^;]+") do
			table.insert(paths, path)
		end

		for _, path in ipairs(paths) do
			local fileName = path:match(".+/(.+)$") or path:match(".+\\(.+)$")
			if fileName then
				table.insert(fileNames, fileName)
			end
		end
		
		local listString = "{\\b1}Shaders loaded:{\\b0}"
		for i, fileName in ipairs(fileNames) do
			listString = listString .. "\n" .. i .. ") " .. fileName
		end
		sview_ov.data = listString
	else
		sview_ov.data = "{\\b1}No shaders loaded.{\\b0}"
	end
	sview_ov:update()
end

function toggle_sview()
	if shader_t then
		shader_t = false
		sview_ov:remove()
	else
		shader_t = true
		update_list()
	end
end

function update_list()
	mp.osd_message('')
	if shader_t then
		slist(mp.get_property('glsl-shaders'))
	end
end


mp.add_key_binding(nil, 'shader-view', toggle_sview)
mp.observe_property('glsl-shaders', nil, update_list)
