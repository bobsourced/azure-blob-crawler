#!/bin/bash

#PRIOR TO USING THIS SCRIPT YOU WILL NEED TO RUN 'az login' TO SET THE ENVIRONMENT

#Change the AZURE variable to the folder where you installed the Azure CLI 2.0
AZURE=/usr/local/bin/az
CURR=$(date -u '+%Y-%m-%dT%RZ') 
#I am using the UTC hour and adding 60 minutes for the SAS token expiration
CURRPLUSSIXTY=$(date -u -d "($CURR) +60 minutes" +%Y-%m-%dT%RZ)

STAC=.azstac.txt
CONT=.azcont.txt

#Get the name of all the storage accounts in the Azure subscription

$AZURE storage account list | jq -r '.[] | .name' > ${STAC}

#Create one folder per storage account in the Azure subscription
while read -r ST_AC_FOLDERS
do 
/bin/mkdir $ST_AC_FOLDERS
done < ${STAC}

if ! [[ -f $STAC ]]; then
       echo "Error: Storage account file not found" >&2; exit 1
fi

while read -r STORAGE_ACCOUNT;
do

AZURE_STORAGE_SAS_TOKEN=$($AZURE storage account generate-sas --account-name $STORAGE_ACCOUNT --expiry ${CURRPLUSSIXTY} --permissions lr --resource-types sco --services b)
$AZURE storage container list --account-name $STORAGE_ACCOUNT | jq -r '.[] | .name' > ${CONT} 

while read CONTAINER;

do
$AZURE storage blob list --account-name ${STORAGE_ACCOUNT} --container-name "${CONTAINER}" | jq -r '.[] | "\(.name),\(.properties.contentLength),\(.properties.lastModified)"' > $STORAGE_ACCOUNT/$CONTAINER.csv
done < ${CONT}

done < ${STAC}

