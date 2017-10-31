#####################################################
################ LOVE TO DO AUTOMATION ##############
################ AUTHOR: MAYANK SHARMA ##############
#####################################################

import paramiko

zabbix_server_ip=["10.147.50.123","10.147.50.122","10.147.50.121"]
server_ip="10.147.50.123"

thrashold=input("enter thrashold for mount point /dev/vda1 = ")


def get_disk_usage(server,mount_point):
	client = paramiko.SSHClient()
	client.set_missing_host_key_policy(paramiko.WarningPolicy())
	client.connect(server,username="root", password="root123")
	stdin, stdout, stderr = client.exec_command("df -h")
	st=stdout.read()
	for i in st.rstrip().split('\n'):
		if i.split()[0] == mount_point:
			ans=i.split()[4].rstrip('%')
			print "disk usage is = " + str(ans)
			break	
	client.close()
	return ans
#for k in zabbix_server_ip:
#	print k
for j in zabbix_server_ip:
	comp=get_disk_usage(j,"/dev/vda1")
	if (int(comp) > int(thrashold)):
		print "alert now"#print ("sending alert for system = " + str(k))
	else:
		print "all ok"#print ("all OK on system = " + str(k))
