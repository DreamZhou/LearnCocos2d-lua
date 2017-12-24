
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

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
    closeItem:setAnchorPoint(1,1)
    closeItem:setPosition(display.right_top)

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

    --Node 
    local pnode = display.newNode()
    local childNode = display.newNode()
    --添加子节点    子节点    zOrder tag:number
    pnode:addChild(childNode,1,1)
    --获取父节点
    local parentNode = childNode:getParent()
    --获取子节点
    local children = pnode:getChildren()
    --设置大小
    pnode:setContentSize(cc.size(100,200))
    --获取大小
    print("content size ->",pnode:getContentSize().width,pnode:getContentSize().height)
    --设置坐标
    pnode:setPosition(display.center.x+100,display.center.y+100)
    --设置锚点
    pnode:setAnchorPoint(cc.p(1,1))
    --移除子节点
    pnode:removeChild(childNode)
end

return MainScene
