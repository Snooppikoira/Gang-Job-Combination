## Gang & Job combination, inspired qbcore FiveM

**Here is just an example of how this works, you have to make the codes yourself to make it work.**

## Exports (CLIENT) 

**Request gang name**
```
exports['sk_gangcombination']:GetPlayerGangName()
```
**Request gang label**
```
exports['sk_gangcombination']:GetPlayerGangNameLabel()
```
**Request gang grade**
```
exports['sk_gangcombination']:GetPlayerGangGrade()
```
**Request gang grade label**
```
exports['sk_gangcombination']:GetPlayerGangGradeLabel()
```
**Request gang grade number**
```
exports['sk_gangcombination']:GetPlayerGangGradeNum()
```
## Command 
```
/setgang (id) (gang) (gradenum)
```

## Some images
> Not in gang<br>
> ![image](https://github.com/user-attachments/assets/2f94e326-8a3c-4cd9-aafb-271d6fdc085a)

> In gang<br>
> ![image](https://github.com/user-attachments/assets/8484376f-9a2b-4657-a893-83c7bd51de9e)

## Example code how to use 


**Print code with command exmaple**
```
RegisterCommand('example', function()
    local table = {    
        gangname = exports['sk_gangcombination']:GetPlayerGangName(),
        ganglabel = exports['sk_gangcombination']:GetPlayerGangLabel(),
        gradename = exports['sk_gangcombination']:GetPlayerGangGrade(),
        gradelabel = exports['sk_gangcombination']:GetPlayerGangGradeLabel(),
        gradenum = exports['sk_gangcombination']:GetPlayerGangGradeNum(),
    }

    if not table then return end

    for k, v in pairs(table) do
        print(("[%s]: %s"):format(k, tostring(v)))
    end
end)
```

# ⚠️ SEND POSSIBLE BUGS IN DISCORD
