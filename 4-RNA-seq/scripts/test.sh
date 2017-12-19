if [ ! -d $1 ]
then
	echo $1
        mkdir $1
fi

for my_file in $1/*
do
if [ -d $my_file ]
then
echo $my_file
        filename="${my_file##*/}"
        extension="${filename##*.}"
        filename="${filename%%.*}" 
echo $filename
fi
done
