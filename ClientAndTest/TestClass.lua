-- Filename: TestClass.lua 
-- Author: xupang
-- Date: 2016-04-21
-- Purpose: test


local storagePath = g_fUtils:getWritablePath().."update" --设置新文件保存的位置

local TestClass = class("TestClass",function()
	return cc.Node:create()
end)

function TestClass:ctor()
	print("dir:"..storagePath)
	self.amEx = cc.AssetsManagerEx:create("res/project.manifest",storagePath)
    self.amEx:retain()
    if not self.amEx:getLocalManifest():isLoaded() then
        print("Fail to update assets, step skipped.")
    else
	    local listener = cc.EventListenerAssetsManagerEx:create(self.amEx,function(event)
	    	self:onUpdateEvent(event)
	    end)
	    g_eDispatcher:addEventListenerWithFixedPriority(listener, 1)
	    
	    self.amEx:update()
    end
end
function TestClass:onUpdateEvent(event)
	local eCode = cc.EventAssetsManagerEx.EventCode
	local _e = event:getEventCode()
    if _e == eCode.ERROR_NO_LOCAL_MANIFEST then
        print("No local manifest file found, skip assets update.")
    elseif  _e == eCode.UPDATE_PROGRESSION then
        local assetId = event:getAssetId()
        local percent = event:getPercent()
        local strInfo = ""

        if assetId == cc.AssetsManagerExStatic.VERSION_ID then
            strInfo = string.format("Version file: %d%%", percent)
        elseif assetId == cc.AssetsManagerExStatic.MANIFEST_ID then
            strInfo = string.format("Manifest file: %d%%", percent)
        else
            strInfo = string.format("%d%%", percent)
        end
        print("update:"..strInfo)
    elseif _e == eCode.ERROR_DOWNLOAD_MANIFEST or _e == eCode.ERROR_PARSE_MANIFEST then
        print("Fail to download manifest file, update skipped.")
    elseif _e == eCode.ALREADY_UP_TO_DATE or _e == eCode.UPDATE_FINISHED then
        print("Update finished.")
    elseif _e == eCode.ERROR_UPDATING then
	    print("Asset ", event:getAssetId(), ", ", event:getMessage())
    end
end

return TestClass