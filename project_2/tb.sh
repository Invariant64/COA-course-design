if (( $# < 1 ))
then
    echo "Usage: tb.sh <Verilog File Name>"
    exit
fi

if [ ! -d ./.output ];
then
    mkdir ./.output
fi

if [ ! -f ./$1.v ];
then
    echo $1.v "doesn't existed!"
    exit
fi

if (( $# > 1 ))
then
    iverilog $file_list
    if [ $? -ne 0 ];
    then
        echo "Error! Compiling failed!"
        exit 1
    fi
    echo "test ok"
    exit
fi

iverilog -o $1.v.out $1.v
if [ $? -ne 0 ];
then
    echo "Error! Compiling failed!"
    exit 1
fi

vvp -n $1.v.out -lxt2
if [ $? -ne 0 ];
then
    echo "Error! Running failed!"
    exit 1
fi

if [ ! -d ./.output/$1 ];
then
    mkdir ./.output/$1
fi
cp $1.v.out ./.output/$1
cp wave.vcd ./.output/$1
rm -rf $1.v.out
rm -rf wave.vcd

gtkwave ./.output/$1/wave.vcd
if [ $? -ne 0 ];
then
    echo "Error! Opening failed!"
    exit 1
fi



