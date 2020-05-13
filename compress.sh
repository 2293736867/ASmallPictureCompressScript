#!/bin/bash
picNums=`ls | grep -iE "*.jpg|*.png|*.jpeg" | grep -v "_compress" | wc -l`
if [[ $picNums == 0 ]]
then
	echo "No pictures found."
else
	originalPic=`ls | grep -iE "*.jpg|*.png|*.jpeg" | grep -v "_compress"`
	minRatio=1
	maxRatio=0
	totalRatio=0
	for i in $originalPic 
	do
		originalSize=`ls -l $i | awk '{print $5}'`
		basename=`basename $i`
		filename="${basename%.*}"
		suffix="${basename##*.}"
		compressFileName="$filename._compress.$suffix"
		if [[ $filename != *_compress* ]]
		then
			convert -quality $1 $i $compressFileName
			compressedSize=`ls -l $compressFileName | awk '{print $5}'`
			ratio=$(printf "%.2f" `echo "scale=2;$compressedSize/$originalSize"|bc`)
			if [[ `echo "$ratio<$minRatio" | bc` == 1 ]]
			then
				minRatio=$ratio
			fi
			if [[ `echo "$ratio>$maxRatio" | bc` == 1 ]]
			then
				maxRatio=$ratio
			fi
			totalRatio=`echo "$totalRatio+$ratio"|bc`
		fi
	done
	echo "Compress finished."
	echo "Max compressed ratio : $maxRatio"
	echo "Min compressed ratio : $minRatio"
	echo "Average compressed ratio :" $(printf "%.2f" `echo "scale=2;$totalRatio/$picNums" | bc`)
fi
