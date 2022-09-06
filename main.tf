resource "azurerm_resource_group" "example" {
  name     = "example-rg"
  location = "uksouth"
}

resource "azurerm_container_registry" "example" {
  name                = var.registry_name
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  sku                 = "Premium"
  admin_enabled       = false
}

# query the existence of the ACR resource using 'external' data source
# TODO: put this into a module
data "external" "query_acr" {
  program = ["zsh", "${path.module}/query.sh"]

  query = {
    # could obviously just grab the resource ID of the ACR above using Terraform resource notation, but this is how we will need to do it with policy
    resource_id = "/subscriptions/2ca65474-3b7b-40f2-b242-0d2fba4bde6e/resourceGroups/example-rg/providers/Microsoft.ContainerRegistry/registries/asfkhsafkasdfsda?api-version=2022-02-01-preview"
  }
}

# if the query above worked, execute this data source
data "azurerm_container_registry" "example" {
  count               = data.external.query_acr.result.query_success
  name                = var.registry_name
  resource_group_name = azurerm_resource_group.example.name
}

# if the query above worked, execute this resource
resource "azurerm_route_table" "example" {
  count               = data.external.query_acr.result.query_success
  name                = "example-route-table"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}
