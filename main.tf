# 
# Data Layer 
#
# Resource to create a resource group
data "azurerm_resource_group" "main-rg" {
  name     = "${var.rg_name}"
}

data "azurerm_client_config" "current" {}


# Resource to create a CosmosDB
resource "azurerm_cosmosdb_account" "cosmos-db" {
  name                      = "${var.cosmos_db_name}"
  location                  = "${var.rg_region}"
  resource_group_name       = "${var.rg_name}"
  offer_type                = "Standard"
  kind                      = "${var.db_kind}"  
  
  enable_automatic_failover = true
  enable_multiple_write_locations = false

  ip_range_filter = "${var.allowed_ips}"

  consistency_policy {
    consistency_level       = "${var.consistency_level}"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }

  geo_location {
    location          = "${var.rg_region}"
    failover_priority = 0
  }
}

resource "azurerm_template_deployment" "cosmos-db-generic" {
  name                = "generic"
  resource_group_name = "${var.rg_name}"

  template_body = <<DEPLOY
{
	"$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
	"contentVersion": "1.0.0.0",
	"parameters": {
		"accountName": {
			"type": "string",
			"metadata": {
				"description": "Cosmos account name"
			}
		},
		"databaseName": {
			"type": "string",
			"metadata": {
				"description": "Database name"
			}
		},
    "throughput": {
			"type": "int",
			"defaultValue": 400,
			"minValue": 400,
			"maxValue": 1000000,
			"metadata": {
				"description": "The throughput for the Mongo DB database"
			}			
		}
	},
	"variables": {
		"accountName": "[toLower(parameters('accountName'))]"
	},
	"resources": 
	[
		{
			"type": "Microsoft.DocumentDB/databaseAccounts/apis/databases",
      "name": "[concat(variables('accountName'), '/mongodb/', parameters('databaseName'))]",
			"apiVersion": "2016-03-31",
      "properties":{
				"resource":{
					"id": "[parameters('databaseName')]"
				},
				"options": { "throughput": "[parameters('throughput')]" }
			}
		}
	]
}
DEPLOY

  # these key-value pairs are passed into the ARM Template's `parameters` block
  parameters = {
      accountName  = "${azurerm_cosmosdb_account.cosmos-db.name}"
      databaseName = "generic"
  }

  deployment_mode = "Incremental"
}

resource "azurerm_storage_account" "storage" {
  name                     = "${var.storage_account_name}"
  location                  = "${var.rg_region}"
  resource_group_name       = "${var.rg_name}"
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "DEVELOPMENT",
	brand       = "Biotherm",
	version     = "1.0.0"
  }
}

# 
# Service Layer 
#
# Resource to create a CosmosDB
resource "azurerm_app_service_plan" "serviceplan" {
  name                      = "${var.service_plan_name}"
  location                  = "${var.rg_region}"
  resource_group_name       = "${var.rg_name}"

  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_app_service" "api" {
  name                = "${var.service_api_name}"
  location            = "${var.rg_region}"
  resource_group_name = "${var.rg_name}"
  app_service_plan_id = "${azurerm_app_service_plan.serviceplan.id}"
  https_only          = true

  site_config {
    dotnet_framework_version    = "v4.0"
    use_32_bit_worker_process   = false
    always_on                   = true
  }

  app_settings = {
    "AZURE_CREDENTIALS_ACCOUNT_KEY"  = "${azurerm_storage_account.storage.primary_access_key}"
    "AZURE_CREDENTIALS_ACCOUNT_NAME" = "${azurerm_storage_account.storage.name}"
    "AZURE_CREDENTIALS_HOST"         = "${azurerm_storage_account.storage.primary_blob_endpoint}"
    "MobileAppsManagement_EXTENSION_VERSION" = "${var.api_extension_version}"
    "MONGODB_URI"                    =  "${azurerm_cosmosdb_account.cosmos-db.connection_strings[0]}"
    "NODE_ENV"                       = "${var.api_node_env}"
    "WEBSITE_NODE_DEFAULT_VERSION"   = "${var.api_website_node_version}"
  }

}


