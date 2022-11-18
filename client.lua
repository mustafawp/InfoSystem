local CONTROL_MARGIN_RIGHT = 5
local LINE_MARGIN = 5
local LINE_HEIGHT = 16
local g_gridListContents = {}   -- info about binded gridlists
local g_openedWindows = {}      -- {window1table = true, window2table = true, ...}
local g_protectedElements = {}
local GRIDLIST_UPDATE_CHUNK_SIZE = 10

wtablo = {}
btablo = {}
local wsayi = 0
local bsayi = 0

genelGuiTablo = {}

--guiCreateWindow
local wtablo = {}
--guiCreateButton
local btablo = {}
--guiCreateMemo
local mtablo = {}
--guiCreateEdit
local etablo = {}
--guiCreateGridList
Ltablo = {}

_guiCreateWindow = guiCreateWindow
_guiCreateButton = guiCreateButton

function resimOlustur(isim)
	if fileExists(isim.."png") then return isim.."png" end
	local texture = dxCreateTexture(1,1) 
	local pixels = dxGetTexturePixels(texture) 
	local r,g,b,a = 999,999,999,255 
	dxSetPixelColor(pixels,0,0,r,g,b,a) 
	dxSetTexturePixels(texture, pixels) 
	local pxl = dxConvertPixels(dxGetTexturePixels(texture),"png") 
	local nImg = fileCreate(isim..".png") 
	fileWrite(nImg,pxl) 
	fileClose(nImg)
	return isim..".png" 
end

function renkVer(resim,hex)
	guiSetProperty(resim,"ImageColours","tl:FF"..hex.." tr:FF"..hex.." bl:FF"..hex.." br:FF"..hex)
end

_guiCreateWindow = guiCreateWindow
function guiCreateWindow(x,y,g,u,yazi,relative,parent,renk1,renk2,renk3,renk4,kapat)
	wsayi = #wtablo +1
	
	if not renk1 or string.len(renk1) > 6 then
		renk1 =  "131314" -- window renk üst taraf
	end
	if not renk2 or string.len(renk2) > 6 then
		renk2 = "000000" -- panel adı kısmı
	end
	if not renk3 or string.len(renk3) > 6 then
		renk3 = "131314" -- window renk alt taraf
	end
	if not renk4 or string.len(renk4) > 6 then
		renk4 = "FF7F00"  -- window cerceve renk
	end
	
	if relative  then
		px,pu = guiGetSize(parent,false)
		x,y,g,u = x*px,y*pu,g*px,u*pu
		relative = false
	end
	
	if not wtablo[wsayi] then wtablo[wsayi] = {} end
	--arkaResim
	wtablo[wsayi].resim = guiCreateStaticImage(x,y,g,u,resimOlustur("test"),relative,parent)
	guiSetProperty(wtablo[wsayi].resim,"ImageColours","tl:FF"..renk1.." tr:FF"..renk1.." bl:FF"..renk1.." br:FF"..renk1.."")
	guiSetAlpha(wtablo[wsayi].resim, 0.85)
	--baslıkArka
	wtablo[wsayi].basarka = guiCreateStaticImage(0,0,g,20, resimOlustur("test"), false, wtablo[wsayi].resim)
	renkVer(wtablo[wsayi].basarka,renk3)
	--kenarlar
	wtablo[wsayi].kenarlar = {
	ordaUst = guiCreateStaticImage(0,0,g,1,resimOlustur("test"), false, wtablo[wsayi].resim),
	ortaAlt = guiCreateStaticImage(0,u-1,g,1,resimOlustur("test"), false, wtablo[wsayi].resim),
	sol = guiCreateStaticImage(0,0,1,u,resimOlustur("test"), false, wtablo[wsayi].resim),
	sag = guiCreateStaticImage(g-1,0,1,u,resimOlustur("test"), false, wtablo[wsayi].resim)}
	
	for i,v in pairs(wtablo[wsayi].kenarlar) do
		guiSetProperty(v,"ImageColours","tl:FFff7f00 tr:FFff7f00 bl:FFff7f00 br:FFff7f00")
		guiSetProperty(v, "AlwaysOnTop", "True")
		guiSetAlpha(v, 0.4)
	end	
	--baslıkLabel
	wtablo[wsayi].label = guiCreateLabel((g/2)-((string.len(yazi)*8)/2),0,(string.len(yazi)*8),20, yazi, false, wtablo[wsayi].basarka)
	guiSetFont(wtablo[wsayi].label, "default-bold-small")
	guiLabelSetHorizontalAlign(wtablo[wsayi].label, "center")
	guiLabelSetVerticalAlign(wtablo[wsayi].label, "center")

	return wtablo[wsayi].resim,wtablo[wsayi].basarka
