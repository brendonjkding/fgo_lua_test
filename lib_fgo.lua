function init()
-- 适用屏幕参数
    SCREEN_RESOLUTION="750x1334";
    SCREEN_COLOR_BITS=32;
    rotateScreen(0);

--指令卡选择坐标
    card_x={222,222,222,222,222,542,542,542}--1,2,3,4,5,np
    card_y={150,400,680,940,1200,454,689,951}--266

--技能坐标
    skill_x={ 150,150,150,
        150,150,150,
        150,150,150,
        425,425,425 }
    skill_y={ 70,170,270,
        400,500,600,
        735,835,935,
        943,1038,1134}
    master_skill_x=418
    master_skill_y=1251

--从者坐标
    servant_x=281
    servant_y={}
    servant_y["a"]=344
    servant_y["b"]=671
    servant_y["c"]=1011

--卡色取色坐标 卡上不被英灵挡住的点
    color_start_x=54
    color_start_y={7}
    color_end_x=265
    color_end_y={284}
    for i=2,5 do
        color_start_y[i]=color_start_y[i-1]+268
        color_end_y[i]=color_end_y[i-1]+268
    end
--敌人坐标
    enemy_x=700
    enemy_y={47,305,548}

--打手取色
    feature_start_x=171
    feature_start_y={24}
    feature_end_x=357
    feature_end_y={256}
    for i=2,5 do
        feature_start_y[i]=feature_start_y[i-1]+268
        feature_end_y[i]=feature_end_y[i-1]+268
    end
    --技能释放延迟
    if is_speed_up=="是" then
        delay_=1200
    else
        delay_=3000
    end
    mc_points={}
    mc_points["午餐"]={ 0x67B180, -27, 4, 0xEFEBE2, -7, 64, 0xF3C8BC, -23, 98, 0x493438, 3, 138, 0x67AF82, -6, 131, 0xA0D898, -24, 138, 0xFBFC84, -32, 137, 0xB1F3D5, -26, 141, 0xF5F9BB }
    mc_points["擦汗"]={ 0x7EA75B, 20, -7, 0xF2ECCF, 29, 24, 0xF5D9D8, 22, 61, 0x9A6ACB, 27, 77, 0xCDA49A, 30, 109, 0x597027, 2, 120, 0xA2C24F, 3, 124, 0xEBF1B2, 7, 120, 0xF9FA44 }
    mc_points["qp"]={ 0xBF8E69, 21, 10, 0x435DCB, 2, 44, 0x283B56, 10, 69, 0xF9D9A1, 9, 94, 0x1A1F2B, 3, 131, 0xFDFB5C, -1, 132, 0xB8D55E, 22, 115, 0xD3EEFA }
    support_points={}
    support_points["孔明"]={ 0xFAF4D6, -6, 4, 0x716256, -3, 15, 0xFBF5D5, -31, 11, 0xDEC4A2, -33, -59, 0xBFEFD6, 36, -15, 0x4C5D59 }
    support_points["梅林"]={ 0x739EE3, 43, 47, 0x6D4B7C, 46, 66, 0xF3D6D9, 54, 81, 0x1D1B68, 41, 104, 0xAEAAE2, 47, 141, 0xFFF0EF }
    support_points["cba"]={ 0xD099F5, 44, -4, 0xDEC9F4, 45, 26, 0x793561, 45, 41, 0xAF0E19, 28, 51, 0xFEFFE1, 45, 86, 0xB10B12 }

    current_turn=1
end
function init_m()
    skills={}
    skills[1]=Split(skill_serial_1," ")
    skills[2]=Split(skill_serial_2," ")
    skills[3]=Split(skill_serial_3," ")
    np_index={}
    np_index[1]=tonumber(np_index_1)+5
    np_index[2]=tonumber(np_index_2)+5
    np_index[3]=tonumber(np_index_3)+5
    --notifyMessage(mode_)
    if mode_=="绿卡" then
        mode="green"
    else
        mode="red"
    end

    if shuffle_cloth=="是" then
        shuffled=false
    else
        shuffled=true
    end

end

function init_ata()

    skill_serial_1="7a 4a 3"
    skill_serial_2="11a 6a 5 1"
    skill_serial_3="9a 8"
    np_index_1="1"
    np_index_2="1"
    np_index_3="1"
    big_enemy="1"
    mode_="绿卡"
    shuffle_cloth="是"

