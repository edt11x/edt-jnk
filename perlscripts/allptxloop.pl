#!perl
#
use strict;
use warnings;

my @list = qw(
SOF.ptx
SOFMixedPackets.ptx
Test256x256.ptx
Test256x256FA1.ptx
Test256x256i.ptx
Test352x256.ptx
Test512x512.ptx
Test640x640.ptx
Test1024x1024.ptx
Test1024x1024i.ptx
resolutionTest.ptx
inverseResTest.ptx
Test1980x1980.ptx
Test1980x1980FA1.ptx
Test1980x1980i.ptx
ImgResChart1.ptx
ImgResChart2.ptx
ImgResChart3.ptx
ImgResChart4.ptx
ImgResChart5.ptx
ImgResChart6.ptx
ImgResChart7.ptx
EOTS_Truck.ptx
EOTS_BarPattern.ptx
EOTS_StaggerPattern.ptx
resolutionTest.ptx
AllCar.ptx
EOTS.ptx
AllColors.ptx
AllCount.ptx
Test1980x1980ThreeFrame.ptx
Test1980x1980FourFrame.ptx
DualFrameSlow.ptx
DualFrameFast.ptx
DualFrameFast320.ptx
Mono256x256.ptx
Mono256x256i.ptx
Mono352x256.ptx
Mono512x512.ptx
Mono640x640.ptx
Mono64x64.ptx
Mono1024x1024.ptx
Mono1920x1920.ptx
Mono1920x1920FA1.ptx
Mono1936x1936.ptx
Mono1952x1952.ptx
Mono1968x1968.ptx
Mono1980FullPackets.ptx
Mono1980x1980.ptx
Mono1984x1984.ptx
Mono2000x2000.ptx
Mono2016x2016.ptx
Mono2032x2032.ptx
Mono2048x2048.ptx
Line1024x1024.ptx
Line1980x1980.ptx
Line256x256.ptx
Line512x512.ptx
Line640x640.ptx
MonoLine1024x1024.ptx
MonoLine1792x1792.ptx
MonoLine188x188.ptx
MonoLine1920x1920.ptx
MonoLine1980x1980.ptx
MonoLine1984x1984.ptx
MonoLine2048x2048.ptx
MonoLine256x256.ptx
MonoLine512x512.ptx
MonoLine640x640.ptx
AllSun.ptx
WhiteTiles.ptx
GreySquares.ptx
AllBug.ptx
AllF35.ptx
AllF350xFA1.ptx
AllFish.ptx
AllJsfWin.ptx
AllMap.ptx
AllMonoF35.ptx
AllPieces.ptx
AllRock.ptx
AllScene.ptx
AllTileCount.ptx
AllTileFA1.ptx
AllWest.ptx
Black256x256.ptx
BlackTiles.ptx
Blue256x256.ptx
BothTiles.ptx
AllBothTile2Sets.ptx
All30Sources.ptx
All32Sources.ptx
AllBothTile.ptx
);

foreach (@list)
{
    my $i = $_;
    print "--",$i,"--\n";
    # system("c:\\perl\\bin\\perl -e\"sleep(30); print;\"");
    system("c:\\perl\\bin\\perl -e\"sleep(30); print\"| (c:\\fcio\\fcio -s 0 -s1 -0 q:\\ptxFiles\\$i -1 q:\\ptxFiles\\$i -r0 -r1 | c:\\fcio\\mpeg2streamer.exe) 2>&1 1>&2 2>&3 | c:\\fcio\\mpeg2streamer.exe 2");
    print "\n";
    sleep(8);
}

