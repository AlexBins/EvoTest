% TODO Replace with implementation in GeometricUtility.CreateRectangle
function rect = CreateRectangle(x, y, w, h)
    rect = [ x, x+w, x+w, x, x; y, y, y+h, y+h, y; 1, 1, 1, 1, 1];
end