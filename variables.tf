# variable "client_id"{
#   type = "string"
#   default = "test-rg"
#   description = "The Client ID which should be used"
# }

# variable "client_secret"{
#   type = "string"
#   default = "test-rg"
#   description = "The Client Secret which should be used"
# }

# variable "subscription_id"{
#   type = "string"
#   default = "e5e4a161-19d0-46f1-9a99-fdd18df60816"
#   description = "he Subscription ID which should be used"
# }

# variable "tenant_id"{
#   type = "string"
#   default = "test-rg"
#   description = "The Tenant ID which should be used"
# }
variable "rg_name"{
  type = "string"
  default = "ne-frcbp-rg-dev-biotherm"
  description = "Resource group name"
}

variable "rg_region"{
  type = "string"
  default = "North Europe"
  description = "Resource group name"
}

variable "admin" {
  type = "string"
  default = "ludovic.fernandez@rd.loreal.com"
  description = "Email address of the subscription admin"
}

variable "cosmos_db_name"{
  type = "string"
  default = "ne-frcbp-azcosdb-dev-biotherm-01"
  description = "Cosmos db name."
}

variable "db_kind"{
  type = "string"
  default = "MongoDB"
  description = "Cosmos db kind. Allowed values - GlobalDocumentDB | MongoDB"
}

variable "allowed_ips"{
  type = "string"
  default = "81.255.154.160,104.42.195.92,40.76.54.131,52.176.6.30,52.169.50.45,52.187.184.26,0.0.0.0"
  description = "IPs that needs to allow access to cosmos db"
}

variable "consistency_level"{
  type = "string"
  default = "Session"
  description = "Consisteny level of cosmos db. Allowed values - Strong | BoundedStaleness | Session | ConsistentPrefix | Eventual"
}

variable "storage_account_name"{
  type = "string"
  default = "nefrcbpstodevbiotherm"
  description = "Storage Account Name"
}

variable "service_plan_name"{
  type = "string"
  default = "ne-frcbp-appsvcplan-dev-biotherm-01"
  description = "Service Plan Name"
}

variable "service_api_name"{
  type = "string"
  default = "ne-frcbp-wapp-dev-biotherm-01"
  description = "Service API Name"
}

variable "service_portal_name"{
  type = "string"
  default = "ne-frcbp-wapp-dev-biotherm-02"
  description = "Service Portal Name"
}

variable "api_extension_version"{
  type = "string"
  default = "latest"
  description = "API Extension Version"
}

variable "api_node_env"{
  type = "string"
  default = "DevelopmentBiotherm"
  description = "Node Environment"
}

variable "api_website_node_version"{
  type = "string"
  default = "6.9.1"
  description = "Node Version"
}

variable "portal_aspversion"{
  type = "string"
  default = "DevelopmentBiotherm"
  description = "Portal Service ASP Version"
}

variable "portal_locked"{
  type = "string"
  default = "1"
  description = "Portal Locked"
}