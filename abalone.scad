// All dimensions are mm, unless otherwise noted

fn=30;
$fn=fn;
boardThickness = 20;
margin=5;
boardSize = 5; // diameter, measured in marbles. Must be odd.
marbleD = 30;
marbleSpacing = 2;
pocketIndent = 5;
channelIndent = 2; // should be < pocketIndent
gutterIndent = 10; // should be > channelIndent
gutterMargin = 5;

boardDiameter = boardSize * (marbleD + marbleSpacing) - marbleSpacing + gutterMargin * 2;

module pocket() {
    translate([0, 0, -pocketIndent]) sphere(d=marbleD);
}

module channel(length) {
    translate([0, 0, -channelIndent]) rotate([-90, 0, 0]) {
        cylinder(d=marbleD, h=length, center=true);
    }
}

function gridOffset(idx) = (marbleD + marbleSpacing) * (idx - (boardSize - 1) / 2);

module gridStrip() {
    for(col = [0: boardSize - 1]) {
        translate([gridOffset(col), 0, 0]) rotate(30)
            children();
    }
}

module pockets() {
    gridStrip() {
        for (row = [0: boardSize - 1]) {
            translate([0, gridOffset(row), 0])
                pocket();
        }
    }
}

module channels() {
    gridStrip() {
        channel(boardDiameter * 2);
    }
}

difference() {
    translate([0, 0, boardThickness/2])
        cylinder(d=boardDiameter + (marbleD + margin) * 2, h=boardThickness, $fn=6, center=true);
    translate([0, 0, boardThickness + marbleD / 2]) {
        intersection() {
            cylinder(d=boardDiameter, h=100, $fn=6, center=true);
            pockets();
        }
        intersection() {
            cylinder(d=boardDiameter + gutterMargin * 2, h=100, $fn=6, center=true);
            for(angle = [0, 60, 120]) {
                rotate(angle) channels();
            }
        }

        translate([0, 0, -gutterIndent]) {
            rotate_extrude($fn=6) {
                translate([(boardDiameter + marbleD) / 2, 0]) circle(d=marbleD, $fn=fn);
            }
        }
    }
}
