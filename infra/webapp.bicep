param webAppName string
param location string = resourceGroup().location

// Imposta uno SKU valido per Web App
@allowed([
  'S1'
  'S2'
  'F1'
  'B1'
])
param sku string = 'F1'

var appServicePlanName = toLower('AppServicePlan-${webAppName}')

var skuMap = {
  F1: {
    name: 'F1'
    tier: 'Free'
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location

  properties: {
    // Windows plan (necessario per F1)
    reserved: false
  }
  sku: {
    // App Service accetta "name" e "tier"; "size" non è necessario se uguale a name
    name: skuMap[sku].name
    tier: skuMap[sku].tier
    // capacity: 1 // (opzionale) Evita di specificarlo su F1; Free ha sempre 1.
  }
}


resource appService 'Microsoft.Web/sites@2022-09-01' = {
  name: webAppName
  kind: 'app'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      
      appSettings: [
        {
          name: 'ASPNETCORE_ENVIRONMENT'
          value: 'Development'
        }
        {
          name: 'UseOnlyInMemoryDatabase'
          value: 'true'
        }
      ]
    }
  }
}
