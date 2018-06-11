## Training Temporal Segment Networks
### Extract Optical flow
first, use the following script to rename the ext from "MP4" to "mp4"
```
for i in $(find . -name *.MP4) ; do mv $i ${i%.*}.mp4 ; done
```
Use the following command to extract optical flow
```
python tools/build_of.py /data/train/r1 /data_op/train/r1/ --num_worker 2 --new_width 340 --new_height 256 --ext mp4
```
### Construct file lists for training and validation
Use the following script to rename the extracted optical flow directory names
```bash
export OP_DATA_PATH=<directory to the extracted optical flow>
export RAW_DATA_PATH=<directory to the src data path>

for i in $(find $RAW_DATA_PATH -name *.mp4) ; do
	dirname=$(dirname $i)
	class_name=${dirname##*/}
	basename=$(basename $i)
	echo $class_name
	mv $OP_DATA_PATH/${basename%.*} $OP_DATA_PATH/$class_name.${basename%.*}
done
```

```
python tools/build_file_list.py --dataset armlc --frame_path <renamed optical flow path> --num_split 1
```
for armlc data, we only perform 1 split, further split strategies will be discussed later.

### Train the prototype network

