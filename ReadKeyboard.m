addpath('/autofs/space/maki6_001/users/r04945014/toolbox_server')
load('DelayList')

cd('/autofs/space/maki6_001/users/r04945014/HyperScanning/Tennis/KeyboardRecord_Original')
pairList = cellstr(ls('*Pair*'));
for p = 1%:length(pairList)
    savePath = sprintf('/autofs/space/maki6_001/users/r04945014/HyperScanning/Tennis/KeyboardRecord_Modified/%s',...
        pairList{p});
    mkdir(savePath)
    cd(pairList{p})
    kbList = cellstr(ls('*KB*'));
    for k=1:2:length(kbList)
        load(kbList{k})
        school = kbList{k}(end-7:end-4);
        KeyboardDetail = ReadKBHistory(KBHistory,KBSecs,school,DelayList(p,(k+1)/2));
        nowPath = pwd;
        cd(savePath)
        save(sprintf('KeyboardDetail_run%i_%s',(k+1)/2,school),'KeyboardDetail')
        cd(nowPath)
        load(kbList{k+1})
        school = kbList{k+1}(end-7:end-4);
        KeyboardDetail = ReadKBHistory(KBHistory,KBSecs,school,DelayList(p,(k+1)/2));
        cd(savePath)
        save(sprintf('KeyboardDetail_run%i_%s',(k+1)/2,school),'KeyboardDetail')
        cd(nowPath)
    end
    cd ..
end
        