end
function init_ber()
    skill_serial_1="7a 4a 2 1"
    skill_serial_2="11a 6a 3"
    skill_serial_3="9a 8 5"
    np_index_1="1"
    np_index_2="1"
    np_index_3="1"
    big_enemy="1"
    mode_="绿卡"
    shuffle_cloth="是"

end

--[[
    -------------------------------------------------------------------
    获取卡信息相关函数
    -------------------------------------------------------------------
]]--

--判断第i张卡的颜色
function get_color(i)
    
    x, y = findMultiColorInRegionFuzzy({ 0x357FFE, -2, 48, 0x56AFFE, 23, 20, 0xB0834A, 52, 13, 0xFEF9CA, 75, -31, 0x075CFE, 61, 69, 0x55C7FE }, 80, color_start_x, color_start_y[i], color_end_x, color_end_y[i]) 
    if x ~= -1 and y ~= -1 then
        return "blue"
    end
    x, y = findMultiColorInRegionFuzzy({ 0xFE5612, -7, 33, 0xFD6F1A, 2, 71, 0xFF3A1E, 68, 11, 0xFEE13A, 76, 67, 0xFE6B1F }, 80, color_start_x, color_start_y[i], color_end_x, color_end_y[i]) 
    if x ~= -1 and y ~= -1 then
        return "red"
    end
    return "green"
end
--卡信息初始化
function info_init()
    --是否已选
    used={false,false,false,false,false}
    --本轮各色色卡的序号
    q_index={}
    a_index={}
    b_index={}
    --本轮各色色卡的数量
    q_num=0
    a_num=0
    b_num=0
    --打手卡数
    count=0

    --是否为打手卡
    is_dashou={true,true,true,true,true}
    --卡色
    color={}
    --是否有cba的红卡
    has_sup_b=false
end
--区分打手与拐
function get_card_info()
    if dashou=="通用" then

        for i=1,5 do
            repeat
                x, y = findMultiColorInRegionFuzzy({ 0xFEFEE6, -1, -16, 0x985598, -6, -28, 0xFEFEED, -5, -35, 0xDE1616, -10, -42, 0xFEFEED }, 90, feature_start_x, feature_start_y[i], feature_end_x, feature_end_y[i]);
                if x ~= -1 and y ~= -1 then  
                    is_dashou[i]=false
                    break
                end
                ----[[
                x, y = findMultiColorInRegionFuzzy({ 0xFFCC77, 24, -3, 0x445555, 18, -17, 0xFFEEDD, 15, -26, 0xD5CCBB, 11, -29, 0xFFEEDD }, 90, feature_start_x, feature_start_y[i], feature_end_x, feature_end_y[i]);
                if x ~= -1 and y ~= -1 then  
                    is_dashou[i]=false
                    break
                end
                --]]--
            until true
        end
    else

        for i=1,5 do
            x, y = findMultiColorInRegionFuzzy(color_points, 80, feature_start_x, feature_start_y[i], feature_end_x, feature_end_y[i]);
            if x ~= -1 and y ~= -1 then  -- 如果找到了
                is_dashou[i]=true   -- 点击那个点
            else
                is_dashou[i]=false
            end
        end
    end
end

--提取打手卡信息
function get_dashou_info()
    for i=1,5 do
        color[i]=get_color(i)
        if is_dashou[i]==true then
            if color[i]=="green" then
                q_num=q_num+1
                q_index[q_num]=i
            elseif color[i]=="blue" then
                a_num=a_num+1
                a_index[a_num]=i
            else
                b_num=b_num+1
                b_index[b_num]=i
            end
            count=count+1
        else
            if color[i]=="red" then
                has_sup_b=true
            end
        end
    end
end
function get_info()
    keepScreen(true)
    info_init()
    get_card_info()
    get_dashou_info()
    keepScreen(false)
end



--[[
    -------------------------------------------------------------------
    选卡逻辑相关函数
    -------------------------------------------------------------------
]]--

