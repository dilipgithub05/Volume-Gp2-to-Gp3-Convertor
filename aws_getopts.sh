#!/bin/bash

while getopts :v:e:i:g: options; 
do
  case $options in
	v) vol=$OPTARG
	;;
	e) er=$OPTARG
	;;
	i) in=$OPTARG
  	;;
  	g) err=$OPTARG
  	;;
  	
  	
  \?)echo aws.sh -v volume,-i instance-id,-e region,-vf regionname,-gp3 



	esac
done


#-------------------------------------------------------------------------------------------------------------------------------------------------------------------


	
if [[ ! -z $er ]]
then 
	
		
volume_ids=$(aws ec2 describe-volumes --region "${er}" --filters Name=volume-type,Values=gp2 | jq -r '.Volumes[].VolumeId')

if [ -z "$volume_ids" ]
then
echo "value is null"

else
for volume_id in "${volume_ids}";
do
    result=$(aws ec2 modify-volume --region "${er}" --volume-type=gp3 --volume-id "${volume_id}" | jq '.VolumeModification.ModificationState' | sed 's/"//g' > errors.txt) 
    if [ $? -eq 0 ] && [ "${result}" == "modifying" ];
    then
        echo "ERROR: couldn't change volume ${volume_id} type to gp3!"
    else
        echo "OK: volume ${volume_id} changed to state 'modifying'"
        

    fi
done
fi
fi

#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if [[ ! -z $vol ]]
then 

for i in `cat region.txt`
	do
	volume_ids=$(aws ec2 describe-volumes --region "$i" --filters Name=volume-id,Values="${vol}"  Name=volume-type,Values=gp2  | jq -r '.Volumes[].VolumeId')
	done 
	if [ -z "$volume_ids" ]
then
echo "value is null"
else
for volume_id in "${volume_ids}";
do
for i in `cat region.txt`
	do
    result=$(aws ec2 modify-volume --region "$i" --volume-type=gp3 --volume-id "${volume_id}" | jq '.VolumeModification.ModificationState' | sed 's/"//g')
    done
    if [ $? -eq 0 ] && [ "${result}" == "modifying" ];then
        echo "OK: volume ${volume_id} changed to state 'modifying'"
    else
        echo "ERROR: couldn't change volume ${volume_id} type to gp3!"
    fi
done
fi
fi
#-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
if [[ ! -z $in ]]
then 

for j in `cat region.txt`
	do
	
	volume_ids=$(aws ec2 describe-volumes --region "$j" --filters Name=attachment.instance-id,Values="${in}"  | jq -r '.Volumes[].VolumeId')
	done
	if [ -z "$volume_ids" ]
then
echo "value is null"
else	
for volume_id in "${volume_ids}";
do
for i in `cat region.txt`
	do
    result=$(aws ec2 modify-volume --region "$j" --volume-type=gp3 --volume-id "${volume_id}" | jq '.VolumeModification.ModificationState' | sed 's/"//g')
    done
    if [ $? -eq 0 ] && [ "${result}" == "modifying" ];then
        echo "OK: volume ${volume_id} changed to state 'modifying'"
    else
        echo "ERROR: couldn't change volume ${volume_id} type to gp3!"
    fi
done
fi
fi
#-----------------------------------------------------------------------------------------------------------------------------------