end

function guiCreateButton(x,y,g,u,konum,relative,parent,yazi,renk)
	bsayi = bsayi +1
	if not btablo[bsayi] then btablo[bsayi] = {} end
	
	if not renk or string.len(renk) > 6 then
		renk = "131314"
	end
	--arkaResim
	if relative  then
		px,pu = guiGetSize(parent,false)
		x,y,g,u = x*px,y*pu,g*px,u*pu
	end	
	btablo[bsayi].resim = guiCreateStaticImage(x,y,g,u,resimOlustur("test"),false,parent)
	guiSetProperty(btablo[bsayi].resim,"ImageColours","tl:FF"..renk.." tr:FF"..renk.." bl:FF"..renk.." br:FF"..renk.."")
	--kenarlar
	btablo[bsayi].kenarlar = {
		ortaUst = guiCreateStaticImage(0,0,g,1,resimOlustur("test"), false, btablo[bsayi].resim),
		ortaAlt = guiCreateStaticImage(0,u-1,g,1,resimOlustur("test"), false, btablo[bsayi].resim),
		sol = guiCreateStaticImage(0,0,1,u,resimOlustur("test"), false, btablo[bsayi].resim),
		sag = guiCreateStaticImage(g-1,0,1,u,resimOlustur("test"), false, btablo[bsayi].resim)
	}
	for i,v in pairs(btablo[bsayi].kenarlar) do
		guiSetProperty(v,"ImageColours","tl:FFff7f00 tr:FFff7f00 bl:FFff7f00 br:FFff7f00")
		guiSetAlpha(v, 0.4)
	end	
	
	btablo[bsayi].label = guiCreateLabel(0,0,g,u,konum,false,btablo[bsayi].resim)
	guiLabelSetHorizontalAlign(btablo[bsayi].label, "center")
	guiLabelSetVerticalAlign(btablo[bsayi].label, "center")
	guiSetFont(btablo[bsayi].label, "default-bold-small")
	return btablo[bsayi].label 
end

genelGuiTablo2 = {}

_guiCreateGridList = guiCreateGridList

function guiCreateGridList(x,y,g,u,relative,parent,kenarrenk)
	Ssayi = #Ltablo +1
	
	if not kenarrenk or string.len(kenarrenk) > 6 then
		kenarrenk =  "ff7f00" -- gridlist kenar renk // gridlist outline color
	end
	
	if not Ltablo[Ssayi] then Ltablo[Ssayi] = {} end
	
	if relative  then
		px,pu = guiGetSize(parent,false)
		x,y,g,u = x*px,y*pu,g*px,u*pu
	end
	local relative = false
	
	Ltablo[Ssayi].resim = guiCreateLabel(x,y,g,u, "", relative, parent)
	Ltablo[Ssayi].liste = _guiCreateGridList(-8,-8,g+10, u+10,false, Ltablo[Ssayi].resim)
	guiSetFont(Ltablo[Ssayi].liste,"default-bold-small")
	Ltablo[Ssayi].kenarlar = {
	ortaUst = guiCreateStaticImage(0,0,g,1,resimOlustur("test"), false, Ltablo[Ssayi].resim),
	ortaAlt = guiCreateStaticImage(0,u-1,g,1,resimOlustur("test"), false, Ltablo[Ssayi].resim),
	sol = guiCreateStaticImage(0,0,1,u,resimOlustur("test"), false, Ltablo[Ssayi].resim),
	sag = guiCreateStaticImage(g-1,0,1,u,resimOlustur("test"), false, Ltablo[Ssayi].resim)}
	genelGuiTablo2[Ltablo[Ssayi].liste] = Ltablo[Ssayi].kenarlar
	
	for i,v in pairs(Ltablo[Ssayi].kenarlar) do
		renkVer(v,kenarrenk)
		guiSetProperty(v, "AlwaysOnTop", "True")
		guiSetAlpha(v, 0.4)
	end	
	
	return Ltablo[Ssayi].liste