--没决定第一张卡时考虑首红
function choose_first()
    if index[1]~=0 then
        return
    end

    local x=1
    for i=1,5 do
        if not used[i] and color[i]=="red" and not is_dashou[i] then
            index[x]=i
            used[i]=true
            return
        end
    end
    for i=1,5 do
        if not used[i] and color[i]=="red" then
            index[x]=i
            used[i]=true
            return
        end
    end

end

function choose_card_blue(x)
    if a_num>0 then
        if not used[a_index[a_num]] then
            index[x]=a_index[a_num]
            used[a_index[a_num]]=true
            a_num=a_num-1
            return
        end

    elseif q_num>0 then
        if not used[q_index[q_num]] then
            index[x]=q_index[q_num]
            used[q_index[q_num]]=true
            q_num=q_num-1
            return
        end
    elseif b_num>0 then
        if not used[b_index[b_num]] then
            index[x]=b_index[b_num]
            used[b_index[b_num]]=true
            b_num=b_num-1
            return
        end
    end
    for i=1,5 do
        if not used[i] and color[i]=="red" then
            index[x]=i
            used[i]=true
            return
        end
    end
    for i=1,5 do
        if not used[i] and color[i]=="blue" then
            index[x]=i
            used[i]=true
            return
        end
    end
    for i=1,5 do
        if not used[i] and color[i]=="green" then
            index[x]=i
            used[i]=true
            return
        end
    end
end


--决定第x张卡
function choose_card_green(x)
    if q_num>0 then
        if not used[q_index[q_num]] then
            index[x]=q_index[q_num]
            used[q_index[q_num]]=true
            q_num=q_num-1
            return
        end
    elseif b_num>0 then
        if not used[b_index[b_num]] then
            index[x]=b_index[b_num]
            used[b_index[b_num]]=true
            b_num=b_num-1
            return
        end
    elseif a_num>0 then
        if not used[a_index[a_num]] then
            index[x]=a_index[a_num]
            used[a_index[a_num]]=true
            a_num=a_num-1
            return
        end
    else
        for i=1,5 do
            if not used[i] and color[i]=="green" then
                index[x]=i
                used[i]=true
                return
            end
        end
        for i=1,5 do
            if not used[i] and color[i]=="red" then
                index[x]=i
                used[i]=true
                return
            end
        end
        for i=1,5 do
            if not used[i] and color[i]=="blue" then
                index[x]=i
                used[i]=true
                return
            end
        end
    end

end
--
function choose_card_red(x)
    if b_num>0 then
        if not used[b_index[b_num]] then
            index[x]=b_index[b_num]
            used[b_index[b_num]]=true
            b_num=b_num-1
            return
        end
    elseif a_num>0 then
        if not used[a_index[a_num]] then
            index[x]=a_index[a_num]
            used[a_index[a_num]]=true
            a_num=a_num-1
            return
        end
    elseif q_num>0 then
        if not used[q_index[q_num]] then
            index[x]=q_index[q_num]
            used[q_index[q_num]]=true
            q_num=q_num-1
            return
        end
    else
        for i=1,5 do
            if not used[i] and color[i]=="red" then
                index[x]=i
                used[i]=true
                return
            end
        end
        for i=1,5 do
            if not used[i] and color[i]=="blue" then
                index[x]=i
                used[i]=true
                return
            end
        end
        for i=1,5 do
            if not used[i] and color[i]=="green" then
                index[x]=i
                used[i]=true
                return
            end
        end
    end
end



--带宝具选卡
function select_np(t,is_debug)


    index={0,0,0}

    if count>=2 then
        --绿卡模式考虑首红
        if b_num>=1 and mode=="green" then--有红
            index[1]=b_index[b_num]
            b_num=b_num-1
            used[index[1]]=true

            index[2]=np_index[t]
        else
            index[1]=np_index[t]
        end
    elseif count==1 then
        if b_num==1 then
            if not has_sup_b and mode=="green" then--有红没拐红
                index[1]=b_index[b_num]
                b_num=b_num-1
                used[index[1]]=true

            end
            index[2]=np_index[t]
        else
            if has_sup_b and mode=="green" then
                index[2]=np_index[t]
            else
                index[1]=np_index[t]
            end

        end
    else
        --绿卡队3t需洗牌
        if sp=="cba" and t==3 and shuffled==false then
            if is_debug then
                return false
            end
            return true
        end
    end
    if count==1 then
        choose_first()
    end
    for i=3,1,-1 do
        if index[i]==0 then

            if mode=="green" then
                choose_card_green(i)
            elseif mode=="red" then
                choose_card_red(i)
            else
                choose_card_blue(i)
            end

        end
    end
    if is_debug then
        notifyMessage(string.format("%d %d %d",index[1],index[2],index[3]))
    else
        select_card(index[1],index[2],index[3])
    end
    return false

