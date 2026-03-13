param webAppName string
param location string = resourceGroup().location

// Imposta uno SKU valido per Web App
@allowed([
  'S1'
  'S2'
  'S3'
  'B1'
])
param sku string = 'B1'

var appServicePlanName = toLower('AppServicePlan-${webAppName}')

resource appServicePlan 'Microsoft.Web/serverfarms@2022-09-01' = {
  name: appServicePlanName
  location: location
  
sku: {
    name: sku       // S1
    tier: 'Standard'
    size: sku
    capacity: 1
  }

  properties: {
    // Linux
    reserved: true
  }
}

resource appService 'Microsoft.Web/sites@2022-09-01' = {
  name: webAppName
  kind: 'app,linux'
  location: location
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      linuxFxVersion: 'DOTNET|8.0' // .NET 8 su Linux
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
