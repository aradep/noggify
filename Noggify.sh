#!/bin/bash
# Noggify
# Usage: Cuts large texturemaps into tiles for import into Noggit Red
# Requirements: Git Bash and ImageMagick

###################################################################################################
# FILE SETTINGS
#
#   Input Directory
#       Description:    Folder where texturemaps are located.
#       Suggestion:     Set this to the output folder of your terrain generation program.

InputDirectory='./'

#   Output Directory
#       Description:    Folder where completed tiles are sent.
#       Suggestion:     Set this to your Noggit project folder. 
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
#       Description:    Map size in ADTs
#       Important:      Maximum heightmap resolution: 256x256 multiplied by GridSize. Maximum 
#                       alphamap resolution: 1024x1024 multiplied by GridSize.

GridSize=1

#   Offset
#       Description:    The top-left tile of the map will be at this coordinate on the ADT grid.
#       Suggestion:     Can be used to center a large map or combine several small ones.

OffsetX=1
OffsetY=1

#
###################################################################################################

# Checks
if [ ! -d "$InputDirectory" ]; then
echo "        _
       | |                  
   ___ | |__    _ __   ___  
  / _ \| '_ \  | '_ \ / _ \ 
 | (_) | | | | | | | | (_) |  _   _   _  
  \___/|_| |_| |_| |_|\___/  (_) (_) (_) 
                            
 The input directory "$InputDirectory" does not exist. 
 Open Noggify.sh with a text editor and set the variables.
"
read -n 1 -s -r -p " Press any key to exit..."
exit 1
else 
if
[ ! -d $OutputDirectory ]; then
echo "        _
       | |                  
   ___ | |__    _ __   ___  
  / _ \| '_ \  | '_ \ / _ \ 
 | (_) | | | | | | | | (_) |  _   _   _  
  \___/|_| |_| |_| |_|\___/  (_) (_) (_) 
                            
 The output directory "$OutputDirectory" does not exist. 
 Open Noggify.sh with a text editor and set the variables.
"
read -n 1 -s -r -p " Press any key to exit..."
exit 1
fi
fi

#You passed
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
echo " Split textures:"
echo " ----------------------"
echo " 1. Height"
echo " 2. Alpha"
echo " 3. vColor"
echo " 4. All"
read -p "> " choice
case $choice in
1)
    if [ -e ${HeightName}${FileType} ]; then
        echo " Heightmap in progress..."
        magick convert  $InputDirectory$HeightName$FileType -crop $GridSize'x'$GridSize@ -set filename:tile $OutputDirectory$MapName'_%[fx:round(page.x/(('$(magick identify -format "%[fx:w]" $InputDirectory$HeightName$FileType)'/'$GridSize')*1)+'$OffsetX')]_%[fx:round(page.y/(('$(magick identify -format "%[fx:w]" $InputDirectory$HeightName$FileType)'/'$GridSize')*1)+'$OffsetY')]_height' -scale 257x257^ +repage +adjoin PNG64:%[filename:tile].png
        echo " Heightmap complete
        "
    else 
        echo " Error: Heightmap "$InputDirectory$HeightName$FileType" not found.
        "
    fi
    ;;
2)
    if [ -e ${Layer1Name}${FileType} ]; then
        echo " Layer1 in progress..."
        magick convert  $InputDirectory$Layer1Name$FileType -crop $GridSize'x'$GridSize@ -set filename:tile $OutputDirectory$MapName'_%[fx:round(page.x/(('$(magick identify -format "%[fx:w]" $InputDirectory$Layer1Name$FileType)'/'$GridSize')*1)+'$OffsetX')]_%[fx:round(page.y/(('$(magick identify -format "%[fx:w]" $InputDirectory$Layer1Name$FileType)'/'$GridSize')*1)+'$OffsetY')]_layer1' -scale 1024x1024^ +repage +adjoin PNG32:%[filename:tile].png
        echo " Layer1 complete
        "
    else 
        echo " Error: Layer1 alphamap "$InputDirectory$Layer1Name$FileType" not found.
        "
    fi
    if [ -e ${Layer2Name}${FileType} ]; then
        echo " Layer2 in progress..."
        magick convert  $InputDirectory$Layer2Name$FileType -crop $GridSize'x'$GridSize@ -set filename:tile $OutputDirectory$MapName'_%[fx:round(page.x/(('$(magick identify -format "%[fx:w]" $InputDirectory$Layer2Name$FileType)'/'$GridSize')*1)+'$OffsetX')]_%[fx:round(page.y/(('$(magick identify -format "%[fx:w]" $InputDirectory$Layer2Name$FileType)'/'$GridSize')*1)+'$OffsetY')]_Layer2' -scale 1024x1024^ +repage +adjoin PNG32:%[filename:tile].png
        echo " Layer2 complete
        "
    else 
        echo " Error: Layer2 alphamap "$InputDirectory$Layer2Name$FileType" not found.
        "
    fi
    if [ -e ${Layer3Name}${FileType} ]; then
        echo " Layer3 in progress..."
        magick convert  $InputDirectory$Layer3Name$FileType -crop $GridSize'x'$GridSize@ -set filename:tile $OutputDirectory$MapName'_%[fx:round(page.x/(('$(magick identify -format "%[fx:w]" $InputDirectory$Layer3Name$FileType)'/'$GridSize')*1)+'$OffsetX')]_%[fx:round(page.y/(('$(magick identify -format "%[fx:w]" $InputDirectory$Layer3Name$FileType)'/'$GridSize')*1)+'$OffsetY')]_Layer3' -scale 1024x1024^ +repage +adjoin PNG32:%[filename:tile].png
        echo " Layer3 complete
        "
    else 
        echo " Error: Layer3 alphamap "$InputDirectory$Layer3Name$FileType" not found.
        "
    fi
    ;;