end
--3t的操作
function turn_3(is_debug)
    if not is_debug then
        click_enemy(big_enemy)
    end
    click_skills(3)
    click_attack()
    --获取卡信息
    get_info()
    --调试
    if is_debug then
        local t=2500
        notifyMessage(string.format("%s %s %s %s %s",is_dashou[1],is_dashou[2],is_dashou[3],is_dashou[4],is_dashou[5]),t);
        notifyMessage(string.format("%s %s %s %s %s",color[1],color[2],color[3],color[4],color[5]),t);
        notifyMessage(string.format("b:%d a:%d q:%d count:%d",b_num,a_num,q_num,count),t);
    end


    --3t选卡
    local need_shuffle=select_np(3,is_debug)
    ----[[
    if need_shuffle then
        shuffle()
        shuffled=true
        get_info()
        select_np(3,is_debug)


    end
    --wait_attack_end()
end



--XJB打
function select_normal(t)
    index={0,0,0}
    if count>=3 then
        if b_num==1 then--有红
            index[1]=b_index[b_num]
            b_num=b_num-1
            used[index[1]]=true
        end
    elseif count>=1 then--1 2
        if b_num==1 then--有红
            if has_sup_b==false then--有红没拐红
                index[1]=b_index[b_num]
                b_num=b_num-1
                used[index[1]]=true
            end
        end
    else
        if sp=="cba" and t==4 and shuffled==false then
            return true
        end

    end
    if count<=2 then
        choose_first()
    end
    for i=3,1,-1 do
        if index[i]==0 then
            choose_card_red(i)
        end
    end
    --notifyMessage(string.format("%d %d %d",index[1],index[2],index[3]))
    select_card(index[1],index[2],index[3])
    return false

end
--4t操作
function turn_4(is_debug)
    if is_debug then
        return
    end

    while not battle_ended() do
        --attack
        click_attack()
        get_info()
        need_shuffle=select_normal(4)
        if need_shuffle then
            shuffle()
            shuffled=true
            get_info()
            need_shuffle=select_normal(4)
        end
    end

end


function wait_battle_start()
    while true do
        x, y = findMultiColorInRegionFuzzy({ 0xFEDF6A, 0, 25, 0xEAEAEA, 39, 103, 0x0061C1, 30, 112, 0x998974, 23, 121, 0x0E49A3 }, 90, 3, 980, 180 , 1213);
        if x ~= -1 and y ~= -1 then  -- attack
            return 
        end
        mSleep(5000)
    end
end
--战斗是否结束
function battle_ended()
    while true do
        x, y = findMultiColorInRegionFuzzy({ 0xFEDF6A, 0, 25, 0xEAEAEA, 39, 103, 0x0061C1, 30, 112, 0x998974, 23, 121, 0x0E49A3 }, 90, 3, 980, 180 , 1213);
        if x ~= -1 and y ~= -1 then  -- 出现attack没结束
            return false
        end

        x, y = findMultiColorInRegionFuzzy({ 0xE6B421, 0, 17, 0xE8B720, 4, 44, 0xDBB425, 4, 73, 0xEAC328, -2, 85, 0xEDBB22, 7, 110, 0xF4CA28 }, 90,529, 74, 580, 255);
        if x ~= -1 and y ~= -1 then  -- 出现与从者的羁绊则结束
            return true
        end
        mSleep(5000)
    end
end



--[[
    -------------------------------------------------------------------
    死操作
    -------------------------------------------------------------------
]]--
function select_skill(index,target)
    local delay_i=1500
    local delay_t=1000


    --按御主技能
    if index>=10 then
        touchDown(5, master_skill_x, master_skill_y)
        mSleep(33);
        touchMove(5, master_skill_x, master_skill_y)
        mSleep(34);
        touchUp(5)
        mSleep(1200)
    end
    --notifyMessage(index)
    a_x=skill_x[index]
    a_y=skill_y[index]

    --按技能
    mSleep(delay_i);
    touchDown(5, a_x, a_y)
    mSleep(33);
    touchMove(5, a_x, a_y)
    mSleep(34);
    touchUp(5)

    if not target then
        mSleep(delay_)
        return
    end
    b_x=servant_x
    b_y=servant_y[target]

    --选目标
    mSleep(1500);
    touchDown(3, b_x, b_y)
    mSleep(33);
    touchMove(3, b_x, b_y)
    mSleep(33);
    touchUp(3)

    mSleep(delay_)

end



--根据序号选卡
function select_card(a,b,c)
    a_x=card_x[a]
    a_y=card_y[a]
    b_x=card_x[b]
    b_y=card_y[b]
    c_x=card_x[c]
    c_y=card_y[c]


    mSleep(500);
    touchDown(5, a_x, a_y)
    mSleep(33);
    touchMove(5, a_x, a_y)
    mSleep(34);
    touchUp(5)

    mSleep(551);
    touchDown(3, b_x, b_y)
    mSleep(33);
    touchMove(3, b_x, b_y)
    mSleep(33);
    touchUp(3)

    mSleep(517);
    touchDown(4, c_x, c_y)
    mSleep(49);
    touchUp(4)
end
function click_skills(t)
    for j,v in pairs(skills[t]) do
        local index=get_skill_index(v)
        local target=get_skill_target(v)
        if index==nil then
            break
        end

        if target~="" then
            select_skill(index,target)
        else
            select_skill(index)
        end
    end
end

--1t 2t
function turn_1(is_debug,need_skip)
    if is_debug or need_skip then
        return
    end
    for i=1,2 do
        --点技能
        click_skills(i)
        
        click_attack()
        get_info()
        select_np(i)
        wait_attack_end()
        
        while get_current_turn() ==i do
            click_attack()
            get_info()
            select_normal()
            wait_attack_end()
        end

    end
end

--(返回) 洗牌 (attack)
function shuffle()
    --返回
    click(35,1253)
    
    select_skill(12)

    click_attack()

end
--连点三下右下角退出战斗
function quit_battle()
    mSleep(1184);
    touchDown(4, 42, 1143)
    mSleep(83);
    touchUp(4)

    mSleep(1184);
    touchDown(4, 42, 1143)
    mSleep(83);
    touchUp(4)

    mSleep(1184);
    touchDown(4, 42, 1143)
    mSleep(83);
    touchUp(4)

    mSleep(1184);
    touchDown(4, 106, 340)
    mSleep(83);
    touchUp(4)
end
--点击attack进入选卡界面
function click_attack()
    mSleep(1000);
    touchDown(3, 88, 1164)
    mSleep(64);
    touchUp(3)

    mSleep(2000);
end
function click_enemy(index)
    index=tonumber(index)
    click(enemy_x, enemy_y[index])
end

function click(x,y)
    mSleep(2000);
    touchDown(3, x, y)
    mSleep(64);
    touchUp(3)
end


--[[
    -------------------------------------------------------------------
    输入信息处理相关函数
    -------------------------------------------------------------------
]]--
function Split(szFullString, szSeparator)  
    local nFindStartIndex = 1  
    local nSplitIndex = 1  
    local nSplitArray = {}  
    while true do  
        local nFindLastIndex = string.find(szFullString, szSeparator, nFindStartIndex)  
        if not nFindLastIndex then  
            nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, string.len(szFullString))  
            break  
        end  
        nSplitArray[nSplitIndex] = string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)  
        nFindStartIndex = nFindLastIndex + string.len(szSeparator)  
        nSplitIndex = nSplitIndex + 1  
    end  
    return nSplitArray  
