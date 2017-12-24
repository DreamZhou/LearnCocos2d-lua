
local MyApp = class("MyApp", cc.load("mvc").AppBase)

function MyApp:onCreate()
    math.randomseed(os.time())
	print("******************************************************************")
    local sharedDirector = cc.Director:getInstance()
    local winSize = sharedDirector:getWinSize()
    print("winsize -->",winSize.width,winSize.height);

end

return MyApp
