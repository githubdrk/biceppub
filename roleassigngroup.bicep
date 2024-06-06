
// @allowed([
//   '/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635', // Storage Blob Data Owner
//   '/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/ba92f5b4-2d11-453d-a403-e96b0029c9fe', // Storage Blob Data Contributor
//   '/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/2a2b9908-6ea1-4ae2-8e65-a410df84e7d1', // Storage Blob Data Reader
//   '/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/974c5e8b-45b9-4653-ba55-5f855dd0fb88', // Storage Queue Data Contributor
//   '/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/19e7f393-937e-4f77-808e-94535e297925', // Storage Queue Data Reader
//   '/subscriptions/{subscriptionId}/providers/Microsoft.Authorization/roleDefinitions/19e7f393-937e-4f77-808e-94535e297925'  // Storage Queue Data Message Processor
// ])
// param roleDefinitionId string

@description('This is the built-in role. See https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#contributor')
resource RoleDefinition 'Microsoft.Authorization/roleDefinitions@2018-01-01-preview' existing = {
  scope: subscription()
  name: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
}

param adGroupId string

param storageAccountName string = ''

var deployStorageAccount = !empty(storageAccountName)

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-04-01' existing = if (deployStorageAccount) {
  name: storageAccountName
}

// resource roleAssignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
//   name: guid(storageAccount.id, roleDefinitionId, adGroupId)
//   scope: storageAccount
//   properties: {
//     roleDefinitionId: roleDefinitionId
//     principalId: adGroupId
//   }
// }

resource roleAssignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(resourceGroup().id, adGroupId, RoleDefinition.id)
  scope: storageAccount
  properties: {
    roleDefinitionId: RoleDefinition.id
    principalId: adGroupId
    principalType:  'Group'
  }
}

