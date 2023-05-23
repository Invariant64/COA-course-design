rm -rf ./$1/wave.vcd
rm -fr ./$1/ifu_tb.v.out

if (( $# < 1 ))
then
    echo "Usage: testbench.sh <Main Verilog Name>"
    exit
fi

if [ ! -d ./$1/ ];
then
    echo $1 "doesn't existed!"
    exit
fi

if [ ! -f ./$1/$1.v ];
then
    echo $1.v "doesn't existed!"
    exit
fi

file_list=""
if (( $# > 1 ))
then
    for file in $(ls ./$1/)
    do 
        if [ "${file##*.}" = "v" ]; then
            # mv ${file} ${file%.*}.c
            file_list="$file_list ./$1/$file"
        fi
    done
    iverilog $file_list

    if [ $? -ne 0 ];
    then
        echo "Error! compile failed!"
        exit
    fi

    echo "test ok"
    exit
fi

if [ ! -f ./$1/$1\_tb.v ];
then
    echo $1_tb.v "doesn't existed!"
    exit
fi

# compile
file_list=""
for file in $(ls ./$1/)
do 
    if [ "${file##*.}" = "v" ]; then
        # mv ${file} ${file%.*}.c
        file_list="$file_list ./$1/$file"
    fi
done

iverilog -o ./$1/$1\_tb.v.out $file_list

if [ $? -ne 0 ];
then
    echo "Error! compile failed!"
    exit 1
fi


# run
cd $1
vvp -n ./$1\_tb.v.out -lxt2
cd ..

if [ $? -ne 0 ];
then
    echo "Error! compile failed!"
    exit 1
fi

# open wave file by gtkwave
gtkwave ./$1/wave.vcd


