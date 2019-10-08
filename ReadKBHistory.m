function [KeyboardDetail] = ReadKBHistory(KBHistory,KBSecs,school,DelayCorrection)

KeyboardDetail{1,1} = 'Status';
KeyboardDetail{1,2} = 'KbName';
KeyboardDetail{1,3} = 'HandSided';
KeyboardDetail{1,4} = 'Duration';
KeyboardDetail{1,5} = 'RelativeTimeToGameStart(YM1stTrigger)';
KeyboardDetail{1,6} = 'TriggerCount';
KeyboardDetail{1,7} = 'TriggerInterval';

if(sum(school=='nymu')==4)
    trigger = 105;
    DelayCorrection = 0;
elseif(sum(school=='nccu')==4)
    trigger = 53;
end

% find first trigger
Flag = 0;
for l=2:length(KBHistory(:,1))
    tempKB = KBHistory(l,:) - KBHistory(l-1,:);
    if(tempKB(trigger)==1&&Flag==0)
        tempSec = KBSecs(l,1);
        FirstTrigger = l;
        Flag = 1;
    elseif(tempKB(trigger)==1&&Flag==1)
        %如果這不是第一個trigger(任2trigger時間差大於2秒或4秒的正負0.05Sec)
        if(abs((KBSecs(l,1)-tempSec)-4)>0.05&&abs((KBSecs(l,1)-tempSec)-2)>0.05)
            tempSec = KBSecs(l,1);
            FirstTrigger = l;
        else
            break
        end
    end
end

KeyboardPointer = 2;
TriggerCounter = 1;
KeyboardDetail{KeyboardPointer,5} = 0;
KeyboardDetail{KeyboardPointer,6} = TriggerCounter;
StartTime = KBSecs(FirstTrigger,1) + DelayCorrection;
LastTriggerTime = StartTime;
KeyPressTiming = zeros(1,256);
for l=(FirstTrigger+1):length(KBHistory(:,1))
    if(KBSecs(l)-StartTime<0)
        continue
    end
    CurrentKeyPress = find(KBHistory(l,:)==1);
    PastKeyPress = find(KBHistory(l-1,:)==1);
    %先看是不是新增按鍵
    for C = 1:length(CurrentKeyPress)
        NewPressKey = 1;
        for P = 1:length(PastKeyPress)
            %如果找到一樣的，就換下一個
            if(CurrentKeyPress(C)==PastKeyPress(P))
                NewPressKey = 0;
                break
            end
        end
        if(NewPressKey==1)
            switch CurrentKeyPress(C)
                case 37
                    KeyPressEffective = 1;
                    HandSided = 'L';
                    KeyName = KbName(CurrentKeyPress(C));
                case 38
                    KeyPressEffective = 1;
                    HandSided = 'L';
                    KeyName = KbName(CurrentKeyPress(C));
                case 39
                    KeyPressEffective = 1;
                    HandSided = 'L';
                    KeyName = KbName(CurrentKeyPress(C));
                case 40
                    KeyPressEffective = 1;
                    HandSided = 'L';
                    KeyName = KbName(CurrentKeyPress(C));
                case 50
                    KeyPressEffective = 1;
                    HandSided = 'R';
                    KeyName = 'PowerStrike';
                case 65
                    KeyPressEffective = 1;
                    HandSided = 'R';
                    KeyName = 'NormalStrike';
                case 87
                    KeyPressEffective = 1;
                    HandSided = 'R';
                    KeyName = 'SpinStrike';
                case trigger
                    KeyPressEffective = 2;
                    TriggerCounter = TriggerCounter + 1;
                otherwise
                    KeyPressEffective = 0;
            end
            if(KeyPressEffective==1)
                KeyboardPointer = KeyboardPointer +1;
                KeyboardDetail{KeyboardPointer,1} = 'Press';
                KeyboardDetail{KeyboardPointer,2} = KeyName;
                KeyboardDetail{KeyboardPointer,3} = HandSided;
                KeyPressTiming(1,CurrentKeyPress(C)) = KBSecs(l,1);
                KeyboardDetail{KeyboardPointer,5} = KBSecs(l,1) - StartTime;
            elseif(KeyPressEffective==2)
                KeyboardPointer = KeyboardPointer +1;
                KeyboardDetail{KeyboardPointer,6} = TriggerCounter;
                KeyboardDetail{KeyboardPointer,7} = KBSecs(l,1) - LastTriggerTime;
                LastTriggerTime = KBSecs(l,1);
            end
        end
    end
    
    %再看是不是釋放按鍵
    for P = 1:length(PastKeyPress)
        NewReleaseKey = 1;
        for C = 1:length(CurrentKeyPress)
            %如果找到一樣的，就換下一個
            if(CurrentKeyPress(C)==PastKeyPress(P))
                NewReleaseKey = 0;
                break
            end
        end
        if(NewReleaseKey==1)
            switch PastKeyPress(P)
                case 37
                    KeyPressEffective = 1;
                    HandSided = 'L';
                    KeyName = KbName(PastKeyPress(P));
                case 38
                    KeyPressEffective = 1;
                    HandSided = 'L';
                    KeyName = KbName(PastKeyPress(P));
                case 39
                    KeyPressEffective = 1;
                    HandSided = 'L';
                    KeyName = KbName(PastKeyPress(P));
                case 40
                    KeyPressEffective = 1;
                    HandSided = 'L';
                    KeyName = KbName(PastKeyPress(P));
                case 50
                    KeyPressEffective = 1;
                    HandSided = 'R';
                    KeyName = 'PowerStrike';
                case 65
                    KeyPressEffective = 1;
                    HandSided = 'R';
                    KeyName = 'NormalStrike';
                case 87
                    KeyPressEffective = 1;
                    HandSided = 'R';
                    KeyName = 'SpinStrike';
                otherwise
                    KeyPressEffective = 0;
            end
            if(KeyPressEffective==1)
                KeyboardPointer = KeyboardPointer +1;
                KeyboardDetail{KeyboardPointer,1} = 'Release';
                KeyboardDetail{KeyboardPointer,2} = KeyName;
                KeyboardDetail{KeyboardPointer,3} = HandSided;
                KeyboardDetail{KeyboardPointer,4} = KBSecs(l,1) - KeyPressTiming(1,PastKeyPress(P));
                KeyPressTiming(1,PastKeyPress(P)) = 0;
                KeyboardDetail{KeyboardPointer,5} = KBSecs(l,1) - StartTime;
            end
        end
    end
    
                
                     
end
    


