#: ' Read JSON Value from file

curl -i 'http://localhost:7557/devices' >device.json
curl -i 'http://localhost:7557/tasks/' >task.txt
devices_file='device.json'
task_file='task.txt'
#data
value=$(grep -Po '"_id":.*?[^\\]"' $devices_file)

i=0;
for j in $value
do
   array[$i]=$j;
   i=$(($i+1));
done

echo "${array[*]}" >device_data.txt
sed 's/"_id":"//g' device_data.txt>device_row.txt
sed 's/ /\n /g' device_row.txt > dev.txt
sed 's/"//g' dev.txt>data.txt
sed -i 's/%/%25/g' data.txt



cr=$'\r'
echo "-------Deleting all devices--------"
file="data.txt"
cr=$'\r'

rm device.json device_row.txt device_data.txt dev.txt task_f.txt task_out.txt task.txt
#count
dcount=$(cat data.txt | wc -l)
tcount=$(cat task_data.txt | wc -l)
echo "Device: $dcount Task: $tcount sucessfully captured"
sleep 2

while read line
do
        line="${line%$cr}"
        curl -i "http://localhost:7557/devices/${line}" -X DELETE
    
done < "$file"


