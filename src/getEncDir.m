% TODO Replace with the implementation in DubinsCar.getEncDir
% DONE
function d = getEncDir(sd, pos)
switch sd(pos)
    case 'R'
        d = 1;
    case 'S'
        d = 0;
    case 'L'
        d = -1;
    otherwise
        return;
end
