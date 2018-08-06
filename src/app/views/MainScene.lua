
local MainScene = class("MainScene", cc.load("mvc").ViewBase)
local _tileMap
local _player
local _layer
function MainScene:onCreate()
    -- add background image
    display.newSprite("HelloWorld.png")
        :move(display.center)
        :addTo(self)

    -- add HelloWorld label
    cc.Label:createWithSystemFont("Hello World", "Arial", 40)
        :move(display.cx, display.cy + 200)
        :addTo(self)
    --关闭按钮回调
    local function closeCallback()
        print("closeMenu Callback")
        cc.Director:getInstance():endToLua()
    end

  
    --add close munu
    local closeItem = cc.MenuItemImage:create("CloseNormal.png","CloseSelected.png")
    closeItem:registerScriptTapHandler(closeCallback)
    closeItem:setAnchorPoint(1,0)
    closeItem:setPosition(display.right_bottom)

    local closeMenu = cc.Menu:create()
    closeMenu:setPosition(display.LEFT_BOTTOM)
    closeMenu:addChild(closeItem)
             :addTo(self)

    --[[ cocos2d-lua 注册事件
    registerScriptTouchHandler       --注册触屏事件
    registerScriptTapHandler        --注册点击事件
    registerScriptHandler           --注册基本事件 包括层的进入 退出 事件
    registerScriptKeypadHandle      --注册键盘事件
    registerScriptAccelerateHandler --注册加速事件

    --]]

    -- 获取导演
    local direcotor = cc.Director:getInstance()
    local winSize = direcotor:getWinSize()
    --可以直接用display
    print("display",display.width,display.height)
    print("winSize",winSize.width,winSize.height)

    --暂停游戏
    --direcotor:pause()
    --继续游戏
    --direcotor:resume()

    -- --Node 
    -- local pnode = display.newNode()
    -- local childNode = display.newNode()
    -- --添加子节点    子节点    zOrder tag:number
    -- pnode:addChild(childNode,1,1)
    -- --获取父节点
    -- local parentNode = childNode:getParent()
    -- --获取子节点
    -- local children = pnode:getChildren()
    -- --设置大小
    -- pnode:setContentSize(cc.size(100,200))
    -- --获取大小
    -- print("content size ->",pnode:getContentSize().width,pnode:getContentSize().height)
    -- --设置坐标
    -- pnode:setPosition(display.center.x+100,display.center.y+100)
    -- --设置锚点
    -- pnode:setAnchorPoint(cc.p(1,1))
    -- --移除子节点
    -- pnode:removeChild(childNode)
    local layer = self:createLayer()
    self:addChild(layer)
end

function MainScene:createLayer()
    _layer = display.newLayer()
    -- 创建TMXTiledMap 对象
    _tileMap = cc.TMXTiledMap:create("map/MiddleMap.tmx")
    _layer:addChild(_tileMap,0,100)

    -- 通过对象层名 "objects" 获取层中对象组集合
    local group = _tileMap:getObjectGroup("objects")
    -- 从对象组中通过对象名 获得 "ninja" 对象信息 返回值是字典类型
    local spawnPoint = group:getObject("ninja")

    local x = spawnPoint["x"]
    local y = spawnPoint["y"]

    _player =display.newSprite("ninja.png")
    _player:setPosition(cc.p(x,y))
    _layer:addChild(_player,2,200)

    -- 创建一个事件监听器 OneByOne 为单点触摸
    local listener = cc.EventListenerTouchOneByOne:create()
    -- 设置是否吞没事件，在touchBegan 返回true 时 吞没
    listener:setSwallowTouches(true)
    local function touchBegan(touch ,event)
        print("touchBegan")
        return true
    end
    
    local function touchMoved(touch ,event)
        print("touchMoved")
    end
    
    local function touchEnded(touch ,event) 
        print("touchEnded")
        -- 获得 OpenGL 坐标
        local touchLocation = touch:getLocation()
        -- 转换为当前层的模型坐标系
        touchLocation = _layer:convertToNodeSpace(touchLocation)
        local playerPosX, playerPosY = _player:getPosition()
        local diff = cc.pSub(touchLocation,cc.p(playerPosX,playerPosY))
    
        -- 比较y轴差 和 x 轴差 哪个大，哪个大就延哪个轴移动
        if math.abs(diff.x) > math.abs(diff.y) then
            if diff.x > 0  then
                playerPosX = playerPosX + _tileMap:getTileSize().width
                _player:runAction(cc.FlipX:create(false))
            else
                playerPosX = playerPosX - _tileMap:getTileSize().width
                _player:runAction(cc.FlipX:create(true))
            end
        else
            if diff.y > 0 then
                playerPosY = playerPosY + _tileMap:getTileSize().height
            else
                playerPosY = playerPosY - _tileMap:getTileSize().height
            end
        end
        print("playerPos (%f, %f)",playerPosX,playerPosY)
        _player:setPosition(cc.p(playerPosX,playerPosY))
    end
    -- EVENT_TOUCH_BEGAN 事件回调函数
    listener:registerScriptHandler(touchBegan,cc.Handler.EVENT_TOUCH_BEGAN)
    -- EVENT_TOUCH_MOVED 事件回调函数
    listener:registerScriptHandler(touchMoved,cc.Handler.EVENT_TOUCH_MOVED)
    -- EVENT_TOUCHE_ENDED 事件回调函数
    listener:registerScriptHandler(touchEnded,cc.Handler.EVENT_TOUCH_ENDED)
    
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener,_layer)

    return _layer
end


return MainScene
