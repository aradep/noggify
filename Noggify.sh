#!/bin/bash
# Noggify
# Usage: Automates the process of cutting large texturemaps into tiles for import into Noggit Red.
# Requirements: Git Bash and ImageMagick

# CONFIG START
###################################################################################################
# SCRIPT SETTINGS
#
#   Parallel processing
#       Description:    Process all selected files at the same time. Increases CPU usage.

parallel=true

#
###################################################################################################

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

MapName='Mountains'

#   GridSize
#       Description:    Map size in ADTs (x by x)
#       Important:      Suggested heightmap resolution: 256x256 multiplied by GridSize. 
#                       Suggested alphamap resolution: 1024x1024 multiplied by GridSize.

GridSize=8

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
echo -e " Height in progress..."
HeightStart=$(date +%s%3N)
HeightFileSize=$(magick identify -ping -format "%w" $InputDirectory$HeightName$FileType)
magick convert -depth 16 -type Grayscale $InputDirectory$HeightName$FileType -crop $GridSize'x'$GridSize@ -set filename:tile $OutputDirectory$MapName'_%[fx:round(page.x/(('$HeightFileSize'/'$GridSize')*1)+'$OffsetX')]_%[fx:round(page.y/(('$HeightFileSize'/'$GridSize')*1)+'$OffsetY')]_height' -resize 256x256! +repage +adjoin %[filename:tile].png
HeightEnd=$((($(date +%s%3N) - HeightStart) / 1000))
echo -e " Height completed in - "$HeightEnd"s"
else echo -e " Error: Heightmap "$InputDirectory$HeightName$FileType" not found.\n"
fi
}

process_layer1() {
if [ -e ${Layer1Name}${FileType} ]; then
echo -e " Layer1 in progress..."
Layer1Start=$(date +%s%3N)
Layer1FileSize=$(magick identify -ping -format "%w" $InputDirectory$Layer1Name$FileType)
magick convert -depth 8 -type Grayscale $InputDirectory$Layer1Name$FileType -crop $GridSize'x'$GridSize@ -set filename:tile $OutputDirectory$MapName'_%[fx:round(page.x/(('$Layer1FileSize'/'$GridSize')*1)+'$OffsetX')]_%[fx:round(page.y/(('$Layer1FileSize'/'$GridSize')*1)+'$OffsetY')]_layer1' -resize 1024x1024! +repage +adjoin %[filename:tile].png
Layer1End=$((($(date +%s%3N) - Layer1Start) / 1000))
echo -e " Layer1 completed in - "$Layer1End"s"
else echo -e " Error: Layer1 alphamap "$InputDirectory$Layer1Name$FileType" not found.\n"
fi
}
process_layer2() {
if [ -e ${Layer2Name}${FileType} ]; then
echo -e " Layer2 in progress..."
Layer2Start=$(date +%s%3N)
Layer2FileSize=$(magick identify -ping -format "%w" $InputDirectory$Layer2Name$FileType)
magick convert  -depth 8 -type Grayscale $InputDirectory$Layer2Name$FileType -crop $GridSize'x'$GridSize@ -set filename:tile $OutputDirectory$MapName'_%[fx:round(page.x/(('$Layer2FileSize'/'$GridSize')*1)+'$OffsetX')]_%[fx:round(page.y/(('$Layer2FileSize'/'$GridSize')*1)+'$OffsetY')]_Layer2' -resize 1024x1024! +repage +adjoin %[filename:tile].png
Layer2End=$((($(date +%s%3N) - Layer2Start) / 1000))
echo -e " Layer2 completed in - "$Layer2End"s"
else echo -e " Error: Layer2 alphamap "$InputDirectory$Layer2Name$FileType" not found.\n"
fi
}
process_layer3() {
if [ -e ${Layer3Name}${FileType} ]; then
echo -e " Layer3 in progress..."
Layer3Start=$(date +%s%3N)
Layer3FileSize=$(magick identify -ping -format "%w" $InputDirectory$Layer3Name$FileType)
magick convert  -depth 8 -type Grayscale $InputDirectory$Layer3Name$FileType -crop $GridSize'x'$GridSize@ -set filename:tile $OutputDirectory$MapName'_%[fx:round(page.x/(('$Layer3FileSize'/'$GridSize')*1)+'$OffsetX')]_%[fx:round(page.y/(('$Layer3FileSize'/'$GridSize')*1)+'$OffsetY')]_Layer3' -resize 1024x1024! +repage +adjoin %[filename:tile].png
Layer3End=$((($(date +%s%3N) - Layer3Start) / 1000))
echo -e " Layer3 completed in - "$Layer3End"s"
else echo -e " Error: Layer3 alphamap "$InputDirectory$Layer3Name$FileType" not found.\n"
fi
}

process_vcolor() {
if [ -e ${VcolorName}${FileType} ]; then
echo -e " Vcolor in progress..."
VcolorStart=$(date +%s%3N)
VcolorFileSize=$(magick identify -ping -format "%w" $InputDirectory$VcolorName$FileType)
magick convert  -depth 8 $InputDirectory$VcolorName$FileType -crop $GridSize'x'$GridSize@ -set filename:tile $OutputDirectory$MapName'_%[fx:round(page.x/(('$VcolorFileSize'/'$GridSize')*1)+'$OffsetX')]_%[fx:round(page.y/(('$VcolorFileSize'/'$GridSize')*1)+'$OffsetY')]_vcol' -resize 1024x1024! +repage +adjoin %[filename:tile].png
VcolorEnd=$((($(date +%s%3N) - VcolorStart) / 1000))
echo -e " Vcolor completed in - "$VcolorEnd"s"
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
2) if $parallel; then process_layer1 & process_layer2 & process_layer3 & wait; else process_layer1 && process_layer2 && process_layer3; fi ;;
3) process_vcolor ;;
4) if $parallel; then process_height & process_layer1 & process_layer2 & process_layer3 & process_vcolor & wait; else process_height && process_layer1 && process_layer2 && process_layer3 && process_vcolor; fi ;;
*) echo -e " Error: Enter 1-4.\n" ;;
esac
done