end

etablo = {}

_guiCreateEdit = guiCreateEdit
function guiCreateEdit(x,y,g,u,yazi,relative,parent,kenarrenk)
	esayi = #etablo +1
	
	if not kenarrenk or string.len(kenarrenk) > 6 then
		kenarrenk =  "ffffff" -- edit kenar renk // edit outline color
	end
	
	if not etablo[esayi] then etablo[esayi] = {} end
	
	if relative  then
		px,pu = guiGetSize(parent,false)
		x,y,g,u = x*px,y*pu,g*px,u*pu
	end
	local relative = false

	etablo[esayi].resim = guiCreateLabel(x,y,g,u, "", relative, parent)
	etablo[esayi].edit = _guiCreateEdit(-7,-5,g+15, u+8,yazi,false, etablo[esayi].resim)
	
	etablo[esayi].kenarlar = {
		ortaUst = guiCreateStaticImage(0,0,g,1,resimOlustur("test"), false, etablo[esayi].resim),
		ortaAlt = guiCreateStaticImage(0,u-1,g,1,resimOlustur("test"), false, etablo[esayi].resim),
		sol = guiCreateStaticImage(0,0,1,u,resimOlustur("test"), false, etablo[esayi].resim),
		sag = guiCreateStaticImage(g-1,0,1,u,resimOlustur("test"), false, etablo[esayi].resim)
	}
	genelGuiTablo2[etablo[esayi].edit] = etablo[esayi].kenarlar
	for i,v in pairs(etablo[esayi].kenarlar) do
		renkVer(v,kenarrenk)
		guiSetProperty(v, "AlwaysOnTop", "True")
		guiSetAlpha(v, 0.4)
	end	
	return etablo[esayi].edit
end
--edit,gridlst,buton,memo mouse
addEventHandler("onClientMouseEnter", resourceRoot, function()
	for i,v in pairs(genelGuiTablo) do
		if source == i then
			for i,v in pairs(v) do
				guiSetAlpha(v, 0.4)
			end	
		end
	end
end)

addEventHandler("onClientMouseLeave", resourceRoot, function()
	for i,v in pairs(genelGuiTablo) do
		if source == i then
			for i,v in pairs(v) do
				guiSetAlpha(v, 8)
			end	
		end
	end
end)


addEventHandler("onClientMouseEnter", resourceRoot, function()
	for i,v in pairs(genelGuiTablo2) do
		if source == i then
			for i,v in pairs(v) do
				guiSetAlpha(v, 1)
			end	
		end
	end
end)

addEventHandler("onClientMouseLeave", resourceRoot, function()
	for i,v in pairs(genelGuiTablo2) do
		if source == i then
			for i,v in pairs(v) do
				guiSetAlpha(v, 0.4)
			end	
		end
	end
end)

addEventHandler("onClientGUIClick", resourceRoot, function()
	for i,v in pairs(wtablo) do
		if source == v.kapat then
			guiSetVisible(v.resim, false)
			showCursor(false)
			esyaGosterme()
		end
	end	
end)

function butonmu(label)
	for i,v in pairs(btablo) do
		if v.label == label then
			return i
		end	
	end
	return false	
end

function penceremi(resim)
	for i,v in pairs(wtablo) do
		if v.resim == resim then
			return i
		end	
	end
	return false	
end

function editmi(edit)
	for i,v in pairs(etablo) do
		if v.edit == edit then
			return i
		end	
	end
	return false	
end

function memomu(memo)
	for i,v in pairs(mtablo) do
		if v.memo == memo then
			return i
		end	
	end
	return false	
end

function basliklabelmi(label)
	for i,v in pairs(wtablo) do
		if v.label == label then
			return i
		end	
	end
	return false	
end

function baslikmi(element)
	for i,v in pairs(wtablo) do
		if v.basarka == element or wtablo[basliklabelmi(element)] and  v.label == element then
			return i
		end	
	end
	return false	
end




