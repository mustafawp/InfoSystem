db = dbConnect("sqlite","destek.db")
local oyuncu
local istek
addEvent("YardimPanel:istekekle",true)
addEventHandler("YardimPanel:istekekle",root,function(gelen)
    local hesap = getAccountName(getPlayerAccount(source))
    local time = getRealTime()
    local hours = time.hour
    local minutes = time.minute
    local seconds = time.second
    local monthday = time.monthday
    local month = time.month
    local year = time.year
    local gerceksaat = string.format("%04d-%02d-%02d %02d:%02d:%02d", year + 1900, month + 1, monthday, hours, minutes, seconds)
    dbExec(db,"INSERT INTO talepler (oyuncukadi, tarih, talebi, durum) VALUES (?,?,?,?)",hesap,gerceksaat,gelen,"Cevaplanmadı")
end)

function gecmisle(veriler)
	local result = dbPoll(veriler, 0)
    triggerClientEvent(oyuncu,"YardimPanel:destekler",oyuncu,result)
end

addCommandHandler("istekoneri",function(oyusncu,cmd)
    local hesap = getAccountName(getPlayerAccount(oyusncu))
    oyuncu = oyusncu
    if not isObjectInACLGroup("user."..hesap,aclGetGroup("superman")) then return end
    dbQuery(gecmisle,db,"SELECT * FROM talepler")
end)

addEvent("YardimPanel:onerisil",true)
addEventHandler("YardimPanel:onerisil",root,function(ids)
    if tonumber(ids) >= 1 then
        dbExec(db,"DELETE FROM talepler WHERE id = ?",tonumber(ids))
        exports.hud:dm("Talep başarıyla silindi",source,255,255,255,true)
        triggerClientEvent(source,"YardimPanel:kapat",source)
    else
        exports.hud:dm("Lütfen geçerli bir talep seçin.",source,255,255,255,true)
    end
end)