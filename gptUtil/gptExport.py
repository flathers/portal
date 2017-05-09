import psycopg2

hostname = 'localhost'
username = 'geoportal'
password = 'geoportal'
database = 'postgres'

myConnection = psycopg2.connect(host=hostname, user=username, password=password, dbname=database)

sql ="select gpt_resource.docuuid, xml from gpt_resource_data, gpt_resource where pubmethod != 'harvester' and pubmethod != 'registration' and approvalstatus != 'incomplete' and gpt_resource.docuuid = gpt_resource_data.docuuid;"

cur = myConnection.cursor()
cur.execute(sql)

for docuuid, xml in cur.fetchall():
    filename = docuuid.replace('{', '').replace('}', '') + '.xml'
    with open(filename, 'w') as f:
        f.write(xml)
    print docuuid

myConnection.close()