--basinca olan ufalma
basili = {}
addEventHandler("onClientGUIMouseDown", resourceRoot, function()
	if butonmu(source) then
		if basili[source] then return end
		basili[source] = true
		local g,u = guiGetSize(source, false)
		local x,y = guiGetPosition(source, false)
		guiSetPosition(source, x+2,y+2, false)
		guiSetSize(source, g-4,u-4, false)
	end
end)

addEventHandler("onClientGUIMouseUp", resourceRoot, function()
	if butonmu(source) then
		if not basili[source] then  
			for i,v in pairs(basili) do
				if v == true then
					source = i
					break
				end
			end	
		end
		if not basili[source] then return end
		basili[source] = nil
		local g,u = guiGetSize(source, false)
		local x,y = guiGetPosition(source, false)
		guiSetPosition(source, x-2,y-2, false)
		guiSetSize(source, g+4,u+4, false)
	else
		for i,v in pairs(basili) do
			if v == true then
				source = i
				break
			end
		end	
		if butonmu(source) then
			basili[source] = nil
			local g,u = guiGetSize(source, false)
			local x,y = guiGetPosition(source, false)
			guiSetPosition(source, x-2,y-2, false)
			guiSetSize(source, g+4,u+4, false)
		end	
	end
end)

function basiliBirak()
	for i,v in pairs(basili) do
			if v == true then
				source = i
				break
			end
		end	
	if butonmu(source) then
		basili[source] = nil
		local g,u = guiGetSize(source, false)
		local x,y = guiGetPosition(source, false)
		guiSetPosition(source, x-2,y-2, false)
		guiSetSize(source, g+4,u+4, false)
	end	
end

addEventHandler("onClientClick", root, function(button, durum, _, _, _, _, _, tiklanan)
	if durum == "up" then
		if tiklanan then 
			local element = getElementType(tiklanan)
			if not string.find(element, "gui-") then
				basiliBirak()
			end	
		else
			basiliBirak()
		end
	end	
end)

--diğer funclar
_guiGetPosition = guiGetPosition
function guiGetPosition(element,relative)
	if butonmu(element) then
		local sira = butonmu(element)
		local x,y = _guiGetPosition(btablo[sira].resim, relative)
		return x,y 
	else
		local x,y = _guiGetPosition(element, relative)
		return x,y
	end
end

_guiSetPosition = guiSetPosition
function guiSetPosition(element,x,y,relative)
	if butonmu(element) then
		local sira = butonmu(element)
		_guiSetPosition(btablo[sira].resim, x,y, relative)
	else
		_guiSetPosition(element,x,y,relative)
	end
end

_guiGetSize = guiGetSize
function guiGetSize(element,relative)
	if butonmu(element) then
		local sira = butonmu(element)
		local g,u = _guiGetSize(btablo[sira].resim, relative)
		return g,u 
	else
		local g,u = _guiGetSize(element, relative)
		return g,u
	end
end

_guiSetSize = guiSetSize
function guiSetSize(element,g,u,relative)
	if butonmu(element) then
		local sira = butonmu(element)
		_guiSetSize(btablo[sira].resim, g,u, false)
		_guiSetSize(btablo[sira].label, g,u, false)
		--sağ kenar çizgi
		_guiSetPosition(btablo[sira].kenarlar.sag, g-1, 0, false)
		_guiSetSize(btablo[sira].kenarlar.sag, 1,u, false)
		--alt kenar çizgi
		_guiSetPosition(btablo[sira].kenarlar.ortaAlt, 0, u-1, false)
		_guiSetSize(btablo[sira].kenarlar.ortaAlt, g,1, false)
	elseif penceremi(element) then
		local sira = penceremi(element)
		_guiSetSize(wtablo[sira].resim, g,u, false)
		--sağ kenar çizgi
		_guiSetPosition(wtablo[sira].kenarlar.sag, g-1, 0, false)
		_guiSetSize(wtablo[sira].kenarlar.sag, 1,u, false)
		--alt kenar çizgi
		_guiSetPosition(wtablo[sira].kenarlar.ortaAlt, 0, u-1, false)
		_guiSetSize(wtablo[sira].kenarlar.ortaAlt, g,1, false)
		--baslik
		_guiSetSize(wtablo[sira].basarka, g,20, false)
		--kapat
		if wtablo[sira].kapatArka then
			_guiSetPosition(wtablo[sira].kapatArka, g-25,1, false)
		end	
		--label
		_guiSetPosition(wtablo[sira].label, (g/2)-((string.len(yazi)*8)/2),0, false)
		_guiSetSize(wtablo[sira].label,(string.len(yazi)*8),20, false)
		guiLabelSetHorizontalAlign(wtablo[sira].label, "center")
		guiLabelSetVerticalAlign(wtablo[sira].label, "center")
	else
		_guiSetSize(element,g,u,relative)
	end	
