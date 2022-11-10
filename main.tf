terraform {
	backend "remote" {
		hostname = "app.terraform.io"
		organization = "tkaburagi"
		workspaces {
			name = "azure-app-service-ddd"
		}
	}
}



provider "azurerm" {
	features {}
}

resource "azurerm_resource_group" "example" {
	name     = "example-resources"
	location = "West Europe"
}

resource "azurerm_app_service_plan" "example" {
	name                = "example-appserviceplan"
	location            = azurerm_resource_group.example.location
	resource_group_name = azurerm_resource_group.example.name

	sku {
		tier = "Standard"
		size = "S1"
	}
}

resource "azurerm_app_service" "my-app-service" {
	app_service_plan_id = azurerm_app_service_plan.example.id
	location            = azurerm_resource_group.example.location
	name                = "my-app-tkabu-service"
	resource_group_name = azurerm_resource_group.example.name

	app_settings = {
		"WEBSITE_HEALTHCHECK_MAXPINGFAILURES" = 10
	}

	lifecycle {
		ignore_changes = [
			app_settings,
		]
	}
}
