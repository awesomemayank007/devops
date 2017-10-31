#####################################################
################ LOVE TO DO AUTOMATION ##############
################ AUTHOR: MAYANK SHARMA ##############
#####################################################

#!/bin/bash
#######################################################
echo "" > /tmp/all_instance_id.dat
echo "" > /tmp/used_image.dat
echo "" > /tmp/all_details.dat
echo "" > /tmp/all_images.dat
echo "" > /tmp/used_image_uniq.dat
echo "" > /tmp/unused_img.dat
echo "" > /tmp/final.dat

echo "########################"
echo "START =: COLLECTING DATA FROM OPENSTACK :USED IMAGES:/tmp/used_image.dat"
echo "########################"

glance image-list --all-tenants &>> /dev/null
if [ "$?" -eq "0" ]
then
        nova list --all-tenants | awk '{print $2}' >> /tmp/all_instance_id.dat
else
         openstack server list --all | awk '{print $2}' >> /tmp/all_instance_id.dat

fi
for i in `tail -n +4 /tmp/all_instance_id.dat`
do

        #############################
        #Gathering used image id's  #
        #############################
        glance image-list --all-tenants &>> /dev/null
        if [ "$?" -eq "0" ]
        then
                tmp1=`nova show $i | grep image | awk '{print $5}'`
        else
                tmp1=`openstack server show  $i | grep image | awk '{print $5}'`
        fi
        img=`echo $tmp1 | cut -d"(" -f2 | cut -d")" -f1`
        echo $img >> /tmp/used_image.dat

        echo "$i        =       $img" >>/tmp/all_details.dat
        #############################

done
sort /tmp/used_image.dat | uniq > /tmp/used_image_uniq.dat

glance image-list --all-tenants &>> /dev/null
if [ "$?" -eq "0" ]
then
        glance image-list --all-tenants | awk '{print $2}' | tail -n +4 > /tmp/all_images.dat
else
        glance image-list  | awk '{print $2}' | tail -n +4 > /tmp/all_images.dat
fi

echo "##############################################################################################"
echo "Find all used images list in = /tmp/used_image_uniq.dat"
echo "Find full details in         = /tmp/all_details.dat"
echo "Find ALL IMAGES details in   = /tmp/all_images.dat"
echo "Find FINAL UNUSED IMAGES details in   = /tmp/final.dat"
echo "##############################################################################################"

echo "##############################################################################################"
echo "INSTANCE_ID                                               IMAGE_NAME"
#cat /tmp/all_details.dat
echo "##############################################################################################"



echo "########################"
echo "FINISHED =: COLLECTING DATA "
echo "########################"


echo "########################"
echo "START =: GETHRING UNUSED IMAGES : /tmp/unused_img.dat"
echo "########################"

echo "All UNUSED IMAGES"
join -v1 -v2 <(sort /tmp/used_image_uniq.dat) <(sort /tmp/all_images.dat) > /tmp/unused_img.dat


echo "########################"
echo "FINISHED =: FINISHED GETHERING UNUSED IMAGES "
echo "########################"

echo "##############################################################################################"
echo "ALL UNUSED IMAGES ID AND NAME ARE BELOW"

for i in `cat /tmp/unused_img.dat`
do
        glance image-list --all-tenants &>> /dev/null
        if [ "$?" -eq "0" ]
        then
                glance image-list --all-tenants | grep  $i >> /tmp/final.dat
        else
                glance image-list | grep  $i >> /tmp/final.dat
        fi
done
echo "##############################################################################################"