end		


_guiGetText = guiGetText
function guiGetText(element)
	if penceremi(element) then
		local sira = penceremi(element)
		local yazi = _guiGetText(wtablo[sira].label)
		return yazi
	else
		local yazi = _guiGetText(element)
		return yazi
	end
end

_destroyElement = destroyElement
function destroyElement(element)
	if butonmu(element) then
		local sira = butonmu(element)
		_destroyElement(btablo[sira].resim)	
		btablo[sira] = nil
	elseif editmi(element) then
		local sira = editmi(element)
		_destroyElement(etablo[sira].resim)
		etablo[sira] = nil
	elseif memomu(element) then
		local sira = memomu(element)
		_destroyElement(mtablo[sira].resim)
		mtablo[sira] = nil		
	else
		_destroyElement(element)
	end	
end	

_guiWindowSetSizable = guiWindowSetSizable
function guiWindowSetSizable(element, bool)
	if getElementType(element) ~= "gui-window" then
		return false
	else
		_guiWindowSetSizable(element, bool)
	end	
end

local sx, sy = guiGetScreenSize()
local pg,pu = 803,488 -- panelGenislik, panelUzunluk // windowWidth, windowHeight
local x,y = (sx-pg)/2, (sy-pu)/2 -- panel ortalama

yardimwindow = guiCreateWindow(x, y, 803, 488, "İstek & Bilgi Paneli", false)
guiWindowSetSizable(yardimwindow, false)
guiSetVisible(yardimwindow,false)

bilgilb1 = guiCreateLabel(236, 30, 330, 23, "Bilgi Edinmek istediğiniz Kategoriyi Aşağıdan Seçiniz.", false, yardimwindow)
local font0_Font13 = guiCreateFont("dosyalar/Font13.ttf", 10)
guiSetFont(bilgilb1, font0_Font13)
cizgilbl1 = guiCreateLabel(18, 53, 769, 23, "⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻", false, yardimwindow)
guiSetFont(cizgilbl1, font0_Font13)
hakkimizdabtn = guiCreateButton(33, 86, 140, 45, "Hakkımızda", false, yardimwindow)
guiSetFont(hakkimizdabtn, font0_Font13)
iletisimbtn = guiCreateButton(183, 86, 140, 45, "İletişim", false, yardimwindow)
guiSetFont(iletisimbtn, font0_Font13)
ayricaliklarbtn = guiCreateButton(333, 86, 140, 45, "Ayrıcalıklar", false, yardimwindow)
guiSetFont(ayricaliklarbtn, font0_Font13)
maddejoinbtn = guiCreateButton(483, 86, 140, 45, "Madde Join", false, yardimwindow)
guiSetFont(maddejoinbtn, font0_Font13)
sistemlerbtn = guiCreateButton(633, 86, 140, 45, "Sistemler", false, yardimwindow)
guiSetFont(sistemlerbtn, font0_Font13)
logo = guiCreateStaticImage(28, 161, 122, 100, "dosyalar/logo.png", false, yardimwindow)
logoyanyazi = guiCreateLabel(152, 202, 107, 23, "Madde Gaming:", false, yardimwindow)
guiSetFont(logoyanyazi, font0_Font13)
bilgiyazisitxt = guiCreateMemo(259, 160, 524, 107, "Seçtiğiniz Kategorinin bilgi yazısı burada yazacak.\n\nMadde Gaming - Geliştirici Ekibi", false, yardimwindow)
guiSetEnabled(bilgiyazisitxt,false)
cizgilbl2 = guiCreateLabel(18, 277, 769, 23, "⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻", false, yardimwindow)
guiSetFont(cizgilbl2, font0_Font13)
bilgilbl1 = guiCreateLabel(269, 294, 250, 26, "Bizlere İstek & Öneri & Bug bildirmek için;", false, yardimwindow)
guiSetFont(bilgilbl1, font0_Font13)
cizgilbl3 = guiCreateLabel(18, 310, 769, 23, "⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻⸻", false, yardimwindow)
guiSetFont(cizgilbl3, font0_Font13)
istekoneritxt = guiCreateMemo(28, 333, 754, 74, "Bizlerden Sunucumuza eklememizi istediğiniz herhangi bir scripti buradan yazıp, göndererek bildirebilirsiniz.\nSunucumuzda Eğer Bug veya Hata bulduysanız, buradan bildirerek ödüller kazanabilirsiniz.\nnot: Buraya bir kez tıkladığınızda, yazılar otomatik silinir.\n-Madde Gaming - Yönetim Ekibi", false, yardimwindow)
istekbildirirdbtn = guiCreateRadioButton(67, 419, 147, 18, "İsteğimi Bildiriyorum.", false, yardimwindow)
guiSetFont(istekbildirirdbtn, font0_Font13)
bugbildirirdbtn = guiCreateRadioButton(67, 447, 147, 18, "Bug Bildiriyorum.", false, yardimwindow)
guiSetFont(bugbildirirdbtn, font0_Font13)
bildirbtn = guiCreateButton(333, 420, 140, 45, "Bildir (3)", false, yardimwindow)
guiSetFont(bildirbtn, font0_Font13)   

