#!/usr/bin/env python3

from xml.etree import ElementTree as ET
import urllib.request

url = 'https://media.chp.ca.gov/SA_XML/SA.xml'
response = urllib.request.urlopen(url)
data = response.read().decode('utf-8')

root = ET.fromstring( data )

for center in root:
    for dispatch in center:
        if dispatch.attrib['ID'] == "CHCC":
            for logID in dispatch:
                print( logID.attrib )
                logTime = logID.find('LogTime').text
                logType = logID.find('LogType').text
                location = logID.find('Location').text
                area = logID.find('Area').text
                latLon = logID.find('LATLON').text
                lat = latLon.split(':')[0]
                lon = latLon.split(':')[1]

                logDetails = logID.find('LogDetails')
                for event in logDetails:
                    try:
                        detailTime = event.find('DetailTime').text
                        print( detailTime )
                    except:
                        continue;
                    try:
                        incidentDetail = event.find('IncidentDetail').text
                        print( incidentDetail )
                    except:
                        x = 5
                    print("-----")
                print()