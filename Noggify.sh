#!/bin/bash
# Noggify
# Usage: Automates the process of cutting large texturemaps into tiles for import into Noggit Red.
# Requirements: Git Bash and ImageMagick

# CONFIG START
###################################################################################################
# FILE SETTINGS
#
#   Input Directory
#       Description:    Folder where texturemaps are located.
#       Suggestion:     Set this to the output folder of your terrain generation program -OR- 
#                       place Noggify.sh in the folder with the texturemaps and leave as default.

InputDirectory='./'

#   Output Directory
#       Description:    Folder where completed tiles are sent.
#       Suggestion:     Set this to the map directory of your Noggit project folder. 
#                       ex. OutputDirectory="E:/WotLK/Data/patch-5.mpq/world/maps/desert/"

OutputDirectory="./output/"

#   Filenames
#       Description:    Texturemap file names and extension.
#       Suggestion:     Match this with the output settings of your terrain generation program.

HeightName='height'
Layer1Name='layer1'
Layer2Name='layer2'
Layer3Name='layer3'
VcolorName='vcolor'
FileType='.png'

#
###################################################################################################

###################################################################################################
# MAP SETTINGS
#
#   MapName
#       Description:    Map name used in Noggit/WoW

MapName='Desert'

#   GridSize
#       Description:    Map size in ADTs (x by x)
#       Important:      Suggested heightmap resolution: 256x256 multiplied by GridSize. 
#                       Suggested alphamap resolution: 1024x1024 multiplied by GridSize.

GridSize=1

#   Offset
#       Description:    The top-left tile of the map will be at this coordinate on the ADT grid.
#       Suggestion:     Can be used to center a large map or combine several small ones.

OffsetX=1
OffsetY=1

#
###################################################################################################
# CONFIG END

if [ ! -d "$InputDirectory" ]; then
echo -e " The input directory "$InputDirectory" does not exist.\n Open Noggify.sh with a text editor and set the configs.\n"
read -n 1 -s -r -p " Press any key to exit..." exit 1
else if [ ! -d $OutputDirectory ]; then
echo -e " The output directory "$OutputDirectory" does not exist.\n Open Noggify.sh with a text editor and set the configs.\n"
read -n 1 -s -r -p " Press any key to exit..." exit 1
fi
fi