end
function get_skill_index(s)
    local index=string.gsub(s, "%D","")  
    return tonumber(index)
end

function get_skill_target(s)
    local target=string.gsub(s,"%A","")
    return target
end
--[[
    -------------------------------------------------------------------
    全自动相关
    -------------------------------------------------------------------
]]--
function get_current_turn()
    keepScreen(true)
    x, y = findMultiColorInRegionFuzzy({ 0xE1E1E1, 2, 3, 0xF9F9F8, 3, 5, 0xFEFFFE, -1, 5, 0xEFEFEF, -6, 5, 0xEFEFEF, -11, 5, 0xEFEFEF }, 90, 716, 908, 730, 913);
    if x ~= -1 and y ~= -1 then  -- 如果找到了
        keepScreen(false)
        return 1
    end
    x, y = findMultiColorInRegionFuzzy({ 0xE9E9E9, 1, 5, 0xF5F5F5, 1, 8, 0xF3F3F3, -3, 10, 0xF8F8F7, -8, 6, 0xFDFEFD, -15, 0, 0xF7F7F7, -16, 7, 0xE6E6E6 }, 90, 714, 905, 731, 915);
    if x ~= -1 and y ~= -1 then  -- 如果找到了
        keepScreen(false)
        return 2
    end
    x, y = findMultiColorInRegionFuzzy({ 0xEFEFEF, 1, 5, 0xF4F4F4, -1, 9, 0xF8F8F7, -7, 4, 0xE8E8E8, -12, 10, 0xF9FAF9, -16, 4, 0xE9E9E9, -14, 0, 0xD7D7D7 }, 90, 714, 905, 731, 915);
    if x ~= -1 and y ~= -1 then  -- 如果找到了
        keepScreen(false)
        return 3
    end
    keepScreen(false)
    return 4