3)
    if [ -e ${VcolorName}${FileType} ]; then
        echo " Vertexcolor in progress..."
        magick convert  $InputDirectory$VcolorName$FileType -crop $GridSize'x'$GridSize@ -set filename:tile $OutputDirectory$MapName'_%[fx:round(page.x/(('$(magick identify -format "%[fx:w]" $InputDirectory$VcolorName$FileType)'/'$GridSize')*1)+'$OffsetX')]_%[fx:round(page.y/(('$(magick identify -format "%[fx:w]" $InputDirectory$VcolorName$FileType)'/'$GridSize')*1)+'$OffsetY')]_Vcolor' -scale 1024x1024^ +repage +adjoin PNG32:%[filename:tile].png
        echo " Vertexcolor complete
        "
    else 
        echo " Error: Vertexcolor map "$InputDirectory$VcolorName$FileType" not found.
        "
    fi
    ;;
4)
    if [ -e ${HeightName}${FileType} ]; then
        echo " Heightmap in progress..."
        magick convert  $InputDirectory$HeightName$FileType -crop $GridSize'x'$GridSize@ -set filename:tile $OutputDirectory$MapName'_%[fx:round(page.x/(('$(magick identify -format "%[fx:w]" $InputDirectory$HeightName$FileType)'/'$GridSize')*1)+'$OffsetX')]_%[fx:round(page.y/(('$(magick identify -format "%[fx:w]" $InputDirectory$HeightName$FileType)'/'$GridSize')*1)+'$OffsetY')]_height' -scale 257x257^ +repage +adjoin PNG64:%[filename:tile].png
        echo " Heightmap complete
        "
    else 
        echo " Error: Heightmap "$InputDirectory$HeightName$FileType" not found.
        "
    fi
    if [ -e ${Layer1Name}${FileType} ]; then
        echo " Layer1 in progress..."
        magick convert  $InputDirectory$Layer1Name$FileType -crop $GridSize'x'$GridSize@ -set filename:tile $OutputDirectory$MapName'_%[fx:round(page.x/(('$(magick identify -format "%[fx:w]" $InputDirectory$Layer1Name$FileType)'/'$GridSize')*1)+'$OffsetX')]_%[fx:round(page.y/(('$(magick identify -format "%[fx:w]" $InputDirectory$Layer1Name$FileType)'/'$GridSize')*1)+'$OffsetY')]_layer1' -scale 1024x1024^ +repage +adjoin PNG32:%[filename:tile].png
        echo " Layer1 complete
        "
    else 
        echo " Error: Layer1 alphamap "$InputDirectory$Layer1Name$FileType" not found.
        "
    fi
    if [ -e ${Layer2Name}${FileType} ]; then
        echo " Layer2 in progress..."
        magick convert  $InputDirectory$Layer2Name$FileType -crop $GridSize'x'$GridSize@ -set filename:tile $OutputDirectory$MapName'_%[fx:round(page.x/(('$(magick identify -format "%[fx:w]" $InputDirectory$Layer2Name$FileType)'/'$GridSize')*1)+'$OffsetX')]_%[fx:round(page.y/(('$(magick identify -format "%[fx:w]" $InputDirectory$Layer2Name$FileType)'/'$GridSize')*1)+'$OffsetY')]_Layer2' -scale 1024x1024^ +repage +adjoin PNG32:%[filename:tile].png
        echo " Layer2 complete
        "
    else 
        echo " Error: Layer2 alphamap "$InputDirectory$Layer2Name$FileType" not found.
        "
    fi
    if [ -e ${Layer3Name}${FileType} ]; then
        echo " Layer3 in progress..."
        magick convert  $InputDirectory$Layer3Name$FileType -crop $GridSize'x'$GridSize@ -set filename:tile $OutputDirectory$MapName'_%[fx:round(page.x/(('$(magick identify -format "%[fx:w]" $InputDirectory$Layer3Name$FileType)'/'$GridSize')*1)+'$OffsetX')]_%[fx:round(page.y/(('$(magick identify -format "%[fx:w]" $InputDirectory$Layer3Name$FileType)'/'$GridSize')*1)+'$OffsetY')]_Layer3' -scale 1024x1024^ +repage +adjoin PNG32:%[filename:tile].png
        echo " Layer3 complete
        "
    else 
        echo " Error: Layer3 alphamap "$InputDirectory$Layer3Name$FileType" not found.
        "
    fi
    if [ -e ${VcolorName}${FileType} ]; then
        echo " Vertexcolor in progress..."
        magick convert  $InputDirectory$VcolorName$FileType -crop $GridSize'x'$GridSize@ -set filename:tile $OutputDirectory$MapName'_%[fx:round(page.x/(('$(magick identify -format "%[fx:w]" $InputDirectory$VcolorName$FileType)'/'$GridSize')*1)+'$OffsetX')]_%[fx:round(page.y/(('$(magick identify -format "%[fx:w]" $InputDirectory$VcolorName$FileType)'/'$GridSize')*1)+'$OffsetY')]_Vcolor' -scale 1024x1024^ +repage +adjoin PNG32:%[filename:tile].png
        echo " Vertexcolor complete
        "
    else 
        echo " Error: Vertexcolor map "$InputDirectory$VcolorName$FileType" not found.
        "
    fi
    ;;
*)
    echo " Error: Enter 1-4.
    "
    ;;
esac
done
