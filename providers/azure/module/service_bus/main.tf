locals {
  queue_instances = {
    for entity in flatten([
      for namespace_key, namespace in var.namespaces : [
        for queue_key, queue in namespace.queues : {
          key           = jsonencode([namespace_key, queue_key])
          namespace_key = namespace_key
          definition    = queue
        }
      ]
    ]) : entity.key => entity
  }

  topic_instances = {
    for entity in flatten([
      for namespace_key, namespace in var.namespaces : [
        for topic_key, topic in namespace.topics : {
          key           = jsonencode([namespace_key, topic_key])
          namespace_key = namespace_key
          definition    = topic
        }
      ]
    ]) : entity.key => entity
  }
}

resource "azurerm_servicebus_namespace" "this" {
  for_each = var.namespaces

  name                          = each.value.name
  resource_group_name           = each.value.resource_group_name
  location                      = each.value.location
  sku                           = each.value.sku
  minimum_tls_version           = "1.2"
  local_auth_enabled            = false
  public_network_access_enabled = each.value.public_network_access_enabled
  capacity                      = each.value.sku == "Premium" ? each.value.capacity : null
  tags                          = each.value.tags

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_servicebus_queue" "this" {
  for_each = local.queue_instances

  name         = each.value.definition.name
  namespace_id = azurerm_servicebus_namespace.this[each.value.namespace_key].id

  lock_duration                           = each.value.definition.lock_duration
  max_delivery_count                      = each.value.definition.max_delivery_count
  dead_lettering_on_message_expiration    = each.value.definition.dead_lettering_on_message_expiration
  requires_duplicate_detection            = each.value.definition.requires_duplicate_detection
  duplicate_detection_history_time_window = each.value.definition.requires_duplicate_detection ? each.value.definition.duplicate_detection_history_time_window : null
}

resource "azurerm_servicebus_topic" "this" {
  for_each = local.topic_instances

  name         = each.value.definition.name
  namespace_id = azurerm_servicebus_namespace.this[each.value.namespace_key].id

  requires_duplicate_detection            = each.value.definition.requires_duplicate_detection
  duplicate_detection_history_time_window = each.value.definition.requires_duplicate_detection ? each.value.definition.duplicate_detection_history_time_window : null
}