end

function wait_attack_end()
    while true do
        x, y = findMultiColorInRegionFuzzy({ 0xFEDF6A, 0, 25, 0xEAEAEA, 39, 103, 0x0061C1, 30, 112, 0x998974, 23, 121, 0x0E49A3 }, 90, 3, 980, 180 , 1213);
        if x ~= -1 and y ~= -1 then  -- attack
            return false
        end
        mSleep(5000)
    end
end

--进本
function enter_mission()
    click(563,999)
    if sp_mode=="自动" then
        select_support()
        click(39,1240)
    end
    wait_battle_start()
end
function wait_exit_mission()
    while true do
        x, y = findMultiColorInRegionFuzzy({ 0x4E71A3, 41, 8, 0x59A9E3, 27, 43, 0xD9DADC, 32, 78, 0x0B0E19, 22, 103, 0xD2D3D6, 28, 123, 0x182341, 21, 144, 0xD6D6D6 }, 90, 15, 1135, 56, 1279);
        if x ~= -1 and y ~= -1 then  -- 如果找到了
            return
        end
        mSleep(5000)
    end
end

function select_support()
    mSleep(1500)
    while true do
        x, y = findMultiColorInRegionFuzzy(mc_points[mc], 80, 134, 25, 561, 240);
        if x ~= -1 and y ~= -1 then  -- 如果找到了礼装
            x, y = findMultiColorInRegionFuzzy(support_points[sp], 80, 134, 25, 561, 240);
            if x ~= -1 and y ~= -1 then  -- 如果找到了英灵
                if sp=="cba" then --cba技能是否满了
                    --notifyMessage(string.format("%d %d",x,y))


                    xx, yy = findMultiColorInRegionFuzzy({ 0xFEFFFE, -1, 2, 0xFEFFFE, -9, 3, 0xFEFFFE, -11, 15, 0xFEFFFE, -5, 11, 0xFEFFFE, -3, 19, 0xFEFFFE, 3, 15, 0xFEFFFE }, 80, x-87, 1021, x-13, 1082);
                    if xx~=-1 and yy~=-1 then  -- 如果找到了
                        touchDown(0, x, y);   -- 点击那个点
                        touchUp(0);
                        mSleep(1000)
                        return
                    end
                else--其它直接选
                    touchDown(0, x, y);   -- 点击那个点
                    touchUp(0);
                    mSleep(1000)
                    return

                end



            end
        end
        move_support()
        x, y = findMultiColorInRegionFuzzy({ 0xF7F8FB, 21, 0, 0xEAEBF0 }, 90, 24, 1292, 45, 1292);
        if x ~= -1 and y ~= -1 then  -- 如果到底了
            refresh_support()
        end

    end

end
function move_support()


    touchDown(5, 100, 770)
    mSleep(34);

    local dx=15
    for i=1,20 do
        touchMove(5, 100+dx, 770)
        mSleep(30);
        dx=dx+15
    end

    touchUp(5)


    mSleep(2000);
end
function refresh_support()
    click(612,881)
    click(162,870)
end
