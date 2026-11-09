variable "namespaces" {
  description = "Service Bus namespace definitions keyed by stable namespace identifiers, each containing optional keyed queues and topics."
  type = map(object({
    name                          = string
    resource_group_name           = string
    location                      = string
    sku                           = optional(string, "Premium")
    capacity                      = optional(number, 1)
    public_network_access_enabled = optional(bool, false)
    tags                          = optional(map(string), {})
    queues = optional(map(object({
      name                                    = string
      lock_duration                           = optional(string, "PT1M")
      max_delivery_count                      = optional(number, 10)
      dead_lettering_on_message_expiration    = optional(bool, true)
      requires_duplicate_detection            = optional(bool, true)
      duplicate_detection_history_time_window = optional(string, "PT10M")
    })), {})
    topics = optional(map(object({
      name                                    = string
      requires_duplicate_detection            = optional(bool, true)
      duplicate_detection_history_time_window = optional(string, "PT10M")
    })), {})
  }))
  default = {}

  validation {
    condition = alltrue([
      for namespace in values(var.namespaces) :
      can(regex("^[A-Za-z0-9][A-Za-z0-9-]{4,48}[A-Za-z0-9]$", namespace.name)) &&
      length(trimspace(namespace.resource_group_name)) > 0 &&
      length(trimspace(namespace.location)) > 0 &&
      contains(["Basic", "Standard", "Premium"], namespace.sku) &&
      namespace.capacity >= 1 &&
      (namespace.sku != "Premium" || contains([1, 2, 4, 8, 16], namespace.capacity))
    ])
    error_message = "Each namespace must have a valid 6-50 character name, resource group, and location, with a supported SKU and Premium capacity of 1, 2, 4, 8, or 16."
  }

  validation {
    condition = alltrue(flatten([
      for namespace in values(var.namespaces) : concat(
        [for queue in values(namespace.queues) : length(trimspace(queue.name)) > 0],
        [for topic in values(namespace.topics) : length(trimspace(topic.name)) > 0]
      )
    ]))
    error_message = "Every queue and topic must have a non-empty name."
  }
}
