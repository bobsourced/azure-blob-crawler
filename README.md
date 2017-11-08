# azure-blob-crawler

This is a simple bash script that generates a CSV file with the name, size and last modification date for every blob in every storage account of a given account subscription. 

First of all you'll need to install the Azure CLI 2.0 (https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest) and then, run 'az login' to set the environment. Then you will have to change the AZURE variable to where your Azure CLI is installed.

You will also need to have installed 'jq', as this script parses the JSON output.