hakkimizdapng = guiCreateStaticImage(28, 181, 169, 61, "dosyalar/hakkimizda.png", false, yardimwindow)
ayricaliklarpng = guiCreateStaticImage(27, 181, 170, 61, "dosyalar/ayricaliklar.png", false, yardimwindow)
iletisimpng = guiCreateStaticImage(27, 181, 170, 61, "dosyalar/iletisim.png", false, yardimwindow)
maddejoinpng = guiCreateStaticImage(27, 181, 170, 61, "dosyalar/maddejoin.png", false, yardimwindow)
sistemlerpng = guiCreateStaticImage(27, 181, 170, 61, "dosyalar/sistemler.png", false, yardimwindow)
guiSetVisible(hakkimizdapng,false)
guiSetVisible(ayricaliklarpng,false)
guiSetVisible(iletisimpng,false)
guiSetVisible(maddejoinpng,false)
guiSetVisible(sistemlerpng,false)

oneriwindow = guiCreateWindow(344, 248, 600, 292, "İstek & Öneri Bildiri Merkezi", false)
guiWindowSetSizable(oneriwindow, false)
guiSetVisible(oneriwindow,false)

gridlist = guiCreateGridList(16, 31, 203, 244, false, oneriwindow)
guiGridListAddColumn(gridlist, "K.Adı", 0.2)
guiGridListAddColumn(gridlist, "Tarih", 0.2)
guiGridListAddColumn(gridlist, "Talebi", 0.2)
guiGridListAddColumn(gridlist, "Durum", 0.2)
guiGridListAddColumn(gridlist, "id", 0.2)
onerisil = guiCreateButton(266, 216, 129, 44, "Öneriyi Sil", false, oneriwindow)
onerigoster = guiCreateButton(427, 216, 129, 44, "Göster", false, oneriwindow)
oneriyazi = guiCreateMemo(266, 50, 290, 139, "", false, oneriwindow)  
onerikapat = guiCreateButton(564, 26, 26, 24, "X", false, oneriwindow)      

