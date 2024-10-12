# #############################################################################
# Define the variables for the storage containers
# #############################################################################

variable "containers" {
  description = "A map of Azure Storage container names and access types"
  type        = map(object({
    container_access_type = string
  }))
  default = null
  validation {
    condition = alltrue([for k, v in var.containers : contains(["blob", "container", "private"], v.container_access_type)])
    error_message = "The container_access_type must be one of: blob, container, or private."
  }
}