process_height() {
if [ -e ${HeightName}${FileType} ]; then
echo -e "\n Heightmap in progress..."
magick convert  -depth 16 -type Grayscale $InputDirectory$HeightName$FileType -crop $GridSize'x'$GridSize@ -set filename:tile $OutputDirectory$MapName'_%[fx:round(page.x/(('$(magick identify -format "%[fx:w]" $InputDirectory$HeightName$FileType)'/'$GridSize')*1)+'$OffsetX')]_%[fx:round(page.y/(('$(magick identify -format "%[fx:w]" $InputDirectory$HeightName$FileType)'/'$GridSize')*1)+'$OffsetY')]_height' -scale 256x256^ +repage +adjoin %[filename:tile].png
echo -e " Heightmap complete"
else echo -e " Error: Heightmap "$InputDirectory$HeightName$FileType" not found.\n"
fi
}
process_layer1() {
if [ -e ${Layer1Name}${FileType} ]; then
echo -e "\n Layer1 in progress..."
magick convert  -depth 8 -type Grayscale $InputDirectory$Layer1Name$FileType -crop $GridSize'x'$GridSize@ -set filename:tile $OutputDirectory$MapName'_%[fx:round(page.x/(('$(magick identify -format "%[fx:w]" $InputDirectory$Layer1Name$FileType)'/'$GridSize')*1)+'$OffsetX')]_%[fx:round(page.y/(('$(magick identify -format "%[fx:w]" $InputDirectory$Layer1Name$FileType)'/'$GridSize')*1)+'$OffsetY')]_layer1' -scale 1024x1024^ +repage +adjoin %[filename:tile].png
echo -e " Layer1 complete"
else echo -e " Error: Layer1 alphamap "$InputDirectory$Layer1Name$FileType" not found.\n"
fi
}
process_layer2() {
if [ -e ${Layer2Name}${FileType} ]; then
echo -e "\n Layer2 in progress..."
magick convert  -depth 8 -type Grayscale $InputDirectory$Layer2Name$FileType -crop $GridSize'x'$GridSize@ -set filename:tile $OutputDirectory$MapName'_%[fx:round(page.x/(('$(magick identify -format "%[fx:w]" $InputDirectory$Layer2Name$FileType)'/'$GridSize')*1)+'$OffsetX')]_%[fx:round(page.y/(('$(magick identify -format "%[fx:w]" $InputDirectory$Layer2Name$FileType)'/'$GridSize')*1)+'$OffsetY')]_Layer2' -scale 1024x1024^ +repage +adjoin %[filename:tile].png
echo -e " Layer2 complete"
else echo -e " Error: Layer2 alphamap "$InputDirectory$Layer2Name$FileType" not found.\n"
fi
}
process_layer3() {
if [ -e ${Layer3Name}${FileType} ]; then
echo -e "\n Layer3 in progress..."
magick convert  -depth 8 -type Grayscale $InputDirectory$Layer3Name$FileType -crop $GridSize'x'$GridSize@ -set filename:tile $OutputDirectory$MapName'_%[fx:round(page.x/(('$(magick identify -format "%[fx:w]" $InputDirectory$Layer3Name$FileType)'/'$GridSize')*1)+'$OffsetX')]_%[fx:round(page.y/(('$(magick identify -format "%[fx:w]" $InputDirectory$Layer3Name$FileType)'/'$GridSize')*1)+'$OffsetY')]_Layer3' -scale 1024x1024^ +repage +adjoin %[filename:tile].png
echo -e " Layer3 complete"
else echo -e " Error: Layer3 alphamap "$InputDirectory$Layer3Name$FileType" not found.\n"
fi
}
process_vcolor() {
if [ -e ${VcolorName}${FileType} ]; then
echo -e "\n Vertexcolor in progress..."
magick convert  -depth 8 -type Grayscale $InputDirectory$VcolorName$FileType -crop $GridSize'x'$GridSize@ -set filename:tile $OutputDirectory$MapName'_%[fx:round(page.x/(('$(magick identify -format "%[fx:w]" $InputDirectory$VcolorName$FileType)'/'$GridSize')*1)+'$OffsetX')]_%[fx:round(page.y/(('$(magick identify -format "%[fx:w]" $InputDirectory$VcolorName$FileType)'/'$GridSize')*1)+'$OffsetY')]_Vcolor' -scale 1024x1024^ +repage +adjoin %[filename:tile].png
echo -e " Vertexcolor complete"
else echo -e " Error: Vertexcolor map "$InputDirectory$VcolorName$FileType" not found.\n"
fi
}

echo "           
                                                     -##-##-##-
                                          -##-##-##- #        #
   _   _                   _  __          #        # #        #
  | \ | |                 (_)/ _|         #        # #        #
  |  \| | ___   __ _  __ _ _| |_ _   _    #        # #        #
  |     |/ _ \ / _  |/ _  | |  _| | | |   #        # -##-##-##-
  | |\  | (_) | (_| | (_| | | | | |_| |   -##-##-##-##-##-##-
  \_| \_/\___/ \__  |\__  |_|_|  \__  |   #        #        #
                __/ | __/ |       __/ |   #        #        #
               |___/ |___/       |___/    #        #        #
                                          #        #        #
                                          -##-##-##-##-##-##-"                            
while true; do
echo -e "\n Split texturemaps"
echo " ----------------------"
echo " 1. Height"
echo " 2. Alpha"
echo " 3. vColor"
echo " 4. All"

read -p "> " choice
case $choice in
1) process_height ;;
2) process_layer1 && process_layer2 && process_layer3 ;;
3) process_vcolor ;;
4) process_height && process_layer1 && process_layer2 && process_layer3 && process_vcolor ;;
*) echo -e " Error: Enter 1-4.\n" ;;
esac
done