addEventHandler("onClientGUIClick",root,function()
	if source == hakkimizdabtn then
	guiSetVisible(hakkimizdapng,true)
	guiSetVisible(ayricaliklarpng,false)
	guiSetVisible(iletisimpng,false)
	guiSetVisible(maddejoinpng,false)
	guiSetVisible(sistemlerpng,false)
	guiSetVisible(logo,false)
	guiSetVisible(logoyanyazi,false)
		guiSetText(bilgiyazisitxt,"Selamlar. Sunucumuz 27 Temmuz 2022 Tarihinde, Burak Şahin önderliğinde 4 kişi tarafından kurulmuştur. Sunucumuz Beta olarak açılıp, 9 Eylül 2022 Tarihinde tam sürüm halinde hizmet vermeye başlamıştır. Madde Gaming özel sistemleri ve adaletli ortamıyla, diğer sunuculara fark atmıştır. Madde Gaming, 5 yıllık Sunucu Sahipliği deneyimleri olan, kurucusu. 3.5 Yıldır askeri&roleplay&freeroam sunucu deneyimlerine sahip yönetim kadrosu tarafından yönetilmektedir.")
	elseif source == ayricaliklarbtn then
		guiSetVisible(hakkimizdapng,false)
		guiSetVisible(ayricaliklarpng,true)
		guiSetVisible(iletisimpng,false)
		guiSetVisible(maddejoinpng,false)
		guiSetVisible(sistemlerpng,false)
		guiSetVisible(logo,false)
		guiSetVisible(logoyanyazi,false)
		guiSetText(bilgiyazisitxt,"Selamlar. Sunucumuzda ayrıcalıklara sahip olmak istiyorsanız; V.I.P, özel maaş, özel nametag, görevlerden ekstra para artışı vb. Şeyler satın alabilirsiniz. Bu ayrıcalıkları sadece Marketten satın alabilirsiniz. Market panelimizi sohbete /market komutunu kullanarak açabilirsiniz. Markette sadece Madde Join para birimi geçmektedir. MJ 'nin ne olduğunu bilmiyorsanız, Üstten 'Madde Join' yazısına tıklayabilirsiniz.")
	elseif source == iletisimbtn then
		guiSetVisible(hakkimizdapng,false)
		guiSetVisible(ayricaliklarpng,false)
		guiSetVisible(iletisimpng,true)
		guiSetVisible(maddejoinpng,false)
		guiSetVisible(sistemlerpng,false)
		guiSetVisible(logo,false)
		guiSetVisible(logoyanyazi,false)
		guiSetText(bilgiyazisitxt,"Selamlar. Bizlere ulaşmak için; \nDiscord: https://discord.gg/VanEd4ZeKq  (/dc)\nInstagram: instagram.com/maddegaming/\nYoutube: Madde Gaming (youtube.com/channel/UC3aYNsWg9Tu6UTfmluo9cfw)\nWeb Site: https://maddegaming.business.site/")
	elseif source == maddejoinbtn then
		guiSetVisible(hakkimizdapng,false)
		guiSetVisible(ayricaliklarpng,false)
		guiSetVisible(iletisimpng,false)
		guiSetVisible(maddejoinpng,true)
		guiSetVisible(sistemlerpng,false)
		guiSetVisible(logo,false)
		guiSetVisible(logoyanyazi,false)
		guiSetText(bilgiyazisitxt,"Selamlar. Madde Join sunucumuzun ayrıcalık para birimidir. Madde Join kısaltması MJ 'dir. MJ para birimi sunucumuza özeldir ve şuanlık sadece Market Panelimizde geçmektedir. Madde Join ile Market panelimizdeki ürünleri satın alabilirsiniz. Madde Join sahibi olmak için, MJ satın almalısınız. MJ 'ler ise TL olarak satılmaktadır. Satın almak için Discord sunucumuza geliniz.")
	elseif source == sistemlerbtn then
		guiSetVisible(hakkimizdapng,false)
		guiSetVisible(ayricaliklarpng,false)
		guiSetVisible(iletisimpng,false)
		guiSetVisible(maddejoinpng,false)
		guiSetVisible(sistemlerpng,true)
		guiSetVisible(logo,false)
		guiSetVisible(logoyanyazi,false)
		guiSetText(bilgiyazisitxt,"Sunucumuzdaki tamamen bize özel olan sistemlerimiz; F1 > Freeroam Panel, F2 > Silah Panel, F3 > Klan Panel, F4 > Araç Panel, F9 > Yardım Panel, F7 > Düello Panel, Banka Sistemi, F1 > Modifiye Sistemi, Piyango Sistemi, Nametag Sistemi, Meslek Sistemi. Sunucumuza Özel Düzenlenen Sistemler; F6 > Sıralama Panel, Görevler")
	elseif source == istekoneritxt then
			guiSetText(istekoneritxt,"")
	end
	if source == onerikapat then
		guiSetVisible(oneriwindow,false)
		showCursor(false)
	end
end)

