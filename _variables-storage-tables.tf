# #############################################################################
# Variables for storage tables
# #############################################################################

variable "tables" {
    type = list(string)
    description = "A list of Azure Storage table names"
    default = []
    validation {
        condition = alltrue([for table in var.tables : can(regex("^[a-z0-9]{3,63}$", table))])
        error_message = "The table name must be between 3 and 63 characters long and can contain only numbers and lowercase letters."
    }
}