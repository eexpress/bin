#old version using imagemagick mplayer
#OGV=$1
#TMPDIR=`mktemp -d`
#mplayer -ao null $OGV -vo jpeg:outdir=$TMPDIR
#convert $TMPDIR/* $OGV-unoptimized.gif
#convert $OGV-unoptimized.gif -fuzz 10% -layers Optimize $OGV.gif

#new version using ffmpeg
INPUT_FILE=$1
#FPS=5
#TEMP_FILE_PATH=`mktemp -d`
#png for high quality, jpg for low one
#FORMAT="png"
#ffmpeg -i $INPUT_FILE -r $FPS $TEMP_FILE_PATH/out_%04d.$FORMAT
#convert -delay $((100/$FPS)) $TEMP_FILE_PATH/*.$FORMAT $INPUT_FILE.gif
#ffmpeg -i $INPUT_FILE -i $TEMP_FILE_PATH -loop 0 -filter_complex "fps=$FPS,scale=$WIDTH:-1:flags=lanczos[x];[x][1:v]paletteuse" $INPUT_FILE.gif
#rm $TEMP_FILE_PATH
ffmpeg -i $INPUT_FILE $INPUT_FILE.gif
#ffmpeg -i $INPUT_FILE -pix_fmt rgb24 $INPUT_FILE.gif