addEventHandler("onClientGUIClick",root,function()
	if source == onerigoster then
		local player = guiGridListGetItemText(gridlist, guiGridListGetSelectedItem(gridlist), 1)
		local tarih = guiGridListGetItemText(gridlist, guiGridListGetSelectedItem(gridlist), 2)
		local talebi = guiGridListGetItemText(gridlist, guiGridListGetSelectedItem(gridlist), 3)
		local id = guiGridListGetItemText(gridlist, guiGridListGetSelectedItem(gridlist), 4)
		guiSetText(oneriyazi,tostring("Gönderen: "..player.." Tarih: "..tarih.." Talebi: "..talebi))
	elseif source == onerisil then
		local id = guiGridListGetItemText(gridlist, guiGridListGetSelectedItem(gridlist), 5)
		triggerServerEvent("YardimPanel:onerisil",localPlayer,id)
	end
end)

addEventHandler("onClientGUIClick",root,function()
	if source == bildirbtn then
		text = guiGetText(bildirbtn)
		local textiki = guiGetText(istekoneritxt)
		if guiRadioButtonGetSelected(istekbildirirdbtn) == false and guiRadioButtonGetSelected(bugbildirirdbtn) == false then exports.hud:dm("#ffffffHata! #ff7f00İstek veya bug bildirimi#ffffff seçeneklerinden birini seçtiğini ve 15 harften uzun yazı yazdıgına emin ol.",255,127,0,true) return end
		if text == "Bildir (3)" then
			guiSetText(bildirbtn,"Bildir (2)")
			exports.hud:dm("#ffffffYukarıdaki yazı yerine #ff7f00sadece istek ve bug bildirimi #ffffffyazdığınıza eminseniz butona basmaya devam edin.",255,127,0,true)
		elseif text == "Bildir (2)" then
			guiSetText(bildirbtn,"Bildir (1)")
			exports.hud:dm("#ffffffYukarıdaki yazı yerine #ff7f00sadece istek veya bug bildirimi #ffffffyazdığınıza eminseniz butona basmaya devam edin.",255,127,0,true)
		elseif text == "Bildir (1)" then
			guiSetText(bildirbtn,"Bildir (3)")
			triggerServerEvent("YardimPanel:istekekle",localPlayer,textiki)
			guiSetVisible(yardimwindow,false)
			showCursor(false)
			guiSetInputEnabled(false)
		end
	end
end)

bindKey("F9","down",function()
	if guiGetVisible(yardimwindow) == true then
		guiSetVisible(yardimwindow,false)
		showCursor(false)
		guiSetInputEnabled(false)
	elseif guiGetVisible(yardimwindow) == false then
		guiSetVisible(hakkimizdapng,false)
		guiSetVisible(ayricaliklarpng,false)
		guiSetVisible(iletisimpng,false)
		guiSetVisible(maddejoinpng,false)
		guiSetVisible(sistemlerpng,false)
		guiSetVisible(logo,true)
		guiSetVisible(logoyanyazi,true)
		guiSetText(bilgiyazisitxt,"Seçtiğiniz Kategorinin bilgi yazısı burada yazacak.\n\nMadde Gaming - Geliştirici Ekibi")
		guiSetText(istekoneritxt,"Bizlerden Sunucumuza eklememizi istediğiniz herhangi bir scripti buradan yazıp, göndererek bildirebilirsiniz.\nSunucumuzda Eğer Bug veya Hata bulduysanız, bizlere buradan bildirerek ödüller kazanabilirsiniz.\nnot: Buraya bir kez tıkladığınızda, yazılar otomatik silinir.\n-Madde Gaming - Yönetim Ekibi")
		guiSetText(bildirbtn,"Bildir (3)")
		guiSetVisible(yardimwindow,true)
		showCursor(true)
		guiSetInputEnabled(true)
	end
end)

addEvent("YardimPanel:destekler",true)
addEventHandler("YardimPanel:destekler",root,function(veriler)
	guiGridListClear(gridlist)
	for i,v in pairs(veriler) do
	row = guiGridListAddRow(gridlist,v["oyuncukadi"],v["tarih"],v["talebi"],v["durum"],v["id"])
	end
	guiSetVisible(oneriwindow,true)
	showCursor(true)
end)

addEvent("YardimPanel:kapat",true)
addEventHandler("YardimPanel:kapat",root,function()
	guiSetVisible(oneriwindow,false)
	showCursor(false)
	guiSetInputEnabled(false)